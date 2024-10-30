//  AIProxy.swift
//  Created by Todd Hamilton on 10/14/24.

import Foundation

open class GeminiService {
    private let partialKey: String
    private let serviceURL: String
    private let clientID: String?

    /// Creates an instance of GeminiService. Note that the initializer is not public.
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
    /// https://ai.google.dev/api/generate-content#v1beta.models.generateContent
    public func generateContentRequest(
        body: GeminiGenerateContentRequestBody
    ) async throws -> GeminiGenerateContentResponseBody {
        let session = AIProxyURLSession.create()
        let proxyPath = "/v1beta/models/\(body.model):generateContent"

        let request = try await AIProxyURLRequest.create(
            partialKey: self.partialKey,
            serviceURL: self.serviceURL,
            clientID: self.clientID,
            proxyPath: proxyPath,
            body:  body.serialize(),
            verb: .post,
            contentType: "application/json"
        )

        let (data, res) = try await session.data(for: request)
        guard let httpResponse = res as? HTTPURLResponse else {
            throw AIProxyError.assertion("Network response is not an http response")
        }

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try GeminiGenerateContentResponseBody.deserialize(from: data)
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
            contentType: "multipart/related; boundary=\(boundary)",
            headers: ["X-Goog-Upload-Protocol": "multipart"]
        )

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)
        if httpResponse.statusCode > 299 {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        let response = try GeminiFileUploadResponseBody.deserialize(from: data)
        return try await self.pollForFileUploadComplete(fileURL: response.file.uri)
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
            verb: .delete
        )
        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)
        if httpResponse.statusCode > 299 {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }
    }

    /// Polls for the completion of a file upload, where the polling URL is Gemini's `url`
    /// returned in `GeminiFileUploadResponseBody`
    ///
    /// - Parameters:
    ///   - fileURL: The URL returned from the `uploadFile` method
    ///   - pollAttempts: The number of times to poll before `GeminiError.reachedRetryLimit` is raised
    ///   - secondsBetweenPollAttempts: The number of seconds between polls
    ///
    /// - Returns: An upload response with status of `.available`
    public func pollForFileUploadComplete(
        fileURL: URL,
        pollAttempts: Int = 60,
        secondsBetweenPollAttempts: UInt64 = 2
    ) async throws -> GeminiFile {
        return try await self.actorPollForFileUploadCompletion(
            fileURL: fileURL,
            numTries: pollAttempts,
            nsBetweenPollAttempts: secondsBetweenPollAttempts * 1_000_000_000
        )
    }

    @NetworkActor
    private func actorPollForFileUploadCompletion(
        fileURL: URL,
        numTries: Int,
        nsBetweenPollAttempts: UInt64
    ) async throws -> GeminiFile {
        try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
        for _ in 0..<numTries {
            let response = try await self.actorGetStatus(
                fileURL: fileURL
            )
            switch response.state {
            case .processing:
                try await Task.sleep(nanoseconds: nsBetweenPollAttempts)
            case .active:
                return response
            }
        }
        throw GeminiError.reachedRetryLimit
    }

    @NetworkActor
    private func actorGetStatus(
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
            verb: .get
        )

        let (data, httpResponse) = try await BackgroundNetworker.send(request: request)

        if (httpResponse.statusCode > 299) {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(data: data, encoding: .utf8) ?? ""
            )
        }

        return try GeminiFile.deserialize(from: data)
    }
}
