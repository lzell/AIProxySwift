//
//  OpenAIInputContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: InputContent, version 2.3.0, line 44803
// OpenAPI spec: InputMessageContentList, version 2.3.0, line 44860
// OpenAPI spec: FunctionAndCustomToolCallOutput, version 2.3.0, line 43338
// Encodable: https://platform.openai.com/docs/api-reference/conversations/create#conversations_create-items-item-custom_tool_call_output-output-output_content_list
// Decodable: https://platform.openai.com/docs/api-reference/conversations/list-items-object#conversations-list_items_object-data-custom_tool_call_output-output-output_content_list

nonisolated public enum OpenAIInputContent: Codable, Sendable {
    case text(OpenAIInputText)
    case image(OpenAIInputImage)
    case file(OpenAIInputFile)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "input_file":
            self = .file(try OpenAIInputFile(from: decoder))
        case "input_image":
            self = .image(try OpenAIInputImage(from: decoder))
        case "input_text":
            self = .text(try OpenAIInputText(from: decoder))
        default:
            self = .futureProof
            logIf(.error)?.error("AIProxy: Could not decode input content type \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .text(let content):
            try content.encode(to: encoder)
        case .image(let content):
            try content.encode(to: encoder)
        case .file(let content):
            try content.encode(to: encoder)
        case .futureProof:
            break
        }
    }
}
