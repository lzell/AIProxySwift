//
//  FalTimings.swift
//
//
//  Created by Lou Zell on 10/4/24.
//

import Foundation

public struct FalTimings: Decodable {
    public let inference: Double?
    
    public init(inference: Double?) {
        self.inference = inference
    }

    private enum CodingKeys: String, CodingKey {
        case inference
    }
}
