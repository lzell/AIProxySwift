//
//  AIProxyGRPC.swift
//  AIProxy
//
//  Created by Codex on 6/19/26.
//

import Foundation

public struct AIProxyGRPCUnaryResponse: Sendable {
    public let message: Data
    public let headers: [String: String]

    public init(message: Data, headers: [String: String]) {
        self.message = message
        self.headers = headers
    }
}

public enum AIProxyGRPC {
    nonisolated public static func metadata(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil
    ) async throws -> [String: String] {
        let identifiers = try self.serviceIdentifiers(from: serviceURL)
        let request = try await AIProxy.request(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            proxyPath: "/"
        )

        var metadata = (request.allHTTPHeaderFields ?? [:]).reduce(into: [String: String]()) {
            $0[$1.key.lowercased()] = $1.value
        }
        metadata["aiproxy-project"] = identifiers.project
        metadata["aiproxy-service"] = identifiers.service
        return metadata.filter { $0.key.hasPrefix("aiproxy-") }
    }

    nonisolated static func serviceIdentifiers(
        from serviceURL: String
    ) throws -> (project: String, service: String) {
        guard let components = URLComponents(string: serviceURL) else {
            throw AIProxyError.assertion("Could not parse the AIProxy serviceURL")
        }

        let pathComponents = components.path.split(separator: "/", omittingEmptySubsequences: true)
        guard pathComponents.count == 2 else {
            throw AIProxyError.assertion(
                "Expected the AIProxy serviceURL path to contain a project and service identifier"
            )
        }

        return (String(pathComponents[0]), String(pathComponents[1]))
    }

    nonisolated public static func unaryRequest(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil,
        serviceName: String,
        methodName: String,
        message: Data,
        secondsToWait: UInt = 60,
        additionalHeaders: [String: String] = [:]
    ) async throws -> URLRequest {
        var headers = additionalHeaders
        headers["TE"] = "trailers"
        headers["grpc-accept-encoding"] = "identity"

        return try await AIProxyURLRequest.create(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            proxyPath: "/\(serviceName)/\(methodName)",
            body: self.encodeUnaryMessage(message),
            verb: .post,
            secondsToWait: secondsToWait,
            contentType: "application/grpc+proto",
            additionalHeaders: headers
        )
    }

    nonisolated public static func sendUnaryRequest(
        partialKey: String,
        serviceURL: String,
        clientID: String? = nil,
        serviceName: String,
        methodName: String,
        message: Data,
        session: URLSession = .shared,
        secondsToWait: UInt = 60,
        additionalHeaders: [String: String] = [:]
    ) async throws -> AIProxyGRPCUnaryResponse {
        var request = try await self.unaryRequest(
            partialKey: partialKey,
            serviceURL: serviceURL,
            clientID: clientID,
            serviceName: serviceName,
            methodName: methodName,
            message: message,
            secondsToWait: secondsToWait,
            additionalHeaders: additionalHeaders
        )
        request.timeoutInterval = TimeInterval(secondsToWait)

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIProxyError.assertion("gRPC request did not receive an HTTP response")
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw AIProxyError.unsuccessfulRequest(
                statusCode: httpResponse.statusCode,
                responseBody: String(decoding: data, as: UTF8.self)
            )
        }
        return AIProxyGRPCUnaryResponse(
            message: try self.decodeUnaryMessage(data),
            headers: self.stringHeaders(from: httpResponse)
        )
    }

    nonisolated public static func encodeUnaryMessage(_ message: Data) -> Data {
        var framed = Data(capacity: message.count + 5)
        framed.append(0)

        let length = UInt32(message.count).bigEndian
        withUnsafeBytes(of: length) { bytes in
            framed.append(contentsOf: bytes)
        }

        framed.append(message)
        return framed
    }

    nonisolated public static func decodeUnaryMessage(_ data: Data) throws -> Data {
        guard data.count >= 5 else {
            throw AIProxyError.assertion("gRPC response was shorter than the 5-byte message header")
        }

        let compressedFlag = data[data.startIndex]
        guard compressedFlag == 0 else {
            throw AIProxyError.assertion("Compressed gRPC responses are not supported yet")
        }

        let lengthStart = data.index(after: data.startIndex)
        let lengthEnd = data.index(lengthStart, offsetBy: 4)
        let declaredLength = data[lengthStart..<lengthEnd].reduce(UInt32(0)) { partial, byte in
            (partial << 8) | UInt32(byte)
        }

        let messageStart = lengthEnd
        let messageEnd = data.index(messageStart, offsetBy: Int(declaredLength), limitedBy: data.endIndex)
        guard let messageEnd else {
            throw AIProxyError.assertion("gRPC response declared a message length larger than the body")
        }

        return data[messageStart..<messageEnd]
    }

    nonisolated private static func stringHeaders(from response: HTTPURLResponse) -> [String: String] {
        var result = [String: String]()
        for (key, value) in response.allHeaderFields {
            guard let key = key as? String else {
                continue
            }
            result[key] = String(describing: value)
        }
        return result
    }
}
