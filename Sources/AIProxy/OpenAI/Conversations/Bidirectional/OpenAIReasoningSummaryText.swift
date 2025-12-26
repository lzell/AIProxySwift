//
//  OpenAIReasoningSummaryText.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public struct OpenAIReasoningSummaryText: Encodable, Decodable, Sendable {
    /// A summary of the reasoning output from the model so far.
    public let text: String

    /// The type of the object. Always `summary_text`.
    public let type = "summary_text"

    public init(text: String) {
        self.text = text
    }
}
