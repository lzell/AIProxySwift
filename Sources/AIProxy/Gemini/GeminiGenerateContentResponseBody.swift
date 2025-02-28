//
//  GeminiChatCompletionResponseBody.swift
//
//
//  Created by Todd Hamilton on 10/14/24.
//

import Foundation

/// Format taken from here:
/// https://ai.google.dev/api/generate-content#generatecontentresponse
public struct GeminiGenerateContentResponseBody: Decodable {
    /// Candidate responses from the mode
    public let candidates: [Candidate]?

    /// Metadata on the generation requests' token usage.
    public let usageMetadata: UsageMetadata?
}

// MARK: - ResponseBody.Candidate
extension GeminiGenerateContentResponseBody {
    /// A response candidate generated from the model.
    /// See: https://ai.google.dev/api/generate-content#candidate
    public struct Candidate: Decodable {
        /// Generated content returned from the model.
        public let content: Content?

        /// The reason why the model stopped generating tokens.
        /// If empty, the model has not stopped generating tokens.
        public let finishReason: String?

        ///  Grounding metadata for the candidate.
        public let groundingMetadata: GroundingMetadata?

        /// Index of the candidate in the list of response candidates.
        public let index: Int?

        /// List of ratings for the safety of a response candidate.
        /// There is at most one rating per category.
        public let safetyRatings: [SafetyRating]?
    }
}

// MARK: - ResponseBody.Candidate.Content
extension GeminiGenerateContentResponseBody.Candidate {
    /// The base structured datatype containing multi-part content of a message.
    /// See https://ai.google.dev/api/caching#Content
    ///
    /// A Content includes a role field designating the producer of the Content and a parts
    /// field containing multi-part data that contains the content of the message turn.
    public struct Content: Decodable {
        /// Ordered Parts that constitute a single message. Parts may have different MIME types.
        public let parts: [Part]?

        /// The producer of the content. Either 'user' or 'model'.
        public let role: String?
    }
}

// MARK: - ResponseBody.Candidate.Content.Part
extension GeminiGenerateContentResponseBody.Candidate.Content {
    /// A datatype containing media that is part of a multi-part Content message.
    /// This field is a union type, but currently only `text` is supported.
    /// See: https://ai.google.dev/api/caching#Part
    public enum Part: Decodable {
        case text(String)
        case functionCall(name: String, args: [String: Any]?)

        private enum CodingKeys: String, CodingKey {
            case text
            case functionCall
        }

        private struct _FunctionCall: Decodable {
            let name: String
            let args: [String: AIProxyJSONValue]?
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let functionCall = try container.decodeIfPresent(_FunctionCall.self, forKey: .functionCall) {
                self = .functionCall(name: functionCall.name, args: functionCall.args?.untypedDictionary)
            } else {
                self = .text(try container.decode(String.self, forKey: .text))
            }
        }
    }
}


// MARK: - ResponseBody.Candidate.SafetyRating
extension GeminiGenerateContentResponseBody.Candidate {
    /// Ratings for safety of the prompt. There is at most one rating per category.
    /// See https://ai.google.dev/api/generate-content#v1beta.SafetyRating
    public struct SafetyRating: Decodable {
        /// Was this content blocked because of this rating?
        public let blocked: Bool?

        /// The category for this rating.
        public let category: String?

        /// The probability of harm for this content.
        public let probability: String?
    }
}

// Extension to handle grounding metadata in the response
extension GeminiGenerateContentResponseBody.Candidate {
    /// Grounding metadata containing information about search results used for the response
    public struct GroundingMetadata: Decodable {
        public let searchEntryPoint: SearchEntryPoint?
        public let groundingChunks: [GroundingChunk]?
        public let groundingSupports: [GroundingSupport]?
        public let webSearchQueries: [String]?
        
        private enum CodingKeys: String, CodingKey {
            case searchEntryPoint
            case groundingChunks
            case groundingSupports
            case webSearchQueries
        }
    }
    
    public struct SearchEntryPoint: Decodable {
        public let renderedContent: String?
    }
    
    public struct GroundingChunk: Decodable {
        public let web: WebInfo?
    }
    
    public struct WebInfo: Decodable {
        public let uri: String?
        public let title: String?
    }
    
    public struct GroundingSupport: Decodable {
        public let segment: Segment?
        public let groundingChunkIndices: [Int]?
        public let confidenceScores: [Double]?
    }
    
    public struct Segment: Decodable {
        public let startIndex: Int?
        public let endIndex: Int?
        public let text: String?
    }
}

// MARK: - ResponseBody.UsageMetadata
extension GeminiGenerateContentResponseBody {
    /// Metadata on the generation request's token usage.
    public struct UsageMetadata: Decodable {
        /// Number of tokens in the cached part of the prompt (the cached content)
        public let cachedContentTokenCount: Int?

        /// Total number of tokens across all the generated response candidates.
        public let candidatesTokenCount: Int?

        /// Number of tokens in the prompt. When cachedContent is set, this is still the total
        /// effective prompt size meaning this includes the number of tokens in the cached
        /// content.
        public let promptTokenCount: Int?

        /// Total token count for the generation request (prompt + response candidates).
        public let totalTokenCount: Int?
    }
}
