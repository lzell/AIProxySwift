//
//  OpenAIFileUploadRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/27/25.
//

import Foundation

internal struct OpenAIFileUploadRequestBody: MultipartFormEncodable {

    /// The binary contents of the file
    let contents: Data

    /// The file mime type
    let contentType: String

    /// The name of the file
    let fileName: String

    /// The intended purpose of the uploaded file. One of:
    /// - assistants: Used in the Assistants API
    /// - batch: Used in the Batch API
    /// - fine-tune: Used for fine-tuning
    /// - vision: Images used for vision fine-tuning
    /// - user_data: Flexible file type for any purpose
    /// - evals: Used for eval data sets
    let purpose: OpenAIFilePurpose

    var formFields: [FormField] {
        return [
            .fileField(
                name: "file",
                content: self.contents,
                contentType: self.contentType,
                filename: self.fileName
            ),
            .textField(
                name: "purpose",
                content: self.purpose.rawValue
            )
        ]
    }
}
