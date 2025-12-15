import XCTest
import Foundation
@testable import AIProxy


final class AnthropicMessageResponseTests: XCTestCase {

    func testMessageResponseIsDecodable() throws {
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

        let res = try AnthropicMessage.deserialize(from: sampleResponse)
        switch res.content.first! {
        case .textBlock(let textBlock):
            XCTAssertEqual("Hello!", textBlock.text)
        default:
            XCTFail()
        }
    }

    func testMessageResponseWithToolUseIsDecodable() throws {
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

        let res = try AnthropicMessage.deserialize(from: sampleResponse)

        switch res.content.last! {
        case .toolUseBlock(let toolUseBlock):
            XCTAssertEqual("get_stock_symbol", toolUseBlock.name)
            XCTAssertEqual("toolu_01GZovj2vHs5AKsNAshWFgUT", toolUseBlock.id)
            if let ticker = toolUseBlock.input["ticker"] as? String {
                XCTAssertEqual("NVDA", ticker)
            } else {
                XCTFail()
            }
        default:
            XCTFail()
        }
    }
}
