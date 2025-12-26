import Foundation
import Yams

/// Parses YAML schema files into APISchema
struct YAMLSchemaParser {
    func parse(from url: URL) throws -> APISchema {
        let content = try String(contentsOf: url, encoding: .utf8)
        return try parse(yaml: content)
    }

    func parse(yaml: String) throws -> APISchema {
        guard let dict = try Yams.load(yaml: yaml) as? [String: Any] else {
            throw SchemaParseError.invalidFormat("Root must be a dictionary")
        }

        let version = dict["version"] as? String ?? "1.0"
        let provider = dict["provider"] as? String ?? "Unknown"

        var schema = APISchema(version: version, provider: provider)

        if let types = dict["types"] as? [String: Any] {
            for (name, value) in types {
                guard let typeDef = value as? [String: Any] else { continue }
                schema.types[name] = try parseType(name: name, def: typeDef)
            }
        }

        return schema
    }

    private func parseType(name: String, def: [String: Any]) throws -> TypeDefinition {
        guard let kind = def["kind"] as? String else {
            throw SchemaParseError.missingField("kind", type: name)
        }

        switch kind {
        case "struct":
            return .structType(try parseStruct(def))
        case "string_enum":
            return .stringEnum(try parseStringEnum(def))
        case "union":
            return .union(try parseUnion(def))
        case "alias":
            return .alias(try parseAlias(def))
        default:
            throw SchemaParseError.unknownKind(kind, type: name)
        }
    }

    private func parseStruct(_ def: [String: Any]) throws -> StructDef {
        let direction = parseDirection(def["direction"] as? String)
        let doc = def["doc"] as? String

        var fields: [String: FieldDef] = [:]
        if let fieldsDict = def["fields"] as? [String: Any] {
            for (name, value) in fieldsDict {
                guard let fieldDef = value as? [String: Any] else { continue }
                fields[name] = parseField(fieldDef)
            }
        }

        return StructDef(direction: direction, doc: doc, fields: fields)
    }

    private func parseField(_ def: [String: Any]) -> FieldDef {
        return FieldDef(
            type: def["type"] as? String ?? "any",
            json: def["json"] as? String,
            required: def["required"] as? Bool ?? false,
            doc: def["doc"] as? String
        )
    }

    private func parseStringEnum(_ def: [String: Any]) throws -> StringEnumDef {
        let direction = parseDirection(def["direction"] as? String)
        let unknownHandling = (def["unknown_handling"] as? String).flatMap { UnknownHandling(rawValue: $0) }
        let fallbackValue = def["fallback_value"] as? String

        var values: [String: String] = [:]
        if let valuesDict = def["values"] as? [String: String] {
            values = valuesDict
        }

        return StringEnumDef(
            direction: direction,
            unknownHandling: unknownHandling,
            fallbackValue: fallbackValue,
            values: values
        )
    }

    private func parseUnion(_ def: [String: Any]) throws -> UnionDef {
        let direction = parseDirection(def["direction"] as? String)
        let unknownHandling = (def["unknown_handling"] as? String).flatMap { UnknownHandling(rawValue: $0) }
        let fallbackVariant = def["fallback_variant"] as? String

        var discriminator: Discriminator?
        if let discDef = def["discriminator"] {
            if let discDict = discDef as? [String: Any] {
                let field = discDict["field"] as? String ?? "type"
                let location = (discDict["location"] as? String).flatMap { DiscriminatorLocation(rawValue: $0) } ?? .inline
                discriminator = Discriminator(field: field, location: location)
            }
            // If discriminator is "none" or null, leave it nil
        }

        var variants: [String: VariantDef] = [:]
        if let variantsDict = def["variants"] as? [String: Any] {
            for (name, value) in variantsDict {
                guard let variantDef = value as? [String: Any] else { continue }
                variants[name] = parseVariant(variantDef)
            }
        }

        return UnionDef(
            direction: direction,
            discriminator: discriminator,
            unknownHandling: unknownHandling,
            fallbackVariant: fallbackVariant,
            variants: variants
        )
    }

    private func parseVariant(_ def: [String: Any]) -> VariantDef {
        var fields: [String: FieldDef]?
        if let fieldsDict = def["fields"] as? [String: Any] {
            fields = [:]
            for (name, value) in fieldsDict {
                guard let fieldDef = value as? [String: Any] else { continue }
                fields?[name] = parseField(fieldDef)
            }
        }

        return VariantDef(
            jsonValue: def["json_value"] as? String,
            payload: def["payload"] as? String,
            type: def["type"] as? String,
            fields: fields,
            literalSugar: def["literal_sugar"] as? String
        )
    }

    private func parseAlias(_ def: [String: Any]) throws -> AliasDef {
        guard let target = def["target"] as? String else {
            throw SchemaParseError.missingField("target", type: "alias")
        }

        return AliasDef(
            target: target,
            deprecated: def["deprecated"] as? Bool ?? false,
            doc: def["doc"] as? String
        )
    }

    private func parseDirection(_ value: String?) -> Direction {
        guard let value = value else { return .both }
        return Direction(rawValue: value) ?? .both
    }
}

enum SchemaParseError: Error, CustomStringConvertible {
    case invalidFormat(String)
    case missingField(String, type: String)
    case unknownKind(String, type: String)

    var description: String {
        switch self {
        case .invalidFormat(let msg):
            return "Invalid schema format: \(msg)"
        case .missingField(let field, let type):
            return "Missing required field '\(field)' in type '\(type)'"
        case .unknownKind(let kind, let type):
            return "Unknown type kind '\(kind)' for type '\(type)'"
        }
    }
}
