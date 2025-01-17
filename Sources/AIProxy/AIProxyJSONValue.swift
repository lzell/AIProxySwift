//
//  AIProxyJSONValue.swift
//
//
//  Created by Lou Zell on 8/15/24.
//

import Foundation

/// Use AIProxyJSONValue when an Encodable or Decodable model has JSON members with types that are not known
/// ahead of time.
///
/// For example, AI providers often include 'tool use' functionality, where the request to the provider
/// contains a JSON schema defining the contract that the tool should conform to.  With AIProxyJSONValue, the
/// user may supply a schema that makes sense for them, unencumbered by strict codable compiler requirements.
/// I use some tricks to make the definition of an AIProxyJSONValue quite natural. It looks, on the surface,
/// like you are creating a non-encodable instance of [String: Any].  Yet, this is fully encodable:
///
///     let toolSchema: [String: AIProxyJSONValue] = [
///         "properties": [
///             "ticker": [
///                 "type": "string",
///                 "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
///             ]
///         ],
///         "required": ["ticker"]
///     ]
///
///     let encoder = JSONEncoder()
///     try encoder.encode(toolSchema) // Compiler is happy
///
/// I think of this as an 'escape hatch' from the confines of Codable. We can work with the ease of untyped
/// dictionaries (e.g. the tool schema definition), in the larger context of a scrict contract (e.g. all other
/// fields of the request body).
///
/// For several examples of its use, with both Encodable and Decodable examples, see AIProxyJSONValueTests.swift
public enum AIProxyJSONValue: Codable {
    case null(NSNull)
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([AIProxyJSONValue])
    case object([String: AIProxyJSONValue])


    public func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         switch self {
         case .null:
             try container.encodeNil()
         case let .bool(bool):
             try container.encode(bool)
         case let .int(int):
             try container.encode(int)
         case let .double(double):
             try container.encode(double)
         case let .string(string):
             try container.encode(string)
         case let .array(array):
             try container.encode(array)
         case let .object(object):
             try container.encode(object)
         }
     }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null(NSNull())
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([AIProxyJSONValue].self) {
            self = .array(array)
        } else if let object = try? container.decode([String: AIProxyJSONValue].self) {
            self = .object(object)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unexpected JSON value"
            )
        }
    }
}

extension [String: AIProxyJSONValue] {
    public var untypedDictionary: [String: Any] {
        return convertToUntypedDictionary(self)
    }
}

#if false
extension [String: Any] {
    public var jsonDictionary: [String: AIProxyJSONValue] {
        return convertToTypedDictionary(self)
    }
}
#endif

extension AIProxyJSONValue: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
    self = .null(NSNull())
  }
}

extension AIProxyJSONValue: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: BooleanLiteralType) {
    self = .bool(value)
  }
}

extension AIProxyJSONValue: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: IntegerLiteralType) {
    self = .int(value)
  }
}

extension AIProxyJSONValue: ExpressibleByFloatLiteral {
  public init(floatLiteral value: FloatLiteralType) {
    self = .double(value)
  }
}

extension AIProxyJSONValue: ExpressibleByStringLiteral {
  public init(stringLiteral value: StringLiteralType) {
    self = .string(value)
  }
}

extension AIProxyJSONValue: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: AIProxyJSONValue...) {
    self = .array(elements)
  }
}

extension AIProxyJSONValue: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, AIProxyJSONValue)...) {
    self = .object(.init(uniqueKeysWithValues: elements))
  }
}

private func convertToUntyped(_ input: AIProxyJSONValue) -> Any {
    switch input {
    case .null:
        return NSNull()
    case .bool(let bool):
        return bool
    case .int(let int):
        return int
    case .double(let double):
        return double
    case .string(let string):
        return string
    case .array(let array):
        return array.map { convertToUntyped($0) }
    case .object(let dictionary):
        return convertToUntypedDictionary(dictionary)
    }
}

private func convertToUntypedDictionary(
    _ input: [String: AIProxyJSONValue]
) -> [String: Any] {
    return input.mapValues { v in
        switch v {
        case .null:
            return NSNull()
        case .bool(let bool):
            return bool
        case .int(let int):
            return int
        case .double(let double):
            return double
        case .string(let string):
            return string
        case .array(let array):
            return array.map { convertToUntyped($0) }
        case .object(let dictionary):
            return convertToUntypedDictionary(dictionary)
        }
    }
}

#if false
private func convertToTyped(_ input: Any) -> AIProxyJSONValue {
    switch input {
    case is NSNull:
        return .null(NSNull())
    case let bool as Bool:
        return .bool(bool)
    case let int as Int:
        return .int(int)
    case let double as Double:
        return .double(double)
    case let string as String:
        return .string(string)
    case let array as [Any]:
        return .array(array.map { convertToTyped($0) })
    case let dictionary as [String: Any]:
        return .object(convertToTypedDictionary(dictionary))
    default:
        return .string("\(input)")
    }
}

private func convertToTypedDictionary(
    _ input: [String: Any]
) -> [String: AIProxyJSONValue] {
    return input.mapValues { v in
        return convertToTyped(v)
    }
}
#endif

