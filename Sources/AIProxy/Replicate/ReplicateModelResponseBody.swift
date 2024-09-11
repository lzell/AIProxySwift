//
//  ReplicateModelResponseBody.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import Foundation

struct ReplicateModelResponseBody: Decodable, Deserializable {
    let description: String?
    let name: String?
    let owner: String?
    let url: URL?
    let visibility: ReplicateModelVisibility?
}
