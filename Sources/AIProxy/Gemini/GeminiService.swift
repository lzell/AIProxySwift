//
//  GeminiService.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

public protocol GeminiService {

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
    func generateContentRequest(
        body: GeminiGenerateContentRequestBody,
        model: String,
        secondsToWait: UInt
    ) async throws -> GeminiGenerateContentResponseBody

    /// Generate images with the Imagen API
    func makeImagenRequest(
        body: GeminiImagenRequestBody,
        model: String
    ) async throws -> GeminiImagenResponseBody


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
    func uploadFile(
        fileData: Data,
        mimeType: String
    ) async throws -> GeminiFile 

    /// Deletes a file from Google's temporary storage
    ///
    /// - Parameter fileURL: The location of the file to delete
    func deleteFile(
        fileURL: URL
    ) async throws

    /// Gets the status of a file upload
    func getStatus(
        fileURL: URL
    ) async throws -> GeminiFile
}

extension GeminiService {
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
        try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
        for _ in 0..<pollAttempts {
            let response = try await self.getStatus(
                fileURL: fileURL
            )
            switch response.state {
            case .processing:
                try await Task.sleep(nanoseconds: secondsBetweenPollAttempts * 1_000_000_000)
            case .active:
                return response
            }
        }
        throw GeminiError.reachedRetryLimit
    }
}
