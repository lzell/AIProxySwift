//
//  Deserializable.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

extension Decodable {
    static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }

    static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not create utf8 data from string")
        }
        return try self.deserialize(from: data)
    }

    static func deserialize(fromLine line: String) -> Self? {
        guard line.hasPrefix("data: ") else {
            let openRouterIgnore = line == ": OPENROUTER PROCESSING"
            let deepSeekIgnore = line == ": keep-alive"
            let openAIIgnore = line.starts(with: "event: ")
            if !(openRouterIgnore || deepSeekIgnore || openAIIgnore) {
                logIf(.warning)?.warning("Received unexpected line from aiproxy: \(line)")
            }
            return nil
        }

        guard line != "data: [DONE]" else {
            logIf(.debug)?.debug("Streaming response has finished")
            return nil
        }

        guard let chunkJSON = line.dropFirst(6).data(using: .utf8),
              let chunk = try? JSONDecoder().decode(Self.self, from: chunkJSON) else
        {
            logIf(.warning)?.warning("Received unexpected JSON from aiproxy: \(line)")
            return nil
        }

        // if ll(.debug) { aiproxyLogger.debug("Received a chunk: \(line)") }
        return chunk
    }
}
