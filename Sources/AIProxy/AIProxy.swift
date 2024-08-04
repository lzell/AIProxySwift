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
    /// - Returns: An instance of OpenAIService configured and ready to make requests
    public static func openAIService(
        partialKey: String,
        serviceURL: String? = nil,
        clientID: String? = nil
    ) -> OpenAIService {
        return OpenAIService(
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

#if canImport(AppKit)
    public static func encodeImageAsJpeg(
        image: NSImage,
        compressionQuality: CGFloat = 1.0
    ) -> Data? {
        return AIProxyUtils.encodeImageAsJpeg(image, compressionQuality)
    }

    public static func openAIEncodedImage(
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

    public static func openAIEncodedImage(
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
