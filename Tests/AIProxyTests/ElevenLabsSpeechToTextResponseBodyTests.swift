//
//  ElevenLabsSpeechToTextResponseBodyTests.swift
//  AIProxy
//
//  Created by Lou Zell on 4/21/25.
//

import XCTest
import Foundation
@testable import AIProxy

final class ElevenLabsSpeechToTextResponseBodyTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "language_code": "eng",
          "language_probability": 0.7772299647331238,
          "text": "[clicking] Hello, world.",
          "words": [
            {
              "text": "[clicking]",
              "start": 0.079,
              "end": 0.78,
              "type": "audio_event"
            },
            {
              "text": " ",
              "start": 0.78,
              "end": 0.979,
              "type": "spacing"
            },
            {
              "text": "Hello,",
              "start": 0.979,
              "end": 1.499,
              "type": "word"
            },
            {
              "text": " ",
              "start": 1.499,
              "end": 1.699,
              "type": "spacing"
            },
            {
              "text": "world.",
              "start": 1.699,
              "end": 2.199,
              "type": "word"
            }
          ]
        }
        """
        let res = try ElevenLabsSpeechToTextResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("eng", res.languageCode)
        XCTAssertEqual("[clicking] Hello, world.", res.text)
        XCTAssertEqual(.audioEvent, res.words?.first?.type)
        XCTAssertEqual("[clicking]", res.words?.first?.text)
    }
}
