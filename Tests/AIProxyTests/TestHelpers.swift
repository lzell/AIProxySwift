//
//  TestHelpers.swift
//  
//
//  Created by Lou Zell on 8/11/24.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
func createImage(width: Int, height: Int) -> NSImage {
    let cgImage = createTestImage(width: width, height: height)
    return NSImage(
        cgImage: cgImage,
        size: CGSize(width: width, height: height)
    )
}
#elseif canImport(UIKit)
func createImage(width: Int, height: Int) -> UIImage {
    let cgImage = createTestImage(width: width, height: height)
    return UIImage(cgImage: cgImage)
}
#endif

/// Creates a red rectangle of `width` and `height`
private func createTestImage(width: Int, height: Int) -> CGImage {
    let numComponents = 3
    let numBytes = height * width * numComponents
    var pixelData = [UInt8](repeating: 0, count: numBytes)
    for i in stride(from: 0, to: numBytes, by: 3) {
        pixelData[i] = 255
        pixelData[i + 1] = 0
        pixelData[i + 2] = 0
    }
    let colorspace = CGColorSpaceCreateDeviceRGB()
    let rgbData = CFDataCreate(nil, pixelData, numBytes)!
    let provider = CGDataProvider(data: rgbData)!
    return CGImage(width: width,
                   height: height,
                   bitsPerComponent: 8,
                   bitsPerPixel: 8 * numComponents,
                   bytesPerRow: width * numComponents,
                   space: colorspace,
                   bitmapInfo: CGBitmapInfo(rawValue: 0),
                   provider: provider,
                   decode: nil,
                   shouldInterpolate: true,
                   intent: CGColorRenderingIntent.defaultIntent)!
}
