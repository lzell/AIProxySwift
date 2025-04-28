//
//  ProxiedService.swift
//
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

protocol ProxiedService: ServiceMixin {}
extension ProxiedService {
    var urlSession: URLSession {
        return AIProxyUtils.proxiedURLSession()
    }
}
