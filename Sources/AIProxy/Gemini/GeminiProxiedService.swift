//  AIProxy.swift
//  Created by Todd Hamilton on 10/14/24.

import Foundation

open class GeminiProxiedService: GeminiService, ProxiedService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.geminiService` defined in AIProxy.swift
    internal init(
        partialKey: String,
        serviceURL: String,
        clientID: String?
    ) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.clientID = clientID
    }

    /// Generate content using Gemini. Google puts chat completions, audio transcriptions, and
    /// video capabilities all under the term 'generate content':
    /// https://ai.google.dev/api/generate-content#method:-models.generatecontent
    /// - Parameters:
    ///   - body: Request body
    ///   - model: The model to use for generating the completion, e.g. "gemini-1.5-flash"
    ///   - secondsToWait: Seconds to wait before raising `URLError.timedOut`.
    ///                    Use `60` if you'd like to be consistent with the default URLSession timeout.
    ///                    Use a longer timeout if you expect your generations to take longer than sixty seconds.
    /// - Returns: Content generated with Gemini
    public func generateContentRequest(
        body: GeminiGenerateContentRequestBody,
        model: String,
        secondsToWait: UInt
    ) async throws -> GeminiGenerateContentResponseBody {
        let proxyPath = "/v1beta/models/\(model):generateContent"
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: proxyPath,
            body:  body.serialize(),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Generate images with the Imagen API
    public func makeImagenRequest(
        body: GeminiImagenRequestBody,
        model: String
    ) async throws -> GeminiImagenResponseBody {
        let proxyPath = "/v1beta/models/\(model):predict"
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: proxyPath,
            body:  body.serialize(),
            verb: .post,
            secondsToWait: 60,
            contentType: "application/json"
        )
        return try await self.makeRequestAndDeserializeResponse(request)
    }

    /// Uploads a file to Google's short term storage.
    ///
    /// The File API lets you store up to 20 GB of files per project, with a per-file maximum
    /// size of 2 GB. Files are stored for 48 hours. They can be accessed in that period with
    /// your API key, but they cannot be downloaded using any API. It is available at no cost
    /// in all regions where the Gemini API is available.
    /// https://ai.google.dev/gemini-api/docs/vision?lang=python#technical-details-video
    ///
    /// - Parameters:
    ///
    ///   - fileData: The binary representation of your file
    ///
    ///   - mimeType: The mime type of the uploaded data, e.g.`video/mp4`, `image/png`,  and `application/zip` are all valid mime types.
    ///
    /// - Returns: A GeminiFile that contains the URL of the file on Google's short term storage. Add this
    ///            URL to any content generation request using `GeminiGenerateContentRequestBody`. You can
    ///            also use this URL to delete the file from Google's storage
    public func uploadFile(
        fileData: Data,
        mimeType: String
    ) async throws -> GeminiFile {
        let body = GeminiFileUploadRequestBody(fileData: fileData, mimeType: mimeType)
        let boundary = UUID().uuidString
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: "/upload/v1beta/files",
            body: body.serialize(withBoundary: boundary),
            verb: .post,
            secondsToWait: 60,
            contentType: "multipart/related; boundary=\(boundary)",
            additionalHeaders: ["X-Goog-Upload-Protocol": "multipart"]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        let response = try GeminiFileUploadResponseBody.deserialize(from: data)
        return try await self.pollForFileUploadComplete(
            fileURL: response.file.uri,
            pollAttempts: 60,
            secondsBetweenPollAttempts: 2
        )
    }

    /// Deletes a file from Google's temporary storage
    ///
    /// - Parameter fileURL: The location of the file to delete
    public func deleteFile(
        fileURL: URL
    ) async throws {
        guard fileURL.host == "generativelanguage.googleapis.com" else {
            throw AIProxyError.assertion("Gemini has changed the file storage domain")
        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: fileURL.path,
            body: nil,
            verb: .delete,
            secondsToWait: 60
        )
        let (_, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
    }

    /// Gets the status of a file upload
    public func getStatus(
        fileURL: URL
    ) async throws -> GeminiFile {
        guard fileURL.host == "generativelanguage.googleapis.com" else {
            throw AIProxyError.assertion("Gemini has changed the upload polling domain")
        }
        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: fileURL.path,
            body: nil,
            verb: .get,
            secondsToWait: 60
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            AIProxyUtils.proxiedURLSession(),
            request
        )
        return try GeminiFile.deserialize(from: data)
    }
}
