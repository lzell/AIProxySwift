//
//  TogetherAIChatCompletionStreamingChunk.swift
//
//
//  Created by Lou Zell on 8/16/24.
//

import Foundation

public struct TogetherAIChatCompletionStreamingChunk: Decodable {
    /// Generated choices
    public let choices: [TogetherAIStreamingChunkChoice]

    /// Time in seconds since unix epoch
    public let created: Int

    /// The model used to create the chunk
    public let model: String

    /// Usage information, which is only included on the last chunk of the stream
    public let usage: TogetherAIChatUsage?
}

public struct TogetherAIStreamingChunkChoice: Decodable {
    /// The text for this generation is within the 'delta' property
    public let delta: TogetherAIStreamingChunkDelta

    /// The reason the stream ended
    public let finishReason: TogetherAIFinishReason?
}

public struct TogetherAIStreamingChunkDelta: Decodable {
    /// The text of the generation
    public let content: String

    /// The role of the generation
    public let role: TogetherAIRole
}
