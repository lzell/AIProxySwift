//
//  OpenAIRequestFormat.swift
//
//
//  Created by Lou Zell on 9/18/24.
//

import Foundation

nonisolated public enum OpenAIRequestFormat: Sendable {
    /// Requests are formatted for use with OpenAI
    /// Automatically adds /v1/ prefix to all paths
    case standard

    /// Requests are formatted for use with your own Azure deployment
    /// Appends ?api-version parameter to all paths
    case azureDeployment(apiVersion: String)
    
    /// Uses paths as-is without adding any version prefix
    /// This allows for custom versioning by including the version in the baseURL.
    /// This is useful for API providers that use different version prefixes, like ByteDance's Volcengine:
    /// ```
    /// // For Volcengine API which uses v3:
    /// let service = AIProxy.openAIDirectService(
    ///     unprotectedAPIKey: "your-api-key",
    ///     baseURL: "https://ark.cn-beijing.volces.com/api/v3",
    ///     requestFormat: .noVersionPrefix
    /// )
    /// ```
    case noVersionPrefix
}
