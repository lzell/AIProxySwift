//
//  AIProxyHTTPVerb.swift
//
//
//  Created by Lou Zell on 8/6/24.
//

import Foundation

/// The HTTP verb to associate with a request.
/// If you select 'automatic', a request with a body will default to 'POST' while a request without a body will default to 'GET'
public enum AIProxyHTTPVerb: String {
    case automatic
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"

    func toString(hasBody: Bool) -> String {
        if self != .automatic {
            return self.rawValue
        }
        return hasBody ? AIProxyHTTPVerb.post.rawValue : AIProxyHTTPVerb.get.rawValue
    }
}
