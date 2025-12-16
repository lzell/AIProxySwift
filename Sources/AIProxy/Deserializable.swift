//
//  Deserializable.swift
//
//
//  Created by Lou Zell on 9/14/24.
//

import Foundation

extension Decodable {

    nonisolated static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }

    nonisolated static func deserialize(from str: String) throws -> Self {
        guard let data = str.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [],
                    debugDescription: "Could not create utf8 data from string"
                )
            )
        }
        return try self.deserialize(from: data)
    }

    // Consider making this throw for consistency with Decodable and our decodable helpers.
    nonisolated static func deserialize(fromLine line: String) -> Self? {
        let ignoredLines = [
            #"data: {"type": "ping"}"#, // Anthropic ping
            ": OPENROUTER PROCESSING",  // OpenRouter
            ": keep-alive",             // DeepSeek
        ]
        let ignoredPrefix = "event: " // Anthropic and OpenAI
        guard !(ignoredLines.contains(line) || line.starts(with: ignoredPrefix)) else {
            return nil
        }

        guard line.hasPrefix("data: ") else {
            logIf(.warning)?.warning("AIProxy: Received unexpected line: \(line)")
            return nil
        }

        guard line != "data: [DONE]" else {
            logIf(.debug)?.debug("AIProxy: Streaming response has finished")
            return nil
        }

        let jsonChunk = line.dropFirst(6)
        guard let jsonChunkData = jsonChunk.data(using: .utf8) else {
            logIf(.warning)?.warning("AIProxy: Received unexpected JSON: \(line)")
            return nil
        }

        do {
            return try JSONDecoder().decode(Self.self, from: jsonChunkData)
        } catch {
            logIf(.warning)?.warning(
                """
                AIProxy: Could not deserialize \(Self.self) from json chunk: \(jsonChunk)
                Decodable error: \(error)
                """
            )
            return nil
        }
    }
}
