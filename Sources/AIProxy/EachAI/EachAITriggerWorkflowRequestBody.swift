//
//  EachAITriggerWorkflowRequestBody.swift
//
//
//  Created by Lou Zell on 12/7/24.
//

import Foundation

/// See this reference: https://docs.eachlabs.ai/api-reference/flows/trigger-ai-workflow
/// Note that the workflowID is not contained in the body. Rather, it is supplied as part of the path.
nonisolated public struct EachAITriggerWorkflowRequestBody: Encodable, Sendable {
    // Required
    let parameters: [String: AIProxyJSONValue]

    public init(parameters: [String : AIProxyJSONValue]) {
        self.parameters = parameters
    }
}
