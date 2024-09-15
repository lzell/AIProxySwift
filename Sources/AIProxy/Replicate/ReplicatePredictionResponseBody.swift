//
//  ReplicatePredictionResponseBody.swift
//
//
//  Created by Lou Zell on 8/25/24.
//

import Foundation

/// Response body for a Replicate prediction.
/// This format is used for both the "create a predition" and "get a prediction" endpoints:
///     https://replicate.com/docs/reference/http#get-a-prediction
///     https://replicate.com/docs/reference/http#create-a-prediction
public struct ReplicatePredictionResponseBody<T: Decodable>: Decodable {

    /// ISO8601 date stamp of when the prediction completed
    public let completedAt: String?

    /// In the case of failure, error will contain the error encountered during the prediction
    public let error: String?

    /// The output adheres to Replicate's "output schema" structure.
    /// Schemas can be found at the Replicate model's detail page by tapping on `API > Schema > Output Schema`.
    /// In the case of SDXL, the output is an array of URLs, which you can see here:
    /// https://replicate.com/stability-ai/sdxl/api/schema#output-schema
    public let output: T?

    /// ISO8601 timestamp of start of prediction
    public let startedAt: String?

    /// One of `starting`, `processing`, `succeeded`, `failed`, `canceled`
    public let status: Status?

    /// URLs to cancel the prediction or get the result from the prediction
    public let urls: ActionURLs?

    /// The version of the model that ran
    public let version: String?

    private enum CodingKeys: String, CodingKey {
        case completedAt = "completed_at"
        case error
        case output
        case startedAt = "started_at"
        case status
        case urls
        case version
    }
}

extension ReplicatePredictionResponseBody {
    public struct ActionURLs: Decodable {
        public let cancel: URL?
        public let get: URL?
    }
}

extension ReplicatePredictionResponseBody {
    public enum Status: String, Decodable {
        case starting
        case processing
        case succeeded
        case failed
        case canceled
    }
}
