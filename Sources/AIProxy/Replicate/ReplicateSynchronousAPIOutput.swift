//
//  ReplicateSynchronousAPIOutput.swift
//  AIProxy
//
//  Created by Lou Zell on 10/19/24.
//

import Foundation

@available(*, deprecated, message: "Use ReplicateSynchronousResponseBody as a replacement")
public typealias ReplicateSynchronousAPIOutput = ReplicateSynchronousResponseBody

public struct ReplicateSynchronousResponseBody<T: Decodable>: Decodable {
    public let error: String?

    public let output: T?

    public let status: String?

    /// The location of a ReplicatePredictionResponseBody
    public let predictionResultURL: URL?

    private enum CodingKeys: String, CodingKey {
        case error
        case output
        case status
        case urls
    }

    private enum NestedKeys: String, CodingKey {
        case get
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.output = try container.decodeIfPresent(T.self, forKey: .output)
        let nestedContainer = try container.nestedContainer(
            keyedBy: NestedKeys.self,
            forKey: .urls
        )
        self.predictionResultURL = try nestedContainer.decode(URL?.self, forKey: .get)
    }
}
