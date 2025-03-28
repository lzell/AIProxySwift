//
//  OpenAICreateResponseRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/12/25.
//

/// OpenAI's most advanced interface for generating model responses.
/// Supports text and image inputs, and text outputs.
/// Create stateful interactions with the model, using the output of previous responses as input.
/// Extend the model's capabilities with built-in tools for file search, web search, computer use, and more.
/// Allow the model access to external systems and data using function calling.
/// https://platform.openai.com/docs/api-reference/responses/create
/// Implementor's note: See ResponseCreateParamsBase in `src/openai/types/responses/response_create_params.py`
public struct OpenAICreateResponseRequestBody: Encodable {
    /// Text, image, or file inputs to the model, used to generate a response.
    public let input: Input
    public let model: String

    public init(
        input: OpenAICreateResponseRequestBody.Input,
        model: String
    ) {
        self.input = input
        self.model = model
    }
}

extension OpenAICreateResponseRequestBody {
    public enum Input: Encodable {
        case text(String)
        case items([ItemOrMessage])

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .text(let txt):
                try container.encode(txt)
            case .items(let items):
                try container.encode(items)
            }
        }
    }

    public enum ItemOrMessage: Encodable {
        case message(role: Role, content: Content)

        private struct _Message: Encodable {
            let role: Role
            let content: Content

            private enum CodingKeys: CodingKey {
                case content
                case role
                case type
            }

            func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("message", forKey: .type)
                try container.encode(self.role.rawValue, forKey: .role)
                try container.encode(self.content, forKey: .content)
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .message(role: let role, content: let content):
                try container.encode(_Message(role: role, content: content))
            }
        }
    }

    public enum Role: String, Encodable {
        case user
        case assistant
        case system
        case developer
    }

    public enum Content: Encodable {
        case text(String)
        case list([ItemContent])

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .text(let txt):
                try container.encode(txt)
            case .list(let itemContent):
                try container.encode(itemContent)
            }
        }
    }

    public enum ItemContent: Encodable {
        case text(String)
        case file(fileID: String)

        private enum CodingKeys: String, CodingKey {
            case type
            case text
            case fileID = "file_id"
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .text(let txt):
                try container.encode(txt, forKey: .text)
                try container.encode("input_text", forKey: .type)
            case .file(let fileID):
                try container.encode(fileID, forKey: .fileID)
                try container.encode("input_file", forKey: .type)
            }
        }
    }
}
