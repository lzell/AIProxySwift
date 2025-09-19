//
//  DirectService.swift
//  
//
//  Created by Lou Zell on 12/16/24.
//

import Foundation

@AIProxyActor protocol DirectService: ServiceMixin {}

extension DirectService {
    var urlSession: URLSession {
        return AIProxyUtils.directURLSession()
    }
}
