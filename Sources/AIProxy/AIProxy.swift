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
    /// - Returns: A request containing all headers that AIProxy expects. The request is ready to be used with a url session
    ///            that you create with `AIProxy.session()`
    public static func request(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil,
        proxyPath: String,
        body: Data? = nil,
        verb: AIProxyHTTPVerb = .automatic
    ) async throws -> URLRequest {
        return try await AIProxyURLRequest.create(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            proxyPath: proxyPath,
            body: body,
            verb: verb
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
        return OpenAIService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            requestFormat: requestFormat
        )
    }

    public static func geminiService(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) -> GeminiService {
        return GeminiService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return AnthropicService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return StabilityAIService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return DeepLService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return TogetherAIService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return ReplicateService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return ElevenLabsService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return FalService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
        return GroqService(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID
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
