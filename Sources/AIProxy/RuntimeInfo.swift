//
//  RuntimeInfo.swift
//  AIProxy
//
//  Created by Lou Zell on 5/21/25.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

nonisolated struct RuntimeInfo {
    let appName: String
    let appVersion: String
    let buildNumber: String
    let bundleID: String
    let deviceModel: String
    let osVersion: String
    let systemName: String

    nonisolated static let current: RuntimeInfo = {
        let bundle = Bundle.main
        let infoDict = bundle.infoDictionary ?? [:]

        return RuntimeInfo(
            appName: infoDict["CFBundleName"] as? String ?? "Unknown",
            appVersion: infoDict["CFBundleShortVersionString"] as? String ?? "Unknown",
            buildNumber: infoDict["CFBundleVersion"] as? String ?? "Unknown",
            bundleID: bundle.bundleIdentifier ?? "Unknown",
            deviceModel: getDeviceModel(),
            osVersion: getOSVersion(),
            systemName: getSystemName()
        )
    }()
}

nonisolated private func getDeviceModel() -> String {
    #if os(macOS)
    let sysCallName = "hw.model"
    #else
    let sysCallName = "hw.machine"
    #endif
    var size: size_t = 0
    guard sysctlbyname(sysCallName, nil, &size, nil, 0) == noErr,
          size > 1 else {
        return "Unknown"
    }

    var machine = [CChar](repeating: 0, count: size)
    guard sysctlbyname(sysCallName, &machine, &size, nil, 0) == noErr else {
        return "Unknown"
    }

    let decoding = machine
        .prefix(size - 1)
        .map { UInt8($0) }

    let deviceModel = String(decoding: decoding, as: UTF8.self)
    logIf(.debug)?.debug("Inferred device model to be: \(deviceModel)")
    return deviceModel
}

nonisolated private func getSystemName() -> String {
    #if os(macOS)
    return "macOS"
    #elseif os(watchOS)
    return "watchOS"
    #else
    return UIDevice.current.systemName
    #endif
}

nonisolated private func getOSVersion() -> String {
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    return "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
}
