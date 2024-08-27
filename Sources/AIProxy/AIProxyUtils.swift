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
