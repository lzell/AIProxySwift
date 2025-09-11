//
//  AIProxyActor.swift
//
//
//  Created by Lou Zell on 11/27/24.
//

import Foundation

@globalActor public actor AIProxyActor {
    public static let shared = AIProxyActor()
}

// This typealias is for backwards compatibility with sdkVersions <= "0.129.0"
public typealias RealtimeActor = AIProxyActor
