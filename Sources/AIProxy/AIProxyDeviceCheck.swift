//
//  AIProxyDeviceCheck.swift
//
//
//  Created by Lou Zell on 6/23/24.
//

import Foundation
import DeviceCheck
import OSLog


private let deviceCheckWarning = """
    AIProxy warning: DeviceCheck is not available on this device.

    To use AIProxy on an iOS simulator, set an AIPROXY_DEVICE_CHECK_BYPASS environment variable.

    See the README at https://github.com/lzell/AIProxySwift for instructions.
    """


enum AIProxyDeviceCheck {

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
    @MainActor
    internal static func getToken(forClient clientID: String?) async -> String? {
        // We have seen `EXC_BAD_ACCESS` on accessing `DCDevice.current.isSupported` in the wild.
        // My theory is that the `DCDevice.h` header uses `NS_ASSUME_NONNULL_BEGIN` when it should not.
        // This juggling is an attempt at preventing the bad access crashes.
        let _dcDevice: DCDevice? = DCDevice.current
        guard let dcDevice = _dcDevice else {
            logIf(.error)?.error("DCDevice singleton is not available. Please contact Lou if you can reproduce this!")
            ClientLibErrorLogger.logDeviceCheckSingletonIsNil(clientID: clientID)
            return nil
        }

        guard dcDevice.isSupported else {
            if ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"] == nil {
                logIf(.warning)?.warning("\(deviceCheckWarning, privacy: .public)")
            }
            #if !targetEnvironment(simulator) && !DEBUG
            ClientLibErrorLogger.logDeviceCheckNotSupported(clientID: clientID)
            #endif
            return nil
        }

        do {
            let data = try await dcDevice.generateToken()
            return data.base64EncodedString()
        } catch {
            logIf(.error)?.error("Could not create DeviceCheck token. Are you using an explicit bundle identifier?")
            #if !targetEnvironment(simulator) && !DEBUG
            ClientLibErrorLogger.logDeviceCheckCouldNotGenerateToken(error.localizedDescription, clientID: clientID)
            #endif
            return nil
        }
    }
}
