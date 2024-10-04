//
//  FalTimings.swift
//
//
//  Created by Lou Zell on 10/4/24.
//

import Foundation

public struct FalTimings: Decodable {
    public let inference: Double?

    private enum CodingKeys: String, CodingKey {
        case inference
    }
}
