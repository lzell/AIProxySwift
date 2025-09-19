//
//  GeminiFileUploadResponseBody.swift
//
//
//  Created by Lou Zell on 10/24/24.
//

import Foundation

nonisolated public struct GeminiFileUploadResponseBody: Decodable, Sendable {
    public let file: GeminiFile
    
    public init(file: GeminiFile) {
        self.file = file
    }
}
