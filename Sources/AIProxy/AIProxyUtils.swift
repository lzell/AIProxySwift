//
//  OpenAIUtils.swift
//
//
//  Created by Lou Zell on 7/9/24.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

struct AIProxyUtils {

    static func serialize(_ encodable: Encodable, pretty: Bool = false) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        if pretty {
            encoder.outputFormatting.insert(.prettyPrinted)
        }
        return try encoder.encode(encodable)
    }

    /// Some providers return invalid JSON that blows up Decodable and JSONSerialization.
    /// Use this to strip fields from raw Data before passing the result off to Decodable.
    static func stripFields(_ fields: [String], from data: Data) throws -> Data {
        // let t = Date()

        guard var str = String(data: data, encoding: .utf8) else {
            throw AIProxyError.assertion("Could not represent data as utf8 string")
        }

        for field in fields {
            if let matchingRange = str.range(of: "\"\(field)\": \"") {
                let startOfSnip = matchingRange.upperBound
                var snipWalker = matchingRange.upperBound
                var endOfSnip = matchingRange.upperBound

                // Advance until we encounter a double quote that is not preceeded by a single escape:
                var avoid = false
                while snipWalker < str.endIndex {
                    if (str[snipWalker] == #"""# && !avoid) {
                        endOfSnip = snipWalker
                        break
                    }
                    avoid = str[snipWalker] == #"\"#
                    snipWalker = str.index(after: snipWalker)
                }
                if startOfSnip != endOfSnip {
                    let before = str[..<startOfSnip]
                    let after = str[endOfSnip...]
                    str = String(before + after)
                }
            }
        }

        guard let stripped = str.data(using: .utf8) else {
            throw AIProxyError.assertion("Could not represent utf8 string as data")
        }

        // print("Replicate hack took \(Date().timeIntervalSince(t))")
        return stripped
    }


#if canImport(AppKit)
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
    private init() {
        fatalError("This type is not designed to be instantiated")
    }
}


#if canImport(AppKit)
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
