//
//  ReplicateSDXLFreshInkInputSchema.swift
//
//
//  Created by Lou Zell on 11/7/24.
//
import Foundation

/// Input schema for use with requests to  fofr/sdxl-fresh-ink SDXL model:
/// https://replicate.com/fofr/sdxl-fresh-ink/versions/8515c238222fa529763ec99b4ba1fa9d32ab5d6ebc82b4281de99e4dbdcec943/api
///
/// It's recommended to use a negative prompt with this model, for example:
///
///     let input = ReplicateSDXLFreshInkInputSchema(
///         prompt: "A fresh ink TOK tattoo of monument valley, Utah",
///         negativePrompt: "ugly, broken, distorted"
///     )
///     let urls = try await replicateService.createSDXLFreshInkImageURLs(
///         input: input
///     )
public struct ReplicateSDXLFreshInkInputSchema: Encodable {

    // Required

    /// For example, "An astronaut riding a rainbow unicorn"
    public let prompt: String

    // Optional

    /// Applies a watermark to enable determining if an image is generated in downstream
    /// applications. If you have other provisions for generating or deploying images safely,
    /// you can use this to disable watermarking.
    /// Default: true
    public let applyWatermark: Bool?

    /// Disable safety checker for generated images. This feature is only available through the API. See https://replicate.com/docs/how-does-replicate-work#safety
    /// Default: false
    public let disableSafetyChecker: Bool?

    /// Scale for classifier-free guidance
    /// (minimum: 1, maximum: 50)
    /// Default: 7.5
    public let guidanceScale: Int?

    /// Height of output image
    ///
    /// Default: 1024
    public let height: Int?

    /// For expert_ensemble_refiner, the fraction of noise to use
    /// (minimum: 0, maximum: 1)
    /// Default: 0.8
    public let highNoiseFrac: Double?

    /// Input image for img2img or inpaint mode
    public let image: URL?

    /// LoRA additive scale. Only applicable on trained models.
    /// (minimum: 0, maximum: 1)
    /// Default: 0.6
    public let loraScale: Double?

    /// Input mask for inpaint mode. Black areas will be preserved, white areas will be inpainted.
    public let mask: URL?

    /// Input Negative Prompt
    /// Default: ""
    public let negativePrompt: String?

    /// (minimum: 1, maximum: 500)
    /// Number of denoising steps
    /// Default: 50
    public let numInferenceSteps: Int?

    /// The number of images to output
    /// Minimum: 1, Maximum: 4
    /// Default: 1
    public let numOutputs: Int?

    /// Prompt strength when using img2img / inpaint. 1.0 corresponds to full destruction of information in image
    /// (minimum: 0, maximum: 1)
    /// Default: 0.8
    public let promptStrength: Double?

    /// Which refine style to use
    /// Default: "no_refiner"
    public let refine: Refiner?

    /// For base_image_refiner, the number of steps to refine, defaults to num_inference_steps
    public let refineSteps: Int?

    /// Random seed. Leave blank to randomize the seed
    public let seed: Int?

    /// Default: "K_EULER"
    public let scheduler: Scheduler?

    /// Width of output image
    /// Default: 1024
    public let width: Int?

    private enum CodingKeys: String, CodingKey {
        case prompt

        case applyWatermark = "apply_watermark"
        case disableSafetyChecker = "disable_safety_checker"
        case guidanceScale = "guidance_scale"
        case height
        case highNoiseFrac = "high_noise_frac"
        case image
        case loraScale = "lora_scale"
        case mask
        case negativePrompt = "negative_prompt"
        case numInferenceSteps = "num_inference_steps"
        case numOutputs = "num_outputs"
        case promptStrength = "prompt_strength"
        case refine
        case refineSteps = "refine_steps"
        case scheduler
        case seed
        case width
    }


    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        prompt: String,
        applyWatermark: Bool? = nil,
        disableSafetyChecker: Bool? = nil,
        guidanceScale: Int? = nil,
        height: Int? = nil,
        highNoiseFrac: Double? = nil,
        image: URL? = nil,
        loraScale: Double? = nil,
        mask: URL? = nil,
        negativePrompt: String? = nil,
        numInferenceSteps: Int? = nil,
        numOutputs: Int? = nil,
        promptStrength: Double? = nil,
        refine: ReplicateSDXLFreshInkInputSchema.Refiner? = nil,
        refineSteps: Int? = nil,
        seed: Int? = nil,
        scheduler: ReplicateSDXLFreshInkInputSchema.Scheduler? = nil,
        width: Int? = nil
    ) {
        self.prompt = prompt
        self.applyWatermark = applyWatermark
        self.disableSafetyChecker = disableSafetyChecker
        self.guidanceScale = guidanceScale
        self.height = height
        self.highNoiseFrac = highNoiseFrac
        self.image = image
        self.loraScale = loraScale
        self.mask = mask
        self.negativePrompt = negativePrompt
        self.numInferenceSteps = numInferenceSteps
        self.numOutputs = numOutputs
        self.promptStrength = promptStrength
        self.refine = refine
        self.refineSteps = refineSteps
        self.seed = seed
        self.scheduler = scheduler
        self.width = width
    }
}

// MARK: - InputSchema.Refiner
extension ReplicateSDXLFreshInkInputSchema {
    public enum Refiner: String, Encodable {
        case baseImageRefiner = "base_image_refiner"
        case expertEnsembleRefiner = "expert_ensemble_refiner"
        case noRefiner = "no_refiner"
    }
}

// MARK: - InputSchema.Scheduler
extension ReplicateSDXLFreshInkInputSchema {
    public enum Scheduler: String, Encodable {
        case ddim = "DDIM"
        case dpmSolverMultistep = "DPMSolverMultistep"
        case heunDiscrete = "HeunDiscrete"
        case kEuler = "K_EULER"
        case kEulerAncestral = "K_EULER_ANCESTRAL"
        case karrasDPM = "KarrasDPM"
        case pndm = "PNDM"
    }
}