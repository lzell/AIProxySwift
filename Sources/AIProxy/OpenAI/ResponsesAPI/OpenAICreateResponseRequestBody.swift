//
//  OpenAICreateResponseRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 3/12/25.
//

/// OpenAI's most advanced interface for generating model responses. Supports text and image inputs, and text outputs. Create stateful interactions with the model, using the output of previous responses as input. Extend the model's capabilities with built-in tools for file search, web search, computer use, and more. Allow the model access to external systems and data using function calling.
/// https://platform.openai.com/docs/api-reference/responses/create
/// Implementor's note: See ResponseCreateParamsBase in `src/openai/types/responses/response_create_params.py`
internal struct OpenAICreateResponseRequestBody: Encodable {

//    /// Text, image, or file inputs to the model, used to generate a response.
    let input: ResponseInputParam
    let model: String

}

//// MARK: -
//extension OpenAICreateResponseRequestBody {
//    // Implementor's note: This type corresponds to the union `ResponseInputItemParam` in the python sdk
//    public enum Input {
//
//        case easyInputMessageParam(
//        /// A text input to the model, equivalent to a text input with the user role.
//        case text(String)
//
//        /// A list of one or many input items to the model, containing different content types.
//        case list([Item])
//    }
//}
//
//// MARK: -
//extension OpenAICreateResponseRequestBody.Input {
//    public enum Item {
//        case message(
//
//    }
//}
//
//
