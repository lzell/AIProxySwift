//
//  BlackForestLabsService.swift
//  AIProxy
//
//  Created by Lou Zell on 1/8/25.
//

import Foundation

public protocol BlackForestLabsService {

    /// Generates a Flux Pro 1.1 image by making a request to `/v1/flux-pro-1.1`
    ///
    /// - Parameters:
    ///   - body: The request body to send to BFL. See this reference:
    ///   https://api.bfl.ml/scalar#tag/tasks/POST/v1/flux-pro-1.1
    ///
    /// - Returns: The generated image.
    func fluxProRequest_v1_1(
        body: BlackForestLabsFluxProRequestBody_v1_1
    ) async throws -> Void


    func getResult(
        id: String
    ) async throws -> Void
}


