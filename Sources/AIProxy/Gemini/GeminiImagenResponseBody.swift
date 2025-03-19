//
//  GeminiImagenResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/18/25.
//

public struct GeminiImagenResponseBody: Decodable {
    public let predictions: [Prediction]
}

extension GeminiImagenResponseBody {
    public struct Prediction: Decodable {
        public let mimeType: String?
        public let bytesBase64Encoded: String
    }
}
