//
//  OpenAIInclude.swift
//  AIProxy
//
//  Created by Lou Zell on 1/14/26.
//
// OpenAPI spec: IncludeEnum, version 2.3.0, line 64755
// https://platform.openai.com/docs/api-reference/conversations/list-items#conversations_list_items-include

/// Specify additional output data to include in the model response.
nonisolated public enum OpenAIInclude: String, Encodable, Sendable {
    /// Include the outputs of python code execution in code interpreter tool call items.
    case codeInterpreterCallOutputs = "code_interpreter_call.outputs"

    /// Include image urls from the computer call output.
    case computerCallOutputImageUrl = "computer_call_output.output.image_url"

    /// Include the search results of the file search tool call.
    case fileSearchCallResults = "file_search_call.results"

    /// Include image urls from the input message.
    case messageInputImageImageUrl = "message.input_image.image_url"

    /// Include logprobs with assistant messages.
    case messageOutputTextLogprobs = "message.output_text.logprobs"

    /// Includes an encrypted version of reasoning tokens in reasoning item outputs.
    case reasoningEncryptedContent = "reasoning.encrypted_content"

    /// Include the sources of the web search tool call.
    case webSearchCallActionSources = "web_search_call.action.sources"
}
