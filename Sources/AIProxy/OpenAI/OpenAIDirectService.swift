//
//  OpenAIDirectService.swift
//
//
//  Created by Lou Zell on 12/14/24.
//

import Foundation

open class OpenAIDirectService: OpenAIService, DirectService {
    private let unprotectedAPIKey: String
    private let requestFormat: OpenAIRequestFormat
    private let baseURL: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.directOpenAIService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String,
        requestFormat: OpenAIRequestFormat = .standard,
        baseURL: String? = nil
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
        self.requestFormat = requestFormat
        self.baseURL = baseURL ?? "https://api.openai.com"
    }

    /// Initiates a non-streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: A ChatCompletionResponse. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/object
    public func chatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenAIChatCompletionResponseBody {
        var body = body
        body.stream = false
        body.streamOptions = nil
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("chat/completions"),
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a streaming chat completion request to /v1/chat/completions.
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/chat/create
    ///   - secondsToWait: The amount of time to wait before `URLError.timedOut` is raised
    /// - Returns: An async sequence of completion chunks. See this reference:
    ///            https://platform.openai.com/docs/api-reference/chat/streaming
    public func streamingChatCompletionRequest(
        body: OpenAIChatCompletionRequestBody,
        secondsToWait: UInt
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, OpenAIChatCompletionChunk> {
        var body = body
        body.stream = true
        body.streamOptions = .init(includeUsage: true)
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("chat/completions"),
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeStreamingChunks(request)
    }

    /// Initiates a create image request to /v1/images/generations
    ///
    /// - Parameters:
    ///   - body: The request body to send to openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/create
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: A response body containing the generated image as base64, or a reference to the image on a CDN
    ///            https://platform.openai.com/docs/api-reference/images/object
    public func createImageRequest(
        body: OpenAICreateImageRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenAICreateImageResponseBody {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("images/generations"),
            body: try body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Initiates a create image edit request to `v1/images/edits`
    ///
    /// - Parameters:
    ///   - body: The request body to send to OpenAI. See this reference:
    ///           https://platform.openai.com/docs/api-reference/images/createEdit
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`
    /// - Returns: A response body containing the generated image as base64, or a reference to the image on a CDN
    ///            https://platform.openai.com/docs/api-reference/images/object
    public func createImageEditRequest(
        body: OpenAICreateImageEditRequestBody,
        secondsToWait: UInt
    ) async throws -> OpenAICreateImageResponseBody {
        let boundary = UUID().uuidString
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("images/edits"),
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }


    /// Initiates a create transcription request to v1/audio/transcriptions
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/audio/createTranscription
    /// - Returns: An transcription response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/json-object
    public func createTranscriptionRequest(
        body: OpenAICreateTranscriptionRequestBody,
        progressCallback: ((Double) -> Void)?
    ) async throws -> OpenAICreateTranscriptionResponseBody {
        let boundary = UUID().uuidString
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("audio/transcriptions"),
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: 60,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request,
            progressCallback
        )
        if progressCallback != nil {
                  logIf(.error)?.error("progressCallback for transcription is not implemented")
        }
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
    /// - Returns: The audio file content. See this reference:
    ///            https://platform.openai.com/docs/api-reference/audio/createSpeech
    public func createTextToSpeechRequest(
        body: OpenAITextToSpeechRequestBody
    ) async throws -> Data {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("audio/speech"),
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return data
    }

    /// Initiates a moderation request to /v1/moderations
    ///
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/moderations
    /// - Returns: A moderation response that contains a `flagged` boolean. See this reference:
    ///            https://platform.openai.com/docs/api-reference/moderations/object
    public func moderationRequest(
        body: OpenAIModerationRequestBody
    ) async throws -> OpenAIModerationResponseBody {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("moderations"),
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms. Related guide:
    /// https://platform.openai.com/docs/guides/embeddings
    /// - Parameters:
    ///   - body: The request body to send to aiproxy and openai. See this reference:
    ///           https://platform.openai.com/docs/api-reference/embeddings/create
    /// - Returns: An embedding response. See this reference:
    ///            https://platform.openai.com/docs/api-reference/embeddings/object
    public func embeddingRequest(
        body: OpenAIEmbeddingRequestBody
    ) async throws -> OpenAIEmbeddingResponseBody {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("embeddings"),
            body: try body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Starts a realtime session.
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/v1/realtime?model=\(model)",
            body: nil,
            verb: .get,
            secondsToWait: 60,
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)",
                "OpenAI-Beta": "realtime=v1",
            ]
        )
        return await OpenAIRealtimeSession(
            webSocketTask: self.urlSession.webSocketTask(with: request),
            sessionConfiguration: configuration
        )
    }

    /// Uploads a file to OpenAI for use in a future tool call
    ///
    /// - Parameters:
    ///   - contents: The binary contents of your file. If you've added your file to xcassets, you
    ///               can access the file's data with `NSDataAsset(name: "myfile").data`.
    ///                If you've added your file to the app bundle, you can access the file's data with:
    ///
    ///                    guard let localURL = Bundle.main.url(forResource: "myfile", withExtension: "pdf"),
    ///                          let pdfData = try? Data(contentsOf: localURL) else { return }
    ///
    ///   - name: The name of the file, e.g. `myfile.pdf`
    ///
    /// - Returns: The file upload response body, which contains the file's ID that can be used in subsequent calls
    public func uploadFile(
        contents: Data,
        name: String,
        purpose: String
    ) async throws -> OpenAIFileUploadResponseBody {
        let body = OpenAIFileUploadRequestBody(
            contents: contents,
            contentType: "application/octet-stream",
            fileName: name,
            purpose: purpose
        )
        let boundary = UUID().uuidString
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: "/v1/files",
            body: formEncode(body, boundary),
            verb: .post,
            secondsToWait: 60,
            contentType: "multipart/form-data; boundary=\(boundary)",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Creates a 'response' using OpenAI's new API product:
    /// https://platform.openai.com/docs/api-reference/responses
    public func createResponse(
        requestBody: OpenAICreateResponseRequestBody
    ) async throws -> OpenAIResponse {
        let request = try AIProxyURLRequest.createDirect(
            baseURL: self.baseURL,
            path: self.resolvedPath("responses"),
            body: try requestBody.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json",
            additionalHeaders: [
                "Authorization": "Bearer \(self.unprotectedAPIKey)"
            ]
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    private func resolvedPath(_ common: String) -> String {
        assert(common[common.startIndex] != "/")
        switch self.requestFormat {
        case .standard:
            return "/v1/\(common)"
        case .azureDeployment(let apiVersion):
            return "/\(common)?api-version=\(apiVersion)"
        }
    }
}
