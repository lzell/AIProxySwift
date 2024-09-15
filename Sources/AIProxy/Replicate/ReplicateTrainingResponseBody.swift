//
//  ReplicateTrainingResponseBody.swift
//
//
//  Created by Lou Zell on 9/8/24.
//

import Foundation

extension ReplicateTrainingResponseBody {
    public struct Metrics: Decodable {
        let predictTime: Double?

        private enum CodingKeys: String, CodingKey {
            case predictTime = "predict_time"
        }
    }
}

extension ReplicateTrainingResponseBody {
    public struct TrainingOutput: Decodable {
        public let version: String?
        public let weights: String?
    }
}


/// Response body for a Replicate training.
/// This format is used for both the "create a training" and "get a training" endpoints:
///     https://replicate.com/docs/reference/http#get-a-training
///     https://replicate.com/docs/reference/http#create-a-training
public struct ReplicateTrainingResponseBody: Decodable {

    /// ISO8601 date stamp of when the training completed
    public let completedAt: String?

    /// ISO8601 date stamp of when the training was created
    public let createdAt: String?

    // Deliberately omitted. Replicate sends data in this field that is not Decodable
    public let error: String?

    /// An identifier of the training
    public let id: String?

    public let logs: String?

    /// Metrics about the training
    public let metrics: Metrics?

    public let model: String?

    public let output: TrainingOutput?

    /// ISO8601 date stamp of when the training started
    public let startedAt: String?

    /// One of `starting`, `processing`, `succeeded`, `failed`, `canceled`
    public let status: Status?

    /// URLs to cancel the prediction or get the result from the prediction
    public let urls: ActionURLs?

    /// The version of the model that ran
    public let version: String?

    private enum CodingKeys: String, CodingKey {
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case error
        case id
        case logs
        case metrics
        case model
        case output
        case startedAt = "started_at"
        case status
        case urls
        case version
    }
}


extension ReplicateTrainingResponseBody {
    public struct ActionURLs: Decodable {
        public let cancel: URL?
        public let get: URL?
    }
}

extension ReplicateTrainingResponseBody {
    public enum Status: String, Decodable {
        case starting
        case processing
        case succeeded
        case failed
        case canceled
    }
}
