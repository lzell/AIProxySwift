//
//  OpenAIRequestFormat.swift
//
//
//  Created by Lou Zell on 9/18/24.
//

import Foundation

public enum OpenAIRequestFormat {
    /// Requests are formatted for use with OpenAI
    case standard

    /// Requests are formatted for use with your own Azure deployment
    case azureDeployment(apiVersion: String)
}
