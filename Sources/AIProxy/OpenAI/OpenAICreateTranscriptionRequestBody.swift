//
//  OpenAICreateTranscriptionRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/11/25.
//

import Foundation

/// Request body for the 'Create transcription' endpoint:
/// https://platform.openai.com/docs/api-reference/audio/createTranscription
public struct OpenAICreateTranscriptionRequestBody: MultipartFormEncodable {
    /// The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    public let file: Data

    /// ID of the model to use. Only `whisper-1` (which is powered by our open source Whisper V2 model) is currently available.
    public let model: String

    // MARK: Optional properties

    /// The language of the input audio. Supplying the input language in ISO-639-1 format will improve accuracy and latency.
    public let language: String?

    /// An optional text to guide the model's style or continue a previous audio segment. The prompt should match the audio language.
    public let prompt: String?

    /// Set this to `verbose_json` to create a transcription object with metadata.
    /// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
    public let responseFormat: String?

    /// The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower
    /// values like 0.2 will make it more focused and deterministic. If set to 0, the model will use log probability to automatically
    /// increase the temperature until certain thresholds are hit.
    public let temperature: Double?

    /// The timestamp granularities to populate for this transcription. `responseFormat` must be set `verbose_json` to
    /// use timestamp granularities. Either or both of these options are supported: `word`, or `segment`. Note: There is no
    /// additional latency for segment timestamps, but generating word timestamps incurs additional latency.
    /// Defaults to `.segment`
    public let timestampGranularities: [TimestampGranularity]?

    public var formFields: [FormField] {
        var fields: [FormField] = [
            .fileField(name: "file", content: self.file, contentType: "audio/mpeg", filename: "aiproxy.m4a"),
            .textField(name: "model", content: self.model),
            self.language.flatMap { .textField(name: "language", content: $0)},
            self.prompt.flatMap { .textField(name: "prompt", content: $0)},
            self.responseFormat.flatMap { .textField(name: "response_format", content: $0)},
            self.temperature.flatMap { .textField(name: "temperature", content: String($0))},
        ].compactMap { $0 }

        if let timestampGranularities = self.timestampGranularities {
            for timestampGranularity in timestampGranularities {
                fields.append(
                    .textField(
                        name: "timestamp_granularities[]",
                        content: timestampGranularity.rawValue
                    )
                )
            }
        }
        return fields
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        file: Data,
        model: String,
        language: String? = nil,
        prompt: String? = nil,
        responseFormat: String? = nil,
        temperature: Double? = nil,
        timestampGranularities: [TimestampGranularity]? = nil
    ) {
        self.file = file
        self.model = model
        self.language = language
        self.prompt = prompt
        self.responseFormat = responseFormat
        self.temperature = temperature
        self.timestampGranularities = timestampGranularities
    }
}

// MARK: -
/// https://platform.openai.com/docs/api-reference/audio/createTranscription#audio-createtranscription-timestamp_granularities
extension OpenAICreateTranscriptionRequestBody {
    public enum TimestampGranularity: String {
        case word
        case segment
    }
}
