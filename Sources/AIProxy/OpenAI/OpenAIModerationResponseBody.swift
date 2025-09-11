//
//  OpenAIModerationResponseBody.swift
//
//
//  Created by Lou Zell on 12/17/24.
//

import Foundation

/// Docstrings from https://platform.openai.com/docs/api-reference/moderations/object
nonisolated public struct OpenAIModerationResponseBody: Decodable, Sendable {

    /// The unique identifier for the moderation request.
    public let id: String?

    /// The model used to generate the moderation results.
    public let model: String?

    /// A list of moderation objects.
    public let results: [ModerationResult]

    public init(id: String?, model: String?, results: [ModerationResult]) {
        self.id = id
        self.model = model
        self.results = results
    }
}

// MARK: -
extension OpenAIModerationResponseBody {
    /// A moderation object.
    /// Represents if a given text input is potentially harmful.
    nonisolated public struct ModerationResult: Decodable, Sendable {
        /// A list of the categories along with the input type(s) that the score applies to.
        public let categoryAppliedInputTypes: CategoryAppliedInputTypes?

        /// A list of the categories along with their scores as predicted by model.
        public let categoryScores: CategoryScores?

        /// A list of the categories, and whether they are flagged or not.
        public let categories: Categories?

        /// Whether any of the below categories are flagged.
        public let flagged: Bool

        public init(categoryAppliedInputTypes: CategoryAppliedInputTypes?, categoryScores: CategoryScores?, categories: Categories?, flagged: Bool) {
            self.categoryAppliedInputTypes = categoryAppliedInputTypes
            self.categoryScores = categoryScores
            self.categories = categories
            self.flagged = flagged
        }

        private enum CodingKeys: String, CodingKey {
            case categoryAppliedInputTypes = "category_applied_input_types"
            case categoryScores = "category_scores"
            case categories
            case flagged
        }
    }

}

// MARK: -
extension OpenAIModerationResponseBody.ModerationResult {
    /// A list of the categories, and whether they are flagged or not.
    nonisolated public struct Categories: Decodable, Sendable {

        /// Content that expresses, incites, or promotes hate based on race, gender, ethnicity,
        /// religion, nationality, sexual orientation, disability status, or caste. Hateful
        /// content aimed at non-protected groups (e.g., chess players) is harassment.
        public let hate: Bool?

        /// Hateful content that also includes violence or serious harm towards the targeted
        /// group based on race, gender, ethnicity, religion, nationality, sexual orientation,
        /// disability status, or caste.
        public let hateThreatening: Bool?

        /// Content that expresses, incites, or promotes harassing language towards any target.
        public let harassment: Bool?

        /// Harassment content that also includes violence or serious harm towards any target.
        public let harassmentThreatening: Bool?

        /// Content that includes instructions or advice that facilitate the planning or
        /// execution of wrongdoing, or that gives advice or instruction on how to commit
        /// illicit acts. For example, "how to shoplift" would fit this category.
        public let illicit: Bool?

        /// Content that includes instructions or advice that facilitate the planning or
        /// execution of wrongdoing that also includes violence, or that gives advice or
        /// instruction on the procurement of any weapon.
        public let illicitViolent: Bool?

        /// Content meant to arouse sexual excitement, such as the description of sexual
        /// activity, or that promotes sexual services (excluding sex education and wellness).
        public let sexual: Bool?

        /// Sexual content that includes an individual who is under 18 years old.
        public let sexualMinors: Bool?

        /// Content that promotes, encourages, or depicts acts of self-harm, such as suicide,
        /// cutting, and eating disorders.
        public let selfHarm: Bool?

        /// Content where the speaker expresses that they are engaging or intend to engage in
        /// acts of self-harm, such as suicide, cutting, and eating disorders.
        public let selfHarmIntent: Bool?

        /// Content that encourages performing acts of self-harm, such as suicide, cutting, and
        /// eating disorders, or that gives instructions or advice on how to commit such acts.
        public let selfHarmInstructions: Bool?

        /// Content that depicts death, violence, or physical injury.
        public let violence: Bool?

        /// Content that depicts death, violence, or physical injury in graphic detail.
        public let violenceGraphic: Bool?

        public init(hate: Bool?, hateThreatening: Bool?, harassment: Bool?, harassmentThreatening: Bool?, illicit: Bool?, illicitViolent: Bool?, sexual: Bool?, sexualMinors: Bool?, selfHarm: Bool?, selfHarmIntent: Bool?, selfHarmInstructions: Bool?, violence: Bool?, violenceGraphic: Bool?) {
            self.hate = hate
            self.hateThreatening = hateThreatening
            self.harassment = harassment
            self.harassmentThreatening = harassmentThreatening
            self.illicit = illicit
            self.illicitViolent = illicitViolent
            self.sexual = sexual
            self.sexualMinors = sexualMinors
            self.selfHarm = selfHarm
            self.selfHarmIntent = selfHarmIntent
            self.selfHarmInstructions = selfHarmInstructions
            self.violence = violence
            self.violenceGraphic = violenceGraphic
        }

        private enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case harassment
            case harassmentThreatening = "harassment/threatening"
            case illicit
            case illicitViolent = "illicit/violent"
            case sexual
            case sexualMinors = "sexual/minors"
            case selfHarm = "self-harm"
            case selfHarmIntent = "self-harm/intent"
            case selfHarmInstructions = "self-harm/instructions"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
}

// MARK: -
extension OpenAIModerationResponseBody.ModerationResult {
    /// A list of the categories along with their scores as predicted by model.
    nonisolated public struct CategoryScores: Decodable, Sendable {

        /// The score for the category 'hate'.
        public let hate: Double?

        /// The score for the category 'hate/threatening'.
        public let hateThreatening: Double?

        /// The score for the category 'harassment'.
        public let harassment: Double?

        /// The score for the category 'harassment/threatening'.
        public let harassmentThreatening: Double?

        /// The score for the category 'illicit'.
        public let illicit: Double?

        /// The score for the category 'illicit/violent'.
        public let illicitViolent: Double?

        /// The score for the category 'sexual'.
        public let sexual: Double?

        /// The score for the category 'sexual/minors'.
        public let sexualMinors: Double?

        /// The score for the category 'self-harm'.
        public let selfHarm: Double?

        /// The score for the category 'self-harm/intent'.
        public let selfHarmIntent: Double?

        /// The score for the category 'self-harm/instructions'.
        public let selfHarmInstructions: Double?

        /// The score for the category 'violence'.
        public let violence: Double?

        /// The score for the category 'violence/graphic'.
        public let violenceGraphic: Double?

        public init(hate: Double?, hateThreatening: Double?, harassment: Double?, harassmentThreatening: Double?, illicit: Double?, illicitViolent: Double?, sexual: Double?, sexualMinors: Double?, selfHarm: Double?, selfHarmIntent: Double?, selfHarmInstructions: Double?, violence: Double?, violenceGraphic: Double?) {
            self.hate = hate
            self.hateThreatening = hateThreatening
            self.harassment = harassment
            self.harassmentThreatening = harassmentThreatening
            self.illicit = illicit
            self.illicitViolent = illicitViolent
            self.sexual = sexual
            self.sexualMinors = sexualMinors
            self.selfHarm = selfHarm
            self.selfHarmIntent = selfHarmIntent
            self.selfHarmInstructions = selfHarmInstructions
            self.violence = violence
            self.violenceGraphic = violenceGraphic
        }

        private enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case harassment
            case harassmentThreatening = "harassment/threatening"
            case illicit
            case illicitViolent = "illicit/violent"
            case sexual
            case sexualMinors = "sexual/minors"
            case selfHarm = "self-harm"
            case selfHarmIntent = "self-harm/intent"
            case selfHarmInstructions = "self-harm/instructions"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
}

// MARK: -
extension OpenAIModerationResponseBody.ModerationResult {
    /// A list of the categories along with the input type(s) that the score applies to.
    nonisolated public struct CategoryAppliedInputTypes: Decodable, Sendable {

        /// The applied input type(s) for the category 'hate'.
        public let hate: [InputType]?

        /// The applied input type(s) for the category 'hate/threatening'.
        public let hateThreatening: [InputType]?

        /// The applied input type(s) for the category 'harassment'.
        public let harassment: [InputType]?

        /// The applied input type(s) for the category 'harassment/threatening'.
        public let harassmentThreatening: [InputType]?

        /// The applied input type(s) for the category 'illicit'.
        public let illicit: [InputType]?

        /// The applied input type(s) for the category 'illicit/violent'.
        public let illicitViolent: [InputType]?

        /// The applied input type(s) for the category 'sexual'.
        public let sexual: [InputType]?

        /// The applied input type(s) for the category 'sexual/minors'.
        public let sexualMinors: [InputType]?

        /// The applied input type(s) for the category 'self-harm'.
        public let selfHarm: [InputType]?

        /// The applied input type(s) for the category 'self-harm/intent'.
        public let selfHarmIntent: [InputType]?

        /// The applied input type(s) for the category 'self-harm/instructions'.
        public let selfHarmInstructions: [InputType]?

        /// The applied input type(s) for the category 'violence'.
        public let violence: [InputType]?

        /// The applied input type(s) for the category 'violence/graphic'.
        public let violenceGraphic: [InputType]?

        public init(hate: [InputType]?, hateThreatening: [InputType]?, harassment: [InputType]?, harassmentThreatening: [InputType]?, illicit: [InputType]?, illicitViolent: [InputType]?, sexual: [InputType]?, sexualMinors: [InputType]?, selfHarm: [InputType]?, selfHarmIntent: [InputType]?, selfHarmInstructions: [InputType]?, violence: [InputType]?, violenceGraphic: [InputType]?) {
            self.hate = hate
            self.hateThreatening = hateThreatening
            self.harassment = harassment
            self.harassmentThreatening = harassmentThreatening
            self.illicit = illicit
            self.illicitViolent = illicitViolent
            self.sexual = sexual
            self.sexualMinors = sexualMinors
            self.selfHarm = selfHarm
            self.selfHarmIntent = selfHarmIntent
            self.selfHarmInstructions = selfHarmInstructions
            self.violence = violence
            self.violenceGraphic = violenceGraphic
        }

        private enum CodingKeys: String, CodingKey {
            case hate
            case hateThreatening = "hate/threatening"
            case harassment
            case harassmentThreatening = "harassment/threatening"
            case illicit
            case illicitViolent = "illicit/violent"
            case sexual
            case sexualMinors = "sexual/minors"
            case selfHarm = "self-harm"
            case selfHarmIntent = "self-harm/intent"
            case selfHarmInstructions = "self-harm/instructions"
            case violence
            case violenceGraphic = "violence/graphic"
        }
    }
}

// MARK: -
extension OpenAIModerationResponseBody.ModerationResult.CategoryAppliedInputTypes {
    nonisolated public enum InputType: String, Decodable, Sendable {
        case image
        case text
    }
}
