//
//  EachAIService+Convenience.swift
//  AIProxy
//
//  Created by Lou Zell on 8/1/25.
//

import Foundation

/// Convenience methods for EachAIService
extension EachAIService {

    /// Convenience method for creating an image through Imagen4l:
    /// https://www.eachlabs.ai/ai-models/imagen-4-fast/api
    ///
    /// - Parameters:
    ///   - input: The input specification of the images you'd like to generate
    ///
    /// - Returns: The URL of the generated image
    public func createImagen4FastImage(
        input: EachAIImagenInput,
        pollAttempts: Int,
        secondsBetweenPollAttempts: UInt64
    ) async throws -> URL {
        let requestBody = EachAICreatePredictionRequestBody(
            input: input,
            model: "imagen-4-fast",
            version: "0.0.1"
        )
        let createPredictionResponse = try await self.createPrediction(
            body: requestBody
        )
        let prediction = try await self.pollForPredictionComplete(
            predictionID: createPredictionResponse.predictionID,
            pollAttempts: pollAttempts,
            secondsBetweenPollAttempts: secondsBetweenPollAttempts
        )
        guard let output = prediction.output else {
            throw EachAIError.predictionDidNotIncludeOutput
        }
        return output
    }
}
