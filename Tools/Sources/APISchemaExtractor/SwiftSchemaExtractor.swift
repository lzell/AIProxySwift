import Foundation
import SwiftParser
import SwiftSyntax

/// Extracts API schema from Swift source files
class SwiftSchemaExtractor {
    let verbose: Bool

    init(verbose: Bool = false) {
        self.verbose = verbose
    }

    func extract(from directory: URL, provider: String) throws -> APISchema {
        var schema = APISchema(provider: provider)

        let files = try findSwiftFiles(in: directory)
        if verbose {
            print("Found \(files.count) Swift files")
        }

        for file in files {
            let source = try String(contentsOf: file, encoding: .utf8)
            let syntax = Parser.parse(source: source)
            let visitor = TypeVisitor(verbose: verbose)
            visitor.walk(syntax)

            for (name, def) in visitor.types {
                schema.types[name] = def
            }
        }

        return schema
    }

    private func findSwiftFiles(in directory: URL) throws -> [URL] {
        let fm = FileManager.default
        var files: [URL] = []

        guard let enumerator = fm.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return files
        }

        for case let fileURL as URL in enumerator {
            if fileURL.pathExtension == "swift" {
                files.append(fileURL)
            }
        }

        return files
    }
}

/// Visits Swift syntax to extract type definitions
class TypeVisitor: SyntaxVisitor {
    var types: [String: TypeDefinition] = [:]
    let verbose: Bool

    init(verbose: Bool) {
        self.verbose = verbose
        super.init(viewMode: .sourceAccurate)
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.name.text
        if verbose {
            print("  Found struct: \(name)")
        }

        let direction = extractDirection(from: node.inheritanceClause)
        let fields = extractFields(from: node.memberBlock)
        let codingKeys = extractCodingKeys(from: node.memberBlock)
        let doc = extractDocComment(from: node)

        var fieldDefs: [String: FieldDef] = [:]
        for field in fields {
            var jsonKey = codingKeys[field.name] ?? field.name
            if jsonKey == field.name {
                jsonKey = field.name  // Will omit in YAML if same
            }
            fieldDefs[field.name] = FieldDef(
                type: field.type,
                json: codingKeys[field.name],
                required: !field.isOptional,
                doc: field.doc
            )
        }

        types[name] = .structType(StructDef(
            direction: direction,
            doc: doc,
            fields: fieldDefs
        ))

        return .skipChildren
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.name.text
        if verbose {
            print("  Found enum: \(name)")
        }

        let direction = extractDirection(from: node.inheritanceClause)
        let isStringEnum = isRawStringEnum(node.inheritanceClause)

        if isStringEnum {
            let values = extractStringEnumCases(from: node.memberBlock)
            let hasFutureProof = values.keys.contains("futureProof")
            let hasCustomDecoder = hasCustomInit(in: node.memberBlock)

            types[name] = .stringEnum(StringEnumDef(
                direction: direction,
                unknownHandling: hasFutureProof && hasCustomDecoder ? .fallback : nil,
                fallbackValue: hasFutureProof ? "futureProof" : nil,
                values: values.filter { $0.key != "futureProof" }
            ))
        } else {
            // It's a union type
            let unionInfo = extractUnionInfo(from: node)
            types[name] = .union(unionInfo)
        }

        return .skipChildren
    }

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.name.text
        let target = node.initializer.value.description.trimmingCharacters(in: .whitespaces)
        let doc = extractDocComment(from: node)
        let deprecated = doc?.lowercased().contains("deprecated") ?? false
        || doc?.lowercased().contains("backwards-compat") ?? false

        if verbose {
            print("  Found typealias: \(name) = \(target)")
        }

        types[name] = .alias(AliasDef(
            target: target,
            deprecated: deprecated,
            doc: doc
        ))

        return .skipChildren
    }

    // MARK: - Helper Methods

    private func extractDirection(from inheritanceClause: InheritanceClauseSyntax?) -> Direction {
        guard let clause = inheritanceClause else { return .both }

        let types = clause.inheritedTypes.map { $0.type.description.trimmingCharacters(in: .whitespaces) }

        let hasEncodable = types.contains("Encodable")
        let hasDecodable = types.contains("Decodable")
        let hasCodable = types.contains("Codable")

        if hasCodable || (hasEncodable && hasDecodable) {
            return .both
        } else if hasEncodable {
            return .encode
        } else if hasDecodable {
            return .decode
        }
        return .both
    }

    private func isRawStringEnum(_ inheritanceClause: InheritanceClauseSyntax?) -> Bool {
        guard let clause = inheritanceClause else { return false }
        let types = clause.inheritedTypes.map { $0.type.description.trimmingCharacters(in: .whitespaces) }
        return types.contains("String")
    }

    private func extractFields(from memberBlock: MemberBlockSyntax) -> [(name: String, type: String, isOptional: Bool, doc: String?)] {
        var fields: [(name: String, type: String, isOptional: Bool, doc: String?)] = []

        for member in memberBlock.members {
            if let varDecl = member.decl.as(VariableDeclSyntax.self) {
                for binding in varDecl.bindings {
                    if let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
                       let typeAnnotation = binding.typeAnnotation {
                        let name = identifier.identifier.text
                        let typeString = typeAnnotation.type.description.trimmingCharacters(in: .whitespaces)
                        let isOptional = typeString.hasSuffix("?")
                        let doc = extractDocComment(from: varDecl)

                        fields.append((name: name, type: normalizeType(typeString), isOptional: isOptional, doc: doc))
                    }
                }
            }
        }

        return fields
    }

    private func extractCodingKeys(from memberBlock: MemberBlockSyntax) -> [String: String] {
        var keys: [String: String] = [:]

        for member in memberBlock.members {
            if let enumDecl = member.decl.as(EnumDeclSyntax.self),
               enumDecl.name.text == "CodingKeys" {
                for caseMember in enumDecl.memberBlock.members {
                    if let caseDecl = caseMember.decl.as(EnumCaseDeclSyntax.self) {
                        for element in caseDecl.elements {
                            let caseName = element.name.text
                            if let rawValue = element.rawValue {
                                let rawString = rawValue.value.description
                                    .trimmingCharacters(in: .whitespaces)
                                    .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                                keys[caseName] = rawString
                            }
                        }
                    }
                }
            }
        }

        return keys
    }

    private func extractStringEnumCases(from memberBlock: MemberBlockSyntax) -> [String: String] {
        var cases: [String: String] = [:]

        for member in memberBlock.members {
            if let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) {
                for element in caseDecl.elements {
                    let caseName = element.name.text
                    if let rawValue = element.rawValue {
                        let rawString = rawValue.value.description
                            .trimmingCharacters(in: .whitespaces)
                            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        cases[caseName] = rawString
                    } else {
                        // No explicit raw value, use case name
                        cases[caseName] = caseName
                    }
                }
            }
        }

        return cases
    }

    private func hasCustomInit(in memberBlock: MemberBlockSyntax) -> Bool {
        for member in memberBlock.members {
            if let initDecl = member.decl.as(InitializerDeclSyntax.self) {
                let params = initDecl.signature.parameterClause.parameters
                if params.count == 1,
                   params.first?.firstName.text == "from" {
                    return true
                }
            }
        }
        return false
    }

    private func extractUnionInfo(from enumDecl: EnumDeclSyntax) -> UnionDef {
        let direction = extractDirection(from: enumDecl.inheritanceClause)
        var variants: [String: VariantDef] = [:]
        var hasFutureProof = false
        var discriminatorField: String?
        var usesSingleValueContainer = false

        // Extract discriminator mappings from init(from decoder:) or encode(to:)
        var jsonValueMappings: [String: String] = [:]  // caseName -> jsonValue

        // Analyze the encode/decode methods to determine discriminator
        for member in enumDecl.memberBlock.members {
            if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
                let body = funcDecl.body?.description ?? ""
                if body.contains("singleValueContainer") {
                    usesSingleValueContainer = true
                }
                if body.contains("forKey: .type") {
                    discriminatorField = "type"
                }
                // Extract from encode(to:) method
                if funcDecl.name.text == "encode",
                   let bodyBlock = funcDecl.body {
                    let encodeMappings = extractEncodeSwitchMappings(from: bodyBlock)
                    jsonValueMappings.merge(encodeMappings) { _, new in new }
                }
            }
            if let initDecl = member.decl.as(InitializerDeclSyntax.self) {
                let body = initDecl.body?.description ?? ""
                if body.contains("forKey: .type") {
                    discriminatorField = "type"
                }
                // Extract from init(from decoder:) method
                if let bodyBlock = initDecl.body {
                    let decodeMappings = extractDecodeSwitchMappings(from: bodyBlock)
                    jsonValueMappings.merge(decodeMappings) { _, new in new }
                }
            }
        }

        // Extract cases
        for member in enumDecl.memberBlock.members {
            if let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) {
                for element in caseDecl.elements {
                    let caseName = element.name.text
                    if caseName == "futureProof" {
                        hasFutureProof = true
                        continue
                    }

                    // Get the json value from our mappings, or use nil to indicate it should use case name
                    let jsonValue = jsonValueMappings[caseName]

                    if let params = element.parameterClause {
                        // Has associated values
                        let paramList = params.parameters
                        if paramList.count == 1,
                           let first = paramList.first {
                            // Single associated type
                            let typeName = first.type.description.trimmingCharacters(in: .whitespaces)
                            variants[caseName] = VariantDef(
                                jsonValue: jsonValue,
                                payload: typeName,
                                type: nil,
                                fields: nil,
                                literalSugar: nil
                            )
                        } else {
                            // Multiple parameters - extract as fields
                            var fields: [String: FieldDef] = [:]
                            for param in paramList {
                                let firstName = param.firstName?.text ?? "_"
                                let paramName = (firstName == "_" ? param.secondName?.text : firstName) ?? "value"
                                let paramType = param.type.description.trimmingCharacters(in: .whitespaces)
                                fields[paramName] = FieldDef(
                                    type: normalizeType(paramType),
                                    json: nil,
                                    required: !paramType.hasSuffix("?"),
                                    doc: nil
                                )
                            }
                            variants[caseName] = VariantDef(
                                jsonValue: jsonValue ?? caseName,
                                payload: nil,
                                type: nil,
                                fields: fields,
                                literalSugar: nil
                            )
                        }
                    } else {
                        // No associated values
                        variants[caseName] = VariantDef(
                            jsonValue: jsonValue ?? caseName,
                            payload: nil,
                            type: nil,
                            fields: nil,
                            literalSugar: nil
                        )
                    }
                }
            }
        }

        return UnionDef(
            direction: direction,
            discriminator: usesSingleValueContainer ? nil : discriminatorField.map {
                Discriminator(field: $0, location: .inline)
            },
            unknownHandling: hasFutureProof ? .fallback : nil,
            fallbackVariant: hasFutureProof ? "futureProof" : nil,
            variants: variants
        )
    }

    /// Extract case name -> json value mappings from init(from decoder:) body
    /// Uses regex to find patterns like: case "text": self = .textBlock(...)
    private func extractDecodeSwitchMappings(from body: CodeBlockSyntax) -> [String: String] {
        var mappings: [String: String] = [:]
        let bodyText = body.description

        // Find all patterns like: case "json_value": ... self = .caseName
        // Pattern: case "value": followed eventually by self = .caseName
        let pattern = #"case\s+"([^"]+)"[^:]*:[\s\S]*?self\s*=\s*\.(\w+)"#

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(bodyText.startIndex..., in: bodyText)
            let matches = regex.matches(in: bodyText, options: [], range: range)

            for match in matches {
                if match.numberOfRanges >= 3,
                   let jsonValueRange = Range(match.range(at: 1), in: bodyText),
                   let caseNameRange = Range(match.range(at: 2), in: bodyText) {
                    let jsonValue = String(bodyText[jsonValueRange])
                    let caseName = String(bodyText[caseNameRange])
                    mappings[caseName] = jsonValue
                }
            }
        } catch {
            // Regex failed, return empty mappings
        }

        return mappings
    }

    /// Extract case name -> json value mappings from encode(to:) body
    /// Uses regex to find patterns like: case .caseName: ... encode("json_value", forKey: .type)
    private func extractEncodeSwitchMappings(from body: CodeBlockSyntax) -> [String: String] {
        var mappings: [String: String] = [:]
        let bodyText = body.description

        // Find patterns like: case .caseName ... encode("value", forKey: .type)
        // This is trickier because the case and encode are on different lines
        // We'll look for case .name followed by encode("value" with forKey: .type

        // First, split by case statements
        let casePattern = #"case\s+\.(\w+)[^:]*:([^}]+?)(?=case\s+\.|default:|$)"#

        do {
            let regex = try NSRegularExpression(pattern: casePattern, options: [.dotMatchesLineSeparators])
            let range = NSRange(bodyText.startIndex..., in: bodyText)
            let matches = regex.matches(in: bodyText, options: [], range: range)

            for match in matches {
                if match.numberOfRanges >= 3,
                   let caseNameRange = Range(match.range(at: 1), in: bodyText),
                   let bodyRange = Range(match.range(at: 2), in: bodyText) {
                    let caseName = String(bodyText[caseNameRange])
                    let caseBody = String(bodyText[bodyRange])

                    // Look for encode("value", forKey: .type) in this case body
                    let encodePattern = #"encode\s*\(\s*"([^"]+)"\s*,\s*forKey:\s*\.type"#
                    if let encodeRegex = try? NSRegularExpression(pattern: encodePattern),
                       let encodeMatch = encodeRegex.firstMatch(in: caseBody, range: NSRange(caseBody.startIndex..., in: caseBody)),
                       encodeMatch.numberOfRanges >= 2,
                       let valueRange = Range(encodeMatch.range(at: 1), in: caseBody) {
                        let jsonValue = String(caseBody[valueRange])
                        mappings[caseName] = jsonValue
                    }
                }
            }
        } catch {
            // Regex failed, return empty mappings
        }

        return mappings
    }

    private func extractDocComment(from node: some SyntaxProtocol) -> String? {
        let trivia = node.leadingTrivia
        var docLines: [String] = []

        for piece in trivia {
            switch piece {
            case .docLineComment(let comment):
                let line = comment.dropFirst(3).trimmingCharacters(in: .whitespaces)
                docLines.append(line)
            case .docBlockComment(let comment):
                let content = comment.dropFirst(3).dropLast(2)
                docLines.append(String(content).trimmingCharacters(in: .whitespacesAndNewlines))
            default:
                break
            }
        }

        return docLines.isEmpty ? nil : docLines.joined(separator: " ")
    }

    private func normalizeType(_ type: String) -> String {
        var t = type.trimmingCharacters(in: .whitespaces)

        // Remove optional suffix for base type analysis
        let isOptional = t.hasSuffix("?")
        if isOptional {
            t = String(t.dropLast())
        }

        // Convert Swift types to schema types
        if t.hasPrefix("[") && t.hasSuffix("]") {
            let inner = String(t.dropFirst().dropLast())
            t = "list[\(normalizeType(inner))]"
        } else if t.hasPrefix("[") && t.contains(":") {
            // Dictionary
            let parts = t.dropFirst().dropLast().split(separator: ":")
            if parts.count == 2 {
                let key = normalizeType(String(parts[0]))
                let value = normalizeType(String(parts[1]))
                t = "map[\(key), \(value)]"
            }
        } else {
            // Primitive type mapping
            switch t {
            case "String": t = "string"
            case "Int": t = "int"
            case "Double", "Float": t = "float"
            case "Bool": t = "bool"
            case "AIProxyJSONValue": t = "any"
            default: break  // Keep as-is (custom type reference)
            }
        }

        return isOptional ? "\(t)?" : t
    }
}
