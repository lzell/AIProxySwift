//
//  GeminiGenerateContentRequestBody.swift
//
//
//  Created by Todd Hamilton on 10/14/24.
//

import Foundation

/// Chat completion request body. See the Gemini reference for available fields.
/// Contributions are welcome if you need something beyond the simple fields I've added so far.
/// Docstrings are taken from this reference:
/// https://ai.google.dev/api/generate-content#request-body
public struct GeminiGenerateContentRequestBody: Encodable {

    // Required

    /// The content of the current conversation with the model.
    /// For single-turn queries, this is a single instance. For multi-turn queries like chat, this is a repeated field that contains the conversation history and the latest request.
    public let contents: [Content]

    // Optional

    /// The name of the content cached to use as context to serve the prediction.
    public let cachedContent: String?

    /// Configuration options for model generation and outputs.
    public let generationConfig: GenerationConfig?

    /// A list of unique SafetySetting instances for blocking unsafe content.
    public let safetySettings: [SafetySetting]?

    /// Developer set system instruction(s). Currently, text only.
    public let systemInstruction: SystemInstruction?

    /// Tool configuration for any Tool specified in the request.
    public let toolConfig: ToolConfig?

    /// A list of Tools the Model may use to generate the next response.
    public let tools: [Tool]?

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        contents: [Content],
        cachedContent: String? = nil,
        generationConfig: GenerationConfig? = nil,
        safetySettings: [SafetySetting]? = nil,
        systemInstruction: SystemInstruction? = nil,
        toolConfig: ToolConfig? = nil,
        tools: [Tool]? = nil
    ) {
        self.contents = contents
        self.cachedContent = cachedContent
        self.generationConfig = generationConfig
        self.safetySettings = safetySettings
        self.systemInstruction = systemInstruction
        self.toolConfig = toolConfig
        self.tools = tools
    }
}

// MARK: - RequestBody.Content
/// Struct representing the content of the conversation with the model.
/// A Content includes a role field (e.g., "user" or "model") and ordered parts that constitute a message.
extension GeminiGenerateContentRequestBody {
    public struct Content: Encodable {
        // Required
        public let parts: [Part]

        // Optional
        public let role: String?

        // This memberwise initializer is autogenerated.
        // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
        // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
        public init(
            parts: [GeminiGenerateContentRequestBody.Content.Part],
            role: String? = nil
        ) {
            self.parts = parts
            self.role = role
        }
    }
}

// MARK: - RequestBody.Content.Part
extension GeminiGenerateContentRequestBody.Content {

    /// Struct representing a part of the content.
    /// A Part can contain text, inline data, function calls, or other forms of media or content.
    /// https://ai.google.dev/api/caching#Part
    public enum Part: Encodable {
        /// Inline text.
        case text(String)

        /// Inline media bytes.
        case inline(data: Data, mimeType: String)

        /// URI based data.
        case file(url: URL, mimeType: String)

        private enum CodingKeys: String, CodingKey {
            case text
            case inlineData
            case fileData
        }

        private enum InlineDataNestedKeys: String, CodingKey {
            case data
            case mimeType
        }

        private enum FileDataNestedKeys: String, CodingKey {
            case fileUri
            case mimeType
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .text(let txt):
                try container.encode(txt, forKey: .text)
            case .inline(data: let data, mimeType: let mimeType):
                var nestedContainer = container.nestedContainer(
                    keyedBy: InlineDataNestedKeys.self,
                    forKey: .inlineData
                )
                try nestedContainer.encode(data.base64EncodedString(), forKey: .data)
                try nestedContainer.encode(mimeType, forKey: .mimeType)
            case .file(url: let url, mimeType: let mimeType):
                var nestedContainer = container.nestedContainer(
                    keyedBy: FileDataNestedKeys.self,
                    forKey: .fileData
                )
                try nestedContainer.encode(url, forKey: .fileUri)
                try nestedContainer.encode(mimeType, forKey: .mimeType)
            }
        }
    }
}

// MARK: - RequestBody.Tool
extension GeminiGenerateContentRequestBody {
    /// Tool details that the model may use to generate response.
    /// A Tool enables the system to interact with external systems to perform an action, or set of actions, outside of knowledge and scope of the model.
    /// https://ai.google.dev/api/caching#Tool
    public enum Tool: Encodable {
        /// A list of FunctionDeclarations available to the model that can be used for function calling.
        /// The model or system does not execute the function. Instead the defined function may be returned as a FunctionCall with arguments to the client side for execution. The model may decide to call a subset of these functions by populating FunctionCall in the response. The next conversation turn may contain a FunctionResponse with the Content.role "function" generation context for the next model turn.
        case functionDeclarations([FunctionDeclaration])

        /// Retrieval tool that is powered by Google search (dynamic retrieval for Gemini 1.5)
        case googleSearchRetrieval(DynamicRetrievalConfig)
        
        /// Google Search tool for Gemini 2.0
        case googleSearch(GoogleSearch = .init())

        private enum RootKey: CodingKey {
            case functionDeclarations
            case googleSearch
            case googleSearchRetrieval
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            switch self {
            case .functionDeclarations(let functionDeclarations):
                try container.encode(functionDeclarations, forKey: .functionDeclarations)
            case .googleSearchRetrieval(let config):
                try container.encode(config, forKey: .googleSearchRetrieval)
            case .googleSearch(let config):
                try container.encode(config, forKey: .googleSearch)
            }
        }
    }
}

extension GeminiGenerateContentRequestBody {
    /// A simple struct that represents the Google Search tool for Gemini 2.0
    /// No configuration options are needed for the basic implementation
    public struct GoogleSearch: Encodable {
        // Add a public initializer
        public init() {
            // No initialization needed
        }
    }
}

// MARK: - RequestBody.Tool.DynamicRetrievalConfig
extension GeminiGenerateContentRequestBody.Tool {
    /// Describes the options to customize dynamic retrieval.
    /// https://ai.google.dev/api/caching#DynamicRetrievalConfig
    public struct DynamicRetrievalConfig: Encodable {
        /// The threshold to be used in dynamic retrieval. If not set, a system default value is used.
        public let dynamicThreshold: Double?

        /// The mode of the predictor to be used in dynamic retrieval.
        public let mode: Mode?

        private enum RootKey: CodingKey {
            case dynamicRetrievalConfig
        }

        private enum NestedKey: CodingKey {
            case dynamicThreshold
            case mode
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: RootKey.self)
            var nestedContainer = container.nestedContainer(keyedBy: NestedKey.self, forKey: .dynamicRetrievalConfig)
            try nestedContainer.encodeIfPresent(self.dynamicThreshold, forKey: .dynamicThreshold)
            try nestedContainer.encodeIfPresent(self.mode, forKey: .mode)
        }

        public init(
            dynamicThreshold: Double? = nil,
            mode: GeminiGenerateContentRequestBody.Tool.DynamicRetrievalConfig.Mode? = nil
        ) {
            self.dynamicThreshold = dynamicThreshold
            self.mode = mode
        }
    }
}

// MARK: - RequestBody.Tool.DynamicRetrievalConfig.Mode
extension GeminiGenerateContentRequestBody.Tool.DynamicRetrievalConfig {
    /// https://ai.google.dev/api/caching#Mode
    public enum Mode: String, Encodable {
        /// Always trigger retrieval.
        case always = "MODE_UNSPECIFIED"

        /// Run retrieval only when system decides it is necessary.
        case dynamic = "MODE_DYNAMIC"
    }
}

// MARK: - RequestBody.Tool.FunctionDeclaration
extension GeminiGenerateContentRequestBody.Tool {
    /// https://ai.google.dev/api/caching#FunctionDeclaration
    /// Structured representation of a function declaration as defined by the OpenAPI 3.03 specification. Included in this declaration are the function name and parameters. This FunctionDeclaration is a representation of a block of code that can be used as a Tool by the model and executed by the client.
    /// OpenAPI 3.03 spec: https://spec.openapis.org/oas/v3.0.3
    public struct FunctionDeclaration: Encodable {
        // Required

        // The name of the function. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 63.
        public let name: String

        // Optional

        // A brief description of the function.
        public let description: String?

        /// Describes the parameters to this function. Reflects the Open API 3.03 Parameter Object string Key: the name of the parameter. Parameter names are case sensitive. Schema Value: the Schema defining the type used for the parameter.
        /// OpenAPI 3.03 spec: https://spec.openapis.org/oas/v3.0.3
        public let parameters: [String: AIProxyJSONValue]?

        // This memberwise initializer is autogenerated.
        // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
        // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
        public init(
            name: String,
            description: String? = nil,
            parameters: [String : AIProxyJSONValue]? = nil
        ) {
            self.name = name
            self.description = description
            self.parameters = parameters
        }
    }
}

// MARK: - RequestBody.ToolConfig
extension GeminiGenerateContentRequestBody {
    /// The Tool configuration containing parameters for specifying Tool use in the request.
    /// https://ai.google.dev/api/caching#ToolConfig
    public struct ToolConfig: Encodable {
        public let functionCallingConfig: FunctionCallingConfig?

        public init(functionCallingConfig: FunctionCallingConfig? = nil) {
            self.functionCallingConfig = functionCallingConfig
        }

        private enum CodingKeys: String, CodingKey {
            case functionCallingConfig = "function_calling_config"
        }
    }
}

// MARK: - RequestBody.ToolConfig.FunctionCallingConfig
extension GeminiGenerateContentRequestBody.ToolConfig {

    /// Configuration for specifying function calling behavior.
    /// https://ai.google.dev/api/caching#FunctionCallingConfig
    public struct FunctionCallingConfig: Encodable {
        // Optional

        /// A set of function names that, when provided, limits the functions the model will call.
        /// This should only be set when the Mode is `.any`.
        /// Function names should match [FunctionDeclaration.name]. With mode set to `.any`, model will predict a function call from the set of function names provided.
        public let allowedFunctionNames: [String]?

        /// Specifies the mode in which function calling should execute. If unspecified, the default value will be set to `.auto`.
        public let mode: Mode?

        private enum CodingKeys: String, CodingKey {
            case mode
            case allowedFunctionNames = "allowed_function_names"
        }

        // This memberwise initializer is autogenerated.
        // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
        // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
        public init(
            allowedFunctionNames: [String]? = nil,
            mode: GeminiGenerateContentRequestBody.ToolConfig.FunctionCallingConfig.Mode? = nil
        ) {
            self.allowedFunctionNames = allowedFunctionNames
            self.mode = mode
        }
    }
}

// MARK: - RequestBody.ToolConfig.FunctionCallingConfig.Mode
extension GeminiGenerateContentRequestBody.ToolConfig.FunctionCallingConfig {
    /// https://ai.google.dev/api/caching#Mode_1
    public enum Mode: String, Encodable {
        /// Model is constrained to always predicting a function call only. If "allowedFunctionNames" are set, the predicted function call will be limited to any one of "allowedFunctionNames", else the predicted function call will be any one of the provided "functionDeclarations"
        case anyFunction = "ANY"

        /// Default model behavior, model decides to predict either a function call or a natural language response.
        case auto = "AUTO"

        /// Model will not predict any function call. Model behavior is same as when not passing any function declarations.
        case noFunction = "NONE"
    }
}

// MARK: - RequestBody.SafetySetting
extension GeminiGenerateContentRequestBody {
    /// A list of unique SafetySetting instances for blocking unsafe content.
    public struct SafetySetting: Encodable {
        public enum SafetyCategory: String, Encodable {
            case harassment = "HARM_CATEGORY_HARASSMENT"
            case hateSpeech = "HARM_CATEGORY_HATE_SPEECH"
            case sexuallyExplicit = "HARM_CATEGORY_SEXUALLY_EXPLICIT"
            case dangerousContent = "HARM_CATEGORY_DANGEROUS_CONTENT"
            case civicIntegrity = "HARM_CATEGORY_CIVIC_INTEGRITY"
        }

        public enum HarmBlockThreshold: String, Encodable {
            case none = "BLOCK_NONE"
            case high = "BLOCK_ONLY_HIGH"
            case mediumAndAbove = "BLOCK_MEDIUM_AND_ABOVE"
            case lowAndAbove = "BLOCK_LOW_AND_ABOVE"
            case unspecified = "HARM_BLOCK_THRESHOLD_UNSPECIFIED"
        }

        public let category: SafetyCategory
        public let threshold: HarmBlockThreshold

        public init(category: SafetyCategory, threshold: HarmBlockThreshold) {
            self.category = category
            self.threshold = threshold
        }
    }
}

// MARK: - RequestBody.SystemInstruction
extension GeminiGenerateContentRequestBody {
    /// Developer set system instruction(s). Currently, text only.
    public struct SystemInstruction: Encodable {
        public let role = "system"
        public let parts: [GeminiGenerateContentRequestBody.Content.Part]

        public init(parts: [GeminiGenerateContentRequestBody.Content.Part]) {
            self.parts = parts
        }
    }
}

// MARK: - RequestBody.GenerationConfig
extension GeminiGenerateContentRequestBody {
    /// Configuration options for model generation and outputs.
    public struct GenerationConfig: Encodable {
        public let maxOutputTokens: Int?
        public let temperature: Double?
        public let topP: Double?
        public let topK: Int?
        public let presencePenalty: Double?
        public let frequencyPenalty: Double?
        public let responseModalities: [String]?
        public let responseMimeType: String?
        public let responseSchema: [String: AIProxyJSONValue]?
        public let speechConfig: SpeechConfig?
        public let thinkingConfig: ThinkingConfig?

        public init(
            maxOutputTokens: Int? = nil,
            temperature: Double? = nil,
            topP: Double? = nil,
            topK: Int? = nil,
            presencePenalty: Double? = nil,
            frequencyPenalty: Double? = nil,
            responseModalities: [String]? = nil,
            responseMimeType: String? = nil,
            responseSchema: [String: AIProxyJSONValue]? = nil,
            speechConfig: SpeechConfig? = nil,
            thinkingConfig: ThinkingConfig? = nil
        ) {
            self.maxOutputTokens = maxOutputTokens
            self.temperature = temperature
            self.topP = topP
            self.topK = topK
            self.presencePenalty = presencePenalty
            self.frequencyPenalty = frequencyPenalty
            self.responseModalities = responseModalities
            self.responseMimeType = responseMimeType
            self.responseSchema = responseSchema
            self.speechConfig = speechConfig
            self.thinkingConfig = thinkingConfig
        }

        private enum CodingKeys: String, CodingKey {
            case maxOutputTokens
            case temperature
            case topP
            case topK
            case presencePenalty
            case frequencyPenalty
            case responseModalities
            case responseMimeType
            case responseSchema
            case speechConfig
            case thinkingConfig
        }
    }
}

extension GeminiGenerateContentRequestBody.GenerationConfig {
    public struct ThinkingConfig: Encodable {
        public let thinkingBudget: Int

        public init(thinkingBudget: Int) {
            self.thinkingBudget = thinkingBudget
        }
    }

    public struct SpeechConfig: Encodable {
        public let multiSpeakerVoiceConfig: MultiSpeakerVoiceConfig?
        public let voiceConfig: VoiceConfig?

        public init(
            multiSpeakerVoiceConfig: MultiSpeakerVoiceConfig? = nil,
            voiceConfig: VoiceConfig? = nil
        ) {
            self.multiSpeakerVoiceConfig = multiSpeakerVoiceConfig
            self.voiceConfig = voiceConfig
        }
    }
}

extension GeminiGenerateContentRequestBody.GenerationConfig.SpeechConfig {
    public struct VoiceConfig: Encodable {
        public let prebuiltVoiceConfig: PrebuiltVoiceConfig

        public init(prebuiltVoiceConfig: PrebuiltVoiceConfig) {
            self.prebuiltVoiceConfig = prebuiltVoiceConfig
        }
    }

    public struct MultiSpeakerVoiceConfig: Encodable {
        public let speakerVoiceConfigs: [SpeakerVoiceConfig]

        public init(speakerVoiceConfigs: [SpeakerVoiceConfig]) {
            self.speakerVoiceConfigs = speakerVoiceConfigs
        }
    }

    public struct PrebuiltVoiceConfig: Encodable {
        public let voiceName: VoiceName

        public init(voiceName: VoiceName) {
            self.voiceName = voiceName
        }
    }

    public struct SpeakerVoiceConfig: Encodable {
        public let speaker: String
        public let voiceConfig: VoiceConfig

        public init(
            speaker: String,
            voiceConfig: VoiceConfig
        ) {
            self.speaker = speaker
            self.voiceConfig = voiceConfig
        }
    }

    /// See this list for voice options:
    /// https://ai.google.dev/gemini-api/docs/speech-generation#voices
    public enum VoiceName: String, Encodable {
        case zephyr = "Zephyr"
        case puck = "Puck"
        case charon = "Charon"
        case kore = "Kore"
        case fenrir = "Fenrir"
        case leda = "Leda"
        case orus = "Orus"
        case aoede = "Aoede"
        case callirrhoe = "Callirrhoe"
        case autonoe = "Autonoe"
        case enceladus = "Enceladus"
        case iapetus = "Iapetus"
        case umbriel = "Umbriel"
        case algieba = "Algieba"
        case despina = "Despina"
        case erinome = "Erinome"
        case algenib = "Algenib"
        case rasalgethi = "Rasalgethi"
        case laomedeia = "Laomedeia"
        case achernar = "Achernar"
        case alnilam = "Alnilam"
        case schedar = "Schedar"
        case gacrux = "Gacrux"
        case pulcherrima = "Pulcherrima"
        case achird = "Achird"
        case zubenelgenubi = "Zubenelgenubi"
        case vindemiatrix = "Vindemiatrix"
        case sadachbia = "Sadachbia"
        case sadaltager = "Sadaltager"
        case sulafat = "Sulafat"
    }
}
