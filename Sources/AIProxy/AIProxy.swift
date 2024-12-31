import OSLog
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

let aiproxyLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "UnknownApp",
    category: "AIProxy"
)

public struct AIProxy {
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your provider's key.
    ///     AIProxy takes your key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to your provider.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your provider's key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    ///   - proxyPath: The path that you want to forward the request onto. For example, if you are trying to reach
    ///     api.example.com/v1/chat/completions, then you would set the proxyPath to `/v1/chat/completions`
    ///
    ///   - body: An optional request body
    ///
    ///   - verb: The HTTP verb to use for this request. If you leave the default selection of 'automatic', then requests that
    ///     contain a body will default to `POST` while requests with no body will default to `GET`
    ///
    ///   - contentType: The optional content type of the request body.
    ///
    ///   - headers: An optional set of additional headers to include in the request.
    ///
    /// - Returns: A request containing all headers that AIProxy expects. The request is ready to be used with a url session
    ///            that you create with `AIProxy.session()`
    public static func request(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil,
        proxyPath: String,
        body: Data? = nil,
        verb: AIProxyHTTPVerb = .automatic,
        headers: [String: String] = [:]
    ) async throws -> URLRequest {
        return try await AIProxyURLRequest.create(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            proxyPath: proxyPath,
            body: body,
            verb: verb,
            additionalHeaders: headers
        )
    }

    /// Returns a URLSession for communication with AIProxy.
    public static func session() -> URLSession {
        return AIProxyURLSession.create()
    }

    /// AIProxy's OpenAI service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your OpenAI key.
    ///     AIProxy takes your OpenAI key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to OpenAI.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your OpenAI key.
    ///     This argument is required for keys that you submitted after July 22nd, 2024. If you are an existing customer that
    ///     configured your AIProxy project before July 22nd, you may continue to leave this blank.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    ///   - requestFormat: If you are sending requests to your own Azure deployment, set this to `.azureDeployment`.
    ///                    Otherwise, you may leave this set to its default value of `.standard`.
    ///
    /// - Returns: An instance of OpenAIService configured and ready to make requests
    public static func openAIService(
        partialKey: String,
        serviceURL: String? = nil,
        clientID: String? = nil,
        requestFormat: OpenAIRequestFormat = .standard
    ) -> OpenAIService {
        return OpenAIProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            requestFormat: requestFormat
        )
    }

    /// Service that makes request directly to OpenAI. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your OpenAI API key
    /// - Returns: An instance of OpenAIService configured and ready to make requests
    public static func openAIDirectService(
        unprotectedAPIKey: String
    ) -> OpenAIService {
        return OpenAIDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Gemini service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Gemini key.
    ///     AIProxy takes your Gemini key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Gemini.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Gemini key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of GeminiService configured and ready to make requests
    public static func geminiService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> GeminiService {
        return GeminiProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to Gemini. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your Gemini API key
    /// - Returns: An instance of  GeminiService configured and ready to make requests
    public static func geminiDirectService(
        unprotectedAPIKey: String
    ) -> GeminiService {
        return GeminiDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Anthropic service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Anthropic key.
    ///     AIProxy takes your Anthropic key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Anthropic.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Anthropic key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of AnthropicService configured and ready to make requests
    public static func anthropicService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> AnthropicService {
        return AnthropicProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to Anthropic. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your Anthropic API key
    /// - Returns: An instance of AnthropicService configured and ready to make requests
    public static func anthropicDirectService(
        unprotectedAPIKey: String
    ) -> AnthropicService {
        return AnthropicDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Stability.ai service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Stability.ai key.
    ///     AIProxy takes your Stability.ai key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Stability.ai.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Stability.ai key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of StabilityAIService configured and ready to make requests
    public static func stabilityAIService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> StabilityAIService {
        return StabilityAIProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to StabilityAI. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your StabilityAI API key
    /// - Returns: An instance of StabilityAIService configured and ready to make requests
    public static func stabilityAIDirectService(
        unprotectedAPIKey: String
    ) -> StabilityAIService {
        return StabilityAIDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's DeepL service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your DeepL key.
    ///     AIProxy takes your DeepL key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to DeepL.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your DeepL key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of DeepLService configured and ready to make requests
    public static func deepLService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> DeepLService {
        return DeepLProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to DeepL. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your DeepL API key
    ///   - accountType: Free or paid
    /// - Returns: An instance of DeepLService configured and ready to make requests
    public static func deepLDirectService(
        unprotectedAPIKey: String,
        accountType: DeepLAccountType
    ) -> DeepLService {
        return DeepLDirectService(
            unprotectedAPIKey: unprotectedAPIKey,
            accountType: accountType
        )
    }

    /// AIProxy's TogetherAI service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your TogetherAI key.
    ///     AIProxy takes your TogetherAI key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to TogetherAI.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your TogetherAI key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of TogetherAIService configured and ready to make requests
    public static func togetherAIService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> TogetherAIService {
        return TogetherAIProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to TogetherAI. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your TogetherAI API key
    /// - Returns: An instance of TogetherAIService configured and ready to make requests
    public static func togetherAIDirectService(
        unprotectedAPIKey: String
    ) -> TogetherAIService {
        return TogetherAIDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Replicate service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Replicate key.
    ///     AIProxy takes your Replicate key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Replicate.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Replicate key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of ReplicateService configured and ready to make requests
    public static func replicateService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> ReplicateService {
        return ReplicateProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to Replicate. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your Replicate API key
    /// - Returns: An instance of ReplicateService configured and ready to make requests
    public static func replicateDirectService(
        unprotectedAPIKey: String
    ) -> ReplicateService {
        return ReplicateDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's ElevenLabs service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your ElevenLabs key.
    ///     AIProxy takes your ElevenLabs key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to ElevenLabs.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your ElevenLabs key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of ElevenLabsService configured and ready to make requests
    public static func elevenLabsService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> ElevenLabsService {
        return ElevenLabsProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to ElevenLabs. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your ElevenLabs API key
    /// - Returns: An instance of  ElevenLabsService configured and ready to make requests
    public static func elevenLabsDirectService(
        unprotectedAPIKey: String
    ) -> ElevenLabsService {
        return ElevenLabsDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Fal service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Fal key.
    ///     AIProxy takes your Fal key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Fal.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Fal key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of FalService configured and ready to make requests
    public static func falService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> FalService {
        return FalProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to ElevenLabs. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your ElevenLabs API key
    /// - Returns: An instance of  ElevenLabsService configured and ready to make requests
    public static func falDirectService(
        unprotectedAPIKey: String
    ) -> FalService {
        return FalDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Groq service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Groq key.
    ///     AIProxy takes your Groq key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Groq.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Groq key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of GroqService configured and ready to make requests
    public static func groqService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> GroqService {
        return GroqProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to Groq. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your Groq API key
    /// - Returns: An instance of  GroqService configured and ready to make requests
    public static func groqDirectService(
        unprotectedAPIKey: String
    ) -> GroqService {
        return GroqDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Perplexity service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Perplexity key.
    ///     AIProxy takes your Perplexity key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Perplexity.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Perplexity key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of PerplexityService configured and ready to make requests
    public static func perplexityService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> PerplexityService {
        return PerplexityProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to Perplexity. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your Perplexity API key
    /// - Returns: An instance of  PerplexityService configured and ready to make requests
    public static func perplexityDirectService(
        unprotectedAPIKey: String
    ) -> PerplexityService {
        return PerplexityDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's Mistral service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your Mistral key.
    ///     AIProxy takes your Mistral key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to Mistral.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your Mistral key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of MistralService configured and ready to make requests
    public static func mistralService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> MistralService {
        return MistralProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to Mistral. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your Mistral API key
    /// - Returns: An instance of  MistralService configured and ready to make requests
    public static func mistralDirectService(
        unprotectedAPIKey: String
    ) -> MistralService {
        return MistralDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's EachAI service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your EachAI key.
    ///     AIProxy takes your EachAI key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to EachAI.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your EachAI key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of EachAIService configured and ready to make requests
    public static func eachAIService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> EachAIService {
        return EachAIProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to EachAI. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your EachAI API key
    /// - Returns: An instance of  EachAI configured and ready to make requests
    public static func eachAIDirectService(
        unprotectedAPIKey: String
    ) -> EachAIService {
        return EachAIDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

    /// AIProxy's OpenRouter service
    ///
    /// - Parameters:
    ///   - partialKey: Your partial key is displayed in the AIProxy dashboard when you submit your OpenRouter key.
    ///     AIProxy takes your OpenRouter key, encrypts it, and stores part of the result on our servers. The part that you include
    ///     here is the other part. Both pieces are needed to decrypt your key and fulfill the request to OpenRouter.
    ///
    ///   - serviceURL: The service URL is displayed in the AIProxy dashboard when you submit your OpenRouter key.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to leave this blank for
    ///     most applications. You would set this if you already have an analytics system, and you'd like to annotate AIProxy
    ///     requests with IDs that are known to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs for you. The default UUIDs are
    ///     persistent on macOS and can be accurately used to attribute all requests to the same device. The default UUIDs
    ///     on iOS are pesistent until the end user chooses to rotate their vendor identification number.
    ///
    /// - Returns: An instance of OpenRouterService configured and ready to make requests
    public static func openRouterService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> OpenRouterService {
        return OpenRouterProxiedService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
        )
    }

    /// Service that makes request directly to OpenRouter. No protections are built-in for this service.
    /// Please only use this for BYOK use cases.
    ///
    /// - Parameters:
    ///   - unprotectedAPIKey: Your OpenRouter API key
    /// - Returns: An instance of  OpenRouter configured and ready to make requests
    public static func openRouterDirectService(
        unprotectedAPIKey: String
    ) -> OpenRouterService {
        return OpenRouterDirectService(
            unprotectedAPIKey: unprotectedAPIKey
        )
    }

#if canImport(AppKit)
    public static func encodeImageAsJpeg(
        image: NSImage,
        compressionQuality: CGFloat = 1.0
    ) -> Data? {
        return AIProxyUtils.encodeImageAsJpeg(image, compressionQuality)
    }

    @available(*, deprecated, message: "This function is deprecated. Use AIProxy.encodeImageAsURL instead.")
    public static func openAIEncodedImage(
        image: NSImage,
        compressionQuality: CGFloat = 1.0
    ) -> URL? {
        return AIProxyUtils.encodeImageAsURL(image, compressionQuality)
    }

    public static func encodeImageAsURL(
        image: NSImage,
        compressionQuality: CGFloat = 1.0
    ) -> URL? {
        return AIProxyUtils.encodeImageAsURL(image, compressionQuality)
    }

#elseif canImport(UIKit)
    public static func encodeImageAsJpeg(
        image: UIImage,
        compressionQuality: CGFloat = 1.0
    ) -> Data? {
        return AIProxyUtils.encodeImageAsJpeg(image, compressionQuality)
    }

    @available(*, deprecated, message: "This function is deprecated. Use AIProxy.encodeImageAsURL instead.")
    public static func openAIEncodedImage(
        image: UIImage,
        compressionQuality: CGFloat = 1.0
    ) -> URL? {
        return AIProxyUtils.encodeImageAsURL(image, compressionQuality)
    }

    public static func encodeImageAsURL(
        image: UIImage,
        compressionQuality: CGFloat = 1.0
    ) -> URL? {
        return AIProxyUtils.encodeImageAsURL(image, compressionQuality)
    }
#endif

    private init() {
        fatalError("This type is not designed to be instantiated")
    }
}
