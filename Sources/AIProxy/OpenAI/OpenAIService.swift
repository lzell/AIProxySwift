//
//  OpenAIService.swift
//  
//
//  Created by Lou Zell on 12/14/24.
//

import Foundation

public protocol OpenAIService {

    /// Initiates a non-streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenAIChatCompletionResponseBody
    
    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk>
    
    /// Initiates a create image request to /v1/images/generations
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenAI. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: A response body containing the generated image as base64, or a reference to the image on a CDN
    ///            https://platform.openai.com/docs/api-reference/images/object
    func createImageRequest(
        body: OpenAICreateImageRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenAICreateImageResponseBody

    /// Initiates a create image edit request to `v1/images/edits`
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenAI. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/createEdit
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: A response body containing the generated image as base64, or a reference to the image on a CDN
    ///            https://platform.openai.com/docs/api-reference/images/object
    func createImageEditRequest(
        body: OpenAICreateImageEditRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenAICreateImageResponseBody

    /// Initiates a create transcription request to v1/audio/transcriptions
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/audio/createTranscription
    ///   - progressCallback: Optional callback to track upload progress. Called with a value between 0.0 and 1.0
    /// - Returns: An transcription response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/json-object
    func createTranscriptionRequest(
        body: OpenAICreateTranscriptionRequestBody,
        progressCallback: ((Double) -> Void)?
    ) async throws -> OpenAICreateTranscriptionResponseBody
    
    /// Initiates a create text to speech request to v1/audio/speech
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/audio/createSpeech
    /// - Returns: The audio file content. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/createSpeech
    func createTextToSpeechRequest(
        body: OpenAITextToSpeechRequestBody
    ) async throws -> Data
    
    /// Initiates a moderation request to /v1/moderations
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/moderations
    /// - Returns: A moderation response that contains a `flagged` boolean. See this reference:
    ///            https://platform.openai.com/docs/api-reference/moderations/object
    func moderationRequest(
        body: OpenAIModerationRequestBody
    ) async throws -> OpenAIModerationResponseBody

    /// Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms. Related guide:
    /// https://platform.openai.com/docs/guides/embeddings
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/embeddings/create
    ///
    /// - Returns: An embedding response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/embeddings/object
    func embeddingRequest(
        body: OpenAIEmbeddingRequestBody
    ) async throws -> OpenAIEmbeddingResponseBody

    /// Starts a realtime session.
    /// 
    /// To protect this connection through AIProxy's backend, your project must have websocket support enabled.
    /// If you would like to be added to the private beta for websocket support, please reach out.
    /// 
    /// - Parameters:
    ///   - model: The model to use. See the available model names here:
    ///            https://platform.openai.com/docs/models#gpt-4o-realtime
    ///   - configuration: The session configuration object, see this reference:
    ///                    https://platform.openai.com/docs/api-reference/realtime-client-events/session/update#realtime-client-events/session/update-session
    ///   - logLevel: The threshold level that this library begins emitting log messages.
    ///               For example, if you set this to `info`, then you'll see all `info`, `warning`, `error`, and `critical` logs.
    ///
    /// - Returns: A realtime session manager that the caller can send and receive messages with.
    func realtimeSession(
        model: String,
        configuration: OpenAIRealtimeSessionConfiguration,
        logLevel: AIProxyLogLevel
    ) async throws -> OpenAIRealtimeSession


    /// Uploads a file to OpenAI for use in a future tool call
    ///
    /// - Parameters:
    ///   - contents: The binary contents of your file. If you've added your file to xcassets, you
    ///               can access the file's data with `NSDataAsset(name: "myfile").data`.
    ///               If you've added your file to the app bundle, you can access the file's data with:
    ///
    ///                    guard let localURL = Bundle.main.url(forResource: "myfile", withExtension: "pdf"),
    ///                          let pdfData = try? Data(contentsOf: localURL) else { return }
    ///
    ///   - name: The name of the file, e.g. `myfile.pdf`
    ///
    /// - Returns: The file upload response body, which contains the file's ID that can be used in subsequent calls
    func uploadFile(
        contents: Data,
        name: String,
        purpose: String
    ) async throws -> OpenAIFileUploadResponseBody

    /// Creates a 'response' using OpenAI's new API product:
    /// https://platform.openai.com/docs/api-reference/responses
    func createResponse(
        requestBody: OpenAICreateResponseRequestBody
    ) async throws -> OpenAIResponse
}

extension OpenAIService {
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> OpenAIChatCompletionResponseBody {
        return try await self.chatCompletionRequest(body: body, secondsToWait: 60)
    }

    public func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk> {
        return try await self.streamingChatCompletionRequest(body: body, secondsToWait: 60)
    }
    
    public func createTranscriptionRequest(
        body: OpenAICreateTranscriptionRequestBody
    ) async throws -> OpenAICreateTranscriptionResponseBody {
        return try await self.createTranscriptionRequest(body: body, progressCallback: nil)
    }
}
