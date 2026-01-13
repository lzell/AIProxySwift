//
//  OpenAIConversationsIncludeParam.swift
//
//
//  Created by Lou Zell on 12/19/24.
//

import Foundation

/// Specifies additional fields to include in the response.
nonisolated public enum OpenAIConversationsIncludeParam: String, Sendable {
    /// Include web search tool call sources.
    case webSearchCallActionSources = "web_search_call.action.sources"

    /// Include code interpreter execution outputs.
    case codeInterpreterCallOutputs = "code_interpreter_call.outputs"

    /// Include computer call output images.
    case computerCallOutputImageUrl = "computer_call_output.output.image_url"

    /// Include file search tool call results.
    case fileSearchCallResults = "file_search_call.results"

    /// Include input message image URLs.
    case messageInputImageUrl = "message.input_image.image_url"

    /// Include assistant message log probabilities.
    case messageOutputTextLogprobs = "message.output_text.logprobs"

    /// Include encrypted reasoning token content.
    case reasoningEncryptedContent = "reasoning.encrypted_content"
}
