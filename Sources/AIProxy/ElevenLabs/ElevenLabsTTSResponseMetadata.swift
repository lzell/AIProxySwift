import Foundation

nonisolated public struct ElevenLabsTTSResponse<Body: Sendable>: Sendable {
    public let body: Body
    public let headers: [String: String]

    public init(body: Body, headers: [String: String]) {
        self.body = body
        self.headers = headers
    }
}

nonisolated public struct ElevenLabsTTSAudioStreamResponse: Sendable {
    public let headers: [String: String]
    public let stream: AsyncStream<Data>

    public init(headers: [String: String], stream: AsyncStream<Data>) {
        self.headers = headers
        self.stream = stream
    }
}

nonisolated public struct ElevenLabsTTSChunkStreamResponse<Chunk: Sendable>: Sendable {
    public let headers: [String: String]
    public let stream: AsyncThrowingStream<Chunk, Error>

    public init(headers: [String: String], stream: AsyncThrowingStream<Chunk, Error>) {
        self.headers = headers
        self.stream = stream
    }
}
