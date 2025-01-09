//
//  ReplicateSynchronousAPIOutput.swift
//  AIProxy
//
//  Created by Lou Zell on 10/19/24.
//

import Foundation

public struct ReplicateSynchronousAPIOutput<T: Decodable>: Decodable {
    public let logs: String?

    public let output: T?

    /// The location of a ReplicatePredictionResponseBody
    public let predictionResultURL: URL?

    private enum CodingKeys: String, CodingKey {
        case logs
        case output
        case urls
    }

    private enum NestedKeys: String, CodingKey {
        case get
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logs = try container.decode(String.self, forKey: .logs)
        self.output = try container.decode(T?.self, forKey: .output)
        let nestedContainer = try container.nestedContainer(
            keyedBy: NestedKeys.self,
            forKey: .urls
        )
        self.predictionResultURL = try nestedContainer.decode(URL?.self, forKey: .get)
    }
}
