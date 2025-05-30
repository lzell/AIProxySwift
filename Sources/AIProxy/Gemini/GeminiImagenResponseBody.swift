//
//  GeminiImagenResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/18/25.
//

public struct GeminiImagenResponseBody: Decodable {
    public let predictions: [Prediction]
    public init(predictions: [Prediction]) {
        self.predictions = predictions
    }
}

extension GeminiImagenResponseBody {
    public struct Prediction: Decodable {
        public let mimeType: String?
        public let bytesBase64Encoded: String
        
        public init(mimeType: String?, bytesBase64Encoded: String) {
            self.mimeType = mimeType
            self.bytesBase64Encoded = bytesBase64Encoded
        }
    }
}
