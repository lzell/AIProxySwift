//
//  ReceiptValidationResponseBody.swift
//  AIProxy
//
//  Created by Lou Zell on 1/28/25.
//

public struct ReceiptValidationResponseBody: Decodable {
    public let isValid: Bool
    
    public init(isValid: Bool) {
        self.isValid = isValid
    }
}
