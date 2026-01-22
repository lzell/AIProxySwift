//
//  OpenAICreateConversationRequestBody.swift
//  AIProxy
//
//  Created by Lou Zell on 12/20/25.
//
// OpenAPI spec: CreateConversationBody, version 2.3.0, line 66769
// https://platform.openai.com/docs/api-reference/conversations/create

public struct OpenAICreateConversationRequestBody: Encodable {
    /// Initial items to include in the conversation context. You may add up to 20 items at a time.
    public var items: [OpenAIInputItem]?
                                                                                           
    /// Set of 16 key-value pairs that can be attached to an object. This can be
    /// useful for storing additional information about the object in a structured
    /// format, and querying for objects via API or the dashboard.
    ///                                                                        
    /// Keys are strings with a maximum length of 64 characters. Values are strings
    /// with a maximum length of 512 characters.
    public var metadata: [String: String]?
                                                         
    public init(           
        items: [OpenAIInputItem]? = nil,
        metadata: [String: String]? = nil
    ) {                   
        self.items = items                        
        self.metadata = metadata     
    }             
}
