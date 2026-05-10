import Foundation

public typealias ElevenLabsTTSResponse<Body: Sendable> = AIProxyResponseWithHeaders<Body>
public typealias ElevenLabsTTSAudioStreamResponse = AIProxyDataStreamResponse
public typealias ElevenLabsTTSChunkStreamResponse<Chunk: Sendable> = AIProxyChunkStreamResponse<Chunk>
