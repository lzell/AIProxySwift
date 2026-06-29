import Foundation
import Testing
@testable import AIProxy

@Suite("AIProxy gRPC helpers")
struct AIProxyGRPCTests {

    @Test("Service URL identifiers become gRPC routing metadata")
    func serviceURLIdentifiers() throws {
        let identifiers = try AIProxyGRPC.serviceIdentifiers(
            from: "https://api.aiproxy.com/eb34427b/f62cb466"
        )

        #expect(identifiers.project == "eb34427b")
        #expect(identifiers.service == "f62cb466")
    }

    @Test("Malformed service URL paths are rejected")
    func malformedServiceURL() {
        #expect(throws: AIProxyError.self) {
            _ = try AIProxyGRPC.serviceIdentifiers(from: "https://api.aiproxy.com/eb34427b")
        }
    }

    @Test("Unary message framing round trips")
    func unaryMessageFramingRoundTrips() throws {
        let message = Data("hello world".utf8)

        let framed = AIProxyGRPC.encodeUnaryMessage(message)
        let decoded = try AIProxyGRPC.decodeUnaryMessage(framed)

        #expect(framed.prefix(5) == Data([0, 0, 0, 0, 11]))
        #expect(decoded == message)
    }

    @Test("Compressed responses are rejected")
    func compressedResponsesAreRejected() throws {
        let compressedFrame = Data([1, 0, 0, 0, 0])

        #expect(throws: AIProxyError.self) {
            _ = try AIProxyGRPC.decodeUnaryMessage(compressedFrame)
        }
    }
}
