//
//  OpenAIUtils.swift
//
//
//  Created by Lou Zell on 7/9/24.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import Network

enum AIProxyUtils {

    static func directURLSession() -> URLSession {
        return URLSession(configuration: .ephemeral)
    }

    static func proxiedURLSession() -> URLSession {
        if AIProxy.resolveDNSOverTLS {
            let host = NWEndpoint.hostPort(host: "one.one.one.one", port: 853)
            let endpoints: [NWEndpoint] = [
                .hostPort(host: "1.1.1.1", port: 853),
                .hostPort(host: "1.0.0.1", port: 853),
                .hostPort(host: "2606:4700:4700::1111", port: 853),
                .hostPort(host: "2606:4700:4700::1001", port: 853)
            ]
            NWParameters.PrivacyContext.default.requireEncryptedNameResolution(
                true,
                fallbackResolver: .tls(host, serverAddresses: endpoints)
            )
        }
        return AIProxyURLSession.create()
    }

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    static func encodeImageAsJpeg(
        _ image: NSImage,
        _ compressionQuality: CGFloat
    ) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
    }

    static func encodeImageAsURL(
        _ image: NSImage,
        _ compressionQuality: CGFloat
    ) -> URL? {
        guard let jpegData = self.encodeImageAsJpeg(image, compressionQuality) else {
            return nil
        }
        return URL(string: "data:image/jpeg;base64,\(jpegData.base64EncodedString())")
    }

#elseif canImport(UIKit)
    static func encodeImageAsJpeg(
        _ image: UIImage,
        _ compressionQuality: CGFloat
    ) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
    }

    static func encodeImageAsURL(
        _ image: UIImage,
        _ compressionQuality: CGFloat
    ) -> URL? {
        guard let jpegData = self.encodeImageAsJpeg(image, compressionQuality) else {
            return nil
        }
        return URL(string: "data:image/jpeg;base64,\(jpegData.base64EncodedString())")
    }
#endif
}


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension NSImage {
    func jpegData(compressionQuality: CGFloat = 1.0) -> Data? {
        guard let tiffData = self.tiffRepresentation else {
            return nil
        }
        guard let bitmapImage = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        let jpegData = bitmapImage.representation(
            using: .jpeg,
            properties: [.compressionFactor: compressionQuality]
        )
        return jpegData
    }
}
#endif
