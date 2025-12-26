import ArgumentParser
import Foundation

@main
struct APICodeGenerator: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "api-schema-generate",
        abstract: "Generate SDK code from API schema",
        discussion: """
            Reads a YAML schema file and generates SDK code in the specified language.
            Currently supports Swift, with plans for Python and TypeScript.
            """
    )

    @Argument(help: "Path to the YAML schema file")
    var schemaPath: String

    @Option(name: .shortAndLong, help: "Output directory for generated code")
    var output: String = "."

    @Option(name: .shortAndLong, help: "Target language (swift, python, typescript)")
    var language: String = "swift"

    @Option(name: .shortAndLong, help: "Type name prefix (e.g., Anthropic)")
    var prefix: String = ""

    @Flag(name: .shortAndLong, help: "Enable verbose output")
    var verbose: Bool = false

    mutating func run() throws {
        guard FileManager.default.fileExists(atPath: schemaPath) else {
            throw ValidationError("Schema file does not exist: \(schemaPath)")
        }

        if verbose {
            print("Reading schema from: \(schemaPath)")
            print("Output directory: \(output)")
            print("Language: \(language)")
        }

        let parser = YAMLSchemaParser()
        let schema = try parser.parse(from: URL(fileURLWithPath: schemaPath))

        let generator: CodeGenerator
        switch language.lowercased() {
        case "swift":
            generator = SwiftCodeGenerator(prefix: prefix, verbose: verbose)
        default:
            throw ValidationError("Unsupported language: \(language). Currently only 'swift' is supported.")
        }

        let files = generator.generate(from: schema)

        let outputURL = URL(fileURLWithPath: output)
        try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)

        for (filename, content) in files {
            let fileURL = outputURL.appendingPathComponent(filename)
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            if verbose {
                print("Generated: \(filename)")
            }
        }

        print("Generated \(files.count) files to: \(output)")
    }
}
