import OSLog

let aiproxyLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "UnknownApp",
    category: "AIProxy"
)

public struct AIProxy {
    /// Entrypoint for AIProxy's OpenAI service
    public static func openAIService(partialKey: String) -> OpenAIService {
        return OpenAIService(partialKey: partialKey)
    }
}
