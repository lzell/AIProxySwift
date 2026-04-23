//
//  OpenAIRealtimeResponseCreate.swift
//
//
//  Created by Lou Zell on 10/14/24.
//

import Foundation

/// https://platform.openai.com/docs/api-reference/realtime-client-events/response
nonisolated public struct OpenAIRealtimeResponseCreate: Encodable {
    public let type = "response.create"
    public let eventID: String?
    public let response: Response?

    private enum CodingKeys: String, CodingKey {
        case type
        case eventID = "event_id"
        case response
    }

    public init(eventID: String? = nil, response: Response? = nil) {
        self.eventID = eventID
        self.response = response
    }
}

// MARK: -
extension OpenAIRealtimeResponseCreate {
    nonisolated public struct Response: Encodable {
        public let conversation: String?
        public let instructions: String?
        /// Encoded as `output_modalities` on the wire.
        public let outputModalities: [OpenAIRealtimeSessionConfiguration.Modality]?
        @available(*, deprecated, renamed: "outputModalities")
        public var modalities: [OpenAIRealtimeSessionConfiguration.Modality]? { outputModalities }
        public let toolChoice: OpenAIRealtimeSessionConfiguration.ToolChoice?
        public let tools: [Tool]?

        private enum CodingKeys: String, CodingKey {
            case conversation
            case instructions
            case outputModalities = "output_modalities"
            case toolChoice = "tool_choice"
            case tools
        }

        public init(
            conversation: String? = nil,
            instructions: String? = nil,
            outputModalities: [OpenAIRealtimeSessionConfiguration.Modality]? = nil,
            tools: [Tool]? = nil,
            toolChoice: OpenAIRealtimeSessionConfiguration.ToolChoice? = nil
        ) {
            self.conversation = conversation
            self.instructions = instructions
            self.outputModalities = outputModalities
            self.tools = tools
            self.toolChoice = toolChoice
        }

        /// Deprecated initializer preserved for source compatibility.
        @available(*, deprecated, message: "Use outputModalities (JSON key output_modalities).")
        @_disfavoredOverload
        public init(
            conversation: String? = nil,
            instructions: String? = nil,
            modalities: [OpenAIRealtimeSessionConfiguration.Modality]? = nil,
            tools: [Tool]? = nil,
            toolChoice: OpenAIRealtimeSessionConfiguration.ToolChoice? = nil
        ) {
            self.init(
                conversation: conversation,
                instructions: instructions,
                outputModalities: modalities,
                tools: tools,
                toolChoice: toolChoice
            )
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(conversation, forKey: .conversation)
            try container.encodeIfPresent(instructions, forKey: .instructions)
            try container.encodeIfPresent(outputModalities, forKey: .outputModalities)
            try container.encodeIfPresent(tools, forKey: .tools)
            try container.encodeIfPresent(toolChoice, forKey: .toolChoice)
        }
    }
}

// MARK: -
extension OpenAIRealtimeResponseCreate.Response {
    nonisolated public enum Tool: Encodable {
        case function(OpenAIRealtimeSessionConfiguration.FunctionTool)
        case mcp(OpenAIRealtimeSessionConfiguration.MCPTool)
        case webSearch(OpenAICreateResponseRequestBody.WebSearchTool)

        public func encode(to encoder: Encoder) throws {
            switch self {
            case .function(let functionTool):
                try functionTool.encode(to: encoder)
            case .mcp(let mcpTool):
                try mcpTool.encode(to: encoder)
            case .webSearch(let webSearchTool):
                try webSearchTool.encode(to: encoder)
            }
        }
    }
}
