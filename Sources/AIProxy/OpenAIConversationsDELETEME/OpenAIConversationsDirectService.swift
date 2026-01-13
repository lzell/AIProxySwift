//
//  OpenAIConversationsDirectService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

@AIProxyActor final class OpenAIConversationsDirectService: OpenAIConversationsService, DirectService, Sendable {

    nonisolated init(
        unprotectedAPIKey: String,
        baseURL: String? = nil
    ) {
        let baseURL = baseURL ?? "https://api.openai.com"
        let requestBuilder = AIProxyDirectRequestBuilder(
            baseURL: baseURL,
            unprotectedAuthHeader: (key: "Authorization", value: "Bearer \(unprotectedAPIKey)")
        )
        super.init(
            requestBuilder: requestBuilder,
            serviceNetworker: DirectServiceNetworker()
        )
    }
}
