//
//  AnthropicBase64PDFSource.swift
//  AIProxy
//
//  Created by Lou Zell on 12/10/25.
//

/// A base64-encoded PDF document source.
/// https://console.anthropic.com/docs/en/api/messages#base64_pdf_source
nonisolated public struct AnthropicBase64PDFSource: Codable, Sendable {
    public let type: String
    public let mediaType: String
    public let data: String
    
    private enum CodingKeys: String, CodingKey {
        case type
        case mediaType = "media_type"
        case data
    }
    
    public init(data: String) {
        self.type = "base64"
        self.mediaType = "application/pdf"
        self.data = data
    }
}
