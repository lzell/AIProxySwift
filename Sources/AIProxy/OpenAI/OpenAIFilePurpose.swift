//
//  OpenAIFilePurpose.swift
//  AIProxy
//
//  Created by Lou Zell on 7/7/25.
//

public enum OpenAIFilePurpose: String {
    /// Used in the Assistants API
    case assistants

    /// Used in the Batch API
    case batch

    /// Used for eval data sets
    case evals

    /// Used for fine-tuning
    case fineTune = "fine-tune"

    /// Flexible file type for any purpose
    case userData = "user_data"

    /// Images used for vision fine-tuning
    case vision
}
