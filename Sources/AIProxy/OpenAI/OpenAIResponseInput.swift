//
//  OpenAIResponseInput.swift
//  AIProxy
//
//  Created by Lou Zell on 8/12/25.
//

extension OpenAIResponse {
    public enum Input: Encodable {
        case text(String)
        case items([ItemOrMessage])

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

    public enum Role: String, Encodable {
        case user
        case assistant
        case system
        case developer
    }

    public enum Content: Encodable {
        case text(String)
        case list([ItemContent])

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .text(let txt):
                try container.encode(txt)
            case .list(let itemContent):
                try container.encode(itemContent)
            }
        }
    }

    public enum ItemContent: Encodable {
        case file(fileID: String)
        case imageURL(URL)
        case text(String)

        private enum CodingKeys: String, CodingKey {
            case fileID = "file_id"
            case imageURL = "image_url"
            case type
            case text
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .file(let fileID):
                try container.encode(fileID, forKey: .fileID)
                try container.encode("input_file", forKey: .type)
            case .imageURL(let imageURL):
                try container.encode(imageURL, forKey: .imageURL)
                try container.encode("input_image", forKey: .type)
            case .text(let txt):
                try container.encode(txt, forKey: .text)
                try container.encode("input_text", forKey: .type)
            }
        }
    }

    public enum ItemOrMessage: Encodable {
        case message(role: Role, content: Content)

        private struct _Message: Encodable {
            let role: Role
            let content: Content

            private enum CodingKeys: CodingKey {
                case content
                case role
                case type
            }

            func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode("message", forKey: .type)
                try container.encode(self.role.rawValue, forKey: .role)
                try container.encode(self.content, forKey: .content)
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .message(role: let role, content: let content):
                try container.encode(_Message(role: role, content: content))
            }
        }
    }
}
