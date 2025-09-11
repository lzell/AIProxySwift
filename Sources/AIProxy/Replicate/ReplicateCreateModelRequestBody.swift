//
//  ReplicateCreateModelRequestBody.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import Foundation

nonisolated struct ReplicateCreateModelRequestBody: Encodable {
    let description: String
    let hardware: String?
    let name: String
    let owner: String
    let visibility: ReplicateModelVisibility
}
