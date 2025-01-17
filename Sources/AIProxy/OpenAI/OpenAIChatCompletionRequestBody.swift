//
//  OpenAIChatCompletionRequestBody.swift
//
//
//  Created by Lou Zell on 6/11/24.
//

import Foundation

/// Chat completion request body. Docstrings are taken from this reference:
/// https://platform.openai.com/docs/api-reference/chat/create
public struct OpenAIChatCompletionRequestBody: Encodable {
    // Required

    // The required section should be in alphabetical order. This section is an exception,
    // because we have existing callers that I don't want to break.

    /// ID of the model to use. See the model endpoint compatibility table for details on which models work
    /// with the Chat API:
    /// https://platform.openai.com/docs/models/model-endpoint-compatibility
    public let model: String

    /// A list of messages comprising the conversation so far
    public let messages: [Message]

    // Optional

    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    /// See more information here: https://platform.openai.com/docs/guides/text-generation
    /// Defaults to 0
    public let frequencyPenalty: Double?

    /// Modify the likelihood of specified tokens appearing in the completion.
    /// Accepts an object that maps tokens (specified by their token ID in the tokenizer) to an associated bias value from -100 to 100. Mathematically, the bias is added to the logits generated by the model prior to sampling. The exact effect will vary per model, but values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.
    public let logitBias: [String: Double]?

    /// Whether to return log probabilities of the output tokens or not. If true, returns the log probabilities of each output token returned in the `content` of `message`.
    /// Defaults to false
    public let logprobs: Bool?

    /// An upper bound for the number of tokens that can be generated for a completion, including visible output tokens and reasoning tokens: https://platform.openai.com/docs/guides/reasoning
    public let maxCompletionTokens: Int?

    /// Developer-defined tags and values used for filtering completions in the dashboard.
    /// Dashboard: https://platform.openai.com/chat-completions
    public let metadata: [String: AIProxyJSONValue]?

    /// How many chat completion choices to generate for each input message. Note that you will be charged based on the number of generated tokens across all of the choices. Keep `n` as `1` to minimize costs.
    /// Defaults to 1
    public let n: Int?

    /// Whether to enable parallel function calling during tool use.
    /// https://platform.openai.com/docs/guides/function-calling#configuring-parallel-function-calling
    /// Defaults to true
    public let parallelToolCalls: Bool?

    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    /// More information about frequency and presence penalties: https://platform.openai.com/docs/guides/text-generation
    /// Defaults to 0
    public let presencePenalty: Double?

    /// Specifies the format that the model must output. See the docstring on OpenAIChatResponseFormat
    public let responseFormat: ResponseFormat?

    /// This feature is in Beta. If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same `seed` and parameters should return the same result. Determinism is not guaranteed, and you should refer to the `systemFingerprint` response parameter to monitor changes in the backend.
    public let seed: Int?

    /// Up to 4 sequences where the API will stop generating further tokens.
    public let stop: [String]?

    /// Whether or not to store the output of this chat completion request for use in our model distillation or evals products.
    /// Model distillation: https://platform.openai.com/docs/guides/distillation
    /// Evals: https://platform.openai.com/docs/guides/evals
    /// Deafults to false
    public let store: Bool?

    /// If set, partial message deltas will be sent. Using the `OpenAIService.streamingChatCompletionRequest`
    /// method is the easiest way to use streaming chats.
    public var stream: Bool?

    /// Options for streaming response. Only set this when you set stream: true
    public var streamOptions: StreamOptions?

    /// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the
    /// output more random, while lower values like 0.2 will make it more focused and
    /// deterministic.
    ///
    /// We generally recommend altering this or `top_p` but not both.
    ///
    /// If not set, OpenAI defaults this value to 1.
    public let temperature: Double?

    /// A list of tools the model may call. Currently, only functions are supported as a tool. Use this to
    /// provide a list of functions the model may generate JSON inputs for. A max of 128 functions are
    /// supported.
    /// See the function calling guide here: https://platform.openai.com/docs/guides/function-calling
    public let tools: [Tool]?

    /// Controls which (if any) tool is called by the model.
    public let toolChoice: ToolChoice?

    /// An integer between 0 and 20 specifying the number of most likely tokens to return at each token position, each with an associated log probability. `logprobs` must be set to `true` if this parameter is used.
    public let topLogprobs: Int?

    /// An alternative to sampling with `temperature`, called nucleus sampling, where the model
    /// considers the results of the tokens with `top_p` probability mass. So 0.1 means only the
    /// tokens comprising the top 10% probability mass are considered.
    ///
    /// We generally recommend altering this or `temperature` but not both.
    /// If not set, OpenAI defaults this value to 1
    public let topP: Double?

    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    /// Learn more: https://platform.openai.com/docs/guides/safety-best-practices#end-user-ids
    public let user: String?

    private enum CodingKeys: String, CodingKey {
        // required
        case messages
        case model

        // optional
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case logprobs
        case maxCompletionTokens = "max_completion_tokens"
        case metadata
        case n
        case parallelToolCalls = "parallel_tool_calls"
        case presencePenalty = "presence_penalty"
        case responseFormat = "response_format"
        case seed
        case stop
        case store
        case stream
        case streamOptions = "stream_options"
        case temperature
        case tools
        case toolChoice = "tool_choice"
        case topLogprobs = "top_logprobs"
        case topP = "top_p"
        case user
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        model: String,
        messages: [OpenAIChatCompletionRequestBody.Message],
        frequencyPenalty: Double? = nil,
        logitBias: [String : Double]? = nil,
        logprobs: Bool? = nil,
        maxCompletionTokens: Int? = nil,
        metadata: [String : AIProxyJSONValue]? = nil,
        n: Int? = nil,
        parallelToolCalls: Bool? = nil,
        presencePenalty: Double? = nil,
        responseFormat: OpenAIChatCompletionRequestBody.ResponseFormat? = nil,
        seed: Int? = nil,
        stop: [String]? = nil,
        store: Bool? = nil,
        stream: Bool? = nil,
        streamOptions: OpenAIChatCompletionRequestBody.StreamOptions? = nil,
        temperature: Double? = nil,
        tools: [OpenAIChatCompletionRequestBody.Tool]? = nil,
        toolChoice: OpenAIChatCompletionRequestBody.ToolChoice? = nil,
        topLogprobs: Int? = nil,
        topP: Double? = nil,
        user: String? = nil
    ) {
        self.model = model
        self.messages = messages
        self.frequencyPenalty = frequencyPenalty
        self.logitBias = logitBias
        self.logprobs = logprobs
        self.maxCompletionTokens = maxCompletionTokens
        self.metadata = metadata
        self.n = n
        self.parallelToolCalls = parallelToolCalls
        self.presencePenalty = presencePenalty
        self.responseFormat = responseFormat
        self.seed = seed
        self.stop = stop
        self.store = store
        self.stream = stream
        self.streamOptions = streamOptions
        self.temperature = temperature
        self.tools = tools
        self.toolChoice = toolChoice
        self.topLogprobs = topLogprobs
        self.topP = topP
        self.user = user
    }
}

// MARK: - RequestBody.Message
extension OpenAIChatCompletionRequestBody {
    /// https://platform.openai.com/docs/api-reference/chat/create#chat-create-messages
    public enum Message: Encodable {
        /// Messages sent by the model in response to user messages
        ///
        /// - Parameters:
        ///   - content: The contents of the assistant message. Can be a single string or multiple strings
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        ///   - refusal: The refusal message by the assistant.
        case assistant(
            content: MessageContent<String, [String]>? = nil,
            name: String? = nil,
            refusal: String? = nil,
            toolCalls: [ToolCall]? = nil
        )

        /// Developer-provided instructions that the model should follow, regardless of messages sent by the user.
        /// With o1 models and newer, `developer` messages replace the previous `system` messages.
        ///
        /// - Parameters:
        ///   - content: The contents of the developer message. Can be a single string or multiple strings
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        case developer(
            content: MessageContent<String, [String]>,
            name: String? = nil
        )

        /// Developer-provided instructions that the model should follow, regardless of messages sent by the user. With o1 models and newer, use `developer` messages for this purpose instead.
        ///
        /// - Parameters:
        ///   - content: The contents of the system message. Can be a single string or multiple strings
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        case system(
            content: MessageContent<String, [String]>,
            name: String? = nil
        )

        case tool(
            content: MessageContent<String, [String]>,
            toolCallID: String
        )

        /// Messages sent by an end user, containing prompts or additional context information.
        ///
        /// - Parameters:
        ///   - content: The contents of the user message.
        ///              The contents can be a single string or an array of content parts.
        ///              Content parts can be text, image, or audio.
        ///              You can pass multiple images by adding multiple imageURL content parts.
        ///              Image input is only supported when using the gpt-4o model.
        ///   - name: An optional name for the participant. Provides the model information to differentiate
        ///           between participants of the same role.
        case user(
            content: MessageContent<String, [ContentPart]>,
            name: String? = nil
        )

        var role: String {
            switch self {
            case .assistant: return "assistant"
            case .developer: return "developer"
            case .system: return "system"
            case .tool: return "tool"
            case .user: return "user"
            }
        }
        private enum RootKey: String, CodingKey {
            case content
            case name
            case refusal
            case role
            case toolCallID = "tool_call_id"
            case toolCalls = "tool_calls"
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            try container.encode(self.role, forKey: .role)
            switch self {
            case .assistant(let content, let name, let refusal, let toolCalls):
                try container.encodeIfPresent(content, forKey: .content)
                try container.encodeIfPresent(name, forKey: .name)
                try container.encodeIfPresent(refusal, forKey: .refusal)
                try container.encodeIfPresent(toolCalls, forKey: .toolCalls)
            case .developer(let content, let name):
                try container.encode(content, forKey: .content)
                try container.encodeIfPresent(name, forKey: .name)
            case .system(let content, let name):
                try container.encode(content, forKey: .content)
                try container.encodeIfPresent(name, forKey: .name)
            case .tool(let content, let toolCallID):
                try container.encode(content, forKey: .content)
                try container.encode(toolCallID, forKey: .toolCallID)
            case .user(let content, let name):
                try container.encode(content, forKey: .content)
                try container.encodeIfPresent(name, forKey: .name)
            }
        }
    }
}

// MARK: - RequestBody.Message.MessageContent
extension OpenAIChatCompletionRequestBody.Message {
    public enum MessageContent<
        SingleType: Encodable,
        PartsType: Encodable
    >: Encodable, SingleOrPartsEncodable {
        case text(SingleType)
        case parts(PartsType)

        var encodableItem: Encodable {
            switch self {
            case .text(let single): return single
            case .parts(let parts): return parts
            }
        }
    }
}

// MARK: - RequestBody.Message.ContentPart
extension OpenAIChatCompletionRequestBody.Message {
    public enum ContentPart: Encodable {
        /// The text content.
        case text(String)

        /// The URL is a "local URL" containing base64 encoded image data. See the helper `AIProxy.openaiEncodedImage`
        /// to construct this URL.
        ///
        /// By controlling the detail parameter, which has three options, low, high, or auto, you have control over
        /// how the model processes the image and generates its textual understanding. By default, the model will use
        /// the auto setting which will look at the image input size and decide if it should use the low or high setting.
        ///
        /// "low" will enable the "low res" mode. The model will receive a low-res 512px x 512px version of the image, and
        /// represent the image with a budget of 85 tokens. This allows the API to return faster responses and consume
        /// fewer input tokens for use cases that do not require high detail.
        ///
        /// "high" will enable "high res" mode, which first allows the model to first see the low res image (using 85
        /// tokens) and then creates detailed crops using 170 tokens for each 512px x 512px tile.
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

// MARK: - RequestBody.Message.UserContent.Part.ImageDetail
extension OpenAIChatCompletionRequestBody.Message.ContentPart {
    public enum ImageDetail: String, Encodable {
        case auto
        case low
        case high
    }
}

// MARK: - RequestBody.Message.ToolCall
extension OpenAIChatCompletionRequestBody.Message {
    public struct ToolCall: Encodable {
        /// The ID of the tool call.
        let id: String

        /// The type of the tool. Currently, only `function` is supported.
        let type = "function"

        /// The function that the model called
        let function: Function

        public init(
            id: String,
            function: OpenAIChatCompletionRequestBody.Message.ToolCall.Function
        ) {
            self.id = id
            self.function = function
        }
    }
}

// MARK: - RequestBody.Message.ToolCall.Function
extension OpenAIChatCompletionRequestBody.Message.ToolCall {
    /// Represents the 'Function' object at `messages > assistant message > tool_calls > function`
    /// https://platform.openai.com/docs/api-reference/chat/create#chat-create-messages
    public struct Function: Encodable {
        /// The name of the function that the assistant asked you to call.
        public let name: String

        /// The arguments that the assistant asked you to call your function with.
        /// After you call the function natively, you pass this information back up to OpenAI to continue the conversation.
        public let arguments: String?

        public init(
            name: String,
            arguments: String? = nil
        ) {
            self.name = name
            self.arguments = arguments
        }
    }
}


// MARK: - RequestBody.ResponseFormat
extension OpenAIChatCompletionRequestBody {
    /// An object specifying the format that the model must output. Compatible with GPT-4o, GPT-4o mini, GPT-4
    /// Turbo and all GPT-3.5 Turbo models newer than gpt-3.5-turbo-1106.
    public enum ResponseFormat: Encodable {

        /// Enables JSON mode, which ensures the message the model generates is valid JSON. Note, if you want to
        /// supply your own schema use `jsonSchema` instead.
        ///
        /// Important: when using JSON mode, you must also instruct the model to produce JSON yourself via a
        /// system or user message. Without this, the model may generate an unending stream of whitespace until
        /// the generation reaches the token limit, resulting in a long-running and seemingly "stuck" request.
        /// Also note that the message content may be partially cut off if finish_reason="length", which indicates
        /// the generation exceeded max_tokens or the conversation exceeded the max context length.
        case jsonObject

        /// Enables Structured Outputs which ensures the model will match your supplied JSON schema.
        /// Learn more in the Structured Outputs guide: https://platform.openai.com/docs/guides/structured-outputs
        ///
        /// - Parameters:
        ///   - name: The name of the response format. Must be a-z, A-Z, 0-9, or contain underscores and dashes,
        ///           with a maximum length of 64.
        ///
        ///   - description: A description of what the response format is for, used by the model to determine how
        ///                  to respond in the format.
        ///
        ///   - schema: The schema for the response format, described as a JSON Schema object.
        ///
        ///   - strict: Whether to enable strict schema adherence when generating the output. If set to true, the
        ///             model will always follow the exact schema defined in the schema field. Only a subset of JSON Schema
        ///             is supported when strict is true. To learn more, read the Structured Outputs guide.
        case jsonSchema(
            name: String,
            description: String? = nil,
            schema: [String: AIProxyJSONValue]? = nil,
            strict: Bool? = nil
        )

        /// Instructs the model to produce text only.
        case text

        private enum RootKey: String, CodingKey {
            case type
            case jsonSchema = "json_schema"
        }

        private enum SchemaKey: String, CodingKey {
            case description
            case name
            case schema
            case strict
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .jsonObject:
                try container.encode("json_object", forKey: .type)
            case .jsonSchema(
                name: let name,
                description: let description,
                schema: let schema,
                strict: let strict
            ):
                try container.encode("json_schema", forKey: .type)
                var nestedContainer = container.nestedContainer(
                    keyedBy: SchemaKey.self,
                    forKey: .jsonSchema
                )
                try nestedContainer.encode(name, forKey: .name)
                try nestedContainer.encodeIfPresent(description, forKey: .description)
                try nestedContainer.encodeIfPresent(schema, forKey: .schema)
                try nestedContainer.encodeIfPresent(strict, forKey: .strict)
            case .text:
                try container.encode("text", forKey: .type)
            }
        }
    }
}

// MARK: - RequestBody.StreamOptions
extension OpenAIChatCompletionRequestBody {
    public struct StreamOptions: Encodable {
       /// If set, an additional chunk will be streamed before the data: [DONE] message.
       /// The usage field on this chunk shows the token usage statistics for the entire request,
       /// and the choices field will always be an empty array. All other chunks will also include
       /// a usage field, but with a null value.
       let includeUsage: Bool

       private enum CodingKeys: String, CodingKey {
           case includeUsage = "include_usage"
       }
    }
}

// MARK: - RequestBody.Tool
extension OpenAIChatCompletionRequestBody {
    public enum Tool: Encodable {

        /// A function that chatGPT can instruct us to call when appropriate
        ///
        /// - Parameters:
        ///   - name: The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and
        ///           dashes, with a maximum length of 64.
        ///
        ///   - description: A description of what the function does, used by the model to choose when and how to
        ///                  call the function.
        ///
        ///   - parameters: The parameters the functions accepts, described as a JSON Schema object. See the guide
        ///                 for examples, and the JSON Schema reference for documentation about the format.
        ///                 Omitting parameters defines a function with an empty parameter list.
        ///
        ///   - strict: Whether to enable strict schema adherence when generating the function call. If set to
        ///             true, the model will follow the exact schema defined in the parameters field. Only a subset of JSON
        ///             Schema is supported when strict is true. Learn more about Structured Outputs in the function calling
        ///             guide: https://platform.openai.com/docs/api-reference/chat/docs/guides/function-calling
        case function(
            name: String,
            description: String?,
            parameters: [String: AIProxyJSONValue]?,
            strict: Bool?
        )

        private enum RootKey: CodingKey {
            case type
            case function
        }

        private enum FunctionKey: CodingKey {
            case description
            case name
            case parameters
            case strict
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .function(
                name: let name,
                description: let description,
                parameters: let parameters,
                strict: let strict
            ):
                try container.encode("function", forKey: .type)
                var functionContainer = container.nestedContainer(
                    keyedBy: FunctionKey.self,
                    forKey: .function
                )
                try functionContainer.encode(name, forKey: .name)
                try functionContainer.encodeIfPresent(description, forKey: .description)
                try functionContainer.encodeIfPresent(parameters, forKey: .parameters)
                try functionContainer.encodeIfPresent(strict, forKey: .strict)
            }
        }
    }
}

// MARK: - RequestBody.ToolChoice
extension OpenAIChatCompletionRequestBody {
    /// Controls which (if any) tool is called by the model.
    public enum ToolChoice: Encodable {

        /// The model will not call any tool and instead generates a message.
        /// This is the default when no tools are present in the request body
        case none

        /// The model can pick between generating a message or calling one or more tools.
        /// This is the default when tools are present in the request body
        case auto

        /// The model must call one or more tools
        case required

        /// Forces the model to call a specific tool
        case specific(functionName: String)

        private enum RootKey: CodingKey {
            case type
            case function
        }

        private enum FunctionKey: CodingKey {
            case name
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .none:
                var container = encoder.singleValueContainer()
                try container.encode("none")
            case .auto:
                var container = encoder.singleValueContainer()
                try container.encode("auto")
            case .required:
                var container = encoder.singleValueContainer()
                try container.encode("required")
            case .specific(let functionName):
                var container = encoder.container(keyedBy: RootKey.self)
                try container.encode("function", forKey: .type)
                var functionContainer = container.nestedContainer(
                    keyedBy: FunctionKey.self,
                    forKey: .function
                )
                try functionContainer.encode(functionName, forKey: .name)
            }
        }
    }
}

