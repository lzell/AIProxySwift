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

struct RuntimeInfo {
    let appName: String
    let appVersion: String
    let buildNumber: String
    let bundleID: String
    let deviceModel: String
    let osVersion: String
    let systemName: String

    static var current: RuntimeInfo = {
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

private func getDeviceModel() -> String {
    #if os(macOS)
    let sysCallName = "hw.model"
    #else
    let sysCallName = "hw.machine"
    #endif
    var size: size_t = 0
    guard sysctlbyname(sysCallName, nil, &size, nil, 0) == noErr, size > 0 else {
        return "Unknown"
    }

    var machine = [CChar](repeating: 0, count: size)
    guard sysctlbyname(sysCallName, &machine, &size, nil, 0) == noErr else {
        return "Unknown"
    }

    return String(cString: machine)
}

private func getSystemName() -> String {
    #if os(macOS)
    return "macOS"
    #elseif os(watchOS)
    return "watchOS"
    #else
    return UIDevice.current.systemName
    #endif
}

private func getOSVersion() -> String {
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    return "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
}
