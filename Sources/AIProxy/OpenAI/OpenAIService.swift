//
//  OpenAIService.swift
//
//
//  Created by Lou Zell on 12/14/24.
//

import Foundation

open class OpenAIService {
    private let requestFormat: OpenAIRequestFormat
    private let requestBuilder: OpenAIRequestBuilder
    private let serviceNetworker: ServiceMixin

    /// This designated initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directOpenAIService` defined in AIProxy.swift.
    init(
        requestFormat: OpenAIRequestFormat,
        requestBuilder: OpenAIRequestBuilder,
        serviceNetworker: ServiceMixin
    ) {
        self.requestFormat = requestFormat
        self.requestBuilder = requestBuilder
        self.serviceNetworker = serviceNetworker
    }

    /// Initiates a non-streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("chat/completions"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    public func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AsyncThrowingStream<OpenAIChatCompletionChunk, Error> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("chat/completions"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeStreamingChunks(request)
    }

    /// Initiates a create image request to /v1/images/generations
    ///
    /// - Parameters:
    ///   - body: The request body to send to openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: A response body containing the generated image as base64, or a reference to the image on a CDN
    ///            https://platform.openai.com/docs/api-reference/images/object
    public func createImageRequest(
        body: OpenAICreateImageRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAICreateImageResponseBody {
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("images/generations"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a create image edit request to `v1/images/edits`
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenAI. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/createEdit
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: A response body containing the generated image as base64, or a reference to the image on a CDN
    ///            https://platform.openai.com/docs/api-reference/images/object
    public func createImageEditRequest(
        body: OpenAICreateImageEditRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAICreateImageResponseBody {
        let request = try await self.requestBuilder.multipartPOST(
            path: self.resolvedPath("images/edits"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a create transcription request to v1/audio/transcriptions
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/audio/createTranscription
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    ///   - progressCallback: Optional callback to track upload progress. Called with a value between 0.0 and 1.0
    /// - Returns: An transcription response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/json-object
    public func createTranscriptionRequest(
        body: OpenAICreateTranscriptionRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:],
        progressCallback: ((Double) -> Void)? = nil
    ) async throws -> OpenAICreateTranscriptionResponseBody {
        let request = try await self.requestBuilder.multipartPOST(
            path: self.resolvedPath("audio/transcriptions"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.serviceNetworker.urlSession,
            request,
            progressCallback
        )
        if body.responseFormat == "text" {
            guard let text = String(data: data, encoding: .utf8) else {
                throw AIProxyError.assertion("Could not represent OpenAI's whisper response as string")
            }
            return OpenAICreateTranscriptionResponseBody(text: text, language: nil, duration: nil, words: nil, segments: nil)
        }

        return try OpenAICreateTranscriptionResponseBody.deserialize(from: data)
    }

    /// Initiates a create text to speech request to v1/audio/speech
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/audio/createSpeech
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: The audio file content. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/createSpeech
    public func createTextToSpeechRequest(
        body: OpenAITextToSpeechRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> Data {
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("audio/speech"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.serviceNetworker.urlSession,
            request
        )
        return data
    }

    /// Initiates a moderation request to /v1/moderations
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/moderations
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: A moderation response that contains a `flagged` boolean. See this reference:
    ///            https://platform.openai.com/docs/api-reference/moderations/object
    public func moderationRequest(
        body: OpenAIModerationRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIModerationResponseBody {
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("moderations"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms. Related guide:
    /// https://platform.openai.com/docs/guides/embeddings
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/embeddings/create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: An embedding response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/embeddings/object
    public func embeddingRequest(
        body: OpenAIEmbeddingRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIEmbeddingResponseBody {
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("embeddings"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

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
    public func realtimeSession(
        model: String,
        configuration: OpenAIRealtimeSessionConfiguration,
        logLevel: AIProxyLogLevel
    ) async throws -> OpenAIRealtimeSession {
        aiproxyCallerDesiredLogLevel = logLevel
        let request = try await self.requestBuilder.plainGET(
            path: "/v1/realtime?model=\(model)",
            secondsToWait: 60,
            additionalHeaders: [
                "openai-beta": "realtime=v1"
            ]
        )
        return await OpenAIRealtimeSession(
            webSocketTask: self.serviceNetworker.urlSession.webSocketTask(with: request),
            sessionConfiguration: configuration
        )
    }

    /// Uploads a file to OpenAI for use in a future tool call
    /// https://platform.openai.com/docs/api-reference/files/create
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
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    ///
    /// - Returns: The file upload response body, which contains the file's ID that can be used in subsequent calls
    public func uploadFile(
        contents: Data,
        name: String,
        purpose: OpenAIFilePurpose,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIFileUploadResponseBody {
        let body = OpenAIFileUploadRequestBody(
            contents: contents,
            contentType: "application/octet-stream",
            fileName: name,
            purpose: purpose
        )
        let request = try await self.requestBuilder.multipartPOST(
            path: self.resolvedPath("files"),
            body: body,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Creates a 'response' using OpenAI's new API product:
    /// https://platform.openai.com/docs/api-reference/responses
    /// - Parameters:
    ///   - requestBody: The request body to send to OpenAI. See this reference:
    ///                  https://platform.openai.com/docs/api-reference/responses/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: An OpenAI response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/responses/object#responses/object-output
    public func createResponse(
        requestBody: OpenAICreateResponseRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIResponse {
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("responses"),
            body: requestBody,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Creates a streaming 'response' using OpenAI's new API product:
    /// https://platform.openai.com/docs/api-reference/responses/streaming
    ///
    /// - Parameters:
    ///   - requestBody: The request body to send to OpenAI. See this reference:
    ///                  https://platform.openai.com/docs/api-reference/responses/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: An async sequence of response chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/responses/streaming
    public func createStreamingResponse(
        requestBody: OpenAICreateResponseRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AsyncThrowingStream<OpenAIResponseStreamingEvent, Error> {
        var requestBody = requestBody
        requestBody.stream = true
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("responses"),
            body: requestBody,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeStreamingChunks(request)
    }

    @available(*, deprecated, message: "This has been renamed to createStreamingResponse")
    public func createStreamingResponseEvents(
        requestBody: OpenAICreateResponseRequestBody,
        secondsToWait: UInt = 60,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AsyncThrowingStream<OpenAIResponseStreamingEvent, Error> {
        return try await self.createStreamingResponse(requestBody: requestBody, secondsToWait: secondsToWait, additionalHeaders: additionalHeaders)
    }

    /// Creates a vector store
    ///
    /// - Parameters:
    ///   - requestBody: The request body to send to OpenAI. See this reference:
    ///                  https://platform.openai.com/docs/api-reference/vector-stores/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: The vector store object
    public func createVectorStore(
        requestBody: OpenAICreateVectorStoreRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIVectorStore {
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("vector_stores"),
            body: requestBody,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    /// Creates a vector store file
    ///
    /// - Parameters:
    ///   - vectorStoreID: The ID of the vector store for which to create a File.
    ///   - requestBody: The request body to send to OpenAI. See this reference:
    ///                  https://platform.openai.com/docs/api-reference/vector-stores-files/createFile
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    ///   - additionalHeaders: Optional headers to pass up with the request alongside the lib's default headers
    /// - Returns: The vector store object
    public func createVectorStoreFile(
        vectorStoreID: String,
        requestBody: OpenAICreateVectorStoreFileRequestBody,
        secondsToWait: UInt,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIVectorStoreFile {
        guard let escapedStoreID = vectorStoreID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw AIProxyError.assertion("Vector store IDs must be URL encodable")
        }
        let request = try await self.requestBuilder.jsonPOST(
            path: self.resolvedPath("vector_stores/\(escapedStoreID)/files"),
            body: requestBody,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        return try await self.serviceNetworker.makeRequestAndDeserializeResponse(request)
    }

    private func resolvedPath(_ common: String) -> String {
        assert(common[common.startIndex] != "/")
        switch self.requestFormat {
        case .standard:
            return "/v1/\(common)"
        case .azureDeployment(let apiVersion):
            return "/\(common)?api-version=\(apiVersion)"
        case .noVersionPrefix:
            return "/\(common)"
        }
    }
}

// Deprecated methods
extension OpenAIService {
    @available(*, deprecated, message: "This has been renamed to chatCompletionRequest(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIChatCompletionResponseBody {
        return try await self.chatCompletionRequest(body: body, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }

    @available(*, deprecated, message: "This has been renamed to streamingChatCompletionRequest(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AsyncThrowingStream<OpenAIChatCompletionChunk, Error> {
        return try await self.streamingChatCompletionRequest(body: body, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }

    @available(*, deprecated, message: "This has been renamed to createTranscriptionRequest(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func createTranscriptionRequest(
        body: OpenAICreateTranscriptionRequestBody,
        additionalHeaders: [String: String] = [:],
        progressCallback: ((Double) -> Void)? = nil
    ) async throws -> OpenAICreateTranscriptionResponseBody {
        return try await self.createTranscriptionRequest(body: body, secondsToWait: 60, additionalHeaders: additionalHeaders, progressCallback: progressCallback)
    }

    @available(*, deprecated, message: "This has been renamed to createTextToSpeechRequest(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func createTextToSpeechRequest(
        body: OpenAITextToSpeechRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> Data {
        return try await self.createTextToSpeechRequest(body: body, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }

    @available(*, deprecated, message: "This has been renamed to moderationRequest(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func moderationRequest(
        body: OpenAIModerationRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIModerationResponseBody {
        return try await self.moderationRequest(body: body, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }

    @available(*, deprecated, message: "This has been renamed to embeddingRequest(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func embeddingRequest(
        body: OpenAIEmbeddingRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIEmbeddingResponseBody {
        return try await self.embeddingRequest(body: body, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }

    @available(*, deprecated, message: "This has been renamed to createResponse(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func createResponse(
        requestBody: OpenAICreateResponseRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> OpenAIResponse {
        return try await self.createResponse(requestBody: requestBody, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }

    @available(*, deprecated, message: "This has been renamed to createStreamingResponse(body:secondsToWait:). For parity with your existing call, pass 60 as the secondsToWait argument.")
    public func createStreamingResponse(
        requestBody: OpenAICreateResponseRequestBody,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AsyncThrowingStream<OpenAIResponseStreamingEvent, Error> {
        return try await self.createStreamingResponse(requestBody: requestBody, secondsToWait: 60, additionalHeaders: additionalHeaders)
    }
}
