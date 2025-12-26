import Foundation

/// Generates Swift code from API schema
struct SwiftCodeGenerator: CodeGenerator {
    let prefix: String
    let verbose: Bool

    init(prefix: String = "", verbose: Bool = false) {
        self.prefix = prefix
        self.verbose = verbose
    }

    func generate(from schema: APISchema) -> [(filename: String, content: String)] {
        var files: [(filename: String, content: String)] = []

        for (name, def) in schema.types.sorted(by: { $0.key < $1.key }) {
            let fullName = prefix.isEmpty ? name : "\(prefix)\(name)"
            let content = generateType(name: fullName, def: def)
            files.append((filename: "\(fullName).swift", content: content))
        }

        return files
    }

    private func generateType(name: String, def: TypeDefinition) -> String {
        switch def {
        case .structType(let structDef):
            return generateStruct(name: name, def: structDef)
        case .stringEnum(let enumDef):
            return generateStringEnum(name: name, def: enumDef)
        case .union(let unionDef):
            return generateUnion(name: name, def: unionDef)
        case .alias(let aliasDef):
            return generateAlias(name: name, def: aliasDef)
        }
    }

    // MARK: - Struct Generation

    private func generateStruct(name: String, def: StructDef) -> String {
        var lines: [String] = []

        lines.append(fileHeader(name: name))
        lines.append("")
        lines.append("import Foundation")
        lines.append("")

        if let doc = def.doc {
            lines.append("/// \(doc)")
        }

        let protocols = protocolsForDirection(def.direction)
        lines.append("nonisolated public struct \(name): \(protocols), Sendable {")
        lines.append("")

        // Properties
        let sortedFields = def.fields.sorted { $0.key < $1.key }
        for (fieldName, field) in sortedFields {
            if let doc = field.doc {
                lines.append("    /// \(doc)")
            }
            let swiftType = schemaTypeToSwift(field.type)
            // Avoid double optionals - if type already ends with ?, don't add another
            let typeWithOptional: String
            if field.required || swiftType.hasSuffix("?") {
                typeWithOptional = swiftType
            } else {
                typeWithOptional = "\(swiftType)?"
            }
            lines.append("    public let \(fieldName): \(typeWithOptional)")
            lines.append("")
        }

        // CodingKeys if needed
        let needsCodingKeys = sortedFields.contains { $0.value.json != nil && $0.value.json != $0.key }
        if needsCodingKeys {
            lines.append("    private enum CodingKeys: String, CodingKey {")
            for (fieldName, field) in sortedFields {
                if let json = field.json, json != fieldName {
                    lines.append("        case \(fieldName) = \"\(json)\"")
                } else {
                    lines.append("        case \(fieldName)")
                }
            }
            lines.append("    }")
            lines.append("")
        }

        // Initializer
        lines.append("    public init(")
        let initParams = sortedFields.map { (name, field) -> String in
            let swiftType = schemaTypeToSwift(field.type)
            // Avoid double optionals
            let typeWithOptional: String
            let isAlreadyOptional = swiftType.hasSuffix("?")
            if field.required || isAlreadyOptional {
                typeWithOptional = swiftType
            } else {
                typeWithOptional = "\(swiftType)?"
            }
            let defaultValue = (field.required && !isAlreadyOptional) ? "" : " = nil"
            return "        \(name): \(typeWithOptional)\(defaultValue)"
        }
        lines.append(initParams.joined(separator: ",\n"))
        lines.append("    ) {")
        for (fieldName, _) in sortedFields {
            lines.append("        self.\(fieldName) = \(fieldName)")
        }
        lines.append("    }")

        lines.append("}")
        lines.append("")

        return lines.joined(separator: "\n")
    }

    // MARK: - String Enum Generation

    private func generateStringEnum(name: String, def: StringEnumDef) -> String {
        var lines: [String] = []

        lines.append(fileHeader(name: name))
        lines.append("")
        lines.append("import Foundation")
        lines.append("")

        let protocols = protocolsForDirection(def.direction)
        lines.append("nonisolated public enum \(name): String, \(protocols), Sendable {")

        // Cases
        let sortedCases = def.values.sorted { $0.key < $1.key }
        for (caseName, rawValue) in sortedCases {
            if caseName == rawValue {
                lines.append("    case \(caseName)")
            } else {
                lines.append("    case \(caseName) = \"\(rawValue)\"")
            }
        }

        // Add futureProof case if needed
        if def.unknownHandling == .fallback, let fallback = def.fallbackValue {
            lines.append("")
            lines.append("    /// Unknown value for future compatibility")
            lines.append("    case \(fallback)")
        }

        // Custom decoder for fallback handling
        if def.unknownHandling == .fallback, let fallback = def.fallbackValue {
            lines.append("")
            lines.append("    public init(from decoder: Decoder) throws {")
            lines.append("        let container = try decoder.singleValueContainer()")
            lines.append("        let value = try container.decode(String.self)")
            lines.append("        self = Self(rawValue: value) ?? .\(fallback)")
            lines.append("    }")
        }

        lines.append("}")
        lines.append("")

        return lines.joined(separator: "\n")
    }

    // MARK: - Union Generation

    private func generateUnion(name: String, def: UnionDef) -> String {
        var lines: [String] = []

        lines.append(fileHeader(name: name))
        lines.append("")
        lines.append("import Foundation")
        lines.append("")

        let protocols = protocolsForDirection(def.direction)
        lines.append("nonisolated public enum \(name): \(protocols), Sendable {")

        // Cases
        let sortedVariants = def.variants.sorted { $0.key < $1.key }
        for (caseName, variant) in sortedVariants {
            if let payload = variant.payload {
                lines.append("    case \(caseName)(\(payload))")
            } else if let type = variant.type {
                lines.append("    case \(caseName)(\(schemaTypeToSwift(type)))")
            } else if let fields = variant.fields, !fields.isEmpty {
                let params = fields.sorted { $0.key < $1.key }.map { (name, field) -> String in
                    let swiftType = schemaTypeToSwift(field.type)
                    let typeWithOptional = field.required ? swiftType : "\(swiftType)?"
                    return "\(name): \(typeWithOptional)"
                }.joined(separator: ", ")
                lines.append("    case \(caseName)(\(params))")
            } else {
                lines.append("    case \(caseName)")
            }
        }

        // Add futureProof case if needed
        if def.unknownHandling == .fallback, let fallback = def.fallbackVariant {
            lines.append("")
            lines.append("    /// Unknown variant for future compatibility")
            lines.append("    case \(fallback)")
        }

        // CodingKeys if discriminator exists
        if let disc = def.discriminator {
            lines.append("")
            lines.append("    private enum CodingKeys: String, CodingKey {")
            lines.append("        case \(disc.field)")

            // Add field keys from variants
            var allFieldKeys: Set<String> = []
            for (_, variant) in sortedVariants {
                if let fields = variant.fields {
                    for (fieldName, field) in fields {
                        if let json = field.json, json != fieldName {
                            allFieldKeys.insert("\(fieldName) = \"\(json)\"")
                        } else {
                            allFieldKeys.insert(fieldName)
                        }
                    }
                }
            }
            for key in allFieldKeys.sorted() {
                lines.append("        case \(key)")
            }

            lines.append("    }")
        }

        // Generate encode or decode based on direction
        if def.direction == .encode || def.direction == .both {
            lines.append(contentsOf: generateUnionEncode(def: def, sortedVariants: sortedVariants))
        }

        if def.direction == .decode || def.direction == .both {
            lines.append(contentsOf: generateUnionDecode(def: def, sortedVariants: sortedVariants))
        }

        lines.append("}")
        lines.append("")

        // ExpressibleBy extensions
        for (caseName, variant) in sortedVariants {
            if let sugar = variant.literalSugar {
                lines.append(contentsOf: generateLiteralConformance(
                    typeName: name,
                    caseName: caseName,
                    sugar: sugar,
                    variantType: variant.type
                ))
            }
        }

        return lines.joined(separator: "\n")
    }

    private func generateUnionEncode(def: UnionDef, sortedVariants: [(key: String, value: VariantDef)]) -> [String] {
        var lines: [String] = []

        lines.append("")
        lines.append("    public func encode(to encoder: Encoder) throws {")

        if def.discriminator == nil {
            // Single value container
            lines.append("        var container = encoder.singleValueContainer()")
            lines.append("        switch self {")
            for (caseName, variant) in sortedVariants {
                if variant.payload != nil || variant.type != nil {
                    lines.append("        case .\(caseName)(let value):")
                    lines.append("            try container.encode(value)")
                } else {
                    lines.append("        case .\(caseName):")
                    lines.append("            break")
                }
            }
            lines.append("        }")
        } else {
            // Keyed container with discriminator
            lines.append("        var container = encoder.container(keyedBy: CodingKeys.self)")
            lines.append("        switch self {")
            for (caseName, variant) in sortedVariants {
                let jsonValue = variant.jsonValue ?? caseName
                if let payload = variant.payload {
                    lines.append("        case .\(caseName)(let value):")
                    lines.append("            try container.encode(\"\(jsonValue)\", forKey: .type)")
                    lines.append("            try value.encode(to: encoder)")
                } else if let fields = variant.fields, !fields.isEmpty {
                    let params = fields.sorted { $0.key < $1.key }.map { "let \($0.key)" }.joined(separator: ", ")
                    lines.append("        case .\(caseName)(\(params)):")
                    lines.append("            try container.encode(\"\(jsonValue)\", forKey: .type)")
                    for (fieldName, field) in fields.sorted(by: { $0.key < $1.key }) {
                        if field.required {
                            lines.append("            try container.encode(\(fieldName), forKey: .\(fieldName))")
                        } else {
                            lines.append("            try container.encodeIfPresent(\(fieldName), forKey: .\(fieldName))")
                        }
                    }
                } else {
                    lines.append("        case .\(caseName):")
                    lines.append("            try container.encode(\"\(jsonValue)\", forKey: .type)")
                }
            }
            if def.unknownHandling == .fallback, let fallback = def.fallbackVariant {
                lines.append("        case .\(fallback):")
                lines.append("            break")
            }
            lines.append("        }")
        }

        lines.append("    }")

        return lines
    }

    private func generateUnionDecode(def: UnionDef, sortedVariants: [(key: String, value: VariantDef)]) -> [String] {
        var lines: [String] = []

        lines.append("")
        lines.append("    public init(from decoder: Decoder) throws {")

        if let disc = def.discriminator {
            lines.append("        let container = try decoder.container(keyedBy: CodingKeys.self)")
            lines.append("        let type = try container.decode(String.self, forKey: .\(disc.field))")
            lines.append("")
            lines.append("        switch type {")

            for (caseName, variant) in sortedVariants {
                let jsonValue = variant.jsonValue ?? caseName
                if let payload = variant.payload {
                    lines.append("        case \"\(jsonValue)\":")
                    lines.append("            self = .\(caseName)(try \(payload)(from: decoder))")
                } else if let fields = variant.fields, !fields.isEmpty {
                    lines.append("        case \"\(jsonValue)\":")
                    let decodeLines = fields.sorted { $0.key < $1.key }.map { (name, field) -> String in
                        let swiftType = schemaTypeToSwift(field.type)
                        if field.required {
                            return "                \(name): try container.decode(\(swiftType).self, forKey: .\(name))"
                        } else {
                            return "                \(name): try container.decodeIfPresent(\(swiftType).self, forKey: .\(name))"
                        }
                    }
                    lines.append("            self = .\(caseName)(")
                    lines.append(decodeLines.joined(separator: ",\n"))
                    lines.append("            )")
                } else {
                    lines.append("        case \"\(jsonValue)\":")
                    lines.append("            self = .\(caseName)")
                }
            }

            lines.append("        default:")
            if let fallback = def.fallbackVariant {
                lines.append("            self = .\(fallback)")
            } else {
                lines.append("            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: \"Unknown type: \\(type)\"))")
            }

            lines.append("        }")
        } else {
            // Single value container decoding - try each type
            lines.append("        let container = try decoder.singleValueContainer()")
            var first = true
            for (caseName, variant) in sortedVariants {
                if let type = variant.type {
                    let swiftType = schemaTypeToSwift(type)
                    if first {
                        lines.append("        if let value = try? container.decode(\(swiftType).self) {")
                        first = false
                    } else {
                        lines.append("        } else if let value = try? container.decode(\(swiftType).self) {")
                    }
                    lines.append("            self = .\(caseName)(value)")
                }
            }
            if !first {
                lines.append("        } else {")
                lines.append("            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: \"Could not decode union\"))")
                lines.append("        }")
            }
        }

        lines.append("    }")

        return lines
    }

    private func generateLiteralConformance(typeName: String, caseName: String, sugar: String, variantType: String?) -> [String] {
        var lines: [String] = []

        switch sugar {
        case "string":
            lines.append("extension \(typeName): ExpressibleByStringLiteral {")
            lines.append("    public init(stringLiteral value: String) {")
            lines.append("        self = .\(caseName)(value)")
            lines.append("    }")
            lines.append("}")
            lines.append("")

        case "array":
            if let type = variantType, type.hasPrefix("list[") {
                let elementType = String(type.dropFirst(5).dropLast())
                let swiftElement = schemaTypeToSwift(elementType)
                lines.append("extension \(typeName): ExpressibleByArrayLiteral {")
                lines.append("    public typealias ArrayLiteralElement = \(swiftElement)")
                lines.append("")
                lines.append("    public init(arrayLiteral elements: \(swiftElement)...) {")
                lines.append("        self = .\(caseName)(elements)")
                lines.append("    }")
                lines.append("}")
                lines.append("")
            }

        default:
            break
        }

        return lines
    }

    // MARK: - Alias Generation

    private func generateAlias(name: String, def: AliasDef) -> String {
        var lines: [String] = []

        lines.append(fileHeader(name: name))
        lines.append("")

        if let doc = def.doc {
            lines.append("/// \(doc)")
        }
        if def.deprecated {
            lines.append("@available(*, deprecated, message: \"Use \(def.target) instead\")")
        }
        lines.append("public typealias \(name) = \(def.target)")
        lines.append("")

        return lines.joined(separator: "\n")
    }

    // MARK: - Helpers

    private func fileHeader(name: String) -> String {
        """
        //
        //  \(name).swift
        //
        //  Generated by api-schema-generate
        //
        """
    }

    private func protocolsForDirection(_ direction: Direction) -> String {
        switch direction {
        case .encode: return "Encodable"
        case .decode: return "Decodable"
        case .both: return "Codable"
        }
    }

    private func schemaTypeToSwift(_ type: String) -> String {
        var t = type

        // Handle optional
        let isOptional = t.hasSuffix("?")
        if isOptional {
            t = String(t.dropLast())
        }

        // Convert schema types to Swift
        if t.hasPrefix("list[") && t.hasSuffix("]") {
            let inner = String(t.dropFirst(5).dropLast())
            t = "[\(schemaTypeToSwift(inner))]"
        } else if t.hasPrefix("map[") && t.hasSuffix("]") {
            let inner = String(t.dropFirst(4).dropLast())
            let parts = inner.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                t = "[\(schemaTypeToSwift(parts[0])): \(schemaTypeToSwift(parts[1]))]"
            }
        } else {
            switch t {
            case "string": t = "String"
            case "int": t = "Int"
            case "float": t = "Double"
            case "bool": t = "Bool"
            case "any": t = "AIProxyJSONValue"
            default: break  // Keep as-is (custom type)
            }
        }

        return isOptional ? "\(t)?" : t
    }
}
