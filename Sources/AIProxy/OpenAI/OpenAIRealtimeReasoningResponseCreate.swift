//
//  OpenAIRealtimeReasoningResponseCreate.swift
//  AIProxy
//

/// `response.create` for Realtime Reasoning models.
nonisolated public struct OpenAIRealtimeReasoningResponseCreate: Encodable {
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

extension OpenAIRealtimeReasoningResponseCreate {
    nonisolated public struct Response: Encodable {
        public let conversation: String?
        public let instructions: String?
        public let outputModalities: [OpenAIRealtimeSessionConfiguration.Modality]?
        public let tools: [OpenAIRealtimeResponseCreate.Response.Tool]?
        public let toolChoice: OpenAIRealtimeSessionConfiguration.ToolChoice?
        public let reasoning: OpenAIRealtimeReasoningConfiguration?
        public let parallelToolCalls: Bool?

        private enum CodingKeys: String, CodingKey {
            case conversation
            case instructions
            case outputModalities = "output_modalities"
            case tools
            case toolChoice = "tool_choice"
            case reasoning
            case parallelToolCalls = "parallel_tool_calls"
        }

        public init(
            conversation: String? = nil,
            instructions: String? = nil,
            outputModalities: [OpenAIRealtimeSessionConfiguration.Modality]? = nil,
            tools: [OpenAIRealtimeResponseCreate.Response.Tool]? = nil,
            toolChoice: OpenAIRealtimeSessionConfiguration.ToolChoice? = nil,
            reasoning: OpenAIRealtimeReasoningConfiguration? = nil,
            parallelToolCalls: Bool? = nil
        ) {
            self.conversation = conversation
            self.instructions = instructions
            self.outputModalities = outputModalities
            self.tools = tools
            self.toolChoice = toolChoice
            self.reasoning = reasoning
            self.parallelToolCalls = parallelToolCalls
        }

        public init(
            base: OpenAIRealtimeResponseCreate.Response,
            reasoning: OpenAIRealtimeReasoningConfiguration? = nil,
            parallelToolCalls: Bool? = nil
        ) {
            self.init(
                conversation: base.conversation,
                instructions: base.instructions,
                outputModalities: base.outputModalities,
                tools: base.tools,
                toolChoice: base.toolChoice,
                reasoning: reasoning,
                parallelToolCalls: parallelToolCalls
            )
        }
    }
}
