//
//  AIProxyClientIdentifier.swift
//
//
//  Created by Lou Zell on 6/23/24.
//

import Foundation

#if os(watchOS)
import WatchKit
#elseif canImport(UIKit)
import UIKit
#elseif canImport(IOKit)
import IOKit
#endif

enum AIProxyIdentifier {
    /// Generates a clientID for this device.
    /// - Returns: The AIProxy stableID if the developer configured the SDK with `useStableID`.
    ///            Otherwise, a UIDevice ID on iOS, an IOKit ID on macOS
    internal static func getClientID() -> String {
        if let stableID = AIProxyConfiguration.stableID {
            return stableID
        }
#if os(watchOS)
        let clientID = WKInterfaceDevice.current().identifierForVendor?.uuidString
#elseif canImport(UIKit)
        let clientID = UIDevice.current.identifierForVendor?.uuidString
#elseif canImport(IOKit)
        let clientID = getIdentifierFromIOKit()
#endif
        if let clientID = clientID {
            return clientID
        }
        ClientLibErrorLogger.logClientIdentifierIsNil()
        return "unknown"
    }

#if canImport(IOKit)
    private static func getIdentifierFromIOKit() -> String? {
        guard let macBytes = copy_mac_address() as? Data else {
            return nil
        }
        let macHex = macBytes.map { String(format: "%02X", $0) }
        return macHex.joined(separator: ":")
    }

    // This function is taken from the Apple sample code at:
    // https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device#3744656
    private static func io_service(named name: String, wantBuiltIn: Bool) -> io_service_t? {
        let default_port = kIOMainPortDefault
        var iterator = io_iterator_t()
        defer {
            if iterator != IO_OBJECT_NULL {
                IOObjectRelease(iterator)
            }
        }

        guard let matchingDict = IOBSDNameMatching(default_port, 0, name),
              IOServiceGetMatchingServices(default_port,
                                           matchingDict as CFDictionary,
                                           &iterator) == KERN_SUCCESS,
              iterator != IO_OBJECT_NULL
        else {
            return nil
        }

        var candidate = IOIteratorNext(iterator)
        while candidate != IO_OBJECT_NULL {
            if let cftype = IORegistryEntryCreateCFProperty(candidate,
                                                            "IOBuiltin" as CFString,
                                                            kCFAllocatorDefault,
                                                            0) {
                let isBuiltIn = cftype.takeRetainedValue() as! CFBoolean
                if wantBuiltIn == CFBooleanGetValue(isBuiltIn) {
                    return candidate
                }
            }

            IOObjectRelease(candidate)
            candidate = IOIteratorNext(iterator)
        }

        return nil
    }

    // This function is taken from the Apple sample code at:
    // https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device#3744656
    private static func copy_mac_address() -> CFData? {
        // Prefer built-in network interfaces.
        // For example, an external Ethernet adaptor can displace
        // the built-in Wi-Fi as en0.
        guard let service = io_service(named: "en0", wantBuiltIn: true)
                ?? io_service(named: "en1", wantBuiltIn: true)
                ?? io_service(named: "en0", wantBuiltIn: false)
        else { return nil }
        defer { IOObjectRelease(service) }

        if let cftype = IORegistryEntrySearchCFProperty(
            service,
            kIOServicePlane,
            "IOMACAddress" as CFString,
            kCFAllocatorDefault,
            IOOptionBits(kIORegistryIterateRecursively | kIORegistryIterateParents)) {
            return (cftype as! CFData)
        }

        return nil
    }
#endif

}



