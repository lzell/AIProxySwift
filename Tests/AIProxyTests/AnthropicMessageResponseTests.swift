import XCTest
import Foundation
@testable import AIProxy


final class AnthropicMessageResponseTests: XCTestCase {

    func testMessageResponseIsDecodable() {
        let sampleResponse = """
        {
          "id": "msg_01XVo4dCtcbBTds8pG1BC6Xf",
          "type": "message",
          "role": "assistant",
          "model": "claude-3-5-sonnet-20240620",
          "content": [
            {
              "type": "text",
              "text": "Hello!"
            }
          ],
          "stop_reason": "end_turn",
          "stop_sequence": null,
          "usage": {
            "input_tokens": 9,
            "output_tokens": 28
          }
        }
        """
        let decoder = JSONDecoder()

        let res = try! decoder.decode(
            AnthropicMessageResponseBody.self,
            from: sampleResponse.data(using: .utf8)!
        )
        switch res.content.first! {
        case .text(let string):
            XCTAssertEqual("Hello!", string)
        default:
            XCTFail()
        }
    }

    func testMessageResponseWithToolUseIsDecodable() {
        let sampleResponse = """
        {
          "id": "msg_011UvQXaEMMwmN4kapqwUpN2",
          "type": "message",
          "role": "assistant",
          "model": "claude-3-5-sonnet-20240620",
          "content": [
            {
              "type": "text",
              "text": "To get Nvidia's stock price, we need to use the stock symbol for Nvidia, which is NVDA. I'll use the available function to retrieve this information for you."
            },
            {
              "type": "tool_use",
              "id": "toolu_01GZovj2vHs5AKsNAshWFgUT",
              "name": "get_stock_symbol",
              "input": {
                "ticker": "NVDA"
              }
            }
          ],
          "stop_reason": "tool_use",
          "stop_sequence": null,
          "usage": {
            "input_tokens": 389,
            "output_tokens": 96
          }
        }
        """

        let res = try! AnthropicMessageResponseBody.deserialize(from: sampleResponse.data(using: .utf8)!)

        switch res.content.last! {
        case .toolUse(id: let id, name: let toolName, input: let input):
            XCTAssertEqual("get_stock_symbol", toolName)
            XCTAssertEqual("toolu_01GZovj2vHs5AKsNAshWFgUT", id)
            XCTAssertEqual("NVDA", input["ticker"] as? String)
        default:
            XCTFail()
        }
    }
}
