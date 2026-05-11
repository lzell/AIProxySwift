//
//  OpenAICreateTranscriptionRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/11/25.
//

import Foundation

/// Request body for the 'Create transcription' endpoint:
/// https://platform.openai.com/docs/api-reference/audio/createTranscription
///
/// This type models the core request fields exposed by AIProxySwift for the transcription API.
nonisolated public struct OpenAICreateTranscriptionRequestBody: MultipartFormEncodable {
    /// The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    public let file: Data

    /// ID of the model to use, for example `gpt-4o-transcribe`, `gpt-4o-mini-transcribe`, `gpt-4o-transcribe-diarize`, or `whisper-1`.
    public let model: String

    // MARK: Optional properties

    /// The language of the input audio. Supplying the input language in ISO-639-1 format will improve accuracy and latency.
    public let language: String?

    /// An optional text to guide the model's style or continue a previous audio segment. The prompt should match the audio language.
    public let prompt: String?

    /// The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, `vtt`, or `diarized_json`.
    /// Some models restrict which response formats are accepted.
    public let responseFormat: String?

    /// If set to true, OpenAI streams transcription events using server-sent events.
    /// Prefer `OpenAIService.streamingTranscriptionRequest` when consuming streamed transcriptions.
    public var stream: Bool?

    /// Controls how the audio is split into chunks before transcription.
    /// Required by `gpt-4o-transcribe-diarize` for inputs longer than 30 seconds.
    public let chunkingStrategy: ChunkingStrategy?

    /// Additional information to include in the transcription response.
    /// `logprobs` is currently returned on `json` responses for supported `gpt-4o-transcribe` models.
    public let include: [IncludeField]?

    /// Optional speaker labels that correspond to `knownSpeakerReferences`.
    /// Up to four speakers are supported by OpenAI.
    public let knownSpeakerNames: [String]?

    /// Optional data URLs containing 2-10 second speaker audio samples matching `knownSpeakerNames`.
    public let knownSpeakerReferences: [String]?

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
            self.stream.flatMap { .textField(name: "stream", content: $0 ? "true" : "false")},
            self.chunkingStrategy.flatMap { .textField(name: "chunking_strategy", content: $0.formValue)},
            self.temperature.flatMap { .textField(name: "temperature", content: String($0))}
        ].compactMap { $0 }

        if let include {
            for includeField in include {
                fields.append(
                    .textField(
                        name: "include[]",
                        content: includeField.rawValue
                    )
                )
            }
        }

        if let knownSpeakerNames {
            for knownSpeakerName in knownSpeakerNames {
                fields.append(
                    .textField(
                        name: "known_speaker_names[]",
                        content: knownSpeakerName
                    )
                )
            }
        }

        if let knownSpeakerReferences {
            for knownSpeakerReference in knownSpeakerReferences {
                fields.append(
                    .textField(
                        name: "known_speaker_references[]",
                        content: knownSpeakerReference
                    )
                )
            }
        }

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
        stream: Bool? = nil,
        chunkingStrategy: ChunkingStrategy? = nil,
        include: [IncludeField]? = nil,
        knownSpeakerNames: [String]? = nil,
        knownSpeakerReferences: [String]? = nil,
        temperature: Double? = nil,
        timestampGranularities: [TimestampGranularity]? = nil
    ) {
        self.file = file
        self.model = model
        self.language = language
        self.prompt = prompt
        self.responseFormat = responseFormat
        self.stream = stream
        self.chunkingStrategy = chunkingStrategy
        self.include = include
        self.knownSpeakerNames = knownSpeakerNames
        self.knownSpeakerReferences = knownSpeakerReferences
        self.temperature = temperature
        self.timestampGranularities = timestampGranularities
    }
}

// MARK: -
extension OpenAICreateTranscriptionRequestBody {
    nonisolated public enum ChunkingStrategy: Sendable {
        case auto
        case serverVAD(ServerVADConfiguration)

        fileprivate var formValue: String {
            switch self {
            case .auto:
                return "auto"
            case .serverVAD(let configuration):
                return configuration.formValue
            }
        }
    }

    nonisolated public struct ServerVADConfiguration: Sendable {
        public let prefixPaddingMs: Int?
        public let silenceDurationMs: Int?
        public let threshold: Double?

        public init(
            prefixPaddingMs: Int? = nil,
            silenceDurationMs: Int? = nil,
            threshold: Double? = nil
        ) {
            self.prefixPaddingMs = prefixPaddingMs
            self.silenceDurationMs = silenceDurationMs
            self.threshold = threshold
        }

        fileprivate var formValue: String {
            var fields = [#""type":"server_vad""#]
            if let prefixPaddingMs {
                fields.append(#""prefix_padding_ms":\#(prefixPaddingMs)"#)
            }
            if let silenceDurationMs {
                fields.append(#""silence_duration_ms":\#(silenceDurationMs)"#)
            }
            if let threshold {
                fields.append(#""threshold":\#(threshold)"#)
            }
            return "{\(fields.joined(separator: ","))}"
        }
    }

    nonisolated public enum IncludeField: String, Sendable {
        case logprobs
    }
}

// MARK: -
/// https://platform.openai.com/docs/api-reference/audio/createTranscription#audio-createtranscription-timestamp_granularities
extension OpenAICreateTranscriptionRequestBody {
    nonisolated public enum TimestampGranularity: String, Sendable {
        case word
        case segment
    }
}
