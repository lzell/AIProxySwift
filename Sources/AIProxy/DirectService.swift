//
//  DirectService.swift
//  
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

protocol DirectService: ServiceMixin {}
extension DirectService {
    var urlSession: URLSession {
        return AIProxyUtils.directURLSession()
    }
}
