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
nonisolated private let kWebsocketPingIntervalNanoseconds: UInt64 = 20_000_000_000

@AIProxyActor open class OpenAIRealtimeSession {
    private var isTearingDown = false
    private let webSocketTask: URLSessionWebSocketTask
    private var continuation: AsyncStream<OpenAIRealtimeMessage>.Continuation?
    private var pingKeepaliveTask: Task<Void, Never>?
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
        self.startPingKeepaliveTask()
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
        self.pingKeepaliveTask?.cancel()
        self.pingKeepaliveTask = nil
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

    private func startPingKeepaliveTask() {
        self.pingKeepaliveTask?.cancel()
        self.pingKeepaliveTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: kWebsocketPingIntervalNanoseconds)
                guard let self, !Task.isCancelled, !self.isTearingDown else { return }
                await self.sendPingKeepalive()
            }
        }
    }

    private func sendPingKeepalive() async {
        await withCheckedContinuation { continuation in
            self.webSocketTask.sendPing { error in
                if let error {
                    logIf(.warning)?.warning("WebSocket ping failed: \(error.localizedDescription)")
                } else {
                    logIf(.debug)?.debug("WebSocket ping keepalive sent")
                }
                continuation.resume()
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
            self.continuation?.yield(.error(.init(errorBody: errorBody)))
        case "session.created":
            self.continuation?.yield(.sessionCreated)
        case "session.updated":
            self.continuation?.yield(.sessionUpdated)
        case "response.audio.delta":
            if let base64Audio = json["delta"] as? String {
                self.continuation?.yield(.responseAudioDelta(.init(base64Audio: base64Audio)))
            }
        case "response.created":
            self.continuation?.yield(
                .responseCreated(
                    .init(
                        responseID: json["response_id"] as? String ?? (jsonObject(at: "response", in: json)?["id"] as? String),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "input_audio_buffer.speech_started":
            self.continuation?.yield(
                .inputAudioBufferSpeechStarted(
                    .init(
                        itemID: json["item_id"] as? String,
                        audioStartMS: intValue(json["audio_start_ms"]),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "input_audio_buffer.speech_stopped":
            self.continuation?.yield(
                .inputAudioBufferSpeechStopped(
                    .init(
                        itemID: json["item_id"] as? String,
                        audioEndMS: intValue(json["audio_end_ms"]),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "input_audio_buffer.committed":
            self.continuation?.yield(
                .inputAudioBufferCommitted(
                    .init(
                        itemID: json["item_id"] as? String,
                        previousItemID: json["previous_item_id"] as? String,
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "conversation.item.created":
            let item = jsonObject(at: "item", in: json)
            self.continuation?.yield(
                .conversationItemCreated(
                    .init(
                        itemID: item?["id"] as? String ?? json["item_id"] as? String,
                        previousItemID: json["previous_item_id"] as? String,
                        role: item?["role"] as? String,
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "response.function_call_arguments.done":
            if let name = json["name"] as? String,
               let arguments = json["arguments"] as? String,
               let callId = json["call_id"] as? String {
                self.continuation?.yield(
                    .responseFunctionCallArgumentsDone(
                        .init(
                            name: name,
                            arguments: arguments,
                            callID: callId
                        )
                    )
                )
            }
        case "response.output_item.added":
            let item = jsonObject(at: "item", in: json)
            self.continuation?.yield(
                .responseOutputItemAdded(
                    .init(
                        responseID: json["response_id"] as? String,
                        itemID: item?["id"] as? String ?? json["item_id"] as? String,
                        outputIndex: intValue(json["output_index"]),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "response.output_item.done":
            let item = jsonObject(at: "item", in: json)
            self.continuation?.yield(
                .responseOutputItemDone(
                    .init(
                        responseID: json["response_id"] as? String,
                        itemID: item?["id"] as? String ?? json["item_id"] as? String,
                        outputIndex: intValue(json["output_index"]),
                        transcript: transcriptFromItem(item),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "response.content_part.added":
            let part = jsonObject(at: "part", in: json)
            self.continuation?.yield(
                .responseContentPartAdded(
                    .init(
                        responseID: json["response_id"] as? String,
                        itemID: json["item_id"] as? String,
                        outputIndex: intValue(json["output_index"]),
                        contentIndex: intValue(json["content_index"]),
                        part: contentPart(from: part),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "response.content_part.done":
            let part = jsonObject(at: "part", in: json)
            self.continuation?.yield(
                .responseContentPartDone(
                    .init(
                        responseID: json["response_id"] as? String,
                        itemID: json["item_id"] as? String,
                        outputIndex: intValue(json["output_index"]),
                        contentIndex: intValue(json["content_index"]),
                        transcript: part?["transcript"] as? String,
                        part: contentPart(from: part),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "response.audio.done", "response.output_audio.done":
            self.continuation?.yield(
                .responseAudioDone(
                    .init(
                        responseID: json["response_id"] as? String,
                        itemID: json["item_id"] as? String,
                        outputIndex: intValue(json["output_index"]),
                        contentIndex: intValue(json["content_index"]),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "response.done":
            let response = jsonObject(at: "response", in: json)
            self.continuation?.yield(
                .responseDone(
                    .init(
                        responseID: response?["id"] as? String ?? json["response_id"] as? String,
                        conversationID: response?["conversation_id"] as? String,
                        status: response?["status"] as? String,
                        eventID: json["event_id"] as? String
                    )
                )
            )
        case "rate_limits.updated":
            self.continuation?.yield(
                .rateLimitsUpdated(
                    .init(
                        rateLimits: parseRateLimits(json["rate_limits"]),
                        eventID: json["event_id"] as? String
                    )
                )
            )
        
        // New cases for handling transcription messages
        case "response.audio_transcript.delta", "response.output_audio_transcript.delta":
            if let delta = json["delta"] as? String {
                self.continuation?.yield(
                    .responseTranscriptDelta(
                        .init(
                            delta: delta,
                            responseID: json["response_id"] as? String,
                            itemID: json["item_id"] as? String,
                            contentIndex: intValue(json["content_index"]),
                            eventID: json["event_id"] as? String
                        )
                    )
                )
            }
            
        case "response.audio_transcript.done", "response.output_audio_transcript.done":
            if let transcript = json["transcript"] as? String {
                self.continuation?.yield(
                    .responseTranscriptDone(
                        .init(
                            transcript: transcript,
                            responseID: json["response_id"] as? String,
                            itemID: json["item_id"] as? String,
                            contentIndex: intValue(json["content_index"]),
                            eventID: json["event_id"] as? String
                        )
                    )
                )
            }
            
        case "input_audio_buffer.transcript":
            if let transcript = json["transcript"] as? String {
                self.continuation?.yield(.inputAudioBufferTranscript(.init(transcript: transcript)))
            }
            
        case "conversation.item.input_audio_transcription.delta":
            if let delta = json["delta"] as? String {
                self.continuation?.yield(
                    .inputAudioTranscriptionDelta(
                        .init(
                            delta: delta,
                            itemID: json["item_id"] as? String ?? (jsonObject(at: "item", in: json)?["id"] as? String),
                            contentIndex: intValue(json["content_index"]),
                            eventID: json["event_id"] as? String
                        )
                    )
                )
            }
            
        case "conversation.item.input_audio_transcription.completed":
            if let transcript = json["transcript"] as? String {
                self.continuation?.yield(
                    .inputAudioTranscriptionCompleted(
                        .init(
                            transcript: transcript,
                            itemID: json["item_id"] as? String ?? (jsonObject(at: "item", in: json)?["id"] as? String),
                            contentIndex: intValue(json["content_index"]),
                            eventID: json["event_id"] as? String
                        )
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

    private func intValue(_ value: Any?) -> Int? {
        if let int = value as? Int {
            return int
        }
        if let number = value as? NSNumber {
            return number.intValue
        }
        if let string = value as? String, let int = Int(string) {
            return int
        }
        return nil
    }

    private func doubleValue(_ value: Any?) -> Double? {
        if let double = value as? Double {
            return double
        }
        if let number = value as? NSNumber {
            return number.doubleValue
        }
        if let string = value as? String, let double = Double(string) {
            return double
        }
        return nil
    }

    private func contentPart(from json: [String: Any]?) -> OpenAIRealtimeContentPart? {
        guard let json else { return nil }
        return OpenAIRealtimeContentPart(
            type: json["type"] as? String,
            audio: json["audio"] as? String,
            text: json["text"] as? String,
            transcript: json["transcript"] as? String
        )
    }

    private func parseRateLimits(_ value: Any?) -> [OpenAIRealtimeRateLimit] {
        guard let array = value as? [[String: Any]] else { return [] }
        return array.map { entry in
            OpenAIRealtimeRateLimit(
                name: entry["name"] as? String,
                limit: intValue(entry["limit"]),
                remaining: intValue(entry["remaining"]),
                resetSeconds: doubleValue(entry["reset_seconds"])
            )
        }
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
