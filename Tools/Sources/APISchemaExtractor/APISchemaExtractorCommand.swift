import ArgumentParser
import Foundation

@main
struct APISchemaExtractor: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "api-schema-extract",
        abstract: "Extract API schema from Swift source files",
        discussion: """
            Parses Swift source files and extracts type definitions into a YAML schema.
            The schema can then be used to generate SDK code in multiple languages.
            """
    )

    @Argument(help: "Path to the Swift source directory to extract from")
    var inputPath: String

    @Option(name: .shortAndLong, help: "Output YAML file path")
    var output: String = "schema.yaml"

    @Option(name: .shortAndLong, help: "Provider name (e.g., Anthropic, OpenAI)")
    var provider: String = "Unknown"

    @Flag(name: .shortAndLong, help: "Enable verbose output")
    var verbose: Bool = false

    mutating func run() throws {
        let inputURL = URL(fileURLWithPath: inputPath)

        guard FileManager.default.fileExists(atPath: inputPath) else {
            throw ValidationError("Input path does not exist: \(inputPath)")
        }

        if verbose {
            print("Extracting schema from: \(inputPath)")
            print("Provider: \(provider)")
        }

        let extractor = SwiftSchemaExtractor(verbose: verbose)
        let schema = try extractor.extract(from: inputURL, provider: provider)

        let emitter = YAMLEmitter()
        let yaml = emitter.emit(schema)

        try yaml.write(toFile: output, atomically: true, encoding: .utf8)

        print("Schema written to: \(output)")
        print("Extracted \(schema.types.count) types")
    }
}
