//
//  OpenAIMessageContent.swift
//  AIProxy
//
//  Created by Lou Zell on 12/22/25.
//
// OpenAPI spec: Message content, version 2.3.0, line 23097

/// Content of a message.
nonisolated public enum OpenAIMessageContent: Decodable, Sendable {
    case computerScreenshot(OpenAIComputerScreenshotContentResource)
    case inputFile(OpenAIInputFileContentResource)
    case inputImage(OpenAIInputImageContentResource)
    case inputText(OpenAIInputTextContentResource)
    case outputText(OpenAIOutputTextContentResource)
    case reasoningText(OpenAIReasoningTextContentResource)
    case refusal(OpenAIRefusalContentResource)
    case summaryText(OpenAISummaryTextContentResource)
    case text(OpenAITextContentResource)

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "computer_screenshot":
            self = .computerScreenshot(try OpenAIComputerScreenshotContentResource(from: decoder))
        case "input_file":
            self = .inputFile(try OpenAIInputFileContentResource(from: decoder))
        case "input_image":
            self = .inputImage(try OpenAIInputImageContentResource(from: decoder))
        case "input_text":
            self = .inputText(try OpenAIInputTextContentResource(from: decoder))
        case "output_text":
            self = .outputText(try OpenAIOutputTextContentResource(from: decoder))
        case "reasoning_text":
            self = .reasoningText(try OpenAIReasoningTextContentResource(from: decoder))
        case "refusal":
            self = .refusal(try OpenAIRefusalContentResource(from: decoder))
        case "summary_text":
            self = .summaryText(try OpenAISummaryTextContentResource(from: decoder))
        case "text":
            self = .text(try OpenAITextContentResource(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown message content type: \(type)"
            )
        }
    }
}

// MARK: - Input Text Content

/// A text input to the model.
nonisolated public struct OpenAIInputTextContentResource: Decodable, Sendable {
    /// The text input to the model.
    public let text: String

    /// The type of the input item. Always `input_text`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}

// MARK: - Output Text Content

/// A text output from the model.
nonisolated public struct OpenAIOutputTextContentResource: Decodable, Sendable {
    /// The annotations of the text output.
    public let annotations: [OpenAIAnnotation]

    /// The text output from the model.
    public let text: String

    /// The type of the output text. Always `output_text`.
    public let type: String

    /// Log probabilities for tokens (optional).
    public let logprobs: [OpenAILogProb]?

    private enum CodingKeys: String, CodingKey {
        case annotations
        case text
        case type
        case logprobs
    }
}

// MARK: - Text Content

/// A text content.
nonisolated public struct OpenAITextContentResource: Decodable, Sendable {
    /// The text.
    public let text: String

    /// The type of the content. Always `text`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}

// MARK: - Summary Text Content

/// A summary text from the model.
nonisolated public struct OpenAISummaryTextContentResource: Decodable, Sendable {
    /// A summary of the reasoning output from the model so far.
    public let text: String

    /// The type of the object. Always `summary_text`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}

// MARK: - Reasoning Text Content

/// Reasoning text from the model.
nonisolated public struct OpenAIReasoningTextContentResource: Decodable, Sendable {
    /// The reasoning text from the model.
    public let text: String

    /// The type of the reasoning text. Always `reasoning_text`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case text
        case type
    }
}

// MARK: - Refusal Content

/// A refusal from the model.
nonisolated public struct OpenAIRefusalContentResource: Decodable, Sendable {
    /// The refusal explanation from the model.
    public let refusal: String

    /// The type of the refusal. Always `refusal`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case refusal
        case type
    }
}

// MARK: - Input Image Content

/// An image input to the model.
///
/// Learn about [image inputs](https://platform.openai.com/docs/guides/vision).
nonisolated public struct OpenAIInputImageContentResource: Decodable, Sendable {
    /// The detail level of the image to be sent to the model.
    ///
    /// One of `high`, `low`, or `auto`. Defaults to `auto`.
    public let detail: OpenAIImageDetailResource

    /// The type of the input item. Always `input_image`.
    public let type: String

    /// The ID of the file to be sent to the model.
    public let fileID: String?

    /// The URL of the image to be sent to the model.
    ///
    /// A fully qualified URL or base64 encoded image in a data URL.
    public let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case detail
        case type
        case fileID = "file_id"
        case imageURL = "image_url"
    }
}

/// The detail level of an image.
nonisolated public enum OpenAIImageDetailResource: String, Decodable, Sendable {
    case auto
    case high
    case low
}

// MARK: - Computer Screenshot Content

/// A screenshot of a computer.
nonisolated public struct OpenAIComputerScreenshotContentResource: Decodable, Sendable {
    /// The identifier of an uploaded file that contains the screenshot.
    public let fileID: String?

    /// The URL of the screenshot image.
    public let imageURL: String?

    /// Specifies the event type. For a computer screenshot, this property is always set to `computer_screenshot`.
    public let type: String

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case imageURL = "image_url"
        case type
    }
}

// MARK: - Input File Content

/// A file input to the model.
nonisolated public struct OpenAIInputFileContentResource: Decodable, Sendable {
    /// The type of the input item. Always `input_file`.
    public let type: String

    /// The content of the file to be sent to the model.
    public let fileData: String?

    /// The ID of the file to be sent to the model.
    public let fileID: String?

    /// The URL of the file to be sent to the model.
    public let fileURL: String?

    /// The name of the file to be sent to the model.
    public let filename: String?

    private enum CodingKeys: String, CodingKey {
        case type
        case fileData = "file_data"
        case fileID = "file_id"
        case fileURL = "file_url"
        case filename
    }
}
