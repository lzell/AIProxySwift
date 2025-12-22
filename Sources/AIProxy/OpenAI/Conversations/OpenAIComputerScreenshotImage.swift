//
//  ComputerScreenshotImage.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

/// A computer screenshot image used with the computer use tool.
nonisolated public struct OpenAIComputerScreenshotImage: Encodable, Sendable {
    /// Specifies the event type. For a computer screenshot, this property is always set to `computer_screenshot`.
    public let type = "computer_screenshot"
    
    /// The identifier of an uploaded file that contains the screenshot.
    public let fileID: String?
    
    /// The URL of the screenshot image.
    public let imageURL: String?
    
    /// Creates a new computer screenshot image.
    /// - Parameters:
    ///   - fileID: The identifier of an uploaded file that contains the screenshot.
    ///   - imageURL: The URL of the screenshot image.
    public init(
        fileID: String? = nil,
        imageURL: String? = nil
    ) {
        self.fileID = fileID
        self.imageURL = imageURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case fileID = "file_id"
        case imageURL = "image_url"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(fileID, forKey: .fileID)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
    }
}
