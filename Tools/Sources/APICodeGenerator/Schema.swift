import Foundation

/// Root schema structure
struct APISchema {
    var version: String = "1.0"
    var provider: String
    var types: [String: TypeDefinition] = [:]
}

/// A type definition in the schema
enum TypeDefinition {
    case structType(StructDef)
    case stringEnum(StringEnumDef)
    case union(UnionDef)
    case alias(AliasDef)
}

/// Struct with fields
struct StructDef {
    var direction: Direction
    var doc: String?
    var fields: [String: FieldDef]
}

struct FieldDef {
    var type: String
    var json: String?
    var required: Bool
    var doc: String?
}

/// String enum with raw values
struct StringEnumDef {
    var direction: Direction
    var unknownHandling: UnknownHandling?
    var fallbackValue: String?
    var values: [String: String]  // caseName: rawValue
}

/// Discriminated union
struct UnionDef {
    var direction: Direction
    var discriminator: Discriminator?
    var unknownHandling: UnknownHandling?
    var fallbackVariant: String?
    var variants: [String: VariantDef]
}

struct Discriminator {
    var field: String
    var location: DiscriminatorLocation
}

enum DiscriminatorLocation: String {
    case inline
    case wrapper
}

struct VariantDef {
    var jsonValue: String?
    var payload: String?
    var type: String?
    var fields: [String: FieldDef]?
    var literalSugar: String?
}

/// Type alias
struct AliasDef {
    var target: String
    var deprecated: Bool
    var doc: String?
}

/// Encoding/decoding direction
enum Direction: String {
    case encode
    case decode
    case both
}

/// How to handle unknown values
enum UnknownHandling: String {
    case fallback
    case error
}
