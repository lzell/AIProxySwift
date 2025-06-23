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
        let json = """
        {"type":"response.created","sequence_number":0,"response":{"id":"resp_6856de6da35081989d78b09b237ef11303108854ae8779ab","object":"response","created_at":1750523501,"status":"in_progress","background":false,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"service_tier":"auto","store":true,"temperature":0.6,"text":{"format":{"type":"json_schema","description":null,"name":"brainstorm_response","schema":{"additionalProperties":false,"properties":{"aaReply":{"type":"string"},"keyPhrasesAndIdeas":{"items":{"additionalProperties":false,"properties":{"ideas":{"items":{"type":"string"},"type":"array"},"keyPhrase":{"type":"string"}},"required":["ideas","keyPhrase"],"type":"object"},"type":["array","null"]},"newMemories":{"items":{"type":"string"},"type":["array","null"]},"questions":{"items":{"type":"string"},"type":["array","null"]},"removeMemories":{"items":{"type":"string"},"type":["array","null"]},"title":{"type":["string","null"]}},"required":["aaReply","keyPhrasesAndIdeas","newMemories","questions","title","removeMemories"],"type":"object"},"strict":true}},"tool_choice":"auto","tools":[],"top_p":0.8,"truncation":"disabled","usage":null,"user":"98558159-A4EB-48B5-8DB6-9A5A67D2644F","metadata":{}}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.type, .responseCreated)
        XCTAssertEqual(event?.sequenceNumber, 0)
    }
    
    func testResponseInProgressEventIsDecodable() throws {
        let json = """
        {"type":"response.in_progress","sequence_number":1,"response":{"id":"resp_6856de6da35081989d78b09b237ef11303108854ae8779ab","object":"response","created_at":1750523501,"status":"in_progress","background":false,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"service_tier":"auto","store":true,"temperature":0.6,"text":{"format":{"type":"json_schema","description":null,"name":"brainstorm_response","schema":{"additionalProperties":false,"properties":{"aaReply":{"type":"string"},"keyPhrasesAndIdeas":{"items":{"additionalProperties":false,"properties":{"ideas":{"items":{"type":"string"},"type":"array"},"keyPhrase":{"type":"string"}},"required":["ideas","keyPhrase"],"type":"object"},"type":["array","null"]},"newMemories":{"items":{"type":"string"},"type":["array","null"]},"questions":{"items":{"type":"string"},"type":["array","null"]},"removeMemories":{"items":{"type":"string"},"type":["array","null"]},"title":{"type":["string","null"]}},"required":["aaReply","keyPhrasesAndIdeas","newMemories","questions","title","removeMemories"],"type":"object"},"strict":true}},"tool_choice":"auto","tools":[],"top_p":0.8,"truncation":"disabled","usage":null,"user":"98558159-A4EB-48B5-8DB6-9A5A67D2644F","metadata":{}}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.in_progress event")
        XCTAssertEqual(event?.type, .responseInProgress)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseOutputItemAddedEventIsDecodable() throws {
        let json = """
        {"type":"response.output_item.added","sequence_number":2,"output_index":0,"item":{"id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","type":"message","status":"in_progress","content":[],"role":"assistant"}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.output_item.added event")
        XCTAssertEqual(event?.type, .responseOutputItemAdded)
        XCTAssertEqual(event?.sequenceNumber, 2)
    }
    
    func testResponseContentPartAddedEventIsDecodable() throws {
        let json = """
        {"type":"response.content_part.added","sequence_number":3,"item_id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","output_index":0,"content_index":0,"part":{"type":"output_text","annotations":[],"text":""}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.content_part.added event")
        XCTAssertEqual(event?.type, .responseContentPartAdded)
        XCTAssertEqual(event?.sequenceNumber, 3)
    }
    
    func testResponseOutputTextDeltaEventIsDecodable() throws {
        let json = """
        {"type":"response.output_text.delta","sequence_number":4,"item_id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","output_index":0,"content_index":0,"delta":"{\\""}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.output_text.delta event")
        XCTAssertEqual(event?.type, .responseOutputTextDelta)
        XCTAssertEqual(event?.sequenceNumber, 4)
        
        if case .outputTextDelta(let data) = event?.data {
            XCTAssertEqual(data.delta, "{\"")
        } else {
            XCTFail("Expected outputTextDelta data")
        }
    }
    
    func testResponseOutputTextDoneEventIsDecodable() throws {
        let json = """
        {"type":"response.output_text.done","sequence_number":42,"item_id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","output_index":0,"content_index":0,"text":"{\\"aaReply\\":\\"Hey! How can I assist you today?\\",\\"keyPhrasesAndIdeas\\":[],\\"newMemories\\":[],\\"questions\\":[],\\"removeMemories\\":[],\\"title\\":null}"}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.output_text.done event")
        XCTAssertEqual(event?.type, .responseOutputTextDone)
        XCTAssertEqual(event?.sequenceNumber, 42)
    }
    
    func testResponseContentPartDoneEventIsDecodable() throws {
        let json = """
        {"type":"response.content_part.done","sequence_number":43,"item_id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","output_index":0,"content_index":0,"part":{"type":"output_text","annotations":[],"text":"{\\"aaReply\\":\\"Hey! How can I assist you today?\\",\\"keyPhrasesAndIdeas\\":[],\\"newMemories\\":[],\\"questions\\":[],\\"removeMemories\\":[],\\"title\\":null}"}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.content_part.done event")
        XCTAssertEqual(event?.type, .responseContentPartDone)
        XCTAssertEqual(event?.sequenceNumber, 43)
    }
    
    func testResponseOutputItemDoneEventIsDecodable() throws {
        let json = """
        {"type":"response.output_item.done","sequence_number":44,"output_index":0,"item":{"id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","type":"message","status":"completed","content":[{"type":"output_text","annotations":[],"text":"{\\"aaReply\\":\\"Hey! How can I assist you today?\\",\\"keyPhrasesAndIdeas\\":[],\\"newMemories\\":[],\\"questions\\":[],\\"removeMemories\\":[],\\"title\\":null}"}],"role":"assistant"}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.output_item.done event")
        XCTAssertEqual(event?.type, .responseOutputItemDone)
        XCTAssertEqual(event?.sequenceNumber, 44)
    }
    
    func testResponseCompletedEventIsDecodable() throws {
        let json = """
        {"type":"response.completed","sequence_number":45,"response":{"id":"resp_6856e03bd0588199b0a48736fe3bec190484fb09fc524d66","object":"response","created_at":1750523963,"status":"completed","background":false,"error":null,"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[{"id":"msg_6856e03c97888199971fa4d4fa47f4d20484fb09fc524d66","type":"message","status":"completed","content":[{"type":"output_text","annotations":[],"text":"{\\"aaReply\\":\\"Hey! How can I assist you today?\\",\\"keyPhrasesAndIdeas\\":[],\\"newMemories\\":[],\\"questions\\":[],\\"removeMemories\\":[],\\"title\\":null}"}],"role":"assistant"}],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"service_tier":"default","store":true,"temperature":0.6,"text":{"format":{"type":"json_schema","description":null,"name":"brainstorm_response","schema":{"additionalProperties":false,"properties":{"aaReply":{"type":"string"},"keyPhrasesAndIdeas":{"items":{"additionalProperties":false,"properties":{"ideas":{"items":{"type":"string"},"type":"array"},"keyPhrase":{"type":"string"}},"required":["keyPhrase","ideas"],"type":"object"},"type":["array","null"]},"newMemories":{"items":{"type":"string"},"type":["array","null"]},"questions":{"items":{"type":"string"},"type":["array","null"]},"removeMemories":{"items":{"type":"string"},"type":["array","null"]},"title":{"type":["string","null"]}},"required":["keyPhrasesAndIdeas","questions","newMemories","removeMemories","title","aaReply"],"type":"object"},"strict":true}},"tool_choice":"auto","tools":[],"top_p":0.8,"truncation":"disabled","usage":{"input_tokens":1332,"input_tokens_details":{"cached_tokens":0},"output_tokens":39,"output_tokens_details":{"reasoning_tokens":0},"total_tokens":1371},"user":"98558159-A4EB-48B5-8DB6-9A5A67D2644F","metadata":{}}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.completed event")
        XCTAssertEqual(event?.type, .responseCompleted)
        XCTAssertEqual(event?.sequenceNumber, 45)
    }
    
    func testResponseFailedEventIsDecodable() throws {
        let json = """
        {"type":"response.failed","sequence_number":1,"response":{"id":"resp_123","object":"response","created_at":1740855869,"status":"failed","error":{"code":"server_error","message":"The model failed to generate a response."},"incomplete_details":null,"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.failed event")
        XCTAssertEqual(event?.type, .responseFailed)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseIncompleteEventIsDecodable() throws {
        let json = """
        {"type":"response.incomplete","response":{"id":"resp_123","object":"response","created_at":1740855869,"status":"incomplete","error":null,"incomplete_details":{"reason":"max_tokens"},"instructions":null,"max_output_tokens":null,"model":"gpt-4o-mini-2024-07-18","output":[],"previous_response_id":null,"reasoning_effort":null,"store":false,"temperature":1,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1,"truncation":"disabled","usage":null,"user":null,"metadata":{}},"sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.incomplete event")
        XCTAssertEqual(event?.type, .responseIncomplete)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseRefusalDeltaEventIsDecodable() throws {
        let json = """
        {"type":"response.refusal.delta","item_id":"msg_123","output_index":0,"content_index":0,"delta":"refusal text so far","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.refusal.delta event")
        XCTAssertEqual(event?.type, .responseRefusalDelta)
        XCTAssertEqual(event?.sequenceNumber, 1)
        
        if case .refusalDelta(let data) = event?.data {
            XCTAssertEqual(data.delta, "refusal text so far")
        } else {
            XCTFail("Expected refusalDelta data")
        }
    }
    
    func testResponseRefusalDoneEventIsDecodable() throws {
        let json = """
        {"type":"response.refusal.done","item_id":"item-abc","output_index":1,"content_index":2,"refusal":"final refusal text","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.refusal.done event")
        XCTAssertEqual(event?.type, .responseRefusalDone)
        XCTAssertEqual(event?.sequenceNumber, 1)
        
        if case .refusalDone(let data) = event?.data {
            XCTAssertEqual(data.refusal, "final refusal text")
        } else {
            XCTFail("Expected refusalDone data")
        }
    }
    
    func testResponseFunctionCallArgumentsDeltaEventIsDecodable() throws {
        let json = """
        {"type":"response.function_call_arguments.delta","item_id":"item-abc","output_index":0,"delta":"{ \\"arg\\":","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.function_call_arguments.delta event")
        XCTAssertEqual(event?.type, .responseFunctionCallArgumentsDelta)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseFunctionCallArgumentsDoneEventIsDecodable() throws {
        let json = """
        {"type":"response.function_call_arguments.done","item_id":"item-abc","output_index":1,"arguments":"{ \\"arg\\": 123 }","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.function_call_arguments.done event")
        XCTAssertEqual(event?.type, .responseFunctionCallArgumentsDone)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseFileSearchCallInProgressEventIsDecodable() throws {
        let json = """
        {"type":"response.file_search_call.in_progress","output_index":0,"item_id":"fs_123","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.file_search_call.in_progress event")
        XCTAssertEqual(event?.type, .responseFileSearchCallInProgress)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseFileSearchCallSearchingEventIsDecodable() throws {
        let json = """
        {"type":"response.file_search_call.searching","output_index":0,"item_id":"fs_123","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.file_search_call.searching event")
        XCTAssertEqual(event?.type, .responseFileSearchCallSearching)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseFileSearchCallCompletedEventIsDecodable() throws {
        let json = """
        {"type":"response.file_search_call.completed","output_index":0,"item_id":"fs_123","sequence_number":1}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.file_search_call.completed event")
        XCTAssertEqual(event?.type, .responseFileSearchCallCompleted)
        XCTAssertEqual(event?.sequenceNumber, 1)
    }
    
    func testResponseWebSearchCallInProgressEventIsDecodable() throws {
        let json = """
        {"type":"response.web_search_call.in_progress","output_index":0,"item_id":"ws_123","sequence_number":0}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.web_search_call.in_progress event")
        XCTAssertEqual(event?.type, .responseWebSearchCallInProgress)
        XCTAssertEqual(event?.sequenceNumber, 0)
    }
    
    func testResponseWebSearchCallSearchingEventIsDecodable() throws {
        let json = """
        {"type":"response.web_search_call.searching","output_index":0,"item_id":"ws_123","sequence_number":0}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.web_search_call.searching event")
        XCTAssertEqual(event?.type, .responseWebSearchCallSearching)
        XCTAssertEqual(event?.sequenceNumber, 0)
    }
    
    func testResponseWebSearchCallCompletedEventIsDecodable() throws {
        let json = """
        {"type":"response.web_search_call.completed","output_index":0,"item_id":"ws_123","sequence_number":0}
        """
        
        let line = "data: " + json
        let event = OpenAIResponseStreamingEvent.deserialize(fromLine: line)
        
        XCTAssertNotNil(event, "Failed to deserialize response.web_search_call.completed event")
        XCTAssertEqual(event?.type, .responseWebSearchCallCompleted)
        XCTAssertEqual(event?.sequenceNumber, 0)
    }
}
