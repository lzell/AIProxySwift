//
//  AnthropicMessageStreamingDeltaBlock.swift
//
//
//  Created by Lou Zell on 10/7/24.
//

import Foundation

nonisolated struct AnthropicMessageStreamingDeltaBlock: Decodable, Sendable {
    /// We do not vend this type. See AnthropicMessageStreamingChunk for the final product that
    /// we vend to the client.
    let delta: Delta

    static func from(line: String) -> Self? {
        guard line.hasPrefix(#"data: {"type":"content_block_delta""#) else {
            return nil
        }
        guard let chunkJSON = line.dropFirst(6).data(using: .utf8),
              let chunk = try? JSONDecoder().decode(Self.self, from: chunkJSON) else
        {
            logIf(.warning)?.warning("Received unexpected JSON from Anthropic: \(line)")
            return nil
        }
        return chunk
    }
}

extension AnthropicMessageStreamingDeltaBlock {
    nonisolated enum Delta: Decodable, Sendable {
        case text(String)
        case toolUse(String)

        private enum CodingKeys: String, CodingKey {
            case partialJSON = "partial_json"
            case text
            case type
        }

        private enum PossibleTypes: String, Decodable {
            case textDelta = "text_delta"
            case inputJSONDelta = "input_json_delta"
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(PossibleTypes.self, forKey: .type)
            switch type {
            case .textDelta:
                self = .text(try container.decode(String.self, forKey: .text))
            case .inputJSONDelta:
                self = .toolUse(try container.decode(String.self, forKey: .partialJSON))
            }
        }
    }
}


