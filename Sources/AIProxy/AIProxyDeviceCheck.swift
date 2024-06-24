//
//  AIProxyUtils.swift
//
//
//  Created by Lou Zell on 6/23/24.
//

import Foundation
import DeviceCheck

struct AIProxyDeviceCheck {

    /// Gets a base64 encoded DeviceCheck token for this device, if possible.
    /// On iOS simulators, the return value will be nil and a log message will be written to console.
    ///
    /// If you are testing AIProxy on a simulator, please see the README.md file for instructions
    /// on adding a DeviceCheck bypass token to your Xcode env variables.
    ///
    /// It is important that you don't let a DeviceCheck bypass token slip into your production codebase.
    /// If you do, an attacker can easily use it themselves to bypass DeviceCheck. Your bypass token is intended
    /// to only be used by developers of your app, and is intended to only be included as a an environment variable.
    ///
    /// - Returns: A base 64 encoded DeviceCheck token, if possible
    internal static func getToken() async -> String? {
        guard DCDevice.current.isSupported else {
            aiproxyLogger.error("DeviceCheck is not available on this device. Are you on the simulator?")
            return nil
        }

        do {
            let data = try await DCDevice.current.generateToken()
            return data.base64EncodedString()
        } catch {
            aiproxyLogger.error("Could not create DeviceCheck token. Are you using an explicit bundle identifier?")
            return nil
        }
    }

    private init() {
        fatalError("This type is not designed to be instantiated")
    }
}
