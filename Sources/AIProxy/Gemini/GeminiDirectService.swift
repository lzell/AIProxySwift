//
//  GeminiDirectService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

open class GeminiDirectService: GeminiService, DirectService {
    private let unprotectedAPIKey: String

    /// This initializer is not public on purpose.
    /// Customers are expected to use the factory `AIProxy.geminiDirectService` defined in AIProxy.swift
    internal init(
        unprotectedAPIKey: String
    ) {
        self.unprotectedAPIKey = unprotectedAPIKey
    }

    /// Generate content using Gemini. Google puts chat completions, audio transcriptions, and
    /// video capabilities all under the term 'generate content':
    /// https://ai.google.dev/api/generate-content#method:-models.generatecontent
    /// - Parameters:
    ///   - body: Request body
    ///   - model: The model to use for generating the completion, e.g. "gemini-1.5-flash"
    /// - Returns: Content generated with Gemini
    public func generateContentRequest(
        body: GeminiGenerateContentRequestBody,
        model: String
    ) async throws -> GeminiGenerateContentResponseBody {
        let proxyPath = "/v1beta/models/\(model):generateContent"
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://generativelanguage.googleapis.com",
            path: proxyPath,
            body:  body.serialize(),
            verb: .post,
            contentType: "application/json",
            additionalHeaders: [
                "X-Goog-Api-Key": self.unprotectedAPIKey
            ]
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
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "https://generativelanguage.googleapis.com",
            path: "/upload/v1beta/files",
            body: body.serialize(withBoundary: boundary),
            verb: .post,
            contentType: "multipart/related; boundary=\(boundary)",
            additionalHeaders: [
                "X-Goog-Upload-Protocol": "multipart",
                "X-Goog-Api-Key": self.unprotectedAPIKey
            ]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        let response = try GeminiFileUploadResponseBody.deserialize(from: data)
        return try await self.pollForFileUploadComplete(fileURL: response.file.uri)
    }

    /// Deletes a file from Google's temporary storage
    ///
    /// - Parameter fileURL: The location of the file to delete
    public func deleteFile(
        fileURL: URL
    ) async throws {
        guard let scheme = fileURL.scheme,
              let host = fileURL.host else {
            throw AIProxyError.assertion("No host available for Gemini file storage")
        }
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "\(scheme)://\(host)",
            path: fileURL.path,
            body: nil,
            verb: .delete,
            additionalHeaders: [
                "X-Goog-Api-Key": self.unprotectedAPIKey
            ]
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
        guard let scheme = fileURL.scheme,
              let host = fileURL.host else {
            throw AIProxyError.assertion("No host available for Gemini file storage")
        }
        let request = try AIProxyURLRequest.createDirect(
            baseURL: "\(scheme)://\(host)",
            path: fileURL.path,
            body: nil,
            verb: .get,
            additionalHeaders: [
                "X-Goog-Api-Key": self.unprotectedAPIKey
            ]
        )
        let (data, _) = try await BackgroundNetworker.makeRequestAndWaitForData(
            self.urlSession,
            request
        )
        return try GeminiFile.deserialize(from: data)
    }
}
