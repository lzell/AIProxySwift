//
//  OpenAIMessageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: Message#content union, version 2.3.0, line 65175
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-message-content

/// Content of a message.
nonisolated public enum OpenAIMessageContent: Decodable, Sendable {

    /// A text input to the model.
    case inputText(OpenAIInputText)

    /// A text output from the model.
    case outputText(OpenAIOutputText)

    /// A text content.
    case text(OpenAIText)

    /// A summary text from the model.
    case summaryText(OpenAISummaryText)

    /// Reasoning text from the model.
    case reasoningText(OpenAIReasoningText)

    /// A refusal from the model.
    case refusal(OpenAIRefusal)

    /// An image input to the model. Learn about image inputs: https://platform.openai.com/docs/guides/vision
    case inputImage(OpenAIInputImage)

    /// A screenshot of a computer.
    case computerScreenshot(OpenAIComputerScreenshot)

    /// A file input to the model.
    case inputFile(OpenAIInputFile)

    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "computer_screenshot":
            self = .computerScreenshot(try OpenAIComputerScreenshot(from: decoder))
        case "input_file":
            self = .inputFile(try OpenAIInputFile(from: decoder))
        case "input_image":
            self = .inputImage(try OpenAIInputImage(from: decoder))
        case "input_text":
            self = .inputText(try OpenAIInputText(from: decoder))
        case "output_text":
            self = .outputText(try OpenAIOutputText(from: decoder))
        case "reasoning_text":
            self = .reasoningText(try OpenAIReasoningText(from: decoder))
        case "refusal":
            self = .refusal(try OpenAIRefusal(from: decoder))
        case "summary_text":
            self = .summaryText(try OpenAISummaryText(from: decoder))
        case "text":
            self = .text(try OpenAIText(from: decoder))
        default:
            logIf(.error)?.error("Unknown message content type: \(type)")
            self = .futureProof
        }
    }
}
