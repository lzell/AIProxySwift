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
                  "renderedContent": "\u003cstyle\u003e\n.container {\n  align-items: center;\n  border-radius: 8px;\n  display: flex;\n  font-family: Google Sans, Roboto, sans-serif;\n  font-size: 14px;\n  line-height: 20px;\n  padding: 8px 12px;\n}\n.chip {\n  display: inline-block;\n  border: solid 1px;\n  border-radius: 16px;\n  min-width: 14px;\n  padding: 5px 16px;\n  text-align: center;\n  user-select: none;\n  margin: 0 8px;\n  -webkit-tap-highlight-color: transparent;\n}\n.carousel {\n  overflow: auto;\n  scrollbar-width: none;\n  white-space: nowrap;\n  margin-right: -12px;\n}\n.headline {\n  display: flex;\n  margin-right: 4px;\n}\n.gradient-container {\n  position: relative;\n}\n.gradient {\n  position: absolute;\n  transform: translate(3px, -9px);\n  height: 36px;\n  width: 9px;\n}\n@media (prefers-color-scheme: light) {\n  .container {\n    background-color: #fafafa;\n    box-shadow: 0 0 0 1px #0000000f;\n  }\n  .headline-label {\n    color: #1f1f1f;\n  }\n  .chip {\n    background-color: #ffffff;\n    border-color: #d2d2d2;\n    color: #5e5e5e;\n    text-decoration: none;\n  }\n  .chip:hover {\n    background-color: #f2f2f2;\n  }\n  .chip:focus {\n    background-color: #f2f2f2;\n  }\n  .chip:active {\n    background-color: #d8d8d8;\n    border-color: #b6b6b6;\n  }\n  .logo-dark {\n    display: none;\n  }\n  .gradient {\n    background: linear-gradient(90deg, #fafafa 15%, #fafafa00 100%);\n  }\n}\n@media (prefers-color-scheme: dark) {\n  .container {\n    background-color: #1f1f1f;\n    box-shadow: 0 0 0 1px #ffffff26;\n  }\n  .headline-label {\n    color: #fff;\n  }\n  .chip {\n    background-color: #2c2c2c;\n    border-color: #3c4043;\n    color: #fff;\n    text-decoration: none;\n  }\n  .chip:hover {\n    background-color: #353536;\n  }\n  .chip:focus {\n    background-color: #353536;\n  }\n  .chip:active {\n    background-color: #464849;\n    border-color: #53575b;\n  }\n  .logo-light {\n    display: none;\n  }\n  .gradient {\n    background: linear-gradient(90deg, #1f1f1f 15%, #1f1f1f00 100%);\n  }\n}\n\u003c/style\u003e\n\u003cdiv class=\"container\"\u003e\n  \u003cdiv class=\"headline\"\u003e\n    \u003csvg class=\"logo-light\" width=\"18\" height=\"18\" viewBox=\"9 9 35 35\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"\u003e\n      \u003cpath fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M42.8622 27.0064C42.8622 25.7839 42.7525 24.6084 42.5487 23.4799H26.3109V30.1568H35.5897C35.1821 32.3041 33.9596 34.1222 32.1258 35.3448V39.6864H37.7213C40.9814 36.677 42.8622 32.2571 42.8622 27.0064V27.0064Z\" fill=\"#4285F4\"/\u003e\n      \u003cpath fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M26.3109 43.8555C30.9659 43.8555 34.8687 42.3195 37.7213 39.6863L32.1258 35.3447C30.5898 36.3792 28.6306 37.0061 26.3109 37.0061C21.8282 37.0061 18.0195 33.9811 16.6559 29.906H10.9194V34.3573C13.7563 39.9841 19.5712 43.8555 26.3109 43.8555V43.8555Z\" fill=\"#34A853\"/\u003e\n      \u003cpath fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M16.6559 29.8904C16.3111 28.8559 16.1074 27.7588 16.1074 26.6146C16.1074 25.4704 16.3111 24.3733 16.6559 23.3388V18.8875H10.9194C9.74388 21.2072 9.06992 23.8247 9.06992 26.6146C9.06992 29.4045 9.74388 32.022 10.9194 34.3417L15.3864 30.8621L16.6559 29.8904V29.8904Z\" fill=\"#FBBC05\"/\u003e\n      \u003cpath fill-rule=\"evenodd\" clip-rule=\"evenodd\" d=\"M26.3109 16.2386C28.85 16.2386 31.107 17.1164 32.9095 18.8091L37.8466 13.8719C34.853 11.082 30.9659 9.3736 26.3109 9.3736C19.5712 9.3736 13.7563 13.245 10.9194 18.8875L16.6559 23.3388C18.0195 19.2636 21.8282 16.2386 26.3109 16.2386V16.2386Z\" fill=\"#EA4335\"/\u003e\n    \u003c/svg\u003e\n    \u003csvg class=\"logo-dark\" width=\"18\" height=\"18\" viewBox=\"0 0 48 48\" xmlns=\"http://www.w3.org/2000/svg\"\u003e\n      \u003ccircle cx=\"24\" cy=\"23\" fill=\"#FFF\" r=\"22\"/\u003e\n      \u003cpath d=\"M33.76 34.26c2.75-2.56 4.49-6.37 4.49-11.26 0-.89-.08-1.84-.29-3H24.01v5.99h8.03c-.4 2.02-1.5 3.56-3.07 4.56v.75l3.91 2.97h.88z\" fill=\"#4285F4\"/\u003e\n      \u003cpath d=\"M15.58 25.77A8.845 8.845 0 0 0 24 31.86c1.92 0 3.62-.46 4.97-1.31l4.79 3.71C31.14 36.7 27.65 38 24 38c-5.93 0-11.01-3.4-13.45-8.36l.17-1.01 4.06-2.85h.8z\" fill=\"#34A853\"/\u003e\n      \u003cpath d=\"M15.59 20.21a8.864 8.864 0 0 0 0 5.58l-5.03 3.86c-.98-2-1.53-4.25-1.53-6.64 0-2.39.55-4.64 1.53-6.64l1-.22 3.81 2.98.22 1.08z\" fill=\"#FBBC05\"/\u003e\n      \u003cpath d=\"M24 14.14c2.11 0 4.02.75 5.52 1.98l4.36-4.36C31.22 9.43 27.81 8 24 8c-5.93 0-11.01 3.4-13.45 8.36l5.03 3.85A8.86 8.86 0 0 1 24 14.14z\" fill=\"#EA4335\"/\u003e\n    \u003c/svg\u003e\n    \u003cdiv class=\"gradient-container\"\u003e\u003cdiv class=\"gradient\"\u003e\u003c/div\u003e\u003c/div\u003e\n  \u003c/div\u003e\n  \u003cdiv class=\"carousel\"\u003e\n    \u003ca class=\"chip\" href=\"https://vertexaisearch.cloud.google.com/grounding-api-redirect/AQXblrzgoTk4Gq0G5Qn6oZ0LnS3HCYW1AUdi4Px7dJdDQH3EizRQ75uzFDnq8DScv_1gZkKGRi6FxUEWJ9Nm9HI6a_o7q_88hoGYDFHRpJBB4TOvz4-H_8JfIpoYCBwl0sk5DJ5skhPGP7Klcr86vEqWHCfq5yGwghXwwM2gr2PE3Gz98kSmFMyqnNes_jN5CaGPeQcRmEVInmi42hTH\"\u003eGoogle stock price today\u003c/a\u003e\n  \u003c/div\u003e\n\u003c/div\u003e\n"
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
