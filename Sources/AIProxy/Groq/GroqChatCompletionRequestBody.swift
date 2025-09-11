//
//  GroqChatCompletionRequestBody.swift
//
//
//  Created by Lou Zell on 9/29/24.
//

import Foundation


/// Docstrings are from:
/// https://console.groq.com/docs/api-reference#chat-create
nonisolated public struct GroqChatCompletionRequestBody: Encodable {

    // Required

    /// A list of messages comprising the conversation so far.
    public let messages: [Message]

    /// ID of the model to use. For details on which models are compatible with the Chat API, see available models
    public let model: String

    // Optional

    /// Positive values penalize new tokens based on their existing frequency in the text so
    /// far, decreasing the model's likelihood to repeat the same line verbatim.
    /// Number between -2.0 and 2.0.
    /// Defaults to 0
    public let frequencyPenalty: Double?

    /// The maximum number of tokens that can be generated in the chat completion. The total
    /// length of input tokens and generated tokens is limited by the model's context length.
    public let maxTokens: Int?

    /// How many chat completion choices to generate for each input message. Note that the
    /// current moment, only n=1 is supported. Other values will result in a 400 response.
    /// Defaults to 1
    public let n: Int?

    /// Whether to enable parallel function calling during tool use.
    /// Defaults to true
    public let parallelToolCalls: Bool?

    /// Positive values penalize new tokens based on whether they appear in the text so far,
    /// increasing the model's likelihood to talk about new topics.
    /// Number between -2.0 and 2.0.
    /// Defaults to 0
    public let presencePenalty: Double?

    /// An object specifying the format that the model must output.
    ///
    /// Setting to `{ "type": "json_object" }` enables JSON mode, which guarantees the message
    /// the model generates is valid JSON.
    ///
    /// Important: when using JSON mode, you must also instruct the model to produce JSON
    /// yourself via a system or user message.
    public let responseFormat: ResponseFormat?

    /// If specified, our system will make a best effort to sample deterministically, such that
    /// repeated requests with the same seed and parameters should return the same result.
    /// Determinism is not guaranteed, and you should refer to the system_fingerprint response
    /// parameter to monitor changes in the backend.
    public let seed: Int?

    /// Up to 4 sequences where the API will stop generating further tokens. The returned text
    /// will not contain the stop sequence.
    public let stop: [String]?

    /// If set, partial message deltas will be sent. Tokens will be sent as data-only
    /// server-sent events as they become available.
    var stream: Bool?

    /// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the
    /// output more random, while lower values like 0.2 will make it more focused and
    /// deterministic. We generally recommend altering this or top_p but not both
    /// Defaults to 1
    public let temperature: Double?

    /// Controls which (if any) tool is called by the model. none means the model will not call
    /// any tool and instead generates a message. auto means the model can pick between
    /// generating a message or calling one or more tools. required means the model must call
    /// one or more tools. Specifying a particular tool via
    /// `{"type": "function", "function": {"name": "my_function"}}` forces the model to call
    /// that tool.
    ///
    /// `none` is the default when no tools are present.
    /// `auto` is the default if tools are present.
    // public let toolChoice: ToolChoice?

    /// A list of tools the model may call. Currently, only functions are supported as a tool.
    /// Use this to provide a list of functions the model may generate JSON inputs for. A max
    /// of 128 functions are supported.
    // public let tools: [Tool]?

    /// An alternative to sampling with temperature, called nucleus sampling, where the model
    /// considers the results of the tokens with top_p probability mass. So 0.1 means only the
    /// tokens comprising the top 10% probability mass are considered. We generally recommend
    /// altering this or temperature but not both.
    /// Defaults to 1
    public let topP: Double?

    /// A unique identifier representing your end-user, which can help us monitor and detect
    /// abuse.
    public let user: String?

    enum CodingKeys: String, CodingKey {
        case frequencyPenalty = "frequency_penalty"
        case maxTokens = "max_tokens"
        case messages
        case model
        case n
        case parallelToolCalls = "parallel_tool_calls"
        case presencePenalty = "presence_penalty"
        case responseFormat = "response_format"
        case seed
        case stop
        case stream
        case temperature
//        // case toolChoice = "tool_choice"
//        // case tools
        case topP = "top_p"
        case user
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        messages: [GroqChatCompletionRequestBody.Message],
        model: String,
        frequencyPenalty: Double? = nil,
        maxTokens: Int? = nil,
        n: Int? = nil,
        parallelToolCalls: Bool? = nil,
        presencePenalty: Double? = nil,
        responseFormat: GroqChatCompletionRequestBody.ResponseFormat? = nil,
        seed: Int? = nil,
        stop: [String]? = nil,
        stream: Bool? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        user: String? = nil
    ) {
        self.messages = messages
        self.model = model
        self.frequencyPenalty = frequencyPenalty
        self.maxTokens = maxTokens
        self.n = n
        self.parallelToolCalls = parallelToolCalls
        self.presencePenalty = presencePenalty
        self.responseFormat = responseFormat
        self.seed = seed
        self.stop = stop
        self.stream = stream
        self.temperature = temperature
        self.topP = topP
        self.user = user
    }
}

// MARK: - RequestBody.Message
extension GroqChatCompletionRequestBody {
    nonisolated public enum Message: Encodable, Sendable {
        /// Assistant message
        /// - Parameters:
        ///   - content: The contents of the assistant message
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        case assistant(content: String, name: String? = nil)

        /// A system message
        /// - Parameters:
        ///   - content: The contents of the system message.
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        case system(content: String, name: String? = nil)

        /// A user message
        /// - Parameters:
        ///   - content: The contents of the user message.
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        case user(content: UserContent, name: String? = nil)

        private enum RootKey: String, CodingKey {
            case content
            case role
            case name
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .assistant(let content, let name):
                try container.encode(content, forKey: .content)
                try container.encode("assistant", forKey: .role)
                if let name = name {
                    try container.encode(name, forKey: .name)
                }
            case .system(let content, let name):
                try container.encode(content, forKey: .content)
                try container.encode("system", forKey: .role)
                if let name = name {
                    try container.encode(name, forKey: .name)
                }
            case .user(let content, let name):
                try container.encode(content, forKey: .content)
                try container.encode("user", forKey: .role)
                if let name = name {
                    try container.encode(name, forKey: .name)
                }
            }
        }
    }
}

// MARK: - RequestBody.Message.UserContent
extension GroqChatCompletionRequestBody.Message {
    /// User messages can consist of a single string or an array of parts, each part can contain a
    /// string or image
    nonisolated public enum UserContent: Encodable, Sendable {
        /// The text contents of the message.
        case text(String)

        /// An array of content parts. You can pass multiple images by adding multiple imageURL content parts.
        /// Image input is only supported when using the gpt-4o model.
        case parts([ContentPart])

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .text(let text):
                try container.encode(text)
            case .parts(let parts):
                try container.encode(parts)
            }
        }
    }
}

// MARK: - RequestBody.Message.UserContent.ContentPart
extension GroqChatCompletionRequestBody.Message.UserContent {
    nonisolated public enum ContentPart: Encodable, Sendable {
        /// The text content.
        case text(String)

        /// The URL is a "local URL", or "data URI", containing base64 encoded image data.
        /// Construct the URL using the helper `AIProxy.encodeImageAsURL`
        case imageURL(URL, detail: ImageDetail? = nil)

        private enum RootKey: String, CodingKey {
            case type
            case text
            case imageURL = "image_url"
        }

        private enum ImageKey: CodingKey {
            case url
            case detail
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .text(let text):
                try container.encode("text", forKey: .type)
                try container.encode(text, forKey: .text)
            case .imageURL(let url, let detail):
                try container.encode("image_url", forKey: .type)
                var nestedContainer = container.nestedContainer(keyedBy: ImageKey.self, forKey: .imageURL)
                try nestedContainer.encode(url, forKey: .url)
                if let detail = detail {
                    try nestedContainer.encode(detail, forKey: .detail)
                }
            }
        }
    }
}

// MARK: - RequestBody.Message.UserContent.ContentPart.ImageDetail
extension GroqChatCompletionRequestBody.Message.UserContent.ContentPart {
    nonisolated public enum ImageDetail: String, Encodable, Sendable {
        case auto
        case low
        case high
    }
}


// MARK: - RequestBody.ResponseFormat
extension GroqChatCompletionRequestBody {
    /// An object specifying the format that the model must output.
    /// Setting to `{ "type": "json_object" }` enables JSON mode, which guarantees the message the model generates is valid JSON.
    /// Important: when using JSON mode, you must also instruct the model to produce JSON yourself via a system or user message.
    nonisolated public enum ResponseFormat: Encodable, Sendable {

        /// Enables JSON mode, which ensures the message the model generates is valid JSON.
        /// Important: when using JSON mode, you must also instruct the model to produce JSON yourself via a
        /// system or user message.
        case jsonObject

        /// Instructs the model to produce text only.
        case text

        private enum RootKey: String, CodingKey {
            case type
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .jsonObject:
                try container.encode("json_object", forKey: .type)
            case .text:
                try container.encode("text", forKey: .type)
            }
        }
    }
}
