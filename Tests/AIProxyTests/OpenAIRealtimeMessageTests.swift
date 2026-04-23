//
//  OpenAIRealtimeMessageTests.swift
//  AIProxyTests
//

import Foundation
import Testing
@testable import AIProxy

/// Realtime server events: verifies selected canonical event names decode as expected.
/// Selected legacy event type aliases remain decodable for compatibility.
/// This suite is intentionally not a full realtime event matrix.
struct OpenAIRealtimeMessageTests {

    @Test
    func testResponseOutputAudioDeltaIsDecodable() throws {
        let event = try decode(
            #"{"type":"response.output_audio.delta","delta":"AQID","response_id":"resp_1","event_id":"event_1"}"#
        )

        guard case .responseAudioDelta(let payload) = event else {
            Issue.record("Expected responseAudioDelta")
            return
        }
        #expect(payload.base64Audio == "AQID")
        #expect(payload.responseID == "resp_1")
    }

    @Test
    func testConversationItemAddedAndDoneAreDecodable() throws {
        let added = try decode(
            #"{"type":"conversation.item.added","event_id":"event_2","item":{"id":"msg_1","role":"assistant"},"previous_item_id":"msg_0"}"#
        )
        let done = try decode(
            #"{"type":"conversation.item.done","event_id":"event_3","item":{"id":"msg_1","role":"assistant"},"previous_item_id":"msg_0"}"#
        )

        guard case .conversationItemAdded(let addedPayload) = added else {
            Issue.record("Expected conversationItemAdded")
            return
        }
        #expect(addedPayload.itemID == "msg_1")
        #expect(addedPayload.role == "assistant")
        #expect(addedPayload.previousItemID == "msg_0")

        guard case .conversationItemDone(let donePayload) = done else {
            Issue.record("Expected conversationItemDone")
            return
        }
        #expect(donePayload.itemID == "msg_1")
        #expect(donePayload.role == "assistant")
        #expect(donePayload.previousItemID == "msg_0")
    }

    @Test
    func testInputAudioBufferTimeoutTriggeredIsDecodable() throws {
        let event = try decode(
            #"{"type":"input_audio_buffer.timeout_triggered","event_id":"event_4","item_id":"item_1","audio_start_ms":1200,"audio_end_ms":2400}"#
        )

        guard case .inputAudioBufferTimeoutTriggered(let payload) = event else {
            Issue.record("Expected inputAudioBufferTimeoutTriggered")
            return
        }
        #expect(payload.itemID == "item_1")
        #expect(payload.audioStartMS == 1200)
        #expect(payload.audioEndMS == 2400)
        #expect(payload.eventID == "event_4")
    }

    @Test
    func testInputAudioBufferDTMFEventReceivedIsDecodable() throws {
        let event = try decode(
            #"{"type":"input_audio_buffer.dtmf_event_received","event":"5","received_at":1743985938}"#
        )

        guard case .inputAudioBufferDTMFEventReceived(let payload) = event else {
            Issue.record("Expected inputAudioBufferDTMFEventReceived")
            return
        }
        #expect(payload.event == "5")
        #expect(payload.receivedAt == 1743985938)
    }

    @Test
    func testTranscriptDeltasRemainDecodableAcrossInterleavedLifecycleEvents() throws {
        let lines: [String] = [
            #"{"type":"conversation.item.added","event_id":"event_10","item":{"id":"assistant_item","role":"assistant"},"previous_item_id":"user_item"}"#,
            #"{"type":"response.output_audio_transcript.delta","event_id":"event_11","response_id":"resp_9","item_id":"assistant_item","content_index":0,"delta":"Hel"}"#,
            #"{"type":"conversation.item.done","event_id":"event_12","item":{"id":"user_item","role":"user"},"previous_item_id":"older_item"}"#,
            #"{"type":"response.output_audio_transcript.delta","event_id":"event_13","response_id":"resp_9","item_id":"assistant_item","content_index":0,"delta":"lo"}"#,
            #"{"type":"response.output_audio_transcript.done","event_id":"event_14","response_id":"resp_9","item_id":"assistant_item","content_index":0,"transcript":"Hello"}"#,
        ]

        var assembled = ""
        var finalTranscript: String?

        for line in lines {
            let event = try decode(line)
            switch event {
            case .responseTranscriptDelta(let payload):
                assembled += payload.delta
            case .responseTranscriptDone(let payload):
                finalTranscript = payload.transcript
            default:
                continue
            }
        }

        #expect(assembled == "Hello")
        #expect(finalTranscript == "Hello")
    }

    @Test
    func testResponseOutputTextEventsAreDecodable() throws {
        let deltaEvent = try decode(
            #"{"type":"response.output_text.delta","event_id":"event_21","response_id":"resp_11","item_id":"assistant_item","output_index":0,"content_index":0,"delta":"Hi"}"#
        )
        let doneEvent = try decode(
            #"{"type":"response.output_text.done","event_id":"event_22","response_id":"resp_11","item_id":"assistant_item","output_index":0,"content_index":0,"text":"Hi there"}"#
        )

        guard case .responseTextDelta(let deltaPayload) = deltaEvent else {
            Issue.record("Expected responseTextDelta")
            return
        }
        #expect(deltaPayload.delta == "Hi")
        #expect(deltaPayload.itemID == "assistant_item")

        guard case .responseTextDone(let donePayload) = doneEvent else {
            Issue.record("Expected responseTextDone")
            return
        }
        #expect(donePayload.text == "Hi there")
        #expect(donePayload.itemID == "assistant_item")
    }

    @Test
    func testLegacyResponseTextEventsRemainDecodableForCompatibility() throws {
        let deltaEvent = try decode(
            #"{"type":"response.text.delta","event_id":"event_23","response_id":"resp_12","item_id":"assistant_item","output_index":0,"content_index":0,"delta":"A"}"#
        )
        let doneEvent = try decode(
            #"{"type":"response.text.done","event_id":"event_24","response_id":"resp_12","item_id":"assistant_item","output_index":0,"content_index":0,"text":"AB"}"#
        )

        guard case .responseTextDelta(let deltaPayload) = deltaEvent else {
            Issue.record("Expected legacy responseTextDelta")
            return
        }
        #expect(deltaPayload.delta == "A")

        guard case .responseTextDone(let donePayload) = doneEvent else {
            Issue.record("Expected legacy responseTextDone")
            return
        }
        #expect(donePayload.text == "AB")
    }

    private func decode(_ json: String) throws -> OpenAIRealtimeMessage {
        try JSONDecoder().decode(OpenAIRealtimeMessage.self, from: Data(json.utf8))
    }
}
