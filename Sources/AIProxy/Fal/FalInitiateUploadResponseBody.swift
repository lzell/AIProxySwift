//
//  FalInitiateUploadResponseBody.swift
//
//
//  Created by Lou Zell on 10/3/24.
//

import Foundation

public struct FalInitiateUploadResponseBody: Decodable {
    let fileURL: URL
    let uploadURL: URL

    private enum CodingKeys: String, CodingKey {
        case fileURL = "file_url"
        case uploadURL = "upload_url"
    }
}
