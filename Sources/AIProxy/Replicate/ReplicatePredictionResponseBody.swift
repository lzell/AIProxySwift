//
//  ReplicatePrediction.swift
//
//
//  Created by Lou Zell on 8/25/24.
//

import Foundation

public typealias ReplicatePredictionResponseBody = ReplicatePrediction

/// Represents the current state of a replicate prediction
///
/// This type is used for both the "create a predition" and "get a prediction" endpoints:
///     https://replicate.com/docs/reference/http#get-a-prediction
///     https://replicate.com/docs/reference/http#create-a-prediction
///
/// And it is used for both the sync and polling API:
///     https://replicate.com/docs/topics/predictions/create-a-prediction#sync-mode
///     https://replicate.com/docs/topics/predictions/create-a-prediction#polling
nonisolated public struct ReplicatePrediction<Output: Decodable & Sendable>: Decodable, Sendable {

    /// ISO8601 date stamp of when the prediction completed
    public let completedAt: String?

    /// ISO8601 date stamp of when the prediction was created
    public let createdAt: String?

    /// https://replicate.com/docs/topics/predictions/data-retention
    public let dataRemoved: Bool?

    /// In the case of failure, error will contain the error encountered during the prediction
    public let error: String?

    /// ID of the prediction
    public let id: String?

    /// Prediction logs
    public let logs: String?

    /// How long the prediction took
    public let metrics: Metrics?

    /// The model being run
    public let model: String?

    /// The output adheres to Replicate's "output schema" structure.
    /// Schemas can be found at the Replicate model's detail page by tapping on `API > Schema > Output Schema`.
    /// In the case of SDXL, the output is an array of URLs, which you can see here:
    /// https://replicate.com/stability-ai/sdxl/api/schema#output-schema
    public let output: Output?

    /// ISO8601 timestamp of start of prediction
    public let startedAt: String?

    /// One of `starting`, `processing`, `succeeded`, `failed`, `canceled`.
    ///
    /// In the `succeeded` case, the `output` property on this type will be an object containing the output of the model.
    /// In the `failed` case, `error` property on this type will contain the error encountered during the prediction.
    public let status: Status?

    /// URLs to cancel the prediction or get the result from the prediction
    public let urls: ActionURLs?

    /// The version of the model that ran
    public let version: String?

    /// For compatibility with an older release of the libary
    public var predictionResultURL: URL? {
        return urls?.get
    }

    private enum CodingKeys: String, CodingKey {
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case dataRemoved = "data_removed"
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
    
    public init(completedAt: String?, createdAt: String?, dataRemoved: Bool?, error: String?, id: String?, logs: String?, metrics: Metrics?, model: String?, output: Output?, startedAt: String?, status: Status?, urls: ActionURLs?, version: String?) {
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.dataRemoved = dataRemoved
        self.error = error
        self.id = id
        self.logs = logs
        self.metrics = metrics
        self.model = model
        self.output = output
        self.startedAt = startedAt
        self.status = status
        self.urls = urls
        self.version = version
    }
}

extension ReplicatePrediction {
    nonisolated public struct ActionURLs: Decodable, Sendable {
        public let cancel: URL?
        public let get: URL?
        
        public init(cancel: URL?, get: URL?) {
            self.cancel = cancel
            self.get = get
        }
    }
}

extension ReplicatePrediction {
    nonisolated public struct Metrics: Decodable, Sendable {
        public let predictTime: Double

        enum CodingKeys: String, CodingKey {
            case predictTime = "predict_time"
        }
        
        public init(predictTime: Double) {
            self.predictTime = predictTime
        }
    }
}

extension ReplicatePrediction {
    nonisolated public enum Status: String, Decodable, Sendable {
        /// The prediction is starting up. If this status lasts longer than a few seconds, then it's typically because a new worker is being started to run the prediction.
        case starting

        /// The `predict()` method of the model is currently running.
        case processing

        /// The prediction completed successfully.
        case succeeded

        /// The prediction encountered an error during processing.
        case failed

        /// The prediction was canceled by its creator
        case canceled

        var isTerminal: Bool {
            return [.succeeded, .failed, .canceled].contains(self)
        }
    }
}
