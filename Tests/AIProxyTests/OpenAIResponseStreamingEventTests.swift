//
//  OpenAIResponseStreamingEventTests.swift
//  AIProxyTests
//
//  Created by Matt Corey on 6/21/25.
//

import XCTest
@testable import AIProxy

class OpenAIResponseStreamingEventTests: XCTestCase {
    
    func testResponseCreatedEventIsDecodable() throws {
        let line = #"data: {"type":"response.created","sequence_number":0,"response":{"id":"resp_123","object":"response","created_at":1751312720,"status":"in_progress","background":false,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"max_tool_calls":null,"model":"gpt-4o-2024-08-06","output":[],"parallel_tool_calls":true,"Received after 983.2 ms: previous_response_id":null,"reasoning":{"effort":null,"summary":null},"service_tier":"auto","store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[{"type":"web_search_preview","search_context_size":"low","user_location":{"type":"approximate","city":null,"country":"US","region":null,"timezone":null}}],"top_logprobs":0,"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .responseCreated(let responseCreated) = event else {
            return XCTFail("Expected responseCreated")
        }
        XCTAssertEqual(responseCreated.sequenceNumber, 0)
        XCTAssertEqual(responseCreated.response?.id, "resp_123")
    }
    
    func testResponseInProgressEventIsDecodable() throws {
        let line = #"data: {"type":"response.in_progress","sequence_number":1,"response":{"id":"resp_123","object":"response","created_at":1751312720,"status":"in_progress","background":false,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"max_tool_calls":null,"model":"gpt-4o-2024-08-06","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"service_tier":"auto","store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[{"type":"web_search_preview","search_context_size":"low","user_location":{"type":"approximate","city":null,"country":"US","region":null,"timezone":null}}],"top_logprobs":0,"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .responseInProgress(let responseInProgress) = event else {
            return XCTFail("Expected in_progress")
        }
        XCTAssertEqual(responseInProgress.sequenceNumber, 1)
        XCTAssertEqual(responseInProgress.response?.id, "resp_123")
    }
    
    func testOutputItemAddedForWebSearchIsDecodable() throws {
        let line = #"data: {"type":"response.output_item.added","sequence_number":2,"output_index":0,"item":{"id":"ws_123","type":"web_search_call","status":"in_progress","action":{"type":"search"}}}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .outputItemAdded(let outputItemAdded) = event else {
            return XCTFail("Expected output_item.added")
        }
        XCTAssertEqual(outputItemAdded.sequenceNumber, 2)

        guard case .webSearchCall(let webSearchCall) = outputItemAdded.item else {
            return XCTFail("Expected web search call")
        }

        XCTAssertEqual(webSearchCall.id, "ws_123")
        XCTAssertEqual(webSearchCall.status, "in_progress")
    }

    func testWebSearchCallInProgressIsDecodable() throws {
        let line = #"data: {"type":"response.web_search_call.in_progress","sequence_number":3,"output_index":0,"item_id":"ws_123"}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .webSearchCallInProgress(let webSearchCallInProgress) = event else {
            return XCTFail("Expected response.web_search_call.in_progress")
        }
        XCTAssertEqual(webSearchCallInProgress.sequenceNumber, 3)
        XCTAssertEqual(webSearchCallInProgress.outputIndex, 0)
        XCTAssertEqual(webSearchCallInProgress.itemID, "ws_123")
    }

    func testWebSearchCallSearchingIsDecodable() throws {
        let line = #"data: {"type":"response.web_search_call.searching","sequence_number":4,"output_index":0,"item_id":"ws_123"}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .webSearchCallSearching(let webSearchCallSearching) = event else {
            return XCTFail("Expected response.web_search_call.searching")
        }
        XCTAssertEqual(webSearchCallSearching.sequenceNumber, 4)
        XCTAssertEqual(webSearchCallSearching.outputIndex, 0)
        XCTAssertEqual(webSearchCallSearching.itemID, "ws_123")
    }

    func testWebSearchCallCompletedIsDecodable() throws {
        let line = #"data: {"type":"response.web_search_call.completed","sequence_number":5,"output_index":0,"item_id":"ws_123"}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .webSearchCallCompleted(let webSearchCallCompleted) = event else {
            return XCTFail("Expected response.web_search_call.completed")
        }
        XCTAssertEqual(webSearchCallCompleted.sequenceNumber, 5)
        XCTAssertEqual(webSearchCallCompleted.outputIndex, 0)
        XCTAssertEqual(webSearchCallCompleted.itemID, "ws_123")
    }

    func testOutputItemDoneForWebSearchIsDecodable() throws {
        let line = #"data: {"type":"response.output_item.done","sequence_number":6,"output_index":0,"item":{"id":"ws_123","type":"web_search_call","status":"completed","action":{"type":"search","query":"Apple stock price today"}}}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .outputItemDone(let outputItemDone) = event else {
            return XCTFail("Expected response.output_item.done")
        }
        XCTAssertEqual(outputItemDone.sequenceNumber, 6)

        guard case .webSearchCall(let webSearchCall) = outputItemDone.item else {
            return XCTFail("Expected web search call")
        }

        XCTAssertEqual(webSearchCall.id, "ws_123")
        XCTAssertEqual(webSearchCall.status, "completed")
    }

    func testOutputItemAddedForContentIsDecodable() throws {
        let line = #"data: {"type":"response.output_item.added","sequence_number":7,"output_index":1,"item":{"id":"msg_123","type":"message","status":"in_progress","content":[],"role":"assistant"}}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .outputItemAdded(let outputItemAdded) = event else {
            return XCTFail("Expected output_item.added")
        }
        XCTAssertEqual(outputItemAdded.sequenceNumber, 7)

        guard case .message(let message) = outputItemAdded.item else {
            return XCTFail("Expected web search call")
        }

        XCTAssertEqual(message.id, "msg_123")
        XCTAssertEqual(message.status, "in_progress")
        XCTAssertEqual(message.role, "assistant")
        XCTAssertEqual(message.content.count, 0)
    }

    func testResponseContentPartAddedEventIsDecodable() throws {
        let line = #"data: {"type":"response.content_part.added","sequence_number":8,"item_id":"msg_6862e954231081a286253cf98401608e0986383194b1e8b5","output_index":1,"content_index":0,"part":{"type":"output_text","annotations":[],"logprobs":[],"text":""}}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .contentPartAdded(let contentPartAdded) = event else {
            return XCTFail("Expected response.content_part.added")
        }

        guard case .outputText(let outputText) = contentPartAdded.part else {
            return XCTFail("Expected the content part to contain output text")
        }

        XCTAssertEqual("", outputText.text)
    }
    
    func testResponseOutputTextDeltaEventIsDecodable() throws {
        let line = #"data: {"type":"response.output_text.delta","sequence_number":9,"item_id":"msg_123","output_index":1,"content_index":0,"delta":"As","logprobs":[]}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .outputTextDelta(let outputTextDelta) = event else {
            return XCTFail("Expected response.output_text.delta")
        }
        XCTAssertEqual(outputTextDelta.sequenceNumber, 9)
        XCTAssertEqual(outputTextDelta.itemID, "msg_123")
        XCTAssertEqual(outputTextDelta.delta, "As")
    }
    
    func testResponseOutputTextDoneEventIsDecodable() throws {
        let line = #"data: {"type":"response.output_text.done","sequence_number":89,"item_id":"msg_123","output_index":1,"content_index":0,"text":"As of June 30, 2025, snip","logprobs":[]}"#
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)

        guard case .outputTextDone(let outputTextDone) = event else {
            return XCTFail("Expected output_text.done")
        }
        XCTAssertEqual(outputTextDone.sequenceNumber, 89)
        XCTAssertEqual(outputTextDone.itemID, "msg_123")
        XCTAssertEqual(outputTextDone.text, "As of June 30, 2025, snip")
    }
//    
//    func testResponseContentPartDoneEventIsDecodable() throws {
//        let json = """
//        {"type":"response.content_part.done","sequence_number":43,"item_id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","output_index":0,"content_index":0,"part":{"type":"output_text","annotations":[],"text":"{\\"aaReply\\":\\"Hey! How can I assist you today?\\",\\"keyPhrasesAndIdeas\\":[],\\"newMemories\\":[],\\"questions\\":[],\\"removeMemories\\":[],\\"title\\":null}"}}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .contentPartDone(let data)? = event else {
//            return XCTFail("Expected content_part.done")
//        }
//        XCTAssertEqual(data.sequenceNumber, 43)
//    }
//    
//
//    func testResponseCompletedEventIsDecodable() throws {
//        let json = """
//        {"type":"response.completed","sequence_number":45,"response":{"id":"resp_6856e03bd0588199b0a48736fe3bec190484fb09fc524d66","object":"response","created_at":1750523963,"status":"completed","background":false,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[{"id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","type":"message","status":"completed","content":[{"type":"output_text","annotations":[],"text":"{\\"aaReply\\":\\"Hey! How can I assist you today?\\",\\"keyPhrasesAndIdeas\\":[],\\"newMemories\\":[],\\"questions\\":[],\\"removeMemories\\":[],\\"title\\":null}"}],"role":"assistant"}],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"service_tier":"default","store":true,"temperature":0.6,"text":{"format":{"type":"json_schema","description":null,"name":"brainstorm_response","schema":{"additionalProperties":false,"properties":{"aaReply":{"type":"string"},"keyPhrasesAndIdeas":{"items":{"additionalProperties":false,"properties":{"ideas":{"items":{"type":"string"},"type":"array"},"keyPhrase":{"type":"string"}},"required":["keyPhrase","ideas"],"type":"object"},"type":["array","null"]},"newMemories":{"items":{"type":"string"},"type":["array","null"]},"questions":{"items":{"type":"string"},"type":["array","null"]},"removeMemories":{"items":{"type":"string"},"type":["array","null"]},"title":{"type":["string","null"]}},"required":["keyPhrasesAndIdeas","questions","newMemories","removeMemories","title","aaReply"],"type":"object"},"strict":true}},"tool_choice":"auto","tools":[],"top_p":0.8,"truncation":"disabled","usage":{"input_tokens":1332,"input_tokens_details":{"cached_tokens":0},"output_tokens":39,"output_tokens_details":{"reasoning_tokens":0},"total_tokens":1371},"user":"98558159-A4EB-48B5-8DB6-9A5A67D2644F","metadata":{}}}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .responseCompleted(let data)? = event else {
//            return XCTFail("Expected response.completed")
//        }
//        XCTAssertEqual(data.sequenceNumber, 45)
//    }
//    
//    func testResponseFailedEventIsDecodable() throws {
//        let json = """
//        {"type":"response.failed","sequence_number":1,"response":{"id":"resp_123","object":"response","created_at":1740855869,"status":"failed","error":{"code":"server_error","message":"The model failed to generate a response."},"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .responseFailed(let data)? = event else {
//            return XCTFail("Expected response.failed")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseIncompleteEventIsDecodable() throws {
//        let json = """
//        {"type":"response.incomplete","response":{"id":"resp_123","object":"response","created_at":1740855869,"status":"incomplete","error":null,"incomplete_details":{"reason":"max_tokens"},"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{}},"sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .responseIncomplete(let data)? = event else {
//            return XCTFail("Expected response.incomplete")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseRefusalDeltaEventIsDecodable() throws {
//        let json = """
//        {"type":"response.refusal.delta","item_id":"msg_123","output_index":0,"content_index":0,"delta":"refusal text so far","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .refusalDelta(let data)? = event else {
//            return XCTFail("Expected refusal.delta")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//        XCTAssertEqual(data.delta, "refusal text so far")
//    }
//    
//    func testResponseRefusalDoneEventIsDecodable() throws {
//        let json = """
//        {"type":"response.refusal.done","item_id":"item-abc","output_index":1,"content_index":2,"refusal":"final refusal text","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .refusalDone(let data)? = event else {
//            return XCTFail("Expected refusal.done")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//        XCTAssertEqual(data.refusal, "final refusal text")
//    }
//    
//    func testResponseFunctionCallArgumentsDeltaEventIsDecodable() throws {
//        let json = """
//        {"type":"response.function_call_arguments.delta","item_id":"item-abc","output_index":0,"delta":"{ \\"arg\\":","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .functionCallArgumentsDelta(let data)? = event else {
//            return XCTFail("Expected function_call_arguments.delta")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseFunctionCallArgumentsDoneEventIsDecodable() throws {
//        let json = """
//        {"type":"response.function_call_arguments.done","item_id":"item-abc","output_index":1,"arguments":"{ \\"arg\\": 123 }","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .functionCallArgumentsDone(let data)? = event else {
//            return XCTFail("Expected function_call_arguments.done")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseFileSearchCallInProgressEventIsDecodable() throws {
//        let json = """
//        {"type":"response.file_search_call.in_progress","output_index":0,"item_id":"fs_123","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .fileSearchCallProgress(let data)? = event else {
//            return XCTFail("Expected file_search_call.in_progress")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseFileSearchCallSearchingEventIsDecodable() throws {
//        let json = """
//        {"type":"response.file_search_call.searching","output_index":0,"item_id":"fs_123","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .fileSearchCallProgress(let data)? = event else {
//            return XCTFail("Expected file_search_call.searching")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseFileSearchCallCompletedEventIsDecodable() throws {
//        let json = """
//        {"type":"response.file_search_call.completed","output_index":0,"item_id":"fs_123","sequence_number":1}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .fileSearchCallProgress(let data)? = event else {
//            return XCTFail("Expected file_search_call.completed")
//        }
//        XCTAssertEqual(data.sequenceNumber, 1)
//    }
//    
//    func testResponseWebSearchCallInProgressEventIsDecodable() throws {
//        let json = """
//        {"type":"response.web_search_call.in_progress","output_index":0,"item_id":"ws_123","sequence_number":0}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .webSearchCallProgress(let data)? = event else {
//            return XCTFail("Expected web_search_call.in_progress")
//        }
//        XCTAssertEqual(data.sequenceNumber, 0)
//    }
//    
//    func testResponseWebSearchCallSearchingEventIsDecodable() throws {
//        let json = """
//        {"type":"response.web_search_call.searching","output_index":0,"item_id":"ws_123","sequence_number":0}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .webSearchCallProgress(let data)? = event else {
//            return XCTFail("Expected web_search_call.searching")
//        }
//        XCTAssertEqual(data.sequenceNumber, 0)
//    }
//    
//    func testResponseWebSearchCallCompletedEventIsDecodable() throws {
//        let json = """
//        {"type":"response.web_search_call.completed","output_index":0,"item_id":"ws_123","sequence_number":0}
//        """
//        
//        let line = "data: " + json
//        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
//
//        guard case .webSearchCallProgress(let data)? = event else {
//            return XCTFail("Expected web_search_call.completed")
//        }
//        XCTAssertEqual(data.sequenceNumber, 0)
//    }
}
