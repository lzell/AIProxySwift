//
//  InputImageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//


/// An image input to the model.
///
/// Learn about image inputs:https://platform.openai.com/docs/guides/vision
public nonisolated struct OpenAIInputImageContent: Encodable, Sendable {
    /// The type of the input item. Always `input_image`.
    public let type = "input_image"
    
    /// The URL of the image to be sent to the model.
    ///
    /// A fully qualified URL or base64 encoded image in a data URL.
    public let imageURL: String?
    
    /// The ID of the file to be sent to the model.
    public let fileID: String?
    
    /// The detail level of the image to be sent to the model.
    ///
    /// One of `high`, `low`, or `auto`. Defaults to `auto`.
    public let detail: ImageDetail
    
    /// Creates a new input image content.
    /// - Parameters:
    ///   - imageURL: The URL of the image to be sent to the model. A fully qualified URL or base64 encoded image in a data URL.
    ///   - fileID: The ID of the file to be sent to the model.
    ///   - detail: The detail level of the image to be sent to the model. Defaults to `auto`.
    public init(
        imageURL: String? = nil,
        fileID: String? = nil,
        detail: ImageDetail = .auto
    ) {
        self.imageURL = imageURL
        self.fileID = fileID
        self.detail = detail
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case imageURL = "image_url"
        case fileID = "file_id"
        case detail
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encodeIfPresent(fileID, forKey: .fileID)
        try container.encode(detail, forKey: .detail)
    }
}
