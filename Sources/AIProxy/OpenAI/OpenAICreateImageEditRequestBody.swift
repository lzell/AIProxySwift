//
//  OpenAICreateImageEditRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 4/23/25.
//

import Foundation

/// Creates an edited or extended image given one or more source images and a prompt.
/// https://platform.openai.com/docs/api-reference/images/createEdit
nonisolated public struct OpenAICreateImageEditRequestBody: MultipartFormEncodable {

    /// The images to edit. Must be a supported image file or an array of images.
    /// For gpt-image-1, each image should be a png, webp, or jpg file less than 25MB.
    /// For dall-e-2, you can only provide one image, and it should be a square png file less than 4MB.
    public let images: [InputImage]

    /// A text description of the desired image(s).
    /// The maximum length is 1000 characters for dall-e-2, and 32000 characters for gpt-image-1.
    public let prompt: String

    // MARK: Optional properties

    /// Allows to set transparency for the background of the generated image(s).
    /// This parameter is only supported for `gpt-image-1`.
    /// Must be one of `.transparent`, `.opaque` or `.auto` (default value).
    /// When `.auto` is used, the model will automatically determine the best background for the image.
    ///
    /// If `.transparent`, the `outputFormat` needs to support transparency, so it should be set to either `.png` (default value) or `.webp`
    public let background: Background?

    /// Control how much effort the model will exert to match the style and features, especially facial features, of input images.
    /// This parameter is only supported for gpt-image-1. Supports `high` and `low`. Defaults to `low`.
    ///
    /// High input fidelity allows you to make subtle edits to an image without altering unrelated areas.
    /// This is ideal for controlled, localized changes.
    ///
    /// Setting `inputFidelity=.high` is especially useful when editing images with faces, logos, or any other details that require high fidelity in the output.
    /// Source: https://cookbook.openai.com/examples/generate_images_with_high_input_fidelity
    public let inputFidelity: InputFidelity?

    /// An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where image should be edited.
    /// If there are multiple images provided, the mask will be applied on the first image.
    /// Must be a valid PNG file, less than 4MB, and have the same dimensions as image.
    public let mask: Data?

    /// The model to use for image generation. Only dall-e-2 and gpt-image-1 are supported.
    /// Defaults to dall-e-2 unless a parameter specific to gpt-image-1 is used.
    public let model: Model?

    /// The number of images to generate. Must be between 1 and 10.
    public let n: Int?

    /// The format in which the generated images are returned.
    /// This parameter is only supported for `gpt-image-1`.
    /// Must be one of `.png`, `.jpeg`, or `.webp`.
    /// The default value is `.png`
    public let outputFormat: OutputFormat?

    /// The quality of the image that will be generated.
    /// high, medium and low are only supported for gpt-image-1.
    /// dall-e-2 only supports standard quality. Defaults to auto.
    public let quality: Quality?

    /// The format in which the generated images are returned.
    /// Must be one of url or `b64_json`.
    /// URLs are only valid for 60 minutes after the image has been generated.
    /// This parameter is only supported for dall-e-2, as gpt-image-1 will always return base64-encoded images.
    public let responseFormat: ResponseFormat?

    /// The size of the generated images.
    /// - For gpt-image-1, one of `1024x1024`, `1536x1024` (landscape), `1024x1536` (portrait), or `auto` (default value)
    /// - For dall-e-2, one of `256x256`, `512x512`, or `1024x1024`
    public let size: String?

    /// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
    public let user: String?

    public var formFields: [FormField] {
        var builder: [FormField] = []
        self.setImageFormField(builder: &builder)
        return builder + [
            .textField(name: "prompt", content: self.prompt),
            self.background.flatMap { .textField(name: "background", content: $0.rawValue) },
            self.inputFidelity.flatMap { .textField(name: "input_fidelity", content: $0.rawValue) },
            self.model.flatMap { .textField(name: "model", content: $0.rawValue) },
            self.mask.flatMap { .fileField(name: "mask", content: $0, contentType: "image/png", filename: "tmpfile-mask") },
            self.n.flatMap { .textField(name: "n", content: String($0)) },
            self.outputFormat.flatMap { .textField(name: "output_format", content: $0.rawValue) },
            self.quality.flatMap { .textField(name: "quality", content: $0.rawValue) },
            self.responseFormat.flatMap { .textField(name: "response_format", content: $0.rawValue) },
            self.size.flatMap { .textField(name: "size", content: $0) },
            self.user.flatMap { .textField(name: "user", content: $0) }
        ].compactMap { $0 }
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        images: [OpenAICreateImageEditRequestBody.InputImage],
        prompt: String,
        background: Background? = nil,
        inputFidelity: OpenAICreateImageEditRequestBody.InputFidelity? = nil,
        mask: Data? = nil,
        model: OpenAICreateImageEditRequestBody.Model? = nil,
        n: Int? = nil,
        outputFormat: OutputFormat? = nil,
        quality: OpenAICreateImageEditRequestBody.Quality? = nil,
        responseFormat: OpenAICreateImageEditRequestBody.ResponseFormat? = nil,
        size: String? = nil,
        user: String? = nil
    ) {
        self.images = images
        self.prompt = prompt
        self.background = background
        self.inputFidelity = inputFidelity
        self.mask = mask
        self.model = model
        self.n = n
        self.outputFormat = outputFormat
        self.quality = quality
        self.responseFormat = responseFormat
        self.size = size
        self.user = user
    }

    private func setImageFormField(builder: inout [FormField]) {
        // If the user wants a dalle-2 edit, we can only allow a single image.
        // Also, OpenAI expects that dalle-2 sends an `image` not `image[]` part:
        if self.model == .dallE2, let img = self.images.first {
            builder.append(
                .fileField(
                    name: "image",
                    content: img.content,
                    contentType: img.contentType,
                    filename: "tmpfile"
                )
            )
        } else {
            for i in 0..<self.images.count {
                let img = self.images[i]
                builder.append(
                    .fileField(
                        name: "image[]",
                        content: img.content,
                        contentType: img.contentType,
                        filename: "tmpfile\(i)"
                    )
                )
            }
        }
    }
}


extension OpenAICreateImageEditRequestBody {

    nonisolated public enum Background: String, Sendable {
        case auto
        case opaque
        case transparent
    }

    nonisolated public enum InputFidelity: String, Sendable {
        case low
        case high
    }

    nonisolated public enum InputImage: Sendable {
        case png(Data)
        case jpeg(Data)

        public var content: Data {
            switch self {
            case let .png(data), let .jpeg(data):
                return data
            }
        }

        public var contentType: String {
            switch self {
            case .png:
                return "image/png"
            case .jpeg:
                return "image/jpeg"
            }
        }
    }

    nonisolated public enum Model: String, Encodable, Sendable {
        case dallE2 = "dall-e-2"
        case gptImage1 = "gpt-image-1"
        case gptImage1Mini = "gpt-image-1-mini"
    }

    nonisolated public enum OutputFormat: String, Sendable {
        case jpeg
        case png
        case webp
    }

    nonisolated public enum Quality: String, Encodable, Sendable {
        case auto

        /// Supported for gpt-image-1
        case high, medium, low

        /// dall-e-2 only supports standard quality
        case standard
    }

    nonisolated public enum ResponseFormat: String, Encodable, Sendable {
        case b64JSON = "b64_json"
        case url
    }
}
