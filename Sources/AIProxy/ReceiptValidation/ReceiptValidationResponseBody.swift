//
//  ReceiptValidationResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 1/28/25.
//

nonisolated public struct ReceiptValidationResponseBody: Decodable, Sendable {
    public let isValid: Bool
    
    public init(isValid: Bool) {
        self.isValid = isValid
    }
}
