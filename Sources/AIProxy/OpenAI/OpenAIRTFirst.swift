//
//  File.swift
//  
//
//  Created by Lou Zell on 10/12/24.
//

import Foundation

public struct Thinger: Encodable {
    internal init(response: Thinger2) {
        self.response = response
    }
    
    public let type = "response.create"
    public let response: Thinger2
}

public struct Thinger2: Encodable {
    internal init(modalities: [String], instructions: String) {
        self.modalities = modalities
        self.instructions = instructions
    }
    
    public let modalities: [String]
    public let instructions: String
}
