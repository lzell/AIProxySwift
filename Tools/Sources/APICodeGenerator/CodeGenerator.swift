import Foundation

protocol CodeGenerator {
    func generate(from schema: APISchema) -> [(filename: String, content: String)]
}
