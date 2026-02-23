import XCTest
import Foundation
@testable import AIProxy

#if false // Flip to true and enter your OpenAI API key to test this

final class URLSessionTests: XCTestCase {
    /// This reproduces a URLSession memory leak and exception, unless the issue has been fixed:
    /// https://github.com/lzell/AIProxySwift/issues/262
    func testURLSessionMemoryLeak() async throws {
        let openAIKey = "" // Enter your OpenAI API key here
        let openAIService = AIProxy.openAIDirectService(unprotectedAPIKey: openAIKey)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for i in 1...1000 {
                if i >= 12 { try await group.next() } // Limit number of parallel requests
                
                group.addTask {
                    let requestBody = OpenAIModerationRequestBody(
                        input: [.text("is this bad \(i)")],
                        model: "omni-moderation-latest"
                    )
                    _ = try await openAIService.moderationRequest(body: requestBody, secondsToWait: 60)
                    print("Received response for #\(i)")
                }
            }
            
            try await group.waitForAll()
        }
    }
}

#endif
