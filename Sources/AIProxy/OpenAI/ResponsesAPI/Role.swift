//
//  Role.swift
//  AIProxy
//
//  Created by Lou Zell on 3/13/25.
//


import Foundation

// MARK: - Input Types

/// Role used in various message types.
public enum Role: String, Encodable {
    case user, assistant, system, developer
}

/// MARK: ResponseInputFileParam
public struct ResponseInputFileParam: Encodable {
    public let type: String = "input_file"
    public let fileData: String?
    public let fileId: String?
    public let filename: String?
    
    public init(fileData: String? = nil, fileId: String? = nil, filename: String? = nil) {
        self.fileData = fileData
        self.fileId = fileId
        self.filename = filename
    }
}

/// MARK: ResponseInputTextParam
public struct ResponseInputTextParam: Encodable {
    public let text: String
    public let type: String = "input_text"
    
    public init(text: String) {
        self.text = text
    }
}

/// MARK: ResponseInputImageParam
public enum ImageDetail: String, Encodable {
    case high, low, auto
}

public struct ResponseInputImageParam: Encodable {
    public let detail: ImageDetail
    public let type: String = "input_image"
    public let fileId: String?
    public let imageUrl: String?
    
    public init(detail: ImageDetail = .auto, fileId: String? = nil, imageUrl: String? = nil) {
        self.detail = detail
        self.fileId = fileId
        self.imageUrl = imageUrl
    }
}

/// MARK: ResponseInputContentParam Union
public enum ResponseInputContentParam: Encodable {
    case text(ResponseInputTextParam)
    case image(ResponseInputImageParam)
    case file(ResponseInputFileParam)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let param):
            try container.encode(param)
        case .image(let param):
            try container.encode(param)
        case .file(let param):
            try container.encode(param)
        }
    }
    
    public init(from decoder: Decoder) throws {
        // Decoding is not implemented.
        throw DecodingError.typeMismatch(ResponseInputContentParam.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding not implemented"))
    }
}

/// A list of one or more input content items.
public typealias ResponseInputMessageContentListParam = [ResponseInputContentParam]

/// MARK: EasyInputMessageParam
/// Represents an input message whose content can be either a simple string or a list of rich content.
public enum EasyInputMessageContent: Encodable {
    case text(String)
    case contentList(ResponseInputMessageContentListParam)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let text):
            try container.encode(text)
        case .contentList(let list):
            try container.encode(list)
        }
    }
    
    public init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(EasyInputMessageContent.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding not implemented"))
    }
}

public struct EasyInputMessageParam: Encodable {
    public let content: EasyInputMessageContent
    public let role: Role
    public let type: String = "message"
    
    public init(content: EasyInputMessageContent, role: Role) {
        self.content = content
        self.role = role
    }
}

// MARK: - Output Types

/// MARK: Annotations for output text
public struct AnnotationFileCitation: Encodable {
    public let fileId: String
    public let index: Int
    public let type: String = "file_citation"
    
    public init(fileId: String, index: Int) {
        self.fileId = fileId
        self.index = index
    }
}

public struct AnnotationURLCitation: Encodable {
    public let endIndex: Int
    public let startIndex: Int
    public let title: String
    public let type: String = "url_citation"
    public let url: String
    
    public init(endIndex: Int, startIndex: Int, title: String, url: String) {
        self.endIndex = endIndex
        self.startIndex = startIndex
        self.title = title
        self.url = url
    }
}

public struct AnnotationFilePath: Encodable {
    public let fileId: String
    public let index: Int
    public let type: String = "file_path"
    
    public init(fileId: String, index: Int) {
        self.fileId = fileId
        self.index = index
    }
}

/// Union of possible annotations.
public enum Annotation: Encodable {
    case fileCitation(AnnotationFileCitation)
    case urlCitation(AnnotationURLCitation)
    case filePath(AnnotationFilePath)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .fileCitation(let value):
            try container.encode(value)
        case .urlCitation(let value):
            try container.encode(value)
        case .filePath(let value):
            try container.encode(value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(Annotation.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding not implemented"))
    }
}

/// MARK: ResponseOutputTextParam
public struct ResponseOutputTextParam: Encodable {
    public let annotations: [Annotation]
    public let text: String
    public let type: String = "output_text"
    
    public init(annotations: [Annotation], text: String) {
        self.annotations = annotations
        self.text = text
    }
}

/// MARK: ResponseOutputRefusalParam
public struct ResponseOutputRefusalParam: Encodable {
    public let refusal: String
    public let type: String = "refusal"
    
    public init(refusal: String) {
        self.refusal = refusal
    }
}

/// Union of output content types.
public enum Content: Encodable {
    case text(ResponseOutputTextParam)
    case refusal(ResponseOutputRefusalParam)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let value):
            try container.encode(value)
        case .refusal(let value):
            try container.encode(value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(Content.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding not implemented"))
    }
}

/// Status used in various message outputs.
public enum MessageStatus: String, Encodable {
    case in_progress, completed, incomplete
}

/// MARK: ResponseOutputMessageParam
public struct ResponseOutputMessageParam: Encodable {
    public let id: String
    public let content: [Content]
    public let role: Role = .assistant
    public let status: MessageStatus
    public let type: String = "message"
    
    public init(id: String, content: [Content], status: MessageStatus) {
        self.id = id
        self.content = content
        self.status = status
    }
}

// MARK: - Reasoning

public struct Summary: Encodable {
    public let text: String
    public let type: String = "summary_text"
    
    public init(text: String) {
        self.text = text
    }
}

public struct ResponseReasoningItemParam: Encodable {
    public let id: String
    public let summary: [Summary]
    public let type: String = "reasoning"
    public let status: MessageStatus
    
    public init(id: String, summary: [Summary], status: MessageStatus) {
        self.id = id
        self.summary = summary
        self.status = status
    }
}

// MARK: - Computer Tool Call Parameters

// MARK: Action Types
public enum Button: String, Encodable {
    case left, right, wheel, back, forward
}

public struct ActionClick: Encodable {
    public let button: Button
    public let type: String = "click"
    public let x: Int
    public let y: Int
    
    public init(button: Button, x: Int, y: Int) {
        self.button = button
        self.x = x
        self.y = y
    }
}

public struct ActionDoubleClick: Encodable {
    public let type: String = "double_click"
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public struct ActionDragPath: Encodable {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public struct ActionDrag: Encodable {
    public let path: [ActionDragPath]
    public let type: String = "drag"
    
    public init(path: [ActionDragPath]) {
        self.path = path
    }
}

public struct ActionKeypress: Encodable {
    public let keys: [String]
    public let type: String = "keypress"
    
    public init(keys: [String]) {
        self.keys = keys
    }
}

public struct ActionMove: Encodable {
    public let type: String = "move"
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public struct ActionScreenshot: Encodable {
    public let type: String = "screenshot"
    
    public init() { }
}

public struct ActionScroll: Encodable {
    public let scrollX: Int
    public let scrollY: Int
    public let type: String = "scroll"
    public let x: Int
    public let y: Int
    
    public init(scrollX: Int, scrollY: Int, x: Int, y: Int) {
        self.scrollX = scrollX
        self.scrollY = scrollY
        self.x = x
        self.y = y
    }
}

public struct ActionType: Encodable {
    public let text: String
    public let type: String = "type"
    
    public init(text: String) {
        self.text = text
    }
}

public struct ActionWait: Encodable {
    public let type: String = "wait"
    
    public init() { }
}

/// Union of all Action types.
public enum Action: Encodable {
    case click(ActionClick)
    case doubleClick(ActionDoubleClick)
    case drag(ActionDrag)
    case keypress(ActionKeypress)
    case move(ActionMove)
    case screenshot(ActionScreenshot)
    case scroll(ActionScroll)
    case type(ActionType)
    case wait(ActionWait)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .click(let value):
            try container.encode(value)
        case .doubleClick(let value):
            try container.encode(value)
        case .drag(let value):
            try container.encode(value)
        case .keypress(let value):
            try container.encode(value)
        case .move(let value):
            try container.encode(value)
        case .screenshot(let value):
            try container.encode(value)
        case .scroll(let value):
            try container.encode(value)
        case .type(let value):
            try container.encode(value)
        case .wait(let value):
            try container.encode(value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(Action.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding not implemented"))
    }
}

/// MARK: ResponseComputerToolCallParam
public struct PendingSafetyCheck: Encodable {
    public let id: String
    public let code: String
    public let message: String
    
    public init(id: String, code: String, message: String) {
        self.id = id
        self.code = code
        self.message = message
    }
}

public struct ResponseComputerToolCallParam: Encodable {
    public let id: String
    public let action: Action
    public let callId: String
    public let pendingSafetyChecks: [PendingSafetyCheck]
    public let status: MessageStatus
    public let type: String = "computer_call"
    
    public init(id: String, action: Action, callId: String, pendingSafetyChecks: [PendingSafetyCheck], status: MessageStatus) {
        self.id = id
        self.action = action
        self.callId = callId
        self.pendingSafetyChecks = pendingSafetyChecks
        self.status = status
    }
}

// MARK: - Function Tool Call

public struct ResponseFunctionToolCallParam: Encodable {
    public let id: String
    public let arguments: String
    public let callId: String
    public let name: String
    public let type: String = "function_call"
    public let status: MessageStatus
    
    public init(id: String, arguments: String, callId: String, name: String, status: MessageStatus) {
        self.id = id
        self.arguments = arguments
        self.callId = callId
        self.name = name
        self.status = status
    }
}

// MARK: - Function Web Search

public enum WebSearchStatus: String, Encodable {
    case in_progress, searching, completed, failed
}

public struct ResponseFunctionWebSearchParam: Encodable {
    public let id: String
    public let status: WebSearchStatus
    public let type: String = "web_search_call"
    
    public init(id: String, status: WebSearchStatus) {
        self.id = id
        self.status = status
    }
}

// MARK: - File Search Tool Call

/// A helper type that can encode basic types (String, Double, Bool)
public enum EncodableValue: Encodable {
    case string(String)
    case double(Double)
    case bool(Bool)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            self = .string(str)
        } else if let dbl = try? container.decode(Double.self) {
            self = .double(dbl)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else {
            throw DecodingError.typeMismatch(EncodableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Not a supported type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        }
    }
}

public struct Result: Encodable {
    public let attributes: [String: EncodableValue]?
    public let fileId: String
    public let filename: String
    public let score: Double
    public let text: String
    
    public init(attributes: [String: EncodableValue]? = nil, fileId: String, filename: String, score: Double, text: String) {
        self.attributes = attributes
        self.fileId = fileId
        self.filename = filename
        self.score = score
        self.text = text
    }
}

public enum FileSearchStatus: String, Encodable {
    case in_progress, searching, completed, incomplete, failed
}

public struct ResponseFileSearchToolCallParam: Encodable {
    public let id: String
    public let queries: [String]
    public let status: FileSearchStatus
    public let type: String = "file_search_call"
    public let results: [Result]?
    
    public init(id: String, queries: [String], status: FileSearchStatus, results: [Result]? = nil) {
        self.id = id
        self.queries = queries
        self.status = status
        self.results = results
    }
}

// MARK: - Additional Input Types

/// A Message input with a list of content items.
public struct Message: Encodable {
    public let content: ResponseInputMessageContentListParam
    public let role: Role
    public let status: MessageStatus
    public let type: String = "message"
    
    public init(content: ResponseInputMessageContentListParam, role: Role, status: MessageStatus) {
        self.content = content
        self.role = role
        self.status = status
    }
}

/// MARK: Computer Call Output
public struct ComputerCallOutputOutput: Encodable {
    public let type: String = "computer_screenshot"
    public let fileId: String
    public let imageUrl: String
    
    public init(fileId: String, imageUrl: String) {
        self.fileId = fileId
        self.imageUrl = imageUrl
    }
}

public struct ComputerCallOutputAcknowledgedSafetyCheck: Encodable {
    public let id: String
    public let code: String
    public let message: String
    
    public init(id: String, code: String, message: String) {
        self.id = id
        self.code = code
        self.message = message
    }
}

public struct ComputerCallOutput: Encodable {
    public let callId: String
    public let output: ComputerCallOutputOutput
    public let type: String = "computer_call_output"
    public let id: String
    public let acknowledgedSafetyChecks: [ComputerCallOutputAcknowledgedSafetyCheck]
    public let status: MessageStatus
    
    public init(callId: String, output: ComputerCallOutputOutput, id: String, acknowledgedSafetyChecks: [ComputerCallOutputAcknowledgedSafetyCheck], status: MessageStatus) {
        self.callId = callId
        self.output = output
        self.id = id
        self.acknowledgedSafetyChecks = acknowledgedSafetyChecks
        self.status = status
    }
}

/// MARK: Function Call Output
public struct FunctionCallOutput: Encodable {
    public let callId: String
    public let output: String
    public let type: String = "function_call_output"
    public let id: String
    public let status: MessageStatus
    
    public init(callId: String, output: String, id: String, status: MessageStatus) {
        self.callId = callId
        self.output = output
        self.id = id
        self.status = status
    }
}

/// MARK: Item Reference
public struct ItemReference: Encodable {
    public let id: String
    public let type: String = "item_reference"
    
    public init(id: String) {
        self.id = id
    }
}

// MARK: - ResponseInputItemParam Union

/// A union of all possible input or output message types.
public enum ResponseInputItemParam: Encodable {
    case easyInputMessage(EasyInputMessageParam)
    case message(Message)
    case responseOutputMessage(ResponseOutputMessageParam)
    case fileSearchToolCall(ResponseFileSearchToolCallParam)
    case computerToolCall(ResponseComputerToolCallParam)
    case computerCallOutput(ComputerCallOutput)
    case functionWebSearch(ResponseFunctionWebSearchParam)
    case functionToolCall(ResponseFunctionToolCallParam)
    case functionCallOutput(FunctionCallOutput)
    case reasoningItem(ResponseReasoningItemParam)
    case itemReference(ItemReference)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .easyInputMessage(let value):
            try container.encode(value)
        case .message(let value):
            try container.encode(value)
        case .responseOutputMessage(let value):
            try container.encode(value)
        case .fileSearchToolCall(let value):
            try container.encode(value)
        case .computerToolCall(let value):
            try container.encode(value)
        case .computerCallOutput(let value):
            try container.encode(value)
        case .functionWebSearch(let value):
            try container.encode(value)
        case .functionToolCall(let value):
            try container.encode(value)
        case .functionCallOutput(let value):
            try container.encode(value)
        case .reasoningItem(let value):
            try container.encode(value)
        case .itemReference(let value):
            try container.encode(value)
        }
    }
    
    public init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(ResponseInputItemParam.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding not implemented"))
    }
}

public enum ResponseInputParam: Encodable {
    case text(String)
    case items([ResponseInputItemParam])

    enum CodingKeys: CodingKey {
        case text
        case items
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .text(let txt):
            try container.encode(txt)
        case .items(let items):
            try container.encode(items)
        }
    }
}


