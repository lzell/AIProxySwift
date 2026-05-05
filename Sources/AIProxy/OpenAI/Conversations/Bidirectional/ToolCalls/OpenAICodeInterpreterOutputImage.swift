//
//  CodeInterpreterOutputImage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

/// The image output from the code interpreter.
nonisolated public struct OpenAICodeInterpreterOutputImage: Codable, Sendable {
    /// The type of the output. Always `image`.
    public let type = "image"
    
    /// The URL of the image output from the code interpreter.
    public let url: String
    
    /// Creates a new code interpreter output image.
    /// - Parameters:
    ///   - url: The URL of the image output from the code interpreter.
    public init(url: String) {
        self.url = url
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case url
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}
