//
//  AIProxyError.swift
//
//
//  Created by Lou Zell on 6/23/24.
//

import Foundation

public enum AIProxyError: LocalizedError, Equatable {

    /// This error is thrown if any programmer assumptions are broken and the library can't continue.
    ///
    /// In application code, this would normally be a FatalError. It's tempting to use FatalError for
    /// broken invariants here, but as a library author I never want an application to crash in
    /// production because of us. If `FatalError` was used for broken library invariants, then an
    /// insufficiently tested codepath could crash an app that depends on us.
    ///
    /// One alternative is to use the built-in `AssertionError` in library code, but that muddles
    /// library interfaces: Any function f -> g that used `AssertionError` would become f -> g?
    /// because AssertionError is not an enforced precondition in production. The program won't halt
    /// and you need to figure out what to return.
    ///
    /// I prefer the alternative of defining `AIProxyError.assertion`, which is thrown for broken
    /// invariants. Interfaces that already `throw` remain unchanged when `AIProxyError.assertion`
    /// is introduced in the function body. Interfaces that did not throw before the introduction of
    /// `AIProxyError.assertion` will need to change, but I consider that worthwhile. Reasonable
    /// people would disagree, and think the introduction of a broken invariant should change a
    /// non-throwing library function from f -> g to f -> g?, but I consider the burden imposed on the
    /// caller to be similar for unwrapping the optional versus handling an error.
    ///
    /// Any AIProxyError.assertion that you encounter in the wild is a programmer error.
    /// Please contact support@aiproxy.pro with a reproduction!
    case assertion(String)


    /// Raised when the status code of a network response is outside of the [200, 299] range.
    /// The associated Int contains the status code of the failed request.
    /// The associated String contains the response body of the failed request.
    ///
    /// A status code that you may experience in normal operation of your app is a 429, which
    /// means that your request was rate limited. A simple way to test this during development is
    /// to place a really low rate limit in the AIProxy dashboard, and then fire a couple requests
    /// from the simulator to reach the rate limit. You wouldn't want to do this once your app is in
    /// production, because the rate limits that you apply will rate limit live users!
    case unsuccessfulRequest(statusCode: Int, responseBody: String)

    /// A core component of our security model is Apple's DeviceCheck.
    /// If we can't generate a DeviceCheck token, then the app is not allowed to make requests to AIProxy's backend.
    /// Catch this error to pop UI to the end user.
    /// Our suggested copy for the alert is:
    /// "We could not create a required credential to make your AI request. Please make sure you are connected to the internet and your system clock is accurately set."
    case deviceCheckIsUnavailable

    /// Raised from the iOS simulator if the `AIPROXY_DEVICE_CHECK_BYPASS` token is not set.
    /// The bypass token is needed on simulators only, where Apple's DeviceCheck is not available.
    case deviceCheckBypassIsMissing

    public var errorDescription: String? {
        switch self {
        case .assertion(let message):
            return "AIProxy - A library precondition was not met: \(message)"
        case .unsuccessfulRequest(statusCode: let statusCode, responseBody: let responseBody):
            return "AIProxy - the request resulted in a status code of \(statusCode) with response body: \(responseBody)."
        case .deviceCheckIsUnavailable:
            return "AIProxy - Apple's DeviceCheck is not available on this device. Please make sure you are connected to the internet and your system clock is accurately set."
        case .deviceCheckBypassIsMissing:
            return "AIProxy - You are running on a simulator without setting the AIPROXY_DEVICE_CHECK_BYPASS env variable. Please see the integration guide for instructions on setting AIPROXY_DEVICE_CHECK_BYPASS: https://www.aiproxy.pro/docs/integration-guide.html"
        }

    }
}

