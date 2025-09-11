//
//  FalOutputImage.swift
//
//
//  Created by Lou Zell on 10/4/24.
//

import Foundation

nonisolated public struct FalOutputImage: Decodable, Sendable {
    public let contentType: String?
    public let height: Int?
    public let url: URL?
    public let width: Int?

    private enum CodingKeys: String, CodingKey {
        case contentType = "content_type"
        case height
        case url
        case width
    }
}
