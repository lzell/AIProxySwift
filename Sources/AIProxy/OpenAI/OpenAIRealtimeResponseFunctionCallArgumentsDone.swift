//
//  OpenAIRealtimeResponseDone.swift
//  AIProxy
//
//  Created by Tim Wheeler on 4/22/25.
//

import Foundation

/// Returned when the model-generated function call arguments are done streaming.
/// Also emitted when a Response is interrupted, incomplete, or cancelled.
/// https://platform.openai.com/docs/api-reference/realtime-server-events/response/function_call_arguments/done
public struct OpenAIRealtimeResponseFunctionCallArgumentsDone: Encodable {
    public let type = "response.function_call_arguments.done"
    public let name: String?
    public let arguments: String?

    public init(name: String, arguments: String) {
        self.name = name
        self.arguments = arguments
    }
}
