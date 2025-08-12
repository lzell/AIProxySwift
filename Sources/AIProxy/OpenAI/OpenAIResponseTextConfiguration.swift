//
//  OpenAIResponseTextConfiguration.swift
//  AIProxy
//
//  Created by Lou Zell on 7/21/25.
//

extension OpenAIResponse {
    public struct TextConfiguration: Codable {
        /// The format specification for the text output
        public let format: Format?

        /// Constrains the verbosity of the model's response. Lower values will result in more concise responses,
        /// while higher values will result in more verbose responses. Currently supported values are low, medium, and high.
        public let verbosity: Verbosity?

        public init(format: Format? = nil, verbosity: Verbosity? = nil) {
            self.format = format
            self.verbosity = verbosity
        }
    }
}

extension OpenAIResponse.TextConfiguration {
    /// An object specifying the format that the model must output.
    /// The case `.jsonObject` is **not recommended for gpt-4o and newer models.**
    public enum Format: Codable {

        /// This case is no longer recommended.
        /// Using `.jsonSchema` is preferred for models that support it.
        ///
        /// Enables the older JSON mode, which ensures the message the model generates is valid JSON.
        /// Important: when using JSON mode, you must also instruct the model to produce JSON yourself via a
        /// system or user message. Without this, the model may generate an unending stream of whitespace until
        /// the generation reaches the token limit, resulting in a long-running and seemingly "stuck" request.
        /// Also note that the message content may be partially cut off if `finish_reason="length"`, which indicates
        /// the generation exceeded `max_tokens` or the conversation exceeded the max context length.
        case jsonObject

        /// Enables Structured Outputs which ensures the model will match your supplied JSON schema.
        /// Learn more in the Structured Outputs guide: https://platform.openai.com/docs/guides/structured-outputs
        ///
        /// - Parameters:
        ///   - name: The name of the response format. Must be a-z, A-Z, 0-9, or contain underscores and dashes,
        ///           with a maximum length of 64.
        ///
        ///   - schema: The schema for the response format, described as a JSON Schema object.
        ///
        ///   - description: A description of what the response format is for, used by the model to determine how
        ///                  to respond in the format.
        ///
        ///   - strict: Whether to enable strict schema adherence when generating the output. If set to true, the
        ///             model will always follow the exact schema defined in the schema field. Only a subset of JSON Schema
        ///             is supported when strict is true. To learn more, read the Structured Outputs guide.
        case jsonSchema(
            name: String,
            schema: [String: AIProxyJSONValue],
            description: String? = nil,
            strict: Bool? = nil
        )

        /// Instructs the model to produce text only.
        case text

        private enum RootKey: String, CodingKey {
            case type

            // There is a difference in structure compared to the chat completion implementation of OpenAIChatCompletionRequestBody.ResponseFormat.
            // In the responsesAPI, these fields are not nested under a separate key.
            case name
            case schema
            case strict
            case description
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .jsonObject:
                try container.encode("json_object", forKey: .type)
            case .jsonSchema(
                name: let name,
                schema: let schema,
                description: let description,
                strict: let strict
            ):
                try container.encode("json_schema", forKey: .type)
                try container.encode(name, forKey: .name)
                try container.encode(schema, forKey: .schema)
                try container.encodeIfPresent(description, forKey: .description)
                try container.encodeIfPresent(strict, forKey: .strict)
            case .text:
                try container.encode("text", forKey: .type)
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RootKey.self)
            let type = try container.decode(String.self, forKey: .type)

            switch type {
            case "json_object":
                self = .jsonObject
            case "json_schema":
                let name = try container.decode(String.self, forKey: .name)
                let schema = try container.decode([String: AIProxyJSONValue].self, forKey: .schema)
                let description = try container.decodeIfPresent(String.self, forKey: .description)
                let strict = try container.decodeIfPresent(Bool.self, forKey: .strict)
                self = .jsonSchema(
                    name: name,
                    schema: schema,
                    description: description,
                    strict: strict
                )
            case "text":
                self = .text
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Unknown response format type: \(type)"
                )
            }
        }
    }

    /// Supported verbosity levels for model responses
    public enum Verbosity: String, Codable {
        case low
        case medium
        case high
    }
}
