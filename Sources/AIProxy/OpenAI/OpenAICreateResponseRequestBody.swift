//
//  OpenAICreateResponseRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/12/25.
//

import Foundation

/// OpenAI's most advanced interface for generating model responses.
/// Supports text and image inputs, and text outputs.
/// Create stateful interactions with the model, using the output of previous responses as input.
/// Extend the model's capabilities with built-in tools for file search, web search, computer use, and more.
/// Allow the model access to external systems and data using function calling.
/// https://platform.openai.com/docs/api-reference/responses/create
/// Implementor's note: See ResponseCreateParamsBase in `src/openai/types/responses/response_create_params.py`
public struct OpenAICreateResponseRequestBody: Encodable {
    private enum CodingKeys: String, CodingKey {
        case input
        case model
        case previousResponseId = "previous_response_id"
        case tools
        case toolChoice = "tool_choice"
        case reasoning
        case parallelToolCalls = "parallel_tool_calls"
    }
    
    /// Text, image, or file inputs to the model, used to generate a response.
    public let input: Input
    public let model: String
    public let previousResponseId: String?
    
    /// An array of tools the model may call while generating a response.
    /// You can specify which tool to use by setting the tool_choice parameter.
    /// The two categories of tools you can provide the model are:
    /// - Built-in tools: Tools that are provided by OpenAI that extend the model's capabilities,
    ///   like web search or file search.
    /// - Function calls (custom tools): Functions that are defined by you,
    ///   enabling the model to call your own code.
    public let tools: [Tool]?
    
    /// How the model should select which tool (or tools) to use when generating a response.
    public let toolChoice: ToolChoice?
    
    /// o-series models only
    /// Configuration options for reasoning models.
    public let reasoning: Reasoning?
    
    /// Whether to allow the model to run tool calls in parallel.
    /// Defaults to true if not specified.
    public let parallelToolCalls: Bool?

    public init(
        input: OpenAICreateResponseRequestBody.Input,
        model: String,
        previousResponseId: String? = nil,
        tools: [Tool]? = nil,
        toolChoice: ToolChoice? = nil,
        reasoning: Reasoning? = nil,
        parallelToolCalls: Bool? = nil
    ) {
        self.input = input
        self.model = model
        self.previousResponseId = previousResponseId
        self.tools = tools
        self.toolChoice = toolChoice
        self.reasoning = reasoning
        self.parallelToolCalls = parallelToolCalls
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
        case file(fileID: String)
        case imageURL(URL)
        case text(String)

        private enum CodingKeys: String, CodingKey {
            case fileID = "file_id"
            case imageURL = "image_url"
            case type
            case text
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .file(let fileID):
                try container.encode(fileID, forKey: .fileID)
                try container.encode("input_file", forKey: .type)
            case .imageURL(let imageURL):
                try container.encode(imageURL, forKey: .imageURL)
                try container.encode("input_image", forKey: .type)
            case .text(let txt):
                try container.encode(txt, forKey: .text)
                try container.encode("input_text", forKey: .type)
            }
        }
    }
}

// MARK: - Tool Types
extension OpenAICreateResponseRequestBody {
    /// A tool specification that models can use in responses.
    /// See https://platform.openai.com/docs/guides/tools
    public enum Tool: Codable {
        /// File search tool to search the contents of uploaded files
        case fileSearch(FileSearchTool)
        /// Web search tool to include data from the Internet
        case webSearch(WebSearchTool)
        /// Computer use tool to enable model to control a computer interface
        case computerUse(ComputerUseTool)
        /// Function calling tool to enable custom code execution
        case function(FunctionTool)

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .fileSearch(let tool): try container.encode(tool)
            case .webSearch(let tool): try container.encode(tool)
            case .computerUse(let tool): try container.encode(tool)
            case .function(let tool): try container.encode(tool)
            }
        }
    }

    // MARK: - File Search Tool
    public struct FileSearchTool: Codable {
        private enum CodingKeys: String, CodingKey {
            case type
            case vectorStoreIds = "vector_store_ids"
            case filters
            case maxNumResults = "max_num_results"
            case rankingOptions = "ranking_options"
        }

        public let type = "file_search"
        public let vectorStoreIds: [String]
        public let filters: FileSearchFilter?
        public let maxNumResults: Int?
        public let rankingOptions: RankingOptions?

        public init(
            vectorStoreIds: [String],
            filters: FileSearchFilter? = nil,
            maxNumResults: Int? = nil,
            rankingOptions: RankingOptions? = nil
        ) {
            self.vectorStoreIds = vectorStoreIds
            self.filters = filters
            self.maxNumResults = maxNumResults
            self.rankingOptions = rankingOptions
        }

        public struct RankingOptions: Codable {
            public let ranker: String?
            public let scoreThreshold: Double?

            private enum CodingKeys: String, CodingKey {
                case ranker
                case scoreThreshold = "score_threshold"
            }

            public init(ranker: String? = "auto", scoreThreshold: Double? = 0) {
                self.ranker = ranker
                self.scoreThreshold = scoreThreshold
            }
        }
    }

    public enum FileSearchFilter: Codable {
        case comparison(ComparisonFilter)
        case compound(CompoundFilter)

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .comparison(let filter): try container.encode(filter)
            case .compound(let filter): try container.encode(filter)
            }
        }

        public struct ComparisonFilter: Codable {
            public let key: String
            public let type: String // eq, ne, gt, gte, lt, lte
            public let value: AIProxyJSONValue

            public init(key: String, type: String, value: AIProxyJSONValue) {
                self.key = key
                self.type = type
                self.value = value
            }
        }

        public struct CompoundFilter: Codable {
            public let filters: [FileSearchFilter]
            public let type: String // and, or

            public init(filters: [FileSearchFilter], type: String) {
                self.filters = filters
                self.type = type
            }
        }
    }

    // MARK: - Web Search Tool
    public struct WebSearchTool: Codable {
        private enum CodingKeys: String, CodingKey {
            case type
            case searchContextSize = "search_context_size"
            case userLocation = "user_location"
        }

        public let type = "web_search_preview"
        public let searchContextSize: SearchContextSize?
        public let userLocation: UserLocation?

        public init(
            searchContextSize: SearchContextSize? = .medium,
            userLocation: UserLocation? = nil
        ) {
            self.searchContextSize = searchContextSize
            self.userLocation = userLocation
        }

        public enum SearchContextSize: String, Codable {
            case high
            case medium
            case low
        }

        public struct UserLocation: Codable {
            public var type = "approximate"
            public let city: String?
            public let country: String?
            public let region: String?
            public let timezone: String?

            public init(
                city: String? = nil,
                country: String? = nil,
                region: String? = nil,
                timezone: String? = nil
            ) {
                self.city = city
                self.country = country
                self.region = region
                self.timezone = timezone
            }
        }
    }

    // MARK: - Computer Use Tool
    public struct ComputerUseTool: Codable {
        private enum CodingKeys: String, CodingKey {
            case type
            case displayWidth = "display_width"
            case displayHeight = "display_height"
            case environment
        }

        public let type = "computer_use_preview"
        public let displayWidth: Int
        public let displayHeight: Int
        public let environment: Environment

        public init(
            displayWidth: Int,
            displayHeight: Int,
            environment: Environment
        ) {
            self.displayWidth = displayWidth
            self.displayHeight = displayHeight
            self.environment = environment
        }

        public enum Environment: String, Codable {
            case browser
            case mac
            case windows
            case ubuntu
        }
    }

    // MARK: - Function Tool
    public struct FunctionTool: Codable {
        private enum CodingKeys: String, CodingKey {
            case type
            case name
            case parameters
            case strict
            case description
        }

        public let type = "function"
        public let name: String
        public let parameters: [String: AIProxyJSONValue]
        public let strict: Bool
        public let description: String?

        public init(
            name: String,
            parameters: [String: AIProxyJSONValue],
            strict: Bool = true,
            description: String? = nil
        ) {
            self.name = name
            self.parameters = parameters
            self.strict = strict
            self.description = description
        }
    }
}

// MARK: - Reasoning
extension OpenAICreateResponseRequestBody {
    /// Configuration options for reasoning models
    public struct Reasoning: Encodable {
        private enum CodingKeys: String, CodingKey {
            case effort
            case generateSummary = "generate_summary"
        }

        /// Constrains effort on reasoning for reasoning models.
        /// Currently supported values are low, medium, and high.
        /// Reducing reasoning effort can result in faster responses and fewer tokens used on reasoning in a response.
        public let effort: Effort?

        /// computer_use_preview only
        /// A summary of the reasoning performed by the model. This can be useful for debugging and
        /// understanding the model's reasoning process. One of concise or detailed.
        public let generateSummary: SummaryType?

        public init(
            effort: Effort? = nil,
            generateSummary: SummaryType? = nil
        ) {
            self.effort = effort
            self.generateSummary = generateSummary
        }
    }
}

// MARK: - Reasoning Types
extension OpenAICreateResponseRequestBody.Reasoning {
    /// Supported effort levels for reasoning models
    public enum Effort: String, Encodable {
        case low
        case medium
        case high
    }

    /// Summary types for reasoning models with computer use preview
    public enum SummaryType: String, Encodable {
        case concise
        case detailed
    }
}

// MARK: - Tool Choice
extension OpenAICreateResponseRequestBody {
    public enum ToolChoice: Codable {
        case none
        case auto
        case required
        case function(name: String)
        
        private enum CodingKeys: String, CodingKey {
            case type
            case name
        }
        
        public func encode(to encoder: Encoder) throws {
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
            case .function(let name):
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("function", forKey: .type)
                try container.encode(name, forKey: .name)
            }
        }
        
        public init(from decoder: Decoder) throws {
            if let container = try? decoder.container(keyedBy: CodingKeys.self) {
                let type = try container.decode(String.self, forKey: .type)
                switch type {
                case "function":
                    let name = try container.decode(String.self, forKey: .name)
                    self = .function(name: name)
                default:
                    throw DecodingError.dataCorruptedError(
                        forKey: .type,
                        in: container,
                        debugDescription: "Unknown tool choice type: \(type)"
                    )
                }
            } else {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(String.self)
                switch value {
                case "none": self = .none
                case "auto": self = .auto
                case "required": self = .required
                default:
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "Unknown tool choice value: \(value)"
                    )
                }
            }
        }
    }
}
