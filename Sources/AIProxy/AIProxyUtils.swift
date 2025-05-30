//
//  OpenAIUtils.swift
//
//
//  Created by Lou Zell on 7/9/24.
//

import AVFoundation
import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(AudioToolbox)
import AudioToolbox
#endif

import Network

public enum AIProxyUtils {

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

    static func metadataHeader(withBodySize bodySize: Int?) -> String {
        let ri = RuntimeInfo.current
        let fields: [String] = [
            "v4",
            ri.bundleID,
            ri.appVersion,
            AIProxy.sdkVersion,
            String(Date().timeIntervalSince1970),
            ri.systemName,
            ri.osVersion,
            ri.deviceModel,
            String(bodySize ?? 0)
        ]
        return fields.joined(separator: "|")
    }

    #if os(macOS)
    static func getDefaultAudioInputDevice() -> AudioDeviceID? {
        var deviceID = AudioDeviceID()
        var propSize = UInt32(MemoryLayout<AudioDeviceID>.size)
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        let err = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            0,
            nil,
            &propSize,
            &deviceID
        )
        guard err == noErr else {
            logIf(.error)?.error("Could not query for default audio input device")
            return nil
        }
        return deviceID
    }
    #endif

    public static var headphonesConnected: Bool {
        #if os(macOS)
        return _audioToolboxHeadphonesConnected()
        #else
        return _audioSessionHeadphonesConnected()
        #endif
    }

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


#if !os(macOS)
private func _audioSessionHeadphonesConnected() -> Bool {
    let session = AVAudioSession.sharedInstance()
    let outputs = session.currentRoute.outputs

    for output in outputs {
        if output.portType == .headphones ||
            output.portType == .bluetoothA2DP ||
            output.portType == .bluetoothLE ||
            output.portType == .bluetoothHFP {
            return true
        }
    }
    return false
}
#endif


#if os(macOS)
private func _audioToolboxHeadphonesConnected() -> Bool {
    // Why am I getting all audio devices?
    // Couldn't I just get the default device? See AIProxyUtils.getDefaultAudioInputDevice

    // Get all audio devices
    var propertySize: UInt32 = 0
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )

    // Get the size of the device list
    var status = AudioObjectGetPropertyDataSize(
        AudioObjectID(kAudioObjectSystemObject),
        &address,
        0,
        nil,
        &propertySize
    )

    guard status == noErr else {
        return false
    }

    let deviceCount = Int(propertySize / UInt32(MemoryLayout<AudioDeviceID>.size))
    var devices = [AudioDeviceID](repeating: 0, count: deviceCount)

    // Get all devices
    status = AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &address,
        0,
        nil,
        &propertySize,
        &devices
    )

    guard status == noErr else {
        return false
    }

    for deviceID in devices {
        if isHeadphoneDevice(deviceID) && isDeviceAlive(deviceID) {
            return true
        }
    }
    return false
}



private func isHeadphoneDevice(_ deviceID: AudioDeviceID) -> Bool {
    // Check if device has output streams (headphones should have output)
    guard hasOutputStreams(deviceID) else { return false }

    // Get transport type
    var transportType = UInt32(0)
    var propertySize = UInt32(MemoryLayout<UInt32>.size)
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyTransportType,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )

    let status = AudioObjectGetPropertyData(
        deviceID,
        &address,
        0,
        nil,
        &propertySize,
        &transportType
    )

    guard status == noErr else { return false }

    // Check for headphone-like transport types
    if transportType == kAudioDeviceTransportTypeBluetooth ||
       transportType == kAudioDeviceTransportTypeBluetoothLE ||
       transportType == kAudioDeviceTransportTypeUSB {
        return true
    }

    // For built-in devices, we need to check the device name or UID
    if transportType == kAudioDeviceTransportTypeBuiltIn {
        return isBuiltInHeadphonePort(deviceID)
    }

    return false
}

private func isBuiltInHeadphonePort(_ deviceID: AudioDeviceID) -> Bool {
    var deviceUID: CFString? = nil
    var propSize = UInt32(MemoryLayout<CFString>.size)
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyDeviceUID,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )

    let err = withUnsafeMutablePointer(to: &deviceUID) { ptr -> OSStatus in
        return AudioObjectGetPropertyData(
            deviceID,
            &address,
            0,
            nil,
            &propSize,
            ptr
        )
    }

    guard err == noErr, let uidString = deviceUID as? String else {
        logIf(.error)?.error("Could not get mic's uidString from CFString")
        return false
    }

    let retval = ["headphone", "lineout"].contains { uidString.lowercased().contains($0) }
    return retval
}

private func hasOutputStreams(_ deviceID: AudioDeviceID) -> Bool {
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyStreams,
        mScope: kAudioObjectPropertyScopeOutput,
        mElement: kAudioObjectPropertyElementMain
    )

    var propertySize: UInt32 = 0
    let status = AudioObjectGetPropertyDataSize(
        deviceID,
        &address,
        0,
        nil,
        &propertySize
    )

    return status == noErr && propertySize > 0
}

private func isDeviceAlive(_ deviceID: AudioDeviceID) -> Bool {
    var isAlive: UInt32 = 0
    var propertySize = UInt32(MemoryLayout<UInt32>.size)
    var address = AudioObjectPropertyAddress(
        mSelector: kAudioDevicePropertyDeviceIsAlive,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )

    let status = AudioObjectGetPropertyData(
        deviceID,
        &address,
        0,
        nil,
        &propertySize,
        &isAlive
    )

    return status == noErr && isAlive != 0
}
#endif
