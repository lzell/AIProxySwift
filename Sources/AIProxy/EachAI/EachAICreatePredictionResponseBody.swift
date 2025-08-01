//
//  EachAIPrediction.swift
//  AIProxy
//
//  Created by Lou Zell on 7/26/25.
//

public struct EachAICreatePredictionResponseBody: Decodable {
    public let predictionID: String
    public let message: String?
    public let status: String?
}
