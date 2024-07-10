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

struct OpenAIUtils {
#if canImport(AppKit)
    static func encodeImageAsURL(
        _ image: NSImage,
        _ compressionQuality: CGFloat
    ) -> URL? {
        guard let jpegData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return URL(string: "data:image/jpeg;base64,\(jpegData.base64EncodedString())")
    }
#elseif canImport(UIKit)
    static func encodeImageAsURL(
        _ image: UIImage,
        _ compressionQuality: CGFloat
    ) -> URL? {
        guard let jpegData = image.jpegData(compressionQuality: compressionQuality) else {
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
