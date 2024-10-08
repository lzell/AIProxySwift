//
//  FalFluxLoRAFastTrainingInputSchema.swift
//
//
//  Created by Lou Zell on 9/15/24.
//

import Foundation


/// Docstrings taken from: https://fal.ai/models/fal-ai/flux-lora-fast-training/api#schema-input
public struct FalFluxLoRAFastTrainingInputSchema: Encodable {

    // Required

    /// URL to zip archive with images of a consistent style. Try to use at least 10 images,
    /// although more is better.
    ///
    /// In addition to images the archive can contain text files with captions. Each text file
    /// should have the same name as the image file it corresponds to.
    ///
    /// The captions can include a special string `[trigger]`. If a `trigger_word` is specified, it
    /// will replace `[trigger]` in the captions.
    public let imagesDataURL: URL

    // Optional

    /// If True segmentation masks will be used in the weight the training loss. For people a face
    /// mask is used if possible. Default value: true
    public let createMasks: Bool?

    /// The format of the archive. If not specified, the format will be inferred from the URL.
    public let dataArchiveFormat: String?

    /// Specifies whether the input data is already in a processed format. When set to False
    /// (default), the system expects raw input where image files and their corresponding caption
    /// files share the same name (e.g., 'photo.jpg' and 'photo.txt'). Set to True if your data is
    /// already in a preprocessed format.
    public let isInputFormatAlreadyPreprocessed: Bool?

    /// If True, the training will be for a style. This will deactivate segmentation, captioning
    /// and will use trigger word instead. Prompt with image of X in style of <trigger word>.
    public let isStyle: Bool?

    /// If you are willing to train multiple times, you can specify the multiplier. For example, if
    /// you specify 2, the training will run with twice the number of compute, with twice the cost.
    /// Default value: 1
    public let iterMultiplier: Double?

    /// Trigger word to be used in the captions. If None, a trigger word will not be used. If no
    /// captions are provided the `triggerWord` will be used instead of captions. If captions are
    /// provided, the trigger word will replace the [trigger] string in the captions.
    public let triggerWord: String?


    private enum CodingKeys: String, CodingKey {
        case createMasks = "create_masks"
        case dataArchiveFormat = "data_archive_format"
        case imagesDataURL = "images_data_url"
        case isInputFormatAlreadyPreprocessed = "is_input_format_already_preprocessed"
        case isStyle = "is_style"
        case iterMultiplier = "iter_multiplier"
        case triggerWord = "trigger_word"
    }

    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        imagesDataURL: URL,
        createMasks: Bool? = nil,
        dataArchiveFormat: String? = nil,
        isInputFormatAlreadyPreprocessed: Bool? = nil,
        isStyle: Bool? = nil,
        iterMultiplier: Double? = nil,
        triggerWord: String? = nil
    ) {
        self.imagesDataURL = imagesDataURL
        self.createMasks = createMasks
        self.dataArchiveFormat = dataArchiveFormat
        self.isInputFormatAlreadyPreprocessed = isInputFormatAlreadyPreprocessed
        self.isStyle = isStyle
        self.iterMultiplier = iterMultiplier
        self.triggerWord = triggerWord
    }
}
