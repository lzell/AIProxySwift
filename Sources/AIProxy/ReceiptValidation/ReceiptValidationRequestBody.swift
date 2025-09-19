//
//  ReceiptValidationRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 1/28/25.
//

/// Encapsulates the data from StoreKit's AppTransaction
nonisolated public struct ReceiptValidationRequestBody: Encodable, Sendable {
    /// The JSON representation of the transaction.
    public let jsonRepresentationBase64: String

    /// A number the App Store uses to uniquely identify the application.
    public let appID: UInt64?

    /// The application version the transaction is for.
    public let appVersion: String

    /// A number the App Store uses to uniquely identify the version of the application.
    public let appVersionID: UInt64?

    /// Identifies the application the transaction is for.
    public let bundleID: String

    /// The server environment this transaction was created in.
    public let environment: String

    /// The version of the app originally purchased.
    public let originalAppVersion: String

    /// The date this original app purchase occurred on.
    public let originalPurchaseDate: Double

    /// A SHA-384 hash of `AppStore.deviceVerificationID` appended after
    /// `deviceVerificationNonce` (both lowercased UUID strings).
    public let deviceVerificationBase64: String

    /// The nonce used when computing `deviceVerification`.
    /// - SeeAlso: `AppStore.deviceVerificationID`
    public let deviceVerificationNonce: String

    /// The date this transaction was generated and signed.
    public let signedDate: Double

    /// The message from StoreKit 2 detailing why verification failed.
    public let verificationError: String?

    public init(
        jsonRepresentationBase64: String,
        appID: UInt64? = nil,
        appVersion: String,
        appVersionID: UInt64? = nil,
        bundleID: String,
        environment: String,
        originalAppVersion: String,
        originalPurchaseDate: Double,
        deviceVerificationBase64: String,
        deviceVerificationNonce: String,
        signedDate: Double,
        verificationError: String?
    ) {
        self.jsonRepresentationBase64 = jsonRepresentationBase64
        self.appID = appID
        self.appVersion = appVersion
        self.appVersionID = appVersionID
        self.bundleID = bundleID
        self.environment = environment
        self.originalAppVersion = originalAppVersion
        self.originalPurchaseDate = originalPurchaseDate
        self.deviceVerificationBase64 = deviceVerificationBase64
        self.deviceVerificationNonce = deviceVerificationNonce
        self.signedDate = signedDate
        self.verificationError = verificationError
    }
}
