//
//  EachAITriggerWorkflowResponseBody.swift
//
//
//  Created by Lou Zell on 12/7/24.
//

import Foundation

nonisolated public struct EachAITriggerWorkflowResponseBody: Decodable, Sendable {
    public let triggerID: String
    public let message: String?
    public let status: String?
    
    public init(triggerID: String, message: String?, status: String?) {
        self.triggerID = triggerID
        self.message = message
        self.status = status
    }

    private enum CodingKeys: String, CodingKey {
        case triggerID = "trigger_id"
        case message
        case status
    }
}
