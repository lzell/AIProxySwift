//
//  ProtectedPropertyQueue.swift
//  AIProxy
//
//  Created by Lou Zell on 4/23/25.
//

import Foundation

internal let protectedPropertyQueue = DispatchQueue(
    label: "aiproxy-protected-property-queue",
    attributes: .concurrent
)
