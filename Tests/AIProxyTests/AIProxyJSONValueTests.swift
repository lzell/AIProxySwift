//
//  AIProxyJSONValueTests.swift
//
//
//  Created by Lou Zell on 8/15/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class AIProxyJSONValueTests: XCTestCase {

    // MARK: Encodable
    func testNullIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": nil
        ]
        XCTAssertEqual(
            #"{"x":null}"#,
            try json.serialize()
        )
    }

    func testBoolIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": true
        ]
        XCTAssertEqual(
            #"{"x":true}"#,
            try json.serialize()
        )
    }

    func testIntIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": 1
        ]
        XCTAssertEqual(
            #"{"x":1}"#,
            try json.serialize()
        )
    }

    func testDoubleIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": 1.1
        ]
        XCTAssertEqual(
            #"{"x":1.1}"#,
            try json.serialize()
        )
    }

    func testStringIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": "y"
        ]
        XCTAssertEqual(
            #"{"x":"y"}"#,
            try json.serialize()
        )
    }

    func testArrayIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": ["y", "z"]
        ]
        XCTAssertEqual(
            #"{"x":["y","z"]}"#,
            try json.serialize()
        )
    }

    func testObjectIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": ["y": "z"]
        ]
        XCTAssertEqual(
            #"{"x":{"y":"z"}}"#,
            try json.serialize()
        )
    }

    func testNestedObjectIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": ["y": ["z": true]]
        ]
        XCTAssertEqual(
            #"{"x":{"y":{"z":true}}}"#,
            try json.serialize()
        )
    }

    func testObjectNestedInAnArrayIsEncodable() throws {
        let json: [String: AIProxyJSONValue] = [
            "x": [["y": "z"]]
        ]
        XCTAssertEqual(
            #"{"x":[{"y":"z"}]}"#,
            try json.serialize()
        )
    }

    // MARK: Decodable
    func testNullIsDecodable() throws {
        let sampleResponse = #"{"x":null}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .null(null) = jsonValue["x"] {
            XCTAssert(null == NSNull())
        } else {
            XCTFail()
        }

        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(NSNull(), dict["x"] as? NSNull)
    }

    func testBoolIsDecodable() throws {
        let sampleResponse = #"{"x":true}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .bool(bool) = jsonValue["x"] {
            XCTAssert(bool)
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(true, dict["x"] as? Bool)
    }

    func testIntIsDecodable() throws {
        let sampleResponse = #"{"x":1}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .int(int) = jsonValue["x"] {
            XCTAssertEqual(1, int)
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(1, dict["x"] as? Int)
    }

    func testDoubleIsDecodable() throws {
        let sampleResponse = #"{"x":1.1}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .double(double) = jsonValue["x"] {
            XCTAssertEqual(1.1, double)
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(1.1, dict["x"] as? Double)
    }

    func testStringIsDecodable() throws {
        let sampleResponse = #"{"x":"y"}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .string(str) = jsonValue["x"] {
            XCTAssertEqual("y", str)
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual("y", dict["x"] as? String)
    }

    func testArrayIsDecodable() throws {
        let sampleResponse = #"{"x":["y","z"]}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .array(arr) = jsonValue["x"] {
            XCTAssertEqual(2, arr.count)
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(["y", "z"], dict["x"] as? [String])
    }

    func testObjectIsDecodable() throws {
        let sampleResponse = #"{"x":{"y":"z"}}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .object(obj) = jsonValue["x"] {
            XCTAssertEqual(["y"], Array(obj.keys))
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(["y": "z"], dict["x"] as? [String : String])
    }

    func testNestedObjectIsDecodable() throws {
        let sampleResponse = #"{"x":{"y":{"z":true}}}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .object(obj) = jsonValue["x"] {
            XCTAssertEqual(["y"], Array(obj.keys))
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual(["y": ["z": true]], dict["x"] as? [String: [String : Bool]])
    }

    func testObjectNestedInAnArrayIsDecodable() throws {
        let sampleResponse = #"{"x":[{"y":"z"}]}"#
        let jsonValue = try [String: AIProxyJSONValue].deserialize(from: sampleResponse)
        if case let .array(arr) = jsonValue["x"] {
            XCTAssertEqual(1, arr.count)
        } else {
            XCTFail()
        }
        let dict = jsonValue.untypedDictionary
        XCTAssertEqual([["y": "z"]], dict["x"] as? [[String: String]])
    }
}
