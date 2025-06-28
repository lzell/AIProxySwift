//
//  GeminiGroundingResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 6/28/25.
//

import XCTest
import Foundation
@testable import AIProxy


final class GeminiGroundingResponseTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "candidates": [
            {
              "content": {
                "parts": [
                  {
                    "text": "Fixing your golf swing involves <snip>"
                  }
                ],
                "role": "model"
              },
              "finishReason": "STOP",
              "index": 0,
              "groundingMetadata": {
                "searchEntryPoint": {
                  "renderedContent": "snip"
                },
                "groundingChunks": [
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/snip",
                      "title": "golf.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFrEUFWosDHiK_yncNoEyeypdkgIowBuIRob0LIQPdZIUHEoYOLghqxZI8sTLwNv5o8u37UAejyGbMesHedfiQjU5l9eymthD9zQmfgblqH6tz2QK5OFpyv-F8gFj3x65Ijy_6oW_nl9Jnj1WdDNW7qvsVs",
                      "title": "oakridgegolfclub.co.uk"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHfMwKMr9g7o61yDzh1qZuvaEzztnX6hVYQMSsGzmxUoRTcyKt5EuRmqw5fDNw6APRe86Z3l0Z8TqDwahxwqD8Z1toUBNTzeYToM6MVo8rWp1APqKBFPua3MksQQCjcT6YRanSjS0c=",
                      "title": "youtube.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQF6GyT-We0tOa0iGINfWVJU4Oqpr3t3hoBcBk_R_on3EbV2GymgHa_1wzd6pkiIHI_Bmj98NX5FMDAaVdye2eCHCfANbExjNhwr5-T4zA6MK6nMdYHOUVJgcDj3lWsADldy98D4HXA1I-8xMdFpVsLDlW44OntRw7oN4w52osZAthrmGq1w0-jF",
                      "title": "littlehaygolf.co.uk"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEBmlF0UZMDPrScstTZ89sXBW2tSQePPL414c0iLGw43G3T68SuGZC99K9fDNdCUrCdiUAkunmiMxIQ1F7z6OwNL6A3mPtYmqPnegnvZ2vG7Ns0kEMXJwBI3QdjI-XkWQf9vrQnvcunpFUx2KKQDTMhAgXsIikeMGwAlPdejQR760R-BrFzpdcdO2Dlyp9h7NseuhUIk-TSDlRG",
                      "title": "thegolfcollective.com.au"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQG9aNYGZpaXu6tRUsVo6n95q9RVt3oR8xciK7MxjKNzm58AFP7AfG44_1Ny2hUxd4tLNTK2jvYIHxjPARLpKhLguqLvOZO_8-m6MbUI42VVIBC26nM0LOsfemDYpZSIumNvLm8dHPTwYZBdsJOpyK4z4oYNZvCmtQ==",
                      "title": "swingtrainer.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGhBgaunrKeNAI8eaqoDvsMBIcaGyqfJLLGjlw5D5QTCPFViz2bQMdnEun_IIDOlgbI7wdab4kAtCUu7UoCFSFsagrIJyjktFgazFUpwh6G_fcHLXzqU2ysV8FlS8NsLn45EEQwm6s=",
                      "title": "youtube.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEeGYJkSw_MKaN9dAbPkoHL7a2N19nNgZM49w6IRqXgaPX7yUwe53RjUVlOVaa-_xfINpcEutbuYjPN0OhKnu8euvCS3DIHeNXtiIADhk3dIa9hSO4gMNu9121fWbL5hyjGF9BfRUYAzzpmOIHkdG_A4dQPLVHl90Fg2yUrnAwhKmE=",
                      "title": "golfforbeginners.academy"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHDbt-uJ6AtKgBLlDFPRHEpyYbCmYn7_kAIOE7B_JVohRr2JUP6Ue9tXpY1A1BxDKK_TCn454jQiTgi2RHtzpDoKCuPyF3cI8jyGgIl5MFBXTCTRjmDL-ev1nBAY0AfbHiPhzPdq2xTol741v35",
                      "title": "hackmotion.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEYFQukBxtYWW1DLjmTJMvsmsQuctoBIk4PZLr6T3JXJvV4SmvX1_AIMnO71avsZ1c8cE1xQ3vVXpskBPuVv4g2QAyFtfHNbhkG8F21OFpAGTKD_ZBNJ2WJi40q_HXXUR5_aQ7eUd6WAwS2koI6Br2yurYftXXCo1h96a0xRpiSM5SRxU555Ec=",
                      "title": "golfmonthly.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEBxNT6YEmhsmSCpufUCskW_FpGN7AIRE1IW4VhO6JxXzPt8BKbcO31oJrTaV4EBEgjOjaa8jxdCT2fTapar693yV6imMxBX3vy_FOKftjrMn7A3eTLLysgsJ7j4dewCWqvTRCdAjsQzczI246TzDok0WqL3lv6OyiZlZu5zNiNrtPFJ1MlAOTpNqy53KaZDxmd3xt89_E54n-5Dpu8Zg==",
                      "title": "dannymaude.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGl4cPV8nuS-L3sIJK3A8SS_-ZFKz9FwN0lN38C16rT0lfTFazp-oShZD6gfJ6bNRFvQ7l2Nfy12sTUDX2LhPiN73qZ1pnq4wUOmy4y4g8HbyNH_UXnzAnbM921y2v4z9hJo2URsTM=",
                      "title": "youtube.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHO0OiWR5_nvufFY8GOPD2u_u6R12HR6nByYO3Q5cux9VBH5GzCpvcVeLnqrMEbeV8fh3nK6d8VmJNhMh1EhH7cw4Icjk4EY-m2T4HeyvbqbULys2CQPnv61LQMIJwc_SOMbMD6Je_4Vz24iqmiG23K4Wi0v33S05P4xjaeioPsfTM6fYnMvuwtPAlPqt0wXXme515lbEaSAPs5GeGAEWQcf8Q=",
                      "title": "golftec.com"
                    }
                  },
                  {
                    "web": {
                      "uri": "https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEK0WishAJZAqEBg88nPUWBJKxCHu2kt5N3rbfSIPqFr0Xe0rtfv-jf6oLuNSCLfrIAE7y3RIAoC1GdcFcYmpba2qjYoXaUpl3vqChWizGHEyeWxk3mtBwf5LETvYa_48_RzFyzGRlY",
                      "title": "hackmotion.com"
                    }
                  }
                ],
                "groundingSupports": [
                  {
                    "segment": {
                      "startIndex": 359,
                      "endIndex": 449,
                      "text": "The \"V\" shape formed by your thumb and forefinger should point towards your trail shoulder"
                    },
                    "groundingChunkIndices": [
                      0,
                      1,
                      2
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 451,
                      "endIndex": 496,
                      "text": "Avoid gripping too tightly to prevent tension"
                    },
                    "groundingChunkIndices": [
                      0,
                      2
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 646,
                      "endIndex": 677,
                      "text": "Your arms should hang naturally"
                    },
                    "groundingChunkIndices": [
                      0,
                      1,
                      3,
                      4
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 679,
                      "endIndex": 747,
                      "text": "This athletic stance provides balance and allows for better rotation"
                    },
                    "groundingChunkIndices": [
                      1,
                      4
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 749,
                      "endIndex": 908,
                      "text": "*   **Alignment:** Your feet, hips, and shoulders should be parallel to your target line, like train tracks, with the clubface pointing directly at your target"
                    },
                    "groundingChunkIndices": [
                      1,
                      3
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 973,
                      "endIndex": 1112,
                      "text": "For a driver, the ball should be off the inside of your lead foot, while for a pitching wedge, it should be more in the middle of your feet"
                    },
                    "groundingChunkIndices": [
                      5
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1114,
                      "endIndex": 1209,
                      "text": "Experiment with ball placement to correct issues like hitting the ball too high or hooks/slices"
                    },
                    "groundingChunkIndices": [
                      1
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1217,
                      "endIndex": 1338,
                      "text": "Key Swing Mechanics:**\n*   **Weight Transfer & Rotation:** The golf swing involves both body rotation and weight transfer"
                    },
                    "groundingChunkIndices": [
                      6,
                      2
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1340,
                      "endIndex": 1454,
                      "text": "In the backswing, shift your weight to your trail side and turn your shoulders, keeping your head relatively still"
                    },
                    "groundingChunkIndices": [
                      5,
                      6,
                      7
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1456,
                      "endIndex": 1583,
                      "text": "For the downswing, initiate with your lower body, firing your hips towards the ball, and transfer your weight to your lead foot"
                    },
                    "groundingChunkIndices": [
                      5,
                      6,
                      2,
                      7
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1585,
                      "endIndex": 1693,
                      "text": "*   **Backswing:** Aim for a smooth, controlled backswing, turning your shoulders rather than just your arms"
                    },
                    "groundingChunkIndices": [
                      3
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1695,
                      "endIndex": 1764,
                      "text": "Keep your lead arm straight to promote a wider arc and generate power"
                    },
                    "groundingChunkIndices": [
                      7
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1766,
                      "endIndex": 1846,
                      "text": "*   **Downswing & Impact:** The downswing is about exerting energy into the ball"
                    },
                    "groundingChunkIndices": [
                      5
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1848,
                      "endIndex": 1928,
                      "text": "Focus on hitting the ground slightly *after* striking the ball for clean contact"
                    },
                    "groundingChunkIndices": [
                      7
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 1930,
                      "endIndex": 1999,
                      "text": "Avoid \"early casting\" (losing wrist lag) or \"stalling through impact\""
                    },
                    "groundingChunkIndices": [
                      8
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2001,
                      "endIndex": 2061,
                      "text": "Maintain forward shaft lean at impact for better ball flight"
                    },
                    "groundingChunkIndices": [
                      8
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2063,
                      "endIndex": 2184,
                      "text": "*   **Tempo & Rhythm:** A smooth, controlled swing with consistent tempo is often more effective than a fast, erratic one"
                    },
                    "groundingChunkIndices": [
                      8,
                      3
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2186,
                      "endIndex": 2273,
                      "text": "Try counting \"one, two\" on the backswing and \"three\" on the downswing to develop rhythm"
                    },
                    "groundingChunkIndices": [
                      3
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2417,
                      "endIndex": 2570,
                      "text": "Try shifting your body to exaggerate a circular path, closing your knees, hips, and shoulders, and moving the ball back in your stance with hands forward"
                    },
                    "groundingChunkIndices": [
                      9,
                      10
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2572,
                      "endIndex": 2678,
                      "text": "*   **Early Extension (Standing up in the downswing):** This is a common issue affecting balance and power"
                    },
                    "groundingChunkIndices": [
                      8,
                      9
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2680,
                      "endIndex": 2765,
                      "text": "*   **Over-the-Top:** This swing path comes from outside to inside, leading to slices"
                    },
                    "groundingChunkIndices": [
                      8,
                      9,
                      4
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2767,
                      "endIndex": 2839,
                      "text": "Getting your trail elbow into the correct position can help prevent this"
                    },
                    "groundingChunkIndices": [
                      11,
                      5
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2841,
                      "endIndex": 2979,
                      "text": "*   **Poor Wrist Action:** A cupped lead wrist at the top or losing wrist angle through impact can lead to an open clubface and weak shots"
                    },
                    "groundingChunkIndices": [
                      8,
                      11
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 2981,
                      "endIndex": 3071,
                      "text": "*   **Lack of Rotation/Poor Weight Transfer:** These can result in weak contact and slices"
                    },
                    "groundingChunkIndices": [
                      8,
                      9
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 3073,
                      "endIndex": 3120,
                      "text": "Ensure a full body turn and proper weight shift"
                    },
                    "groundingChunkIndices": [
                      6
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 3304,
                      "endIndex": 3395,
                      "text": "Technology can capture data on your body movement and compare it to professional benchmarks"
                    },
                    "groundingChunkIndices": [
                      12
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 3397,
                      "endIndex": 3554,
                      "text": "*   **Drills:** Practice drills that focus on specific areas, such as maintaining wrist angles, getting your trail elbow in place, or promoting arm extension"
                    },
                    "groundingChunkIndices": [
                      11,
                      9,
                      7
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 3556,
                      "endIndex": 3647,
                      "text": "*   **Consistency:** Establish a repeatable pre-shot routine and maintain a consistent pace"
                    },
                    "groundingChunkIndices": [
                      13
                    ]
                  },
                  {
                    "segment": {
                      "startIndex": 3649,
                      "endIndex": 3735,
                      "text": "*   **Relaxation:** Avoid tension in your body, as it can negatively affect your swing"
                    },
                    "groundingChunkIndices": [
                      0,
                      3
                    ]
                  }
                ],
                "webSearchQueries": [
                  "common golf swing faults and fixes",
                  "how to improve golf swing",
                  "golf swing basics for beginners"
                ]
              }
            }
          ],
          "usageMetadata": {
            "promptTokenCount": 17,
            "candidatesTokenCount": 845,
            "totalTokenCount": 960,
            "promptTokensDetails": [
              {
                "modality": "TEXT",
                "tokenCount": 17
              }
            ],
            "toolUsePromptTokenCount": 48,
            "thoughtsTokenCount": 50
          },
          "modelVersion": "gemini-2.5-flash",
          "responseId": "9i1gaParBsa21MkPia-U-Qw"
        }
        """#
        let body = try GeminiGenerateContentResponseBody.deserialize(from: sampleResponse)
        guard case .text(let txtContent) = body.candidates?.first?.content?.parts?.first else {
            return XCTFail()
        }

        XCTAssertEqual("Fixing your golf swing involves <snip>", txtContent)

        guard let groundingChunks = body.candidates?.first?.groundingMetadata?.groundingChunks else {
            return XCTFail()
        }
        XCTAssertEqual(URL(string: "https://vertexaisearch.cloud.google.com/grounding-api-redirect/snip"), groundingChunks.first?.web?.url)
    }
}

