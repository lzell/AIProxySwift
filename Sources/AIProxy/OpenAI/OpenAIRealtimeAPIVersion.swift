//
//  OpenAIRealtimeAPIVersion.swift
//

import Foundation

/// Realtime API wire version.
///
/// Field contract by interface:
/// - GA (`session.update.session`): `type`, `include`, `audio`, `instructions`, `model`,
///   `max_output_tokens`, `output_modalities`, `prompt`, `tracing`, `truncation`, `tools`,
///   `tool_choice`
/// - beta-v1 (`session.update.session`): `input_audio_format`, `input_audio_transcription`,
///   `instructions`, `max_response_output_tokens`, `modalities`, `output_audio_format`,
///   `speed`, `temperature`, `tools`, `tool_choice`, `turn_detection`, `voice`
///
/// Sources:
/// - https://developers.openai.com/api/reference/resources/realtime
/// - https://platform.openai.com/docs/guides/realtime#beta-to-ga-migration
public enum OpenAIRealtimeAPIVersion: Sendable {
    case ga
    case betaV1

    var requestHeaders: [String: String] {
        switch self {
        case .ga:
            return [:]
        case .betaV1:
            return ["openai-beta": "realtime=v1"]
        }
    }

    func makeSessionUpdate(
        from configuration: OpenAIRealtimeSessionConfiguration,
        eventID: String? = nil
    ) -> OpenAIRealtimeSessionUpdate {
        switch self {
        case .ga:
            return OpenAIRealtimeSessionUpdate(
                eventId: eventID,
                session: configuration,
                sessionBody: .ga(.init(configuration: configuration.asGAConfiguration))
            )
        case .betaV1:
            return OpenAIRealtimeSessionUpdate(
                eventId: eventID,
                session: configuration,
                sessionBody: .betaV1(.init(configuration: configuration))
            )
        }
    }

    func makeSessionUpdate(
        from configuration: OpenAIRealtimeSessionConfigurationGA,
        eventID: String? = nil
    ) -> OpenAIRealtimeSessionUpdate {
        OpenAIRealtimeSessionUpdate(
            eventId: eventID,
            session: configuration.asLegacyBetaConfiguration,
            sessionBody: .ga(.init(configuration: configuration))
        )
    }

    @available(*, deprecated, message: "beta-v1 is being sunset. Prefer OpenAIRealtimeSessionConfigurationGA.")
    func makeSessionUpdate(
        from configuration: OpenAIRealtimeSessionConfigurationBetaV1,
        eventID: String? = nil
    ) -> OpenAIRealtimeSessionUpdate {
        OpenAIRealtimeSessionUpdate(
            eventId: eventID,
            session: configuration.asLegacyBetaConfiguration,
            sessionBody: .betaV1(.init(configuration: configuration.asLegacyBetaConfiguration))
        )
    }
}

enum OpenAIRealtimeSessionUpdateBody: Encodable, Sendable {
    case ga(OpenAIRealtimeSessionConfigurationGAWire)
    case betaV1(OpenAIRealtimeSessionConfigurationBetaV1Wire)

    func encode(to encoder: Encoder) throws {
        switch self {
        case .ga(let payload):
            try payload.encode(to: encoder)
        case .betaV1(let payload):
            try payload.encode(to: encoder)
        }
    }
}

// MARK: - GA Session Configuration
struct OpenAIRealtimeSessionConfigurationGAWire: Encodable, Sendable {
    let include: [OpenAIRealtimeSessionConfigurationGA.IncludeField]?
    let type: OpenAIRealtimeSessionConfiguration.SessionType
    let inputAudioFormat: OpenAIRealtimeSessionConfiguration.AudioFormat?
    let inputAudioNoiseReduction: OpenAIRealtimeSessionConfigurationGA.InputAudioNoiseReduction?
    let inputAudioTranscription: OpenAIRealtimeSessionConfigurationGA.InputAudioTranscription?
    let instructions: String?
    let maxOutputTokens: OpenAIRealtimeSessionConfiguration.MaxOutputTokens?
    let model: String?
    let outputModalities: [OpenAIRealtimeSessionConfiguration.Modality]?
    let outputAudioFormat: OpenAIRealtimeSessionConfiguration.AudioFormat?
    let speed: Float?
    let tools: [OpenAIRealtimeSessionConfigurationGA.Tool]?
    let toolChoice: OpenAIRealtimeSessionConfigurationGA.ToolChoice?
    let turnDetection: OpenAIRealtimeSessionConfigurationGA.TurnDetection?
    let voice: OpenAIRealtimeSessionConfigurationGA.Voice?
    let prompt: OpenAIRealtimeSessionConfigurationGA.Prompt?
    let tracing: OpenAIRealtimeSessionConfigurationGA.Tracing?
    let truncation: OpenAIRealtimeSessionConfigurationGA.Truncation?

    init(configuration: OpenAIRealtimeSessionConfigurationGA) {
        self.include = configuration.include
        self.type = configuration.type
        self.inputAudioFormat = configuration.inputAudioFormat
        self.inputAudioNoiseReduction = configuration.inputAudioNoiseReduction
        self.inputAudioTranscription = configuration.inputAudioTranscription
        self.instructions = configuration.instructions
        self.maxOutputTokens = configuration.maxOutputTokens
        self.model = configuration.model
        self.outputModalities = configuration.outputModalities
        self.outputAudioFormat = configuration.outputAudioFormat
        self.speed = configuration.speed
        self.tools = configuration.tools
        self.toolChoice = configuration.toolChoice
        self.turnDetection = configuration.turnDetection
        self.voice = configuration.voice
        self.prompt = configuration.prompt
        self.tracing = configuration.tracing
        self.truncation = configuration.truncation
    }

    private enum CodingKeys: String, CodingKey {
        case include
        case type
        case audio
        case instructions
        case maxOutputTokens = "max_output_tokens"
        case model
        case outputModalities = "output_modalities"
        case prompt
        case tracing
        case truncation
        case tools
        case toolChoice = "tool_choice"
    }

    private enum AudioCodingKeys: String, CodingKey {
        case input
        case output
    }

    private enum InputAudioCodingKeys: String, CodingKey {
        case format
        case noiseReduction = "noise_reduction"
        case transcription
        case turnDetection = "turn_detection"
    }

    private enum OutputAudioCodingKeys: String, CodingKey {
        case format
        case speed
        case voice
    }

    /// GA `audio.*.format` is an object union (`audio/pcm`, `audio/pcmu`, `audio/pcma`),
    /// while legacy/beta shapes used string enums (`pcm16`, `g711_*`).
    private struct RealtimeAudioFormatWire: Encodable, Sendable {
        let type: String
        let rate: Int?

        init(_ format: OpenAIRealtimeSessionConfiguration.AudioFormat) {
            switch format {
            case .pcm16:
                self.type = "audio/pcm"
                self.rate = 24000
            case .g711Ulaw:
                self.type = "audio/pcmu"
                self.rate = nil
            case .g711Alaw:
                self.type = "audio/pcma"
                self.rate = nil
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(include, forKey: .include)
        try container.encodeIfPresent(instructions, forKey: .instructions)
        try container.encodeIfPresent(maxOutputTokens, forKey: .maxOutputTokens)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(outputModalities, forKey: .outputModalities)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(tracing, forKey: .tracing)
        try container.encodeIfPresent(truncation, forKey: .truncation)
        try container.encodeIfPresent(tools, forKey: .tools)
        try container.encodeIfPresent(toolChoice, forKey: .toolChoice)

        let hasInputAudioConfig =
            inputAudioFormat != nil || inputAudioNoiseReduction != nil || inputAudioTranscription != nil || turnDetection != nil
        let hasOutputAudioConfig =
            outputAudioFormat != nil || speed != nil || voice != nil

        if hasInputAudioConfig || hasOutputAudioConfig {
            var audioContainer = container.nestedContainer(
                keyedBy: AudioCodingKeys.self,
                forKey: .audio
            )
            if hasInputAudioConfig {
                var inputContainer = audioContainer.nestedContainer(
                    keyedBy: InputAudioCodingKeys.self,
                    forKey: .input
                )
                if let inputAudioFormat {
                    try inputContainer.encode(
                        RealtimeAudioFormatWire(inputAudioFormat),
                        forKey: .format
                    )
                }
                try inputContainer.encodeIfPresent(inputAudioNoiseReduction, forKey: .noiseReduction)
                try inputContainer.encodeIfPresent(inputAudioTranscription, forKey: .transcription)
                try inputContainer.encodeIfPresent(turnDetection, forKey: .turnDetection)
            }
            if hasOutputAudioConfig {
                var outputContainer = audioContainer.nestedContainer(
                    keyedBy: OutputAudioCodingKeys.self,
                    forKey: .output
                )
                if let outputAudioFormat {
                    try outputContainer.encode(
                        RealtimeAudioFormatWire(outputAudioFormat),
                        forKey: .format
                    )
                }
                try outputContainer.encodeIfPresent(speed, forKey: .speed)
                try outputContainer.encodeIfPresent(voice, forKey: .voice)
            }
        }
    }
}

// MARK: - beta-v1 Session Configuration
struct OpenAIRealtimeSessionConfigurationBetaV1Wire: Encodable, Sendable {
    let inputAudioFormat: OpenAIRealtimeSessionConfiguration.AudioFormat?
    let inputAudioTranscription: OpenAIRealtimeSessionConfiguration.InputAudioTranscription?
    let instructions: String?
    let maxResponseOutputTokens: OpenAIRealtimeSessionConfiguration.MaxOutputTokens?
    let modalities: [OpenAIRealtimeSessionConfiguration.Modality]?
    let outputAudioFormat: OpenAIRealtimeSessionConfiguration.AudioFormat?
    let speed: Float?
    let temperature: Double?
    let tools: [OpenAIRealtimeSessionConfiguration.Tool]?
    let toolChoice: OpenAIRealtimeSessionConfiguration.ToolChoice?
    let turnDetection: OpenAIRealtimeSessionConfiguration.TurnDetection?
    let voice: String?

    init(configuration: OpenAIRealtimeSessionConfiguration) {
        self.inputAudioFormat = configuration.inputAudioFormat
        self.inputAudioTranscription = configuration.inputAudioTranscription
        self.instructions = configuration.instructions
        self.maxResponseOutputTokens = configuration.maxOutputTokens
        self.modalities = configuration.outputModalities
        self.outputAudioFormat = configuration.outputAudioFormat
        self.speed = configuration.speed
        self.temperature = configuration.temperature
        self.tools = configuration.tools
        self.toolChoice = configuration.toolChoice
        self.turnDetection = configuration.turnDetection
        self.voice = configuration.voice
    }

    private enum CodingKeys: String, CodingKey {
        case inputAudioFormat = "input_audio_format"
        case inputAudioTranscription = "input_audio_transcription"
        case instructions
        case maxResponseOutputTokens = "max_response_output_tokens"
        case modalities
        case outputAudioFormat = "output_audio_format"
        case speed
        case temperature
        case tools
        case toolChoice = "tool_choice"
        case turnDetection = "turn_detection"
        case voice
    }
}
