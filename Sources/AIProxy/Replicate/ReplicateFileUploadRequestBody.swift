//
//  ReplicateFile.swift
//
//
//  Created by Lou Zell on 9/9/24.
//

import Foundation

struct ReplicateFileUploadRequestBody: MultipartFormEncodable {

    let fileData: Data
    let fileName: String

    var formFields: [FormField] {
        return [
            .fileField(
                name: "content",
                content: self.fileData,
                contentType: "application/zip",
                filename: self.fileName
            )
        ]
    }
}
