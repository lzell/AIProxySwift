import Testing
@testable import AIProxy

@Suite("AIProxy gRPC metadata")
struct AIProxyGRPCMetadataTests {

    @Test("Service URL identifiers become gRPC routing metadata")
    func serviceURLIdentifiers() throws {
        let identifiers = try AIProxy.grpcServiceIdentifiers(
            from: "https://api.aiproxy.com/eb34427b/f62cb466"
        )

        #expect(identifiers.project == "eb34427b")
        #expect(identifiers.service == "f62cb466")
    }

    @Test("Malformed service URL paths are rejected")
    func malformedServiceURL() {
        #expect(throws: AIProxyError.self) {
            _ = try AIProxy.grpcServiceIdentifiers(from: "https://api.aiproxy.com/eb34427b")
        }
    }
}
