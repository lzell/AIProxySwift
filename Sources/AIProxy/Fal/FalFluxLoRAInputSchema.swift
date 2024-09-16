//
//  FalFluxLoRAInputSchema.swift
//
//
//  Created by Lou Zell on 10/4/24.
//

import Foundation

/// Use this type for inference after training a LoRA with `FalFluxLoRAFastTrainingInputSchema`.
/// Docstrings taken from the tooltips here: https://fal.ai/models/fal-ai/flux-lora
public struct FalFluxLoRAInputSchema: Encodable {
    // Required

    /// The prompt to generate an image from.
    public let prompt: String

    // Optional

    /// If set to true, the safety checker will be enabled. Default value: true
    public let enableSafetyChecker: Bool?

    /// The CFG (Classifier Free Guidance) scale is a measure of how close you want the model
    /// to stick to your prompt when looking for a related image to show you.
    /// Default value: `3.5`
    public let guidanceScale: Double?

    /// The size of the generated image.
    /// Default value: `.landscape4x3`
    public let imageSize: ImageSize?

    /// The list of LoRA weights to use.
    public let loras: [Lora]?

    /// The number of images to generate.
    /// Default value: `1`
    public let numImages: Int?

    /// The number of inference steps to perform.
    /// Default value: `28`
    public let numInferenceSteps: Int?

    /// The format of the generated image. Default value: `.jpeg`
    public let outputFormat: OutputFormat?

    /// The same seed and the same prompt given to the same version of the model will output the same image every time.
    public let seed: Int?

    /// If set to true, the function will wait for the image to be generated and uploaded
    /// before returning the response. This will increase the latency of the function but it
    /// allows you to get the image directly in the response without going through the CDN.
    public let syncMode: Bool?

    private enum CodingKeys: String, CodingKey {
        case enableSafetyChecker = "enable_safety_checker"
        case guidanceScale = "guidance_scale"
        case imageSize = "image_size"
        case loras
        case numImages = "num_images"
        case numInferenceSteps = "num_inference_steps"
        case outputFormat = "output_format"
        case prompt
        case seed
        case syncMode = "sync_mode"
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        prompt: String,
        enableSafetyChecker: Bool? = nil,
        guidanceScale: Double? = nil,
        imageSize: FalFluxLoRAInputSchema.ImageSize? = nil,
        loras: [FalFluxLoRAInputSchema.Lora]? = nil,
        numImages: Int? = nil,
        numInferenceSteps: Int? = nil,
        outputFormat: FalFluxLoRAInputSchema.OutputFormat? = nil,
        seed: Int? = nil,
        syncMode: Bool? = nil
    ) {
        self.prompt = prompt
        self.enableSafetyChecker = enableSafetyChecker
        self.guidanceScale = guidanceScale
        self.imageSize = imageSize
        self.loras = loras
        self.numImages = numImages
        self.numInferenceSteps = numInferenceSteps
        self.outputFormat = outputFormat
        self.seed = seed
        self.syncMode = syncMode
    }

}

// MARK: - InputSchema.ImageSize
public extension FalFluxLoRAInputSchema {
    enum ImageSize: String, Encodable {
        case landscape16x9 = "landscape_16_9"
        case landscape4x3 = "landscape_4_3"
        case portrait16x9 = "portrait_16_9"
        case portrait4x3 = "portrait_4_3"
        case square
        case squareHD = "square_hd"
    }
}

// MARK: - InputSchema.Lora
public extension FalFluxLoRAInputSchema {
    struct Lora: Encodable {
        // Required
        /// URL to the LoRA weights.
        public let path: URL

        /// The scale of the LoRA weight. This is used to scale the LoRA weight before merging it with the base model.
        /// Default value: `1`
        public let scale: Double?

        public init(
            path: URL,
            scale: Double? = nil
        ) {
            self.path = path
            self.scale = scale
        }
    }
}

// MARK: - InputSchema.OutputFormat
public extension FalFluxLoRAInputSchema {
    enum OutputFormat: String, Encodable {
        case jpeg
        case png
    }
}
