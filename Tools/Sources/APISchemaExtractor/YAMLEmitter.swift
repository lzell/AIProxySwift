import Foundation
import Yams

/// Emits API schema as YAML
struct YAMLEmitter {
    func emit(_ schema: APISchema) -> String {
        var lines: [String] = []

        lines.append("version: \"\(schema.version)\"")
        lines.append("provider: \(schema.provider)")
        lines.append("")
        lines.append("types:")

        // Sort types alphabetically for consistent output
        let sortedTypes = schema.types.sorted { $0.key < $1.key }

        for (name, def) in sortedTypes {
            lines.append("")
            lines.append(emitType(name: name, def: def))
        }

        return lines.joined(separator: "\n")
    }

    private func emitType(name: String, def: TypeDefinition) -> String {
        switch def {
        case .structType(let structDef):
            return emitStruct(name: name, def: structDef)
        case .stringEnum(let enumDef):
            return emitStringEnum(name: name, def: enumDef)
        case .union(let unionDef):
            return emitUnion(name: name, def: unionDef)
        case .alias(let aliasDef):
            return emitAlias(name: name, def: aliasDef)
        }
    }

    private func emitStruct(name: String, def: StructDef) -> String {
        var lines: [String] = []

        lines.append("  \(name):")
        lines.append("    kind: struct")
        lines.append("    direction: \(def.direction.rawValue)")

        if let doc = def.doc {
            lines.append("    doc: \"\(escapeYAML(doc))\"")
        }

        if !def.fields.isEmpty {
            lines.append("    fields:")

            // Sort fields for consistent output
            let sortedFields = def.fields.sorted { $0.key < $1.key }

            for (fieldName, field) in sortedFields {
                lines.append("      \(fieldName):")
                lines.append("        type: \"\(field.type)\"")
                if let json = field.json, json != fieldName {
                    lines.append("        json: \(json)")
                }
                if field.required {
                    lines.append("        required: true")
                }
                if let doc = field.doc {
                    lines.append("        doc: \"\(escapeYAML(truncate(doc, to: 80)))\"")
                }
            }
        }

        return lines.joined(separator: "\n")
    }

    private func emitStringEnum(name: String, def: StringEnumDef) -> String {
        var lines: [String] = []

        lines.append("  \(name):")
        lines.append("    kind: string_enum")
        lines.append("    direction: \(def.direction.rawValue)")

        if let handling = def.unknownHandling {
            lines.append("    unknown_handling: \(handling.rawValue)")
        }
        if let fallback = def.fallbackValue {
            lines.append("    fallback_value: \(fallback)")
        }

        if !def.values.isEmpty {
            lines.append("    values:")

            // Sort values for consistent output
            let sortedValues = def.values.sorted { $0.key < $1.key }

            for (caseName, rawValue) in sortedValues {
                if caseName == rawValue {
                    lines.append("      \(caseName): \"\(rawValue)\"")
                } else {
                    lines.append("      \(caseName): \"\(rawValue)\"")
                }
            }
        }

        return lines.joined(separator: "\n")
    }

    private func emitUnion(name: String, def: UnionDef) -> String {
        var lines: [String] = []

        lines.append("  \(name):")
        lines.append("    kind: union")
        lines.append("    direction: \(def.direction.rawValue)")

        if let disc = def.discriminator {
            lines.append("    discriminator:")
            lines.append("      field: \(disc.field)")
            lines.append("      location: \(disc.location.rawValue)")
        } else {
            lines.append("    discriminator: none")
        }

        if let handling = def.unknownHandling {
            lines.append("    unknown_handling: \(handling.rawValue)")
        }
        if let fallback = def.fallbackVariant {
            lines.append("    fallback_variant: \(fallback)")
        }

        if !def.variants.isEmpty {
            lines.append("    variants:")

            // Sort variants for consistent output
            let sortedVariants = def.variants.sorted { $0.key < $1.key }

            for (variantName, variant) in sortedVariants {
                lines.append("      \(variantName):")

                if let jsonValue = variant.jsonValue {
                    lines.append("        json_value: \"\(jsonValue)\"")
                }
                if let payload = variant.payload {
                    lines.append("        payload: \(payload)")
                }
                if let type = variant.type {
                    lines.append("        type: \"\(type)\"")
                }
                if let sugar = variant.literalSugar {
                    lines.append("        literal_sugar: \(sugar)")
                }
                if let fields = variant.fields, !fields.isEmpty {
                    lines.append("        fields:")
                    let sortedFields = fields.sorted { $0.key < $1.key }
                    for (fieldName, field) in sortedFields {
                        lines.append("          \(fieldName):")
                        lines.append("            type: \"\(field.type)\"")
                        if let json = field.json {
                            lines.append("            json: \(json)")
                        }
                        if field.required {
                            lines.append("            required: true")
                        }
                    }
                }
            }
        }

        return lines.joined(separator: "\n")
    }

    private func emitAlias(name: String, def: AliasDef) -> String {
        var lines: [String] = []

        lines.append("  \(name):")
        lines.append("    kind: alias")
        lines.append("    target: \(def.target)")

        if def.deprecated {
            lines.append("    deprecated: true")
        }
        if let doc = def.doc {
            lines.append("    doc: \"\(escapeYAML(doc))\"")
        }

        return lines.joined(separator: "\n")
    }

    private func escapeYAML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: " ")
    }

    private func truncate(_ string: String, to length: Int) -> String {
        if string.count <= length {
            return string
        }
        return String(string.prefix(length - 3)) + "..."
    }
}
