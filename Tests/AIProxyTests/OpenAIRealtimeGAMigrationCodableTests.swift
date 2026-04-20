//
//  OpenAIRealtimeGAMigrationCodableTests.swift
//  AIProxyTests
//

import Foundation
import Testing
@testable import AIProxy

struct OpenAIRealtimeGAMigrationCodableTests {

    @Test
    func testLegacySessionConfigurationEncodesBetaShapeByDefault() throws {
        let config = OpenAIRealtimeSessionConfiguration(instructions: "Hi")
        let encoded: Data = try config.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionConfigurationMirror.self, from: encoded)
        #expect(decoded.type == nil)
        #expect(decoded.instructions == "Hi")
        #expect(decoded.audio == nil)
    }

    @Test
    func testLegacySessionConfigurationUsesTopLevelBetaAudioKeys() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            type: .transcription,
            inputAudioTranscription: .init(model: "gpt-4o-mini-transcribe")
        )
        let encoded: Data = try config.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionConfigurationMirror.self, from: encoded)

        #expect(decoded.type == nil)
        #expect(decoded.legacyInputAudioTranscription?.model == "gpt-4o-mini-transcribe")
        #expect(decoded.audio == nil)
    }

    @Test
    func testRealtimeAPIInterfaceAppliesBetaHeaderOnlyForBetaV1() {
        let gaHeaders = OpenAIRealtimeAPIVersion.ga.requestHeaders
        #expect(gaHeaders["openai-beta"] == nil)

        let betaHeaders = OpenAIRealtimeAPIVersion.betaV1.requestHeaders
        #expect(betaHeaders["openai-beta"] == "realtime=v1")
    }

    @Test
    func testLegacySessionConfigurationEncodesBetaMaxResponseOutputTokensKey() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            maxOutputTokens: .int(321)
        )
        let encoded: Data = try config.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionConfigurationMirror.self, from: encoded)

        #expect(decoded.maxOutputTokens == nil)
        #expect(decoded.legacyMaxResponseOutputTokens == 321)
    }

    @Test
    func testLegacySessionConfigurationInitializerLabelsRemainSupported() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            maxResponseOutputTokens: .int(654),
            modalities: [.text]
        )
        let encoded: Data = try config.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionConfigurationMirror.self, from: encoded)
        #expect(decoded.maxOutputTokens == nil)
        #expect(decoded.outputModalities == nil)
        #expect(decoded.legacyMaxResponseOutputTokens == 654)
        #expect(decoded.modalities == ["text"])
    }

    @Test
    func testGAOptInSessionUpdateUsesNestedAudioAndNoLegacyKeys() throws {
        let update = OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(
            from: OpenAIRealtimeSessionConfigurationGA(
                type: .realtime,
                inputAudioFormat: .pcm16,
                inputAudioTranscription: .init(model: "gpt-4o-mini-transcribe"),
                outputAudioFormat: .pcm16,
                speed: 1.0,
                voice: .builtin("alloy")
            )
        )

        let encoded: Data = try update.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.type == "session.update")
        #expect(decoded.session.type == "realtime")
        #expect(decoded.session.audio?.input?.format?.type == "audio/pcm")
        #expect(decoded.session.audio?.input?.format?.rate == 24000)
        #expect(decoded.session.audio?.input?.transcription?.model == "gpt-4o-mini-transcribe")
        #expect(decoded.session.audio?.output?.format?.type == "audio/pcm")
        #expect(decoded.session.audio?.output?.format?.rate == 24000)
        #expect(decoded.session.audio?.output?.voice == "alloy")
        #expect(decoded.session.legacyInputAudioFormat == nil)
        #expect(decoded.session.legacyInputAudioTranscription == nil)
        #expect(decoded.session.legacyOutputAudioFormat == nil)
        #expect(decoded.session.temperature == nil)
    }

    @Test
    func testLegacySessionUpdateInitializerRemainsBetaCompatible() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            maxResponseOutputTokens: .int(42),
            modalities: [.text]
        )
        let update = OpenAIRealtimeSessionUpdate(session: config)
        let encoded: Data = try update.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)
        #expect(decoded.type == "session.update")
        #expect(decoded.session.maxOutputTokens == nil)
        #expect(decoded.session.outputModalities == nil)
        #expect(decoded.session.legacyMaxResponseOutputTokens == 42)
        #expect(decoded.session.modalities == ["text"])
    }

    @Test
    func testSessionUpdateModalitiesMapToOutputModalitiesForGAAndStayModalitiesForBeta() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            type: .realtime,
            outputModalities: [.text]
        )

        let gaUpdate = OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(from: config)
        let gaEncoded: Data = try gaUpdate.serialize(pretty: false)
        let gaDecoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: gaEncoded)
        #expect(gaDecoded.session.outputModalities == ["text"])
        #expect(gaDecoded.session.modalities == nil)

        let betaUpdate = OpenAIRealtimeAPIVersion.betaV1.makeSessionUpdate(from: config)
        let betaEncoded: Data = try betaUpdate.serialize(pretty: false)
        let betaDecoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: betaEncoded)
        #expect(betaDecoded.session.outputModalities == nil)
        #expect(betaDecoded.session.modalities == ["text"])
    }

    @Test
    func testBetaSessionUpdateUsesLegacyKeysAndOmitsGAOnlyShape() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            type: .realtime,
            inputAudioFormat: .pcm16,
            inputAudioTranscription: .init(model: "gpt-4o-mini-transcribe"),
            maxOutputTokens: .int(456),
            outputModalities: [.audio, .text],
            outputAudioFormat: .pcm16,
            speed: 1.0,
            voice: "alloy"
        )
        let betaUpdate = OpenAIRealtimeAPIVersion.betaV1.makeSessionUpdate(from: config)
        let encoded: Data = try betaUpdate.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.session.type == nil)
        #expect(decoded.session.audio == nil)
        #expect(decoded.session.modalities == ["audio", "text"])
        #expect(decoded.session.outputModalities == nil)
        #expect(decoded.session.maxOutputTokens == nil)
        #expect(decoded.session.legacyMaxResponseOutputTokens == 456)
        #expect(decoded.session.legacyInputAudioFormat == "pcm16")
        #expect(decoded.session.legacyInputAudioTranscription?.model == "gpt-4o-mini-transcribe")
        #expect(decoded.session.legacyOutputAudioFormat == "pcm16")
    }

    @Test
    func testLegacyConfigurationEncodedAsGAOmitsTemperature() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            outputModalities: [.audio],
            temperature: 0.7
        )
        let update = OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(from: config)
        let encoded: Data = try update.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.session.outputModalities == ["audio"])
        #expect(decoded.session.temperature == nil)
    }

    @Test
    func testGAConfigurationUsesNestedAudioForGA() throws {
        let config = OpenAIRealtimeSessionConfiguration(
            inputAudioFormat: .pcm16,
            inputAudioTranscription: .init(model: "gpt-4o-mini-transcribe"),
            outputAudioFormat: .pcm16,
            speed: 1.0,
            voice: "alloy"
        )
        let encoded: Data = try OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(from: config.asGAConfiguration).serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.session.audio?.input?.format?.type == "audio/pcm")
        #expect(decoded.session.audio?.input?.format?.rate == 24000)
        #expect(decoded.session.audio?.input?.transcription?.model == "gpt-4o-mini-transcribe")
        #expect(decoded.session.audio?.output?.format?.type == "audio/pcm")
        #expect(decoded.session.audio?.output?.format?.rate == 24000)
        #expect(decoded.session.audio?.output?.speed == 1.0)
        #expect(decoded.session.audio?.output?.voice == "alloy")
        #expect(decoded.session.legacyInputAudioFormat == nil)
        #expect(decoded.session.legacyInputAudioTranscription == nil)
        #expect(decoded.session.legacyOutputAudioFormat == nil)
    }

    @Test
    func testGAExtendedSessionFieldsEncodeWithExpectedShapes() throws {
        let update = OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(
            from: OpenAIRealtimeSessionConfigurationGA(
                include: [.inputAudioTranscriptionLogprobs],
                type: .realtime,
                inputAudioFormat: .pcm16,
                inputAudioNoiseReduction: .init(type: .nearField),
                inputAudioTranscription: .init(
                    language: "en",
                    model: "gpt-4o-mini-transcribe",
                    prompt: "Expect medical terminology."
                ),
                instructions: "Answer briefly.",
                maxOutputTokens: .int(800),
                model: "gpt-realtime",
                outputModalities: [.audio],
                outputAudioFormat: .pcm16,
                speed: 1.5,
                tools: [
                    .webSearch(.init(searchContextSize: .high)),
                    .function(
                        .init(
                            name: "lookup_weather",
                            description: "Get weather by city",
                            parameters: [
                                "type": .string("object"),
                                "properties": .object([
                                    "city": .object(["type": .string("string")])
                                ])
                            ]
                        )
                    ),
                    .mcp(
                        .init(
                            serverLabel: "internal_mcp",
                            allowedTools: .names(["summarize_report"]),
                            requireApproval: .never
                        )
                    )
                ],
                toolChoice: .mcp(serverLabel: "internal_mcp", name: "summarize_report"),
                turnDetection: .semanticVAD(
                    .init(
                        createResponse: true,
                        eagerness: .auto,
                        interruptResponse: false
                    )
                ),
                voice: .custom(id: "voice_custom_123"),
                prompt: .init(
                    id: "pmpt_123",
                    variables: ["locale": .string("en-US")],
                    version: "5"
                ),
                tracing: .configuration(
                    .init(
                        groupID: "trace_group",
                        metadata: ["feature": .string("voice_mode")],
                        workflowName: "voice_assistant"
                    )
                ),
                truncation: .retentionRatio(
                    .init(
                        retentionRatio: 0.7,
                        tokenLimits: .init(postInstructions: 512)
                    )
                )
            )
        )

        let encoded: Data = try update.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.session.type == "realtime")
        #expect(decoded.session.model == "gpt-realtime")
        #expect(decoded.session.include == ["item.input_audio_transcription.logprobs"])
        #expect(decoded.session.maxOutputTokens == 800)
        #expect(decoded.session.outputModalities == ["audio"])
        #expect(decoded.session.audio?.input?.format?.type == "audio/pcm")
        #expect(decoded.session.audio?.input?.noiseReduction?.type == "near_field")
        #expect(decoded.session.audio?.input?.transcription?.language == "en")
        #expect(decoded.session.audio?.input?.transcription?.prompt == "Expect medical terminology.")
        #expect(decoded.session.audio?.input?.turnDetection?.type == "semantic_vad")
        #expect(decoded.session.audio?.input?.turnDetection?.eagerness == "auto")
        #expect(decoded.session.audio?.output?.speed == 1.5)
        #expect(decoded.session.audio?.output?.voice == nil)
        #expect(decoded.session.audio?.output?.voiceObject?.id == "voice_custom_123")
        #expect(decoded.session.tools?.count == 3)
        #expect(decoded.session.tools?.first?.type == "web_search")
        #expect(decoded.session.tools?[1].type == "function")
        #expect(decoded.session.tools?[2].type == "mcp")
        #expect(decoded.session.toolChoice?.type == "mcp")
        #expect(decoded.session.toolChoice?.serverLabel == "internal_mcp")
        #expect(decoded.session.prompt?.id == "pmpt_123")
        #expect(decoded.session.prompt?.version == "5")
        #expect(decoded.session.tracing?.groupID == "trace_group")
        #expect(decoded.session.tracing?.workflowName == "voice_assistant")
        #expect(decoded.session.truncation?.type == "retention_ratio")
        #expect(decoded.session.truncation?.retentionRatio == 0.7)
        #expect(decoded.session.truncation?.tokenLimits?.postInstructions == 512)
    }

    @Test
    func testGATurnDetectionServerVADIncludesGAOptions() throws {
        let update = OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(
            from: OpenAIRealtimeSessionConfigurationGA(
                turnDetection: .serverVAD(
                    .init(
                        createResponse: false,
                        idleTimeoutMs: 1500,
                        interruptResponse: true,
                        prefixPaddingMs: 250,
                        silenceDurationMs: 700,
                        threshold: 0.4
                    )
                )
            )
        )
        let encoded: Data = try update.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.session.audio?.input?.turnDetection?.type == "server_vad")
        #expect(decoded.session.audio?.input?.turnDetection?.createResponse == false)
        #expect(decoded.session.audio?.input?.turnDetection?.idleTimeoutMs == 1500)
        #expect(decoded.session.audio?.input?.turnDetection?.interruptResponse == true)
        #expect(decoded.session.audio?.input?.turnDetection?.prefixPaddingMs == 250)
        #expect(decoded.session.audio?.input?.turnDetection?.silenceDurationMs == 700)
        #expect(decoded.session.audio?.input?.turnDetection?.threshold == 0.4)
    }

    @Test
    func testVoiceWithWebSearchHelperConfiguresBuiltinTooling() {
        let config = OpenAIRealtimeSessionConfigurationGA.voiceWithWebSearch()
        #expect(config.voice?.asLegacyBetaVoice == "alloy")
        #expect(config.toolChoice != nil)
        #expect(config.tools?.count == 1)
    }

    @Test
    func testGAAudioFormatsEncodeAsTypedObjectsForG711() throws {
        let update = OpenAIRealtimeAPIVersion.ga.makeSessionUpdate(
            from: OpenAIRealtimeSessionConfigurationGA(
                type: .realtime,
                inputAudioFormat: .g711Ulaw,
                outputAudioFormat: .g711Alaw
            )
        )

        let encoded: Data = try update.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(SessionUpdateMirror.self, from: encoded)

        #expect(decoded.session.audio?.input?.format?.type == "audio/pcmu")
        #expect(decoded.session.audio?.input?.format?.rate == nil)
        #expect(decoded.session.audio?.output?.format?.type == "audio/pcma")
        #expect(decoded.session.audio?.output?.format?.rate == nil)
    }

    @Test
    func testRealtimeErrorWithObjectBodyDecodesMessage() throws {
        let payload = """
        {
          "type":"error",
          "event_id":"event_test",
          "error":{
            "type":"invalid_request_error",
            "code":"unknown_parameter",
            "message":"Unknown parameter: 'session.input_audio_format'.",
            "param":"session.input_audio_format",
            "event_id":null
          }
        }
        """
        let message = try JSONDecoder().decode(OpenAIRealtimeMessage.self, from: Data(payload.utf8))
        guard case .error(let event) = message else {
            Issue.record("Expected decoded realtime error message")
            return
        }
        #expect(event.errorBody == "Unknown parameter: 'session.input_audio_format'.")
    }

    @Test
    func testConversationItemCreateUsesOutputTextForAssistantRole() throws {
        let item = OpenAIRealtimeConversationItemCreate.Item(role: "assistant", text: "Hello")
        let encoded: String = try item.serialize(pretty: false)
        #expect(encoded.contains("\"type\":\"output_text\""))
        #expect(!encoded.contains("\"type\":\"text\""))
    }

    @Test
    func testConversationItemCreateUsesInputTextForUserRole() throws {
        let item = OpenAIRealtimeConversationItemCreate.Item(role: "user", text: "Hello")
        let encoded: String = try item.serialize(pretty: false)
        #expect(encoded.contains("\"type\":\"input_text\""))
    }

    @Test
    func testResponseCreateUsesGAOutputModalitiesKey() throws {
        let event = OpenAIRealtimeResponseCreate(
            eventID: "evt_123",
            response: .init(
                instructions: "Be concise.",
                outputModalities: [.audio],
                tools: [.webSearch(.init(searchContextSize: .medium))],
                toolChoice: .auto
            )
        )

        let encoded: Data = try event.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(ResponseCreateMirror.self, from: encoded)

        #expect(decoded.type == "response.create")
        #expect(decoded.eventID == "evt_123")
        #expect(decoded.response?.instructions == "Be concise.")
        #expect(decoded.response?.outputModalities == ["audio"])
        #expect(decoded.response?.modalities == nil)
        #expect(decoded.response?.tools?.first?.type == "web_search")
        #expect(decoded.response?.toolChoiceString == "auto")
    }

    @Test
    func testResponseCreateToolChoiceMCPEncodesObjectShape() throws {
        let event = OpenAIRealtimeResponseCreate(
            response: .init(
                outputModalities: [.text],
                toolChoice: .mcp(serverLabel: "acme_mcp", name: "lookup_ticket")
            )
        )
        let encoded: Data = try event.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(ResponseCreateMirror.self, from: encoded)

        #expect(decoded.response?.outputModalities == ["text"])
        #expect(decoded.response?.toolChoiceObject?.type == "mcp")
        #expect(decoded.response?.toolChoiceObject?.serverLabel == "acme_mcp")
        #expect(decoded.response?.toolChoiceObject?.name == "lookup_ticket")
    }

    @Test
    func testConversationItemCreateSupportsFunctionCallAndOutput() throws {
        let functionCall = OpenAIRealtimeConversationItemCreate(
            item: .functionCall(
                callID: "call_1",
                name: "lookup_weather",
                arguments: "{\"city\":\"Paris\"}"
            )
        )
        let functionOutput = OpenAIRealtimeConversationItemCreate(
            item: .functionCallOutput(
                callID: "call_1",
                output: "{\"temp_c\":18}"
            )
        )

        let callEncoded: Data = try functionCall.serialize(pretty: false)
        let outputEncoded: Data = try functionOutput.serialize(pretty: false)
        let callDecoded = try JSONDecoder().decode(ConversationItemCreateMirror.self, from: callEncoded)
        let outputDecoded = try JSONDecoder().decode(ConversationItemCreateMirror.self, from: outputEncoded)

        #expect(callDecoded.item.type == "function_call")
        #expect(callDecoded.item.callID == "call_1")
        #expect(callDecoded.item.name == "lookup_weather")
        #expect(callDecoded.item.arguments == "{\"city\":\"Paris\"}")
        #expect(outputDecoded.item.type == "function_call_output")
        #expect(outputDecoded.item.callID == "call_1")
        #expect(outputDecoded.item.output == "{\"temp_c\":18}")
    }

    @Test
    func testConversationItemCreateSupportsInputAudioContent() throws {
        let item = OpenAIRealtimeConversationItemCreate.Item(
            role: "user",
            content: [.inputAudio("BASE64_PCM16_AUDIO")]
        )
        let event = OpenAIRealtimeConversationItemCreate(item: item)

        let encoded: Data = try event.serialize(pretty: false)
        let decoded = try JSONDecoder().decode(ConversationItemCreateMirror.self, from: encoded)

        #expect(decoded.item.type == "message")
        #expect(decoded.item.role == "user")
        #expect(decoded.item.content?.first?.type == "input_audio")
        #expect(decoded.item.content?.first?.audio == "BASE64_PCM16_AUDIO")
    }

    private struct SessionUpdateMirror: Decodable {
        let type: String
        let session: SessionConfigurationMirror
    }

    private struct ResponseCreateMirror: Decodable {
        let eventID: String?
        let response: ResponseMirror?
        let type: String

        private enum CodingKeys: String, CodingKey {
            case eventID = "event_id"
            case response
            case type
        }
    }

    private struct ResponseMirror: Decodable {
        let instructions: String?
        let modalities: [String]?
        let outputModalities: [String]?
        let tools: [ToolMirror]?
        let toolChoiceObject: ResponseToolChoiceObject?
        let toolChoiceString: String?

        private enum CodingKeys: String, CodingKey {
            case instructions
            case modalities
            case outputModalities = "output_modalities"
            case toolChoice = "tool_choice"
            case tools
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
            self.modalities = try container.decodeIfPresent([String].self, forKey: .modalities)
            self.outputModalities = try container.decodeIfPresent([String].self, forKey: .outputModalities)
            self.tools = try container.decodeIfPresent([ToolMirror].self, forKey: .tools)
            if container.contains(.toolChoice) {
                let toolChoiceDecoder = try container.superDecoder(forKey: .toolChoice)
                if let stringChoice = try? String(from: toolChoiceDecoder) {
                    self.toolChoiceString = stringChoice
                    self.toolChoiceObject = nil
                } else {
                    self.toolChoiceString = nil
                    self.toolChoiceObject = try ResponseToolChoiceObject(from: toolChoiceDecoder)
                }
            } else {
                self.toolChoiceString = nil
                self.toolChoiceObject = nil
            }
        }
    }

    private struct ResponseToolChoiceObject: Decodable {
        let name: String?
        let serverLabel: String?
        let type: String?

        private enum CodingKeys: String, CodingKey {
            case name
            case serverLabel = "server_label"
            case type
        }
    }

    private struct ConversationItemCreateMirror: Decodable {
        let item: ConversationItemMirror
        let type: String
    }

    private struct ConversationItemMirror: Decodable {
        let arguments: String?
        let callID: String?
        let content: [ConversationContentMirror]?
        let name: String?
        let output: String?
        let role: String?
        let type: String

        private enum CodingKeys: String, CodingKey {
            case arguments
            case callID = "call_id"
            case content
            case name
            case output
            case role
            case type
        }
    }

    private struct ConversationContentMirror: Decodable {
        let audio: String?
        let itemID: String?
        let text: String?
        let type: String

        private enum CodingKeys: String, CodingKey {
            case audio
            case itemID = "item_id"
            case text
            case type
        }
    }

    private struct SessionConfigurationMirror: Decodable {
        let type: String?
        let instructions: String?
        let audio: Audio?
        let include: [String]?
        let model: String?
        let prompt: Prompt?
        let toolChoice: ToolChoice?
        let tools: [ToolMirror]?
        let tracing: TracingConfiguration?
        let truncation: TruncationMirror?
        // beta session.update shape
        let modalities: [String]?
        // GA session.update shape
        let outputModalities: [String]?
        let maxOutputTokens: Int?
        let legacyInputAudioFormat: String?
        let legacyInputAudioTranscription: InputAudioTranscription?
        let legacyOutputAudioFormat: String?
        let legacyMaxResponseOutputTokens: Int?
        let temperature: Double?

        private enum CodingKeys: String, CodingKey {
            case type
            case instructions
            case audio
            case include
            case model
            case prompt
            case toolChoice = "tool_choice"
            case tools
            case tracing
            case truncation
            case modalities
            case outputModalities = "output_modalities"
            case maxOutputTokens = "max_output_tokens"
            case legacyInputAudioFormat = "input_audio_format"
            case legacyInputAudioTranscription = "input_audio_transcription"
            case legacyOutputAudioFormat = "output_audio_format"
            case legacyMaxResponseOutputTokens = "max_response_output_tokens"
            case temperature
        }
    }

    private struct Audio: Decodable {
        let input: InputAudio?
        let output: OutputAudio?
    }

    private struct InputAudio: Decodable {
        let format: AudioFormatObject?
        let noiseReduction: NoiseReduction?
        let transcription: InputAudioTranscription?
        let turnDetection: TurnDetectionMirror?

        private enum CodingKeys: String, CodingKey {
            case format
            case noiseReduction = "noise_reduction"
            case transcription
            case turnDetection = "turn_detection"
        }
    }

    private struct InputAudioTranscription: Decodable {
        let language: String?
        let model: String?
        let prompt: String?
    }

    private struct OutputAudio: Decodable {
        let format: AudioFormatObject?
        let speed: Double?
        let voice: String?
        let voiceObject: VoiceObject?

        enum CodingKeys: String, CodingKey {
            case format
            case speed
            case voice
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.format = try container.decodeIfPresent(AudioFormatObject.self, forKey: .format)
            self.speed = try container.decodeIfPresent(Double.self, forKey: .speed)
            if container.contains(.voice) {
                let voiceDecoder = try container.superDecoder(forKey: .voice)
                if let stringValue = try? String(from: voiceDecoder) {
                    self.voice = stringValue
                    self.voiceObject = nil
                } else {
                    self.voice = nil
                    self.voiceObject = try VoiceObject(from: voiceDecoder)
                }
            } else {
                self.voice = nil
                self.voiceObject = nil
            }
        }
    }

    private struct AudioFormatObject: Decodable {
        let type: String?
        let rate: Int?
    }

    private struct VoiceObject: Decodable {
        let id: String?
    }

    private struct NoiseReduction: Decodable {
        let type: String?
    }

    private struct TurnDetectionMirror: Decodable {
        let createResponse: Bool?
        let eagerness: String?
        let idleTimeoutMs: Int?
        let interruptResponse: Bool?
        let prefixPaddingMs: Int?
        let silenceDurationMs: Int?
        let threshold: Double?
        let type: String?

        private enum CodingKeys: String, CodingKey {
            case createResponse = "create_response"
            case eagerness
            case idleTimeoutMs = "idle_timeout_ms"
            case interruptResponse = "interrupt_response"
            case prefixPaddingMs = "prefix_padding_ms"
            case silenceDurationMs = "silence_duration_ms"
            case threshold
            case type
        }
    }

    private struct Prompt: Decodable {
        let id: String?
        let version: String?
    }

    private struct ToolMirror: Decodable {
        let type: String?
    }

    private struct ToolChoice: Decodable {
        let type: String?
        let serverLabel: String?

        private enum CodingKeys: String, CodingKey {
            case type
            case serverLabel = "server_label"
        }
    }

    private struct TracingConfiguration: Decodable {
        let groupID: String?
        let workflowName: String?

        private enum CodingKeys: String, CodingKey {
            case groupID = "group_id"
            case workflowName = "workflow_name"
        }
    }

    private struct TruncationMirror: Decodable {
        let type: String?
        let retentionRatio: Double?
        let tokenLimits: TokenLimits?

        private enum CodingKeys: String, CodingKey {
            case type
            case retentionRatio = "retention_ratio"
            case tokenLimits = "token_limits"
        }
    }

    private struct TokenLimits: Decodable {
        let postInstructions: Int?

        private enum CodingKeys: String, CodingKey {
            case postInstructions = "post_instructions"
        }
    }
}
