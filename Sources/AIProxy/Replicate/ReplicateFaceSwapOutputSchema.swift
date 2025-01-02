//
//  FaceSwapOutputSchema.swift
//  AIProxy
//
//  Created by Lou Zell on 1/1/25.
//

import Foundation

/// Output schema for https://replicate.com/xiankgx/face-swap/api/schema
public struct ReplicateFaceSwapOutputSchema: Decodable {
    public let code: Int?
    public let imageURL: URL?
    public let msg: String?
    public let status: String

    private enum CodingKeys: CodingKey {
        case code
        case image
        case msg
        case status
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.imageURL = self.status == "succeed"
            ? try container.decodeIfPresent(URL.self, forKey: .image)
            : nil
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        self.msg = try container.decodeIfPresent(String.self, forKey: .msg)
    }
}
