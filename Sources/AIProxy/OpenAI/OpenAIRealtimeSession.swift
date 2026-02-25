//
//  RealtimeSession.swift
//
//
//  Created by Lou Zell on 11/28/24.
//

import Foundation
import AVFoundation

nonisolated private let kWebsocketDisconnectedErrorCode = 57
nonisolated private let kWebsocketDisconnectedEarlyThreshold: TimeInterval = 3

@AIProxyActor open class OpenAIRealtimeSession {
    private var isTearingDown = false
    private let webSocketTask: URLSessionWebSocketTask
    private var continuation: AsyncStream<OpenAIRealtimeMessage>.Continuation?
    private let setupTime = Date()
    let sessionConfiguration: OpenAIRealtimeSessionConfiguration

    init(
        webSocketTask: URLSessionWebSocketTask,
        sessionConfiguration: OpenAIRealtimeSessionConfiguration
    ) {
        self.webSocketTask = webSocketTask
        self.sessionConfiguration = sessionConfiguration

        Task {
            await self.sendMessage(OpenAIRealtimeSessionUpdate(session: self.sessionConfiguration))
        }
        self.webSocketTask.resume()
        self.receiveMessage()
    }

    deinit {
        logIf(.debug)?.debug("OpenAIRealtimeSession is being freed")
    }

    /// Messages sent from OpenAI are published on this receiver as they arrive
    public var receiver: AsyncStream<OpenAIRealtimeMessage> {
        return AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    /// Sends a message through the websocket connection
    public func sendMessage(_ encodable: Encodable) async {
        guard !self.isTearingDown else {
            logIf(.debug)?.debug("Ignoring ws sendMessage. The RT session is tearing down.")
            return
        }
        do {
            let wsMessage = URLSessionWebSocketTask.Message.string(try encodable.serialize())
            try await self.webSocketTask.send(wsMessage)
        } catch {
            logIf(.error)?.error("Could not send message to OpenAI: \(error.localizedDescription)")
        }
    }

    /// Close the websocket connection
    public func disconnect() {
        self.isTearingDown = true
        self.continuation?.finish()
        self.continuation = nil
        self.webSocketTask.cancel()
    }

    /// Tells the websocket task to receive a new message
    private func receiveMessage() {
        self.webSocketTask.receive { result in
            switch result {
            case .failure(let error as NSError):
                Task {
                    await self.didReceiveWebSocketError(error)
                }
            case .success(let message):
                Task {
                    await self.didReceiveWebSocketMessage(message)
                }
            }
        }
    }

    /// Handles socket errors. We disconnect on all errors.
    private func didReceiveWebSocketError(_ error: NSError) {
        guard !isTearingDown else {
            return
        }

        switch error.code {
        case kWebsocketDisconnectedErrorCode:
            let disconnectedEarly = Date().timeIntervalSince(setupTime) <= kWebsocketDisconnectedEarlyThreshold
            if disconnectedEarly {
                logIf(.warning)?.warning("AIProxy: websocket disconnected immediately. Check that you've followed the DeviceCheck integration guide at https://www.aiproxy.com/docs/integration-guide.html")
            } else {
                logIf(.debug)?.debug("AIProxy: websocket disconnected normally")
            }
        default:
            logIf(.error)?.error("Received ws error: \(error.localizedDescription)")
        }

        self.disconnect()
    }

    /// Handles received websocket messages
    private func didReceiveWebSocketMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            if let data = text.data(using: .utf8) {
                self.didReceiveWebSocketData(data)
            }
        case .data(let data):
            self.didReceiveWebSocketData(data)
        @unknown default:
            logIf(.error)?.error("Received an unknown websocket message format")
            self.disconnect()
        }
    }

    private func didReceiveWebSocketData(_ data: Data) {
        guard !self.isTearingDown else {
            // The caller already initiated disconnect,
            // don't send any more messages back to the caller
            return
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let messageType = json["type"] as? String else {
            logIf(.error)?.error("Received websocket data that we don't understand")
            self.disconnect()
            return
        }
        logIf(.debug)?.debug("Received \(messageType) from OpenAI")

        switch messageType {
        case "error":
            let errorBody = String(describing: json["error"] as? [String: Any])
            logIf(.error)?.error("Received error from OpenAI websocket: \(errorBody)")
            self.continuation?.yield(.error(errorBody))
        case "session.created":
            self.continuation?.yield(.sessionCreated)
        case "session.updated":
            self.continuation?.yield(.sessionUpdated)
        case "response.audio.delta":
            if let base64Audio = json["delta"] as? String {
                self.continuation?.yield(.responseAudioDelta(base64Audio))
            }
        case "response.created":
            self.continuation?.yield(
                .responseCreated(responseId: json["response_id"] as? String ?? (jsonObject(at: "response", in: json)?["id"] as? String))
            )
        case "input_audio_buffer.speech_started":
            self.continuation?.yield(.inputAudioBufferSpeechStarted(itemId: json["item_id"] as? String))
        case "input_audio_buffer.speech_stopped":
            self.continuation?.yield(
                .inputAudioBufferSpeechStopped(
                    itemId: json["item_id"] as? String,
                    audioEndMs: json["audio_end_ms"] as? Int
                )
            )
        case "input_audio_buffer.committed":
            self.continuation?.yield(
                .inputAudioBufferCommitted(
                    itemId: json["item_id"] as? String,
                    previousItemId: json["previous_item_id"] as? String
                )
            )
        case "conversation.item.created":
            let item = jsonObject(at: "item", in: json)
            self.continuation?.yield(
                .conversationItemCreated(
                    itemId: item?["id"] as? String ?? json["item_id"] as? String,
                    previousItemId: json["previous_item_id"] as? String,
                    role: item?["role"] as? String
                )
            )
        case "response.function_call_arguments.done":
            if let name = json["name"] as? String,
               let arguments = json["arguments"] as? String,
               let callId = json["call_id"] as? String {
                self.continuation?.yield(.responseFunctionCallArgumentsDone(name, arguments, callId))
            }
        case "response.output_item.added":
            let item = jsonObject(at: "item", in: json)
            self.continuation?.yield(
                .responseOutputItemAdded(
                    responseId: json["response_id"] as? String,
                    itemId: item?["id"] as? String ?? json["item_id"] as? String,
                    outputIndex: json["output_index"] as? Int
                )
            )
        case "response.output_item.done":
            let item = jsonObject(at: "item", in: json)
            self.continuation?.yield(
                .responseOutputItemDone(
                    responseId: json["response_id"] as? String,
                    itemId: item?["id"] as? String ?? json["item_id"] as? String,
                    outputIndex: json["output_index"] as? Int,
                    transcript: transcriptFromItem(item)
                )
            )
        case "response.content_part.added":
            self.continuation?.yield(
                .responseContentPartAdded(
                    responseId: json["response_id"] as? String,
                    itemId: json["item_id"] as? String,
                    outputIndex: json["output_index"] as? Int,
                    contentIndex: json["content_index"] as? Int
                )
            )
        case "response.content_part.done":
            let part = jsonObject(at: "part", in: json)
            self.continuation?.yield(
                .responseContentPartDone(
                    responseId: json["response_id"] as? String,
                    itemId: json["item_id"] as? String,
                    outputIndex: json["output_index"] as? Int,
                    contentIndex: json["content_index"] as? Int,
                    transcript: part?["transcript"] as? String
                )
            )
        case "response.audio.done":
            self.continuation?.yield(
                .responseAudioDone(
                    responseId: json["response_id"] as? String,
                    itemId: json["item_id"] as? String,
                    outputIndex: json["output_index"] as? Int,
                    contentIndex: json["content_index"] as? Int
                )
            )
        case "response.done":
            let response = jsonObject(at: "response", in: json)
            self.continuation?.yield(
                .responseDone(
                    responseId: response?["id"] as? String ?? json["response_id"] as? String,
                    conversationId: response?["conversation_id"] as? String
                )
            )
        case "rate_limits.updated":
            self.continuation?.yield(.rateLimitsUpdated)
        
        // New cases for handling transcription messages
        case "response.audio_transcript.delta":
            if let delta = json["delta"] as? String {
                self.continuation?.yield(
                    .responseTranscriptDelta(
                        delta,
                        responseId: json["response_id"] as? String,
                        itemId: json["item_id"] as? String
                    )
                )
            }
            
        case "response.audio_transcript.done":
            if let transcript = json["transcript"] as? String {
                self.continuation?.yield(
                    .responseTranscriptDone(
                        transcript,
                        responseId: json["response_id"] as? String,
                        itemId: json["item_id"] as? String
                    )
                )
            }
            
        case "input_audio_buffer.transcript":
            if let transcript = json["transcript"] as? String {
                self.continuation?.yield(.inputAudioBufferTranscript(transcript))
            }
            
        case "conversation.item.input_audio_transcription.delta":
            if let delta = json["delta"] as? String {
                self.continuation?.yield(
                    .inputAudioTranscriptionDelta(
                        delta,
                        itemId: json["item_id"] as? String ?? (jsonObject(at: "item", in: json)?["id"] as? String)
                    )
                )
            }
            
        case "conversation.item.input_audio_transcription.completed":
            if let transcript = json["transcript"] as? String {
                self.continuation?.yield(
                    .inputAudioTranscriptionCompleted(
                        transcript,
                        itemId: json["item_id"] as? String ?? (jsonObject(at: "item", in: json)?["id"] as? String)
                    )
                )
            }
            
        default:
            // Log unhandled message types for debugging
            logIf(.debug)?.debug("Unhandled message type: \(messageType) - \(json)")
            break
        }

        if messageType != "error" && !self.isTearingDown {
            self.receiveMessage()
        }
    }

    private func jsonObject(at key: String, in json: [String: Any]) -> [String: Any]? {
        return json[key] as? [String: Any]
    }

    private func transcriptFromItem(_ item: [String: Any]?) -> String? {
        guard let item,
              let content = item["content"] as? [[String: Any]],
              !content.isEmpty else {
            return nil
        }
        for part in content {
            if let transcript = part["transcript"] as? String {
                return transcript
            }
        }
        return nil
    }
}
