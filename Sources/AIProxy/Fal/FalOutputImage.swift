//
//  FalOutputImage.swift
//
//
//  Created by Lou Zell on 10/4/24.
//

import Foundation

public struct FalOutputImage: Decodable {
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
