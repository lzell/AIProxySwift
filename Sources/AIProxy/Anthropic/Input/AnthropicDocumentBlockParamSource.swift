//
//  AnthropicDocumentBlockParamSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// Represents the union type for the `source` field of Anthropic's `DocumentBlockParam` object.
/// https://console.anthropic.com/docs/en/api/messages#document_block_param
nonisolated public enum AnthropicDocumentBlockParamSource: Encodable, Sendable {
    case base64PDF(AnthropicBase64PDFSource)
    case plainText(AnthropicPlainTextSource)
    case content(AnthropicContentBlockSource)
    case url(AnthropicURLPDFSource)

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .base64PDF(let source):
            try source.encode(to: encoder)
        case .plainText(let source):
            try source.encode(to: encoder)
        case .content(let source):
            try source.encode(to: encoder)
        case .url(let source):
            try source.encode(to: encoder)
        }
    }
}
