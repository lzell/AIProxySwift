//
//  EachAIPrediction.swift
//  AIProxy
//
//  Created by Lou Zell on 8/1/25.
//

import Foundation

public struct EachAIPrediction: Decodable {
    public let id: String?
    public let input: Input?
    public let logs: String?
    public let metrics: Metrics?
    public let output: URL?
    public let status: String?
    public let urls: ActionURLs?

    fileprivate enum CodingKeys: CodingKey {
        case id
        case input
        case logs
        case metrics
        case output
        case status
        case urls
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.input = try container.decodeIfPresent(EachAIPrediction.Input.self, forKey: .input)
        self.logs = try container.decodeIfPresent(String.self, forKey: .logs)
        self.metrics = try container.decodeIfPresent(EachAIPrediction.Metrics.self, forKey: .metrics)
        self.output = try decodeOutput(container)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.urls = try container.decodeIfPresent(EachAIPrediction.ActionURLs.self, forKey: .urls)
    }
}

extension EachAIPrediction {
    public struct Input: Decodable {
        public let prompt: String?
    }

    public struct Metrics: Decodable {
        public let predictTime: Double?
        public let cost: Double?

        private enum CodingKeys: String, CodingKey {
            case predictTime = "predict_time"
            case cost
        }
    }

    public struct ActionURLs: Decodable {
        public let cancel: String?
        public let get: String?
    }
}

private func decodeOutput(
    _ container: KeyedDecodingContainer<EachAIPrediction.CodingKeys>
) throws -> URL? {
    if let outputStr = try container.decodeIfPresent(String.self, forKey: .output) {
        if outputStr != "" {
            return URL(string: outputStr)
        }
    }
    return nil
}
