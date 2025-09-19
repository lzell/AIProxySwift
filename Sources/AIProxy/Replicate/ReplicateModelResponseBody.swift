//
//  ReplicateModelResponseBody.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import Foundation

nonisolated struct ReplicateModelResponseBody: Decodable, Sendable {
    let description: String?
    let name: String?
    let owner: String?
    let url: URL?
    let visibility: ReplicateModelVisibility?
    
    public init(description: String?, name: String?, owner: String?, url: URL?, visibility: ReplicateModelVisibility?) {
        self.description = description
        self.name = name
        self.owner = owner
        self.url = url
        self.visibility = visibility
    }
}
