//
//  GeminiGenerateContentResponseBodyTests.swift
//
//
//  Created by Todd Hamilton on 10/15/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class GeminiGenerateContentResponseBodyTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
            "candidates": [
                {
                "content": {
                    "parts": [
                    {
                        "text": "findme"
                    }
                    ],
                    "role": "model"
                },
                "finishReason": "STOP",
                "index": 0,
                "safetyRatings": [
                    {
                    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                    "probability": "NEGLIGIBLE"
                    },
                    {
                    "category": "HARM_CATEGORY_HATE_SPEECH",
                    "probability": "NEGLIGIBLE"
                    },
                    {
                    "category": "HARM_CATEGORY_HARASSMENT",
                    "probability": "NEGLIGIBLE"
                    },
                    {
                    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                    "probability": "NEGLIGIBLE"
                    }
                ]
                }
            ],
            "usageMetadata": {
                "promptTokenCount": 4,
                "candidatesTokenCount": 16,
                "totalTokenCount": 20
            }
        }
        """#
        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        if case .text(let generated) = body.candidates?.first?.content?.parts?.first {
            XCTAssertEqual(generated, "findme")
        } else {
            XCTFail()
        }
    }

    func testToolCallResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "candidates": [
            {
              "content": {
                "parts": [
                  {
                    "functionCall": {
                      "name": "controlLight",
                      "args": {
                        "brightness": 50,
                        "colorTemperature": "cool"
                      }
                    }
                  }
                ],
                "role": "model"
              },
              "finishReason": "STOP",
              "safetyRatings": [
                {
                  "category": "HARM_CATEGORY_HATE_SPEECH",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_HARASSMENT",
                  "probability": "NEGLIGIBLE"
                },
                {
                  "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                  "probability": "NEGLIGIBLE"
                }
              ],
              "avgLogprobs": -0.09892001748085022
            }
          ],
          "usageMetadata": {
            "promptTokenCount": 98,
            "candidatesTokenCount": 6,
            "totalTokenCount": 104
          },
          "modelVersion": "gemini-2.0-flash-exp"
        }
        """#
        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        if case let .functionCall(name: name, args: args) = body.candidates?.first?.content?.parts?.first {
            XCTAssertEqual("controlLight", name)
            XCTAssertEqual(50, args!["brightness"] as? Int)
            XCTAssertEqual("cool", args!["colorTemperature"] as? String)
        } else {
            XCTFail()
        }
    }

    func testToolCallWithGoogleSearchIsDecodable() throws {
        let sampleResponse = #"""
        {
          "candidates": [
            {
              "content": {
                "parts": [
                  {
                    "text": "As of February 27, 2025, here's the price<snip>"
                  }
                ],
                "role": "model"
              },
              "finishReason": "STOP",
              "groundingMetadata": {
                "searchEntryPoint": {
                  "renderedContent": "snip"
                },
                "groundingChunks": [
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AQXblry3MyjDAunDGmW0g-f6cJdiBH_tObftq8oGqVX7FIsRRe5o7D4P9Tg3_bStmIg8lLE-ubBAsqkVouQviocwpuqW3qHig7jNreur16s_sDCqqoeQMYpxGGuvMSQ-2qC2ANOPnDG_Jy1QWZ1P",
                      "title": "tradingview.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AQXblrxjjMaChVchUXSlucYTmaVEPxJZvGiiD8CLUM_B5iv9YNQ9NJq12Eje3W9pR1RLYTipzaUyHB5iukjdiWLMLF6Kd293lT4Uw1OMaUOpopLhM82VBIng01upGF3ujAU=",
                      "title": "robinhood.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AQXblrwYvCTii1Fn8A9Vco6CnyVV8VajUBtX9K-UpPzlL8FkqX0-v2MWL0dQz8qm-MxsIcos9o98eD2S1SuPBb0z40ZZA1aE_4byURstUi5Z-KNDo19HN3Lo-xrBjFSAX5EkXWhvFs6oPD6xD-VLX_aK-3QMJGrbRpx9J4ml0HM=",
                      "title": "indmoney.com"
                    }
                  }
                ],
                "groundingSupports": [
                  {
                    "segment": {
                      "startIndex": 89,
                      "endIndex": 110,
                      "text": "**GOOG (Alphabet Inc."
                    },
                    "groundingChunkIndices": [
                      0
                    ],
                    "confidenceScores": [
                      0.63744724
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 124,
                      "endIndex": 157,
                      "text": "*   The current price is $172.73."
                    },
                    "groundingChunkIndices": [
                      0
                    ],
                    "confidenceScores": [
                      0.96421456
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 158,
                      "endIndex": 210,
                      "text": "*   It has decreased by -1.51% in the past 24 hours."
                    },
                    "groundingChunkIndices": [
                      0
                    ],
                    "confidenceScores": [
                      0.9433775
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 212,
                      "endIndex": 234,
                      "text": "**GOOGL (Alphabet Inc."
                    },
                    "groundingChunkIndices": [
                      1
                    ],
                    "confidenceScores": [
                      0.7672731
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 248,
                      "endIndex": 319,
                      "text": "*   The stock opened at $178.04, following a previous close of $179.25."
                    },
                    "groundingChunkIndices": [
                      2
                    ],
                    "confidenceScores": [
                      0.99511707
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 320,
                      "endIndex": 380,
                      "text": "*   It reached a daily high of $177.25 and a low of $172.90."
                    },
                    "groundingChunkIndices": [
                      1
                    ],
                    "confidenceScores": [
                      0.8689863
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 381,
                      "endIndex": 406,
                      "text": "*   Market Price: $173.96"
                    },
                    "groundingChunkIndices": [
                      1
                    ],
                    "confidenceScores": [
                      0.9451317
                    ]
                  }
                ],
                "retrievalMetadata": {},
                "webSearchQueries": [
                  "Google stock price today"
                ]
              }
            }
          ],
          "usageMetadata": {
            "promptTokenCount": 13,
            "candidatesTokenCount": 158,
            "totalTokenCount": 171,
            "promptTokensDetails": [
              {
                "modality": "TEXT",
                "tokenCount": 13
              }
            ],
            "candidatesTokensDetails": [
              {
                "modality": "TEXT",
                "tokenCount": 158
              }
            ]
          },
          "modelVersion": "gemini-2.0-flash"
        }
        """#

        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        guard let candidate = body.candidates?.first else {
            XCTFail()
            return
        }

        if case let .text(txt) = candidate.content?.parts?.first {
            XCTAssertEqual("As of February 27, 2025, here's the price<snip>", txt)
        } else {
            XCTFail()
        }

        XCTAssertEqual(3, candidate.groundingMetadata?.groundingChunks?.count)
        XCTAssertEqual("tradingview.com", candidate.groundingMetadata?.groundingChunks?.first?.web?.title)

        XCTAssertEqual(7, candidate.groundingMetadata?.groundingSupports?.count)
        XCTAssertEqual([0.63744724], candidate.groundingMetadata?.groundingSupports?.first?.confidenceScores)
    }
}
