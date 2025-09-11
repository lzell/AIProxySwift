//
//  FalFastQueueResponseBody.swift
//
//
//  Created by Lou Zell on 9/13/24.
//

import Foundation

/// https://fal.ai/docs/model-endpoints/queue
nonisolated public struct FalQueueResponseBody: Decodable, Sendable {
    public let cancelURL: URL?
    public let logs: String?
    public let metrics: Metrics?
    public let responseURL: URL?
    public let requestID: String?
    public let status: Status?
    public let statusURL: URL?
    public let queuePosition: Int?
    
    public init(cancelURL: URL?, logs: String?, metrics: Metrics?, responseURL: URL?, requestID: String?, status: Status?, statusURL: URL?, queuePosition: Int?) {
        self.cancelURL = cancelURL
        self.logs = logs
        self.metrics = metrics
        self.responseURL = responseURL
        self.requestID = requestID
        self.status = status
        self.statusURL = statusURL
        self.queuePosition = queuePosition
    }

    private enum CodingKeys: String, CodingKey {
        case cancelURL = "cancel_url"
        case logs
        case metrics
        case responseURL = "response_url"
        case requestID = "request_id"
        case status
        case statusURL = "status_url"
        case queuePosition = "queue_position"
    }
}

extension FalQueueResponseBody {
    nonisolated public enum Status: String, Decodable, Sendable {
        case inQueue = "IN_QUEUE"
        case inProgress = "IN_PROGRESS"
        case completed = "COMPLETED"
    }
}

extension FalQueueResponseBody {
    nonisolated public struct Metrics: Decodable, Sendable {
        let inferenceTime: Double?
        
        public init(inferenceTime: Double?) {
            self.inferenceTime = inferenceTime
        }

        private enum CodingKeys: String, CodingKey {
            case inferenceTime = "inference_time"
        }
    }
}
