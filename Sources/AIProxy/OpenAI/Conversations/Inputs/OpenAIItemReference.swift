//
//  OpenAIItemReference.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: ItemReferenceParam, version 2.3.0, line 66250

/// An internal identifier for an item to reference.
public struct OpenAIItemReference: Encodable, Sendable {
    /// The type of item to reference. Always `item_reference`.
    let type = "item_reference"

    /// The ID of the item to reference.
    let id: String

    /// Creates a new item reference parameter.
    /// - Parameters:
    ///   - id: The ID of the item to reference.
    public init(id: String) {
        self.id = id
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
    }
}
