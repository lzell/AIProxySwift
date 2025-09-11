//
//  ReplicateFile.swift
//
//
//  Created by Lou Zell on 9/9/24.
//

import Foundation

struct ReplicateFileUploadRequestBody: MultipartFormEncodable {

    /// The binary contents of the file
    let contents: Data

    /// The file mime type
    let contentType: String

    /// The name of the file. I believe this does not get preserved on replicate's CDN. Can it be removed?
    let fileName: String

    var formFields: [FormField] {
        return [
            .fileField(
                name: "content",
                content: self.contents,
                contentType: self.contentType,
                filename: self.fileName
            )
        ]
    }
}
