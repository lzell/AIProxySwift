//
//  AnthropicMessageStreamingChunk.swift
//
//
//  Created by Lou Zell on 10/7/24.
//

import Foundation

nonisolated public enum AnthropicMessageStreamingChunk: Sendable {
    /// The `String` argument is the chat completion response text "delta", meaning the new bit
    /// of text that just became available. It is not the full message.
    case text(String)

    /// The name of the tool that Claude wants to call, and a buffered input to the function.
    /// The input argument is not a "delta". Internally to this lib, we accumulate the tool
    /// call deltas and map them to `[String: Any]` once all tool call deltas have been
    /// received.
    case toolUse(name: String, input: [String: any Sendable])
}
