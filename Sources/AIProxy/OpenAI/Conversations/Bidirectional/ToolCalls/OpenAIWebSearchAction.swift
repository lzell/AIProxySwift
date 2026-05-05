//
//  OpenAIWebSearchAction.swift
//  AIProxy
//
//  Created by Lou Zell on 12/21/25.
//

nonisolated public enum OpenAIWebSearchAction: Codable, Sendable {
    case search(OpenAISearchAction)
    case openPage(OpenAIOpenPageAction)
    case find(OpenAIFindAction)
    case futureProof

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "find":
            self = .find(try OpenAIFindAction(from: decoder))
        case "open_page":
            self = .openPage(try OpenAIOpenPageAction(from: decoder))
        case "search":
            self = .search(try OpenAISearchAction(from: decoder))
        default:
            self = .futureProof
            logIf(.error)?.error("No OpenAIWebSearchAction type of \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .search(let action):
            try action.encode(to: encoder)
        case .openPage(let action):
            try action.encode(to: encoder)
        case .find(let action):
            try action.encode(to: encoder)
        case .futureProof:
            break
        }
    }
}
