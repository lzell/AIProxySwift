//
//  AnthropicMessageStreamingContentBlockStart.swift
//
//
//  Created by Lou Zell on 10/7/24.
//

import Foundation

nonisolated struct AnthropicMessageStreamingContentBlockStart: Decodable, Sendable {
    let contentBlock: ContentBlock

    static func from(line: String) -> Self? {
        guard line.hasPrefix(#"data: {"type":"content_block_start""#) else {
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

    private enum CodingKeys: String, CodingKey {
        case contentBlock = "content_block"
    }
}

extension AnthropicMessageStreamingContentBlockStart {
    nonisolated enum ContentBlock: Decodable, Sendable {
        case text(String)
        case toolUse(name: String)

        private enum CodingKeys: String, CodingKey {
            case name
            case text
            case type
        }

        private enum PossibleTypes: String, Decodable {
            case text = "text"
            case toolUse = "tool_use"
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(PossibleTypes.self, forKey: .type)
            switch type {
            case PossibleTypes.text:
                self = .text(try container.decode(String.self, forKey: CodingKeys.text))
            case PossibleTypes.toolUse:
                self = .toolUse(name: try container.decode(String.self, forKey: CodingKeys.name))
            }
        }
    }
}
