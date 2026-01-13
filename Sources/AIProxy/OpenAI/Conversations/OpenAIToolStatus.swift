//
//  OpenAIToolStatus.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//

nonisolated public enum OpenAIToolStatus: String, Sendable, Codable {
    case inProgress = "in_progress"
    case completed
    case incomplete
}
