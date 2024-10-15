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
/// https://ai.google.dev/api/generate-content#v1beta.models.generateContent
public struct GeminiGenerateContentRequestBody: Encodable {

    // MARK: Required

    /// The model to use for generating the completion. Format: models/{model}
    public let model: String

    /// The content of the current conversation with the model.
    public let contents: [Content]

    // MARK: Optional

    /// The name of the content cached to use as context to serve the prediction.
    public let cachedContent: String?

    /// Configuration options for model generation and outputs.
    public let generationConfig: GenerationConfig?

    /// A list of unique SafetySetting instances for blocking unsafe content.
    public let safetySettings: [SafetySetting]?

    /// Developer set system instruction(s). Currently, text only.
    public let systemInstruction: SystemInstruction?

    /// A list of Tools the Model may use to generate the next response.
    public let tools: [Tool]?

    /// Tool configuration for any Tool specified in the request.
    public let toolConfig: ToolConfig?

    // MARK: Initializer

    public init(
        model: String,
        contents: [Content],
        cachedContent: String? = nil,
        generationConfig: GenerationConfig? = nil,
        safetySettings:[SafetySetting]? = nil,
        systemInstruction: SystemInstruction? = nil,
        tools: [Tool]? = nil,
        toolConfig: ToolConfig? = nil
    ) {
        self.model = model
        self.contents = contents
        self.cachedContent = cachedContent
        self.generationConfig = generationConfig
        self.safetySettings = safetySettings
        self.systemInstruction = systemInstruction
        self.tools = tools
        self.toolConfig = toolConfig
    }
}

/// Struct representing the content of the conversation with the model.
/// A Content includes a role field (e.g., "user" or "model") and ordered parts that constitute a message.
public struct Content: Encodable {
    public let role: String?
    public let parts: [Part]

    public init(role: String? = nil, parts: [Part]) {
        self.role = role
        self.parts = parts
    }
}

/// Struct representing a part of the content.
/// A Part can contain text, inline data, function calls, or other forms of media or content.
public struct Part: Encodable {
    public let text: String?

    public init(
        text: String? = nil
    ) {
        self.text = text
    }
}

/// Tool details that the model may use to generate response.
/// A Tool is a piece of code that enables the system to interact with external systems to perform an action,
/// or set of actions, outside of knowledge and scope of the model.
public struct Tool: Encodable {
    public let functionDeclarations: [FunctionDeclaration]?
    public let codeExecution: CodeExecution?

    public init(functionDeclarations: [FunctionDeclaration]? = nil, codeExecution: CodeExecution? = nil) {
        self.functionDeclarations = functionDeclarations
        self.codeExecution = codeExecution
    }
}

/// Tool configuration for any Tool specified in the request.
public struct ToolConfig: Encodable {
    public let functionCallingConfig: FunctionCallingConfig?

    public init(functionCallingConfig: FunctionCallingConfig? = nil) {
        self.functionCallingConfig = functionCallingConfig
    }
}

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

/// Developer set system instruction(s). Currently, text only.
public struct SystemInstruction: Encodable {
    public let role: String?
    public let parts: [Part]

    public init(role: String? = nil, parts: [Part]) {
        self.role = role
        self.parts = parts
    }
}

/// Configuration options for model generation and outputs.
public struct GenerationConfig: Encodable {
    public let maxTokens: Int?
    public let temperature: Double?
    public let topP: Double?
    public let topK: Int?
    public let presencePenalty: Double?
    public let frequencyPenalty: Double?

    public init(maxTokens: Int? = nil,
                temperature: Double? = nil,
                topP: Double? = nil,
                topK: Int? = nil,
                presencePenalty: Double? = nil,
                frequencyPenalty: Double? = nil) {
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.topP = topP
        self.topK = topK
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
    }
}

/// Content that has been preprocessed and can be used in subsequent request to GenerativeService.
/// Cached content can be only used with model it was created for.
public struct ChachedContent: Encodable {
    public let cachedContentName: String?

    public init(cachedContentName: String? = nil) {
        self.cachedContentName = cachedContentName
    }
}

/// Structured representation of a function declaration as defined by the OpenAPI 3.03 specification.
public struct FunctionDeclaration: Encodable {
    public let name: String
    public let description: String
    public let parameters: [String: Schema]?

    public init(name: String, description: String, parameters: [String: Schema]? = nil) {
        self.name = name
        self.description = description
        self.parameters = parameters
    }
}

/// Enables the model to execute code as part of generation.
public struct CodeExecution: Encodable {
    public let language: String
    public let code: String

    public init(language: String, code: String) {
        self.language = language
        self.code = code
    }
}

/// Configuration for specifying function calling behavior.
public struct FunctionCallingConfig: Encodable {
    public enum Mode: String, Encodable {
        case auto = "AUTO"
        case none = "NONE"
        case any = "ANY"
    }

    public let mode: Mode?
    public let allowedFunctionNames: [String]?

    public init(mode: Mode? = nil, allowedFunctionNames: [String]? = nil) {
        self.mode = mode
        self.allowedFunctionNames = allowedFunctionNames
    }
}

/// The Schema object allows the definition of input and output data types.
/// These types can be objects, but also primitives and arrays. Represents a select subset of an OpenAPI 3.0 schema object.
public struct Schema: Encodable {
    public let type: String
    public let format: String?

    public init(type: String, format: String? = nil) {
        self.type = type
        self.format = format
    }
}