//
//  GeminiChatCompletionRequestBody.swift
//
//
//  Created by Todd Hamilton on 10/14/24.
//

import Foundation

/// Chat completion request body. See the Gemini reference for available fields.
/// Contributions are welcome if you need something beyond the simple fields I've added so far.
/// Docstrings are taken from this reference:
/// https://ai.google.dev/api/generate-content#v1beta.models.generateContent
public struct GeminiChatCompletionRequestBody: Encodable {

    // MARK: Required

    /// The model to use for generating the completion. Format: models/{model}
    public let model: String

    /// The content of the current conversation with the model.
    public let contents: [Content]

    // MARK: Initializer

    public init(model: String, contents: [Content]) {
        self.model = model
        self.contents = contents
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

/// Struct representing Blob data for inline media bytes.
// public struct Blob: Encodable {
//     public let mimeType: String
//     public let data: Data

//     public init(mimeType: String, data: Data) {
//         self.mimeType = mimeType
//         self.data = data
//     }
// }