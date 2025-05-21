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
        var deviceModel = "Unknown"
        var systemName = "Unknown"
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let osVersionString = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"

        #if os(iOS) || os(tvOS) || os(watchOS)
        deviceModel = UIDevice.current.model
        systemName = UIDevice.current.systemName
        #elseif os(macOS)
        deviceModel = Host.current().localizedName ?? "Mac"
        systemName = "macOS"
        #endif

        return RuntimeInfo(
            appName: infoDict["CFBundleName"] as? String ?? "Unknown",
            appVersion: infoDict["CFBundleShortVersionString"] as? String ?? "Unknown",
            buildNumber: infoDict["CFBundleVersion"] as? String ?? "Unknown",
            bundleID: bundle.bundleIdentifier ?? "Unknown",
            deviceModel: deviceModel,
            osVersion: osVersionString,
            systemName: systemName
        )
    }()
}
