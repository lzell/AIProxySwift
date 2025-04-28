//
//  AnthropicMessageRequestBody.swift
//
//
//  Created by Lou Zell on 7/25/24.
//

import Foundation

/// All docstrings in this file are from: https://docs.anthropic.com/en/api/messages
public struct AnthropicMessageRequestBody: Encodable {
    // Required

    /// The maximum number of tokens to generate before stopping.
    ///
    /// Note that our models may stop before reaching this maximum. This parameter only specifies the
    /// absolute maximum number of tokens to generate.
    ///
    /// Different models have different maximum values for this parameter. See the 'Max output'
    /// value for each model listed here: https://docs.anthropic.com/en/docs/models-overview
    public let maxTokens: Int

    /// Input messages.
    ///
    /// Our models are trained to operate on alternating user and assistant conversational turns.
    /// When creating a new Message, you specify the prior conversational turns with the messages
    /// parameter, and the model then generates the next Message in the conversation.
    ///
    /// Each input message must be an object with a role and content. You can specify a single
    /// user-role message, or you can include multiple user and assistant messages. The first
    /// message must always use the user role.
    ///
    /// If the final message uses the assistant role, the response content will continue
    /// immediately from the content in that message. This can be used to constrain part of the
    /// model's response.
    ///
    /// Example with a single user message:
    ///
    ///     [{"role": "user", "content": "Hello, Claude"}]
    ///
    /// Example with multiple conversational turns:
    ///
    ///     [
    ///       {"role": "user", "content": "Hello there."},
    ///       {"role": "assistant", "content": "Hi, I'm Claude. How can I help you?"},
    ///       {"role": "user", "content": "Can you explain LLMs in plain English?"},
    ///     ]
    ///
    /// Example with a partially-filled response from Claude:
    ///
    ///     [
    ///       {"role": "user", "content": "What's the Greek name for Sun? (A) Sol (B) Helios (C) Sun"},
    ///       {"role": "assistant", "content": "The best answer is ("},
    ///     ]
    ///
    /// Starting with Claude 3 models, you can also send image content blocks:
    ///
    ///     {"role": "user", "content": [
    ///       {
    ///         "type": "image",
    ///         "source": {
    ///           "type": "base64",
    ///           "media_type": "image/jpeg",
    ///           "data": "/9j/4AAQSkZJRg...",
    ///         }
    ///       },
    ///       {"type": "text", "text": "What is in this image?"}
    ///     ]}
    ///
    /// See this for more input examples: https://docs.anthropic.com/en/api/messages-examples#vision
    public let messages: [AnthropicInputMessage]

    /// The model that will complete your prompt.
    /// See this resource for a list of model strings you may use:
    /// https://docs.anthropic.com/en/docs/about-claude/models#model-names
    public let model: String


    // Optional
    /// An object describing metadata about the request.
    public let metadata: AnthropicRequestMetadata?

    /// Custom text sequences that will cause the model to stop generating.
    ///
    /// Our models will normally stop when they have naturally completed their turn, which will
    /// result in a response stop_reason of "end_turn".
    ///
    /// If you want the model to stop generating when it encounters custom strings of text, you can
    /// use the stop_sequences parameter. If the model encounters one of the custom sequences, the
    /// response stop_reason value will be "stop_sequence" and the response stop_sequence value
    /// will contain the matched stop sequence.
    public let stopSequences: [String]?

    /// Whether to incrementally stream the response using server-sent events.
    /// See https://docs.anthropic.com/en/api/messages-streaming
    public var stream: Bool?

    /// A system prompt is a way of providing context and instructions to Claude, such as
    /// specifying a particular goal or role. See our guide to system prompts.
    public let system: String?

    /// Amount of randomness injected into the response.
    ///
    /// Defaults to 1.0. Ranges from 0.0 to 1.0. Use temperature closer to 0.0 for analytical /
    /// multiple choice, and closer to 1.0 for creative and generative tasks.
    ///
    /// Note that even with temperature of 0.0, the results will not be fully deterministic.
    public let temperature: Double?

    /// How the model should use the provided tools. The model can use a specific tool, any available tool, or decide by itself.
    /// More information here: https://docs.anthropic.com/en/docs/build-with-claude/tool-use
    public let toolChoice: AnthropicToolChoice?

    /// Definitions of tools that the model may use.
    ///
    /// If you include tools in your API request, the model may return `tool_use` content blocks that
    /// represent the model's use of those tools. You can then run those tools using the tool input
    /// generated by the model and then optionally return results back to the model using
    /// `tool_result` content blocks.
    ///
    /// Each tool definition includes:
    ///
    /// - name: Name of the tool.
    /// - description: Optional, but strongly-recommended description of the tool.
    /// - input_schema: JSON schema for the tool input shape that the model will produce in tool_use output content blocks.
    ///
    /// For example, if you defined tools as:
    ///
    ///     [
    ///       {
    ///         "name": "get_stock_price",
    ///         "description": "Get the current stock price for a given ticker symbol.",
    ///         "input_schema": {
    ///           "type": "object",
    ///           "properties": {
    ///             "ticker": {
    ///               "type": "string",
    ///               "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
    ///             }
    ///           },
    ///           "required": ["ticker"]
    ///         }
    ///       }
    ///     ]
    ///
    /// And then asked the model "What's the S&P 500 at today?", the model might produce tool_use
    /// content blocks in the response like this:
    ///
    ///     [
    ///       {
    ///         "type": "tool_use",
    ///         "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    ///         "name": "get_stock_price",
    ///         "input": { "ticker": "^GSPC" }
    ///       }
    ///     ]
    ///
    /// You might then run your get_stock_price tool with {"ticker": "^GSPC"} as an input, and
    /// return the following back to the model in a subsequent user message:
    ///
    ///     [
    ///       {
    ///         "type": "tool_result",
    ///         "tool_use_id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    ///         "content": "259.75 USD"
    ///       }
    ///     ]
    ///
    /// Tools can be used for workflows that include running client-side tools and functions, or
    /// more generally whenever you want the model to produce a particular JSON structure of
    /// output.
    ///
    /// See this guide for more details: https://docs.anthropic.com/en/docs/tool-use
    public var tools: [AnthropicTool]?

    /// Only sample from the top K options for each subsequent token.
    ///
    /// Used to remove "long tail" low probability responses.
    /// Learn more technical details here: https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277
    ///
    /// Recommended for advanced use cases only. You usually only need to use `temperature`.
    public let topK: Int?

    /// Use nucleus sampling.
    ///
    /// In nucleus sampling, we compute the cumulative distribution over all the options for each
    /// subsequent token in decreasing probability order and cut it off once it reaches a
    /// particular probability specified by `top_p`.
    ///
    /// You should either alter `temperature` or `top_p`, but not both.
    ///
    /// Recommended for advanced use cases only. You usually only need to use `temperature`.
    public let topP: Double?

    /// Returns true if this message request requires the pdf beta header to be applied
    public var needsPDFBeta: Bool {
        for msg in self.messages {
            for content in msg.content {
                if case .pdf(_) = content {
                    return true
                }
            }
        }
        return false
    }

    private enum CodingKeys: String, CodingKey {
        // Required
        case maxTokens = "max_tokens"
        case messages
        case model

        // Optional
        case metadata
        case stopSequences = "stop_sequences"
        case stream
        case system
        case temperature
        case toolChoice = "tool_choice"
        case tools
        case topK = "top_k"
        case topP = "top_p"
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        maxTokens: Int,
        messages: [AnthropicInputMessage],
        model: String,
        metadata: AnthropicRequestMetadata? = nil,
        stopSequences: [String]? = nil,
        stream: Bool? = nil,
        system: String? = nil,
        temperature: Double? = nil,
        toolChoice: AnthropicToolChoice? = nil,
        tools: [AnthropicTool]? = nil,
        topK: Int? = nil,
        topP: Double? = nil
    ) {
        self.maxTokens = maxTokens
        self.messages = messages
        self.model = model
        self.metadata = metadata
        self.stopSequences = stopSequences
        self.stream = stream
        self.system = system
        self.temperature = temperature
        self.toolChoice = toolChoice
        self.tools = tools
        self.topK = topK
        self.topP = topP
    }
}


public enum AnthropicImageMediaType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case webp = "image/webp"
}


public enum AnthropicInputContent: Encodable {
    case image(mediaType: AnthropicImageMediaType, data: String)
    case pdf(data: String)
    case text(String)
    case toolUse(id: String, name: String, input: [String: AIProxyJSONValue])
    case toolResult(toolUseId: String, content: String)

    private enum CodingKeys: String, CodingKey {
        case image
        case source
        case text
        case type
        case id
        case name
        case input
        case toolUseId = "tool_use_id"
        case content
    }

    private enum SourceCodingKeys: String, CodingKey {
        case type
        case mediaType = "media_type"
        case data
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .image(mediaType: let mediaType, data: let data):
            try container.encode("image", forKey: .type)
            var nested = container.nestedContainer(keyedBy: SourceCodingKeys.self, forKey: .source)
            try nested.encode("base64", forKey: .type)
            try nested.encode(mediaType.rawValue, forKey: .mediaType)
            try nested.encode(data, forKey: .data)
        case .pdf(data: let data):
            try container.encode("document", forKey: .type)
            var nested = container.nestedContainer(keyedBy: SourceCodingKeys.self, forKey: .source)
            try nested.encode("base64", forKey: .type)
            try nested.encode("application/pdf", forKey: .mediaType)
            try nested.encode(data, forKey: .data)
        case .text(let txt):
            try container.encode("text", forKey: .type)
            try container.encode(txt, forKey: .text)
        case .toolUse(id: let id, name: let name, input: let input):
            try container.encode("tool_use", forKey: .type)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(input, forKey: .input)
        case .toolResult(toolUseId: let toolUseId, content: let content):
            try container.encode("tool_result", forKey: .type)
            try container.encode(toolUseId, forKey: .toolUseId)
            try container.encode(content, forKey: .content)
        }
    }
}


public struct AnthropicInputMessage: Encodable {
    public init(
        content: [AnthropicInputContent],
        role: AnthropicInputMessageRole
    ) {
        self.content = content
        self.role = role
    }

    /// The content of the input to send to Claude.
    /// Supports text, images, and tools
    public let content: [AnthropicInputContent]

    /// One of `user` or `assistant`.
    /// Note that if you want to include a system prompt, you can use the top-level `system`
    /// parameter on `AnthropicMessageRequestBody`
    public let role: AnthropicInputMessageRole
}


public enum AnthropicInputMessageRole: String, Encodable {
    case assistant
    case user
}


public struct AnthropicRequestMetadata: Encodable {
    /// An external identifier for the user who is associated with the request.
    ///
    /// This should be a uuid, hash value, or other opaque identifier. Anthropic may use this id to
    /// help detect abuse. Do not include any identifying information such as name, email address, or
    /// phone number.
    let userID: String?
}


public enum AnthropicToolChoice: Encodable {
    case any
    case auto
    case tool(name: String)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .auto:
            try container.encode("auto", forKey: .type)
        case .any:
            try container.encode("any", forKey: .type)
        case .tool(let name):
            try container.encode("tool", forKey: .type)
            try container.encode(name, forKey: .name)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
    }
}


public struct AnthropicTool: Encodable {
    /// Description of what this tool does.
    /// Tool descriptions should be as detailed as possible. The more information that the
    /// model has about what the tool is and how to use it, the better it will perform. You can
    /// use natural language descriptions to reinforce important aspects of the tool input JSON
    /// schema.
    public let description: String

    /// A JSON schema for this tool's input.
    /// This defines the shape of the `input` that your tool accepts and that the model will
    /// produce. For example:
    ///
    ///     {
    ///       "type": "object",
    ///       "properties": {
    ///         "location": {
    ///           "type": "string",
    ///           "description": "The city and state, e.g. San Francisco, CA"
    ///         }
    ///       },
    ///       "required": ["location"]
    ///     }
    public var inputSchema: [String: AIProxyJSONValue]

    /// The tool name.
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case description
        case inputSchema = "input_schema"
        case name
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        description: String,
        inputSchema: [String: AIProxyJSONValue],
        name: String
    ) {
        self.description = description
        self.inputSchema = inputSchema
        self.name = name
    }
}
