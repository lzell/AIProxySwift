/// Send this event to update the session’s default configuration.
///
/// Docstrings from:
/// https://platform.openai.com/docs/api-reference/realtime-client-events/session/update
nonisolated public struct OpenAIRealtimeSessionUpdate: Encodable {
    /// Optional client-generated ID used to identify this event.
    public let eventId: String?

    /// Session configuration as provided by the caller.
    public let session: OpenAIRealtimeSessionConfiguration

    /// Session payload to update. The wire shape is selected by API version.
    private let sessionBody: OpenAIRealtimeSessionUpdateBody

    /// The event type, must be "session.update".
    public let type = "session.update"

    private enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case session
        case type
    }

    init(
        eventId: String? = nil,
        session: OpenAIRealtimeSessionConfiguration,
        sessionBody: OpenAIRealtimeSessionUpdateBody
    ) {
        self.eventId = eventId
        self.session = session
        self.sessionBody = sessionBody
    }

    /// Deprecated initializer preserved for source compatibility.
    ///
    /// It encodes using beta-v1 wire shape to preserve legacy behavior.
    /// Prefer `OpenAIRealtimeAPIVersion.makeSessionUpdate` for explicit wire version control.
    @available(*, deprecated, message: "Legacy initializer encodes beta-v1. Use OpenAIRealtimeAPIVersion.makeSessionUpdate(from:eventID:) for explicit version control.")
    public init(
        eventId: String? = nil,
        session: OpenAIRealtimeSessionConfiguration
    ) {
        self.init(
            eventId: eventId,
            session: session,
            sessionBody: .betaV1(.init(configuration: session))
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(eventId, forKey: .eventId)
        try container.encode(type, forKey: .type)
        try container.encode(sessionBody, forKey: .session)
    }
}
