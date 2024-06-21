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

    /// Entrypoint for AIProxy's OpenAI service
    ///
    /// - Parameters:
    ///   - partialKey: The partial key that was displayed in the AIProxy dashboard when you
    ///     submitted your OpenAI key
    ///
    ///   - serviceURL: The service URL that was displayed in the AIProxy dashboard when you
    ///     submitted your OpenAI key. This argument is required for keys that you submitted after
    ///     July 22nd, 2024. If you are an existing customer that configured your AIProxy project
    ///     before July 22nd, you may continue to leave this blank.
    ///
    ///   - clientID: An optional clientID to attribute requests to specific users or devices. It is OK to
    ///     leave this blank for most applications. You would set this if you already have an
    ///     analytics system, and you'd like to annotate AIProxy requests with IDs that are known
    ///     to other parts of your system.
    ///
    ///     If you do not supply your own clientID, the internals of this lib will generate UUIDs
    ///     for you. The default UUIDs are persistent on macOS and can be accurately used to
    ///     attribute all requests to the same device. The default UUIDs on iOS are pesistent until
    ///     the end user chooses to rotate their vendor identification number.
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


#if canImport(AppKit)
    public static func openAIEncodedImage(
        image: NSImage,
        compressionQuality: CGFloat = 1.0
    ) -> URL? {
        return OpenAIUtils.encodeImageAsURL(image, compressionQuality)
    }
#elseif canImport(UIKit)
    public static func openAIEncodedImage(
        image: UIImage,
        compressionQuality: CGFloat = 1.0
    ) -> URL? {
        return OpenAIUtils.encodeImageAsURL(image, compressionQuality)
    }
#endif

    private init() {
        fatalError("This type is not designed to be instantiated")
    }
}
