//
//  EachAITriggerWorkflowResponseBody.swift
//
//
//  Created by Lou Zell on 12/7/24.
//

import Foundation

public struct EachAITriggerWorkflowResponseBody: Decodable {
    public let triggerID: String
    public let message: String?
    public let status: String?

    private enum CodingKeys: String, CodingKey {
        case triggerID = "trigger_id"
        case message
        case status
    }
}
