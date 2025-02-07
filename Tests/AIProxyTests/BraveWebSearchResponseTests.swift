//
//  BraveResponseTests.swift
//  AIProxy
//
//  Created by Lou Zell on 2/7/25.
//

import XCTest
import Foundation
@testable import AIProxy

final class BraveResponseTests: XCTestCase {

    func testResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
            "query": {
                "original": "How does concurrency work in Swift 6",
                "show_strict_warning": false,
                "is_navigational": false,
                "is_news_breaking": false,
                "spellcheck_off": true,
                "country": "us",
                "bad_results": false,
                "should_fallback": false,
                "postal_code": "",
                "city": "",
                "header_country": "",
                "more_results_available": true,
                "state": ""
            },
            "mixed": {
                "type": "mixed",
                "main": [
                    {
                        "type": "web",
                        "index": 0,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 1,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 2,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 3,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 4,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 5,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 6,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 7,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 8,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 9,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 10,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 11,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 12,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 13,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 14,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 15,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 16,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 17,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 18,
                        "all": false
                    },
                    {
                        "type": "web",
                        "index": 19,
                        "all": false
                    }
                ],
                "top": [],
                "side": []
            },
            "type": "search",
            "web": {
                "type": "search",
                "results": [
                    {
                        "title": "Complete concurrency enabled by default – available from Swift 6.0",
                        "url": "https://www.hackingwithswift.com/swift/6.0/concurrency",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "<strong>Swift</strong> <strong>6</strong> contains another barrage of updates around <strong>concurrency</strong>, and the team ought to be proud of the extraordinary advances they have made to make this release possible. By far the biggest change is that complete <strong>concurrency</strong> checking is enabled by default. Unless you&#x27;re very fortunate indeed, ...",
                        "profile": {
                            "name": "Hacking with Swift",
                            "url": "https://www.hackingwithswift.com/swift/6.0/concurrency",
                            "long_name": "hackingwithswift.com",
                            "img": "https://imgs.search.brave.com/JTWLNUlqRfoXanoYwOU4mSggf7c_duVttaxs1rzmYnY/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYzJkNzI1NWFl/M2M4MjA5YWIxNTM0/MTFjOWE2OTY4MDc4/MDIzMTRmOWE2OTcx/ZGI0YWJhODAxODFj/MjM1NzY3Ni93d3cu/aGFja2luZ3dpdGhz/d2lmdC5jb20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "hackingwithswift.com",
                            "hostname": "www.hackingwithswift.com",
                            "favicon": "https://imgs.search.brave.com/JTWLNUlqRfoXanoYwOU4mSggf7c_duVttaxs1rzmYnY/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYzJkNzI1NWFl/M2M4MjA5YWIxNTM0/MTFjOWE2OTY4MDc4/MDIzMTRmOWE2OTcx/ZGI0YWJhODAxODFj/MjM1NzY3Ni93d3cu/aGFja2luZ3dpdGhz/d2lmdC5jb20v",
                            "path": "› swift  › 6.0  › concurrency"
                        }
                    },
                    {
                        "title": "Adopting strict concurrency in Swift 6 apps | Apple Developer Documentation",
                        "url": "https://developer.apple.com/documentation/swift/adoptingswift6",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Enable strict <strong>concurrency</strong> checking to find data races at compile time.",
                        "profile": {
                            "name": "Apple",
                            "url": "https://developer.apple.com/documentation/swift/adoptingswift6",
                            "long_name": "developer.apple.com",
                            "img": "https://imgs.search.brave.com/ZCU4M7z669FUgINSItxXnji8XrpE77lxnSTW2a_3TZk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYmY4MjZlMTk0/MzlmMDhhOGNiMDQw/N2EzNGRhOWM4YjQ4/NjAwNzk0MzY2NzEw/OWQ2Y2Y2YjZhN2Y4/YzQ3NGRiYi9kZXZl/bG9wZXIuYXBwbGUu/Y29tLw"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "developer.apple.com",
                            "hostname": "developer.apple.com",
                            "favicon": "https://imgs.search.brave.com/ZCU4M7z669FUgINSItxXnji8XrpE77lxnSTW2a_3TZk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYmY4MjZlMTk0/MzlmMDhhOGNiMDQw/N2EzNGRhOWM4YjQ4/NjAwNzk0MzY2NzEw/OWQ2Y2Y2YjZhN2Y4/YzQ3NGRiYi9kZXZl/bG9wZXIuYXBwbGUu/Y29tLw",
                            "path": "› documentation  › swift  › adoptingswift6"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/IjAW3uWKYeOFfjF-wP1r1BPSND-oa16K3w-LxvZ5ggY/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9kb2Nz/LmRldmVsb3Blci5h/cHBsZS5jb20vdHV0/b3JpYWxzL2RldmVs/b3Blci1vZy5qcGc",
                            "original": "https://docs.developer.apple.com/tutorials/developer-og.jpg",
                            "logo": false
                        }
                    },
                    {
                        "title": "Swift Concurrency by Example - free quick start tutorials for Swift developers",
                        "url": "https://www.hackingwithswift.com/quick-start/concurrency",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Get hands-on example code to help you learn important Apple frameworks faster.",
                        "profile": {
                            "name": "Hacking with Swift",
                            "url": "https://www.hackingwithswift.com/quick-start/concurrency",
                            "long_name": "hackingwithswift.com",
                            "img": "https://imgs.search.brave.com/JTWLNUlqRfoXanoYwOU4mSggf7c_duVttaxs1rzmYnY/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYzJkNzI1NWFl/M2M4MjA5YWIxNTM0/MTFjOWE2OTY4MDc4/MDIzMTRmOWE2OTcx/ZGI0YWJhODAxODFj/MjM1NzY3Ni93d3cu/aGFja2luZ3dpdGhz/d2lmdC5jb20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "hackingwithswift.com",
                            "hostname": "www.hackingwithswift.com",
                            "favicon": "https://imgs.search.brave.com/JTWLNUlqRfoXanoYwOU4mSggf7c_duVttaxs1rzmYnY/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYzJkNzI1NWFl/M2M4MjA5YWIxNTM0/MTFjOWE2OTY4MDc4/MDIzMTRmOWE2OTcx/ZGI0YWJhODAxODFj/MjM1NzY3Ni93d3cu/aGFja2luZ3dpdGhz/d2lmdC5jb20v",
                            "path": "› quick-start  › concurrency"
                        }
                    },
                    {
                        "title": "Understanding Concurrency in Swift 6 with Sendable protocol, MainActor, and async-await | by Egzon Pllana | Medium",
                        "url": "https://medium.com/@egzonpllana/understanding-concurrency-in-swift-6-with-sendable-protocol-mainactor-and-async-await-5ccfdc0ca2b6",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Swift Concurrency (async/await and Tasks): Introduced in Swift 5.5, this is a more modern and user-friendly approach to managing asynchronous code. It <strong>uses async and await keywords to write asynchronous code that looks synchronous</strong>. You can also use structured concurrency with Task and TaskGroup.",
                        "page_age": "2024-11-17T19:46:51",
                        "profile": {
                            "name": "Medium",
                            "url": "https://medium.com/@egzonpllana/understanding-concurrency-in-swift-6-with-sendable-protocol-mainactor-and-async-await-5ccfdc0ca2b6",
                            "long_name": "medium.com",
                            "img": "https://imgs.search.brave.com/4R4hFITz_F_be0roUiWbTZKhsywr3fnLTMTkFL5HFow/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTZhYmQ1N2Q4/NDg4ZDcyODIyMDZi/MzFmOWNhNjE3Y2E4/Y2YzMThjNjljNDIx/ZjllZmNhYTcwODhl/YTcwNDEzYy9tZWRp/dW0uY29tLw"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "article",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "medium.com",
                            "hostname": "medium.com",
                            "favicon": "https://imgs.search.brave.com/4R4hFITz_F_be0roUiWbTZKhsywr3fnLTMTkFL5HFow/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTZhYmQ1N2Q4/NDg4ZDcyODIyMDZi/MzFmOWNhNjE3Y2E4/Y2YzMThjNjljNDIx/ZjllZmNhYTcwODhl/YTcwNDEzYy9tZWRp/dW0uY29tLw",
                            "path": "› @egzonpllana  › understanding-concurrency-in-swift-6-with-sendable-protocol-mainactor-and-async-await-5ccfdc0ca2b6"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/knEQFqqUxAAkaxEJmJqYIdt8f236MCHh_7qW3XMj5lc/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9taXJv/Lm1lZGl1bS5jb20v/djIvcmVzaXplOmZp/dDoxMjAwLzEqZG90/Mzd1alJXM1dqNnhX/MHpiUVVhQS5wbmc",
                            "original": "https://miro.medium.com/v2/resize:fit:1200/1*dot37ujRW3Wj6xW0zbQUaA.png",
                            "logo": false
                        },
                        "age": "November 17, 2024"
                    },
                    {
                        "title": "Concurrency in Swift 6. Powering SwiftUI with Modern… | by Naser Daliribejindi | Medium",
                        "url": "https://medium.com/@amir.daliri/concurrency-in-swift-6-6f2b960065f1",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "This model thrives on a declarative approach, making it essential for <strong>concurrency</strong> mechanisms to integrate seamlessly with SwiftUI’s lifecycle and state management. ... Lack of Cancellation Support: GCD doesn’t provide built-in mechanisms to cancel tasks, which can lead to unnecessary <strong>work</strong> if ...",
                        "page_age": "2024-11-14T18:23:48",
                        "profile": {
                            "name": "Medium",
                            "url": "https://medium.com/@amir.daliri/concurrency-in-swift-6-6f2b960065f1",
                            "long_name": "medium.com",
                            "img": "https://imgs.search.brave.com/4R4hFITz_F_be0roUiWbTZKhsywr3fnLTMTkFL5HFow/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTZhYmQ1N2Q4/NDg4ZDcyODIyMDZi/MzFmOWNhNjE3Y2E4/Y2YzMThjNjljNDIx/ZjllZmNhYTcwODhl/YTcwNDEzYy9tZWRp/dW0uY29tLw"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "article",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "medium.com",
                            "hostname": "medium.com",
                            "favicon": "https://imgs.search.brave.com/4R4hFITz_F_be0roUiWbTZKhsywr3fnLTMTkFL5HFow/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTZhYmQ1N2Q4/NDg4ZDcyODIyMDZi/MzFmOWNhNjE3Y2E4/Y2YzMThjNjljNDIx/ZjllZmNhYTcwODhl/YTcwNDEzYy9tZWRp/dW0uY29tLw",
                            "path": "› @amir.daliri  › concurrency-in-swift-6-6f2b960065f1"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/8nAeK48k8G-R23dTTf2xtXcya4fbb4yeJBHssmabABk/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9taXJv/Lm1lZGl1bS5jb20v/djIvcmVzaXplOmZp/dDoxMjAwLzEqRDM5/WGpPRG1QN2dkeGNQ/d2JIS19hUS5wbmc",
                            "original": "https://miro.medium.com/v2/resize:fit:1200/1*D39XjODmP7gdxcPwbHK_aQ.png",
                            "logo": false
                        },
                        "age": "November 14, 2024"
                    },
                    {
                        "title": "Swift Concurrency cheat sheet: A Dive into Async/Await, Actors, and More | by Liudas Baronas | Medium",
                        "url": "https://liudasbar.medium.com/the-new-world-of-swift-concurrency-a-deep-dive-into-async-await-actors-and-more-e03ee9a72450",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Combine often uses Future to perform asynchronous work. Task in Swift concurrency is <strong>used to create units of work that can run asynchronously</strong>.",
                        "page_age": "2025-01-29T22:23:56",
                        "profile": {
                            "name": "Medium",
                            "url": "https://liudasbar.medium.com/the-new-world-of-swift-concurrency-a-deep-dive-into-async-await-actors-and-more-e03ee9a72450",
                            "long_name": "liudasbar.medium.com",
                            "img": "https://imgs.search.brave.com/t02mq39AY-DwnnQCUbjChTASAWSYHvTcA5gvXnmc1Q8/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvNDJiYjdhODNj/OWU3NGQ4MTRkYTVm/ZGU4NTJjYzZlYWI3/Njc1YjQ1ZjM1YWYw/NDkyNDlmNmNhMmJh/ODdkMzZjYy9saXVk/YXNiYXIubWVkaXVt/LmNvbS8"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "article",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "liudasbar.medium.com",
                            "hostname": "liudasbar.medium.com",
                            "favicon": "https://imgs.search.brave.com/t02mq39AY-DwnnQCUbjChTASAWSYHvTcA5gvXnmc1Q8/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvNDJiYjdhODNj/OWU3NGQ4MTRkYTVm/ZGU4NTJjYzZlYWI3/Njc1YjQ1ZjM1YWYw/NDkyNDlmNmNhMmJh/ODdkMzZjYy9saXVk/YXNiYXIubWVkaXVt/LmNvbS8",
                            "path": "› the-new-world-of-swift-concurrency-a-deep-dive-into-async-await-actors-and-more-e03ee9a72450"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/lDaL93ZeZM8e_GEXePvgctlgAP3UxpJAUvwKYxCysGo/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9taXJv/Lm1lZGl1bS5jb20v/djIvcmVzaXplOmZp/dDoxMjAwLzEqeUxI/R1kxQXg0ZWk4NGs5/dHZFV2Vldy5wbmc",
                            "original": "https://miro.medium.com/v2/resize:fit:1200/1*yLHGY1Ax4ei84k9tvEWeew.png",
                            "logo": false
                        },
                        "age": "1 week ago"
                    },
                    {
                        "title": "Concurrency | Apple Developer Documentation",
                        "url": "https://developer.apple.com/documentation/swift/concurrency",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Perform asynchronous and parallel operations",
                        "profile": {
                            "name": "Apple",
                            "url": "https://developer.apple.com/documentation/swift/concurrency",
                            "long_name": "developer.apple.com",
                            "img": "https://imgs.search.brave.com/ZCU4M7z669FUgINSItxXnji8XrpE77lxnSTW2a_3TZk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYmY4MjZlMTk0/MzlmMDhhOGNiMDQw/N2EzNGRhOWM4YjQ4/NjAwNzk0MzY2NzEw/OWQ2Y2Y2YjZhN2Y4/YzQ3NGRiYi9kZXZl/bG9wZXIuYXBwbGUu/Y29tLw"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "developer.apple.com",
                            "hostname": "developer.apple.com",
                            "favicon": "https://imgs.search.brave.com/ZCU4M7z669FUgINSItxXnji8XrpE77lxnSTW2a_3TZk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYmY4MjZlMTk0/MzlmMDhhOGNiMDQw/N2EzNGRhOWM4YjQ4/NjAwNzk0MzY2NzEw/OWQ2Y2Y2YjZhN2Y4/YzQ3NGRiYi9kZXZl/bG9wZXIuYXBwbGUu/Y29tLw",
                            "path": "› documentation  › swift  › concurrency"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/IjAW3uWKYeOFfjF-wP1r1BPSND-oa16K3w-LxvZ5ggY/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9kb2Nz/LmRldmVsb3Blci5h/cHBsZS5jb20vdHV0/b3JpYWxzL2RldmVs/b3Blci1vZy5qcGc",
                            "original": "https://docs.developer.apple.com/tutorials/developer-og.jpg",
                            "logo": false
                        }
                    },
                    {
                        "title": "A Swift Concurrency Glossary | massicotte.org",
                        "url": "https://www.massicotte.org/concurrency-glossary",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "It would be nice if there was a single place to go to look up all the terms, keywords, and annotations related to <strong>Swift</strong> <strong>concurrency</strong>. So here it is. By no means do you need to understand everything here to use <strong>concurrency</strong> successfully. Let me know what I forgot!",
                        "page_age": "2025-01-25T00:00:00",
                        "profile": {
                            "name": "Massicotte",
                            "url": "https://www.massicotte.org/concurrency-glossary",
                            "long_name": "massicotte.org",
                            "img": "https://imgs.search.brave.com/qOSL0psa-cfT2sSJWDniBf-mginOjaw-zgIMKfBIJSQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTc1MDNjNTI5/YWE1MGNiOGJmMjQz/NDJmZmFjZmZjN2Rl/MjYwM2Q5NGNjMGEz/OGM0NmZiNTA2YTYw/MWY4ZjcyYS93d3cu/bWFzc2ljb3R0ZS5v/cmcv"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "massicotte.org",
                            "hostname": "www.massicotte.org",
                            "favicon": "https://imgs.search.brave.com/qOSL0psa-cfT2sSJWDniBf-mginOjaw-zgIMKfBIJSQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTc1MDNjNTI5/YWE1MGNiOGJmMjQz/NDJmZmFjZmZjN2Rl/MjYwM2Q5NGNjMGEz/OGM0NmZiNTA2YTYw/MWY4ZjcyYS93d3cu/bWFzc2ljb3R0ZS5v/cmcv",
                            "path": "› concurrency-glossary"
                        },
                        "age": "2 weeks ago"
                    },
                    {
                        "title": "Migrating to Swift 6: The Strict Concurrency You Must Adopt - Apiumhub",
                        "url": "https://apiumhub.com/tech-blog-barcelona/migrating-to-swift-6/",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "While these tools have allowed ... something didn’t <strong>work</strong> as expected. With <strong>Swift</strong> <strong>6</strong>, Apple is giving us a big hand with what they call Strict <strong>Concurrency</strong>. <strong>In</strong> short, it provides us with clearer rules and safer tools to ensure <strong>concurrent</strong> code doesn’t become an unpredictable ...",
                        "page_age": "2024-10-25T09:32:01",
                        "profile": {
                            "name": "Apiumhub",
                            "url": "https://apiumhub.com/tech-blog-barcelona/migrating-to-swift-6/",
                            "long_name": "apiumhub.com",
                            "img": "https://imgs.search.brave.com/yf6zJ2Vg4a-MRPec9FiDdaq6Aqr-Ha6MuWgPy8ui1-k/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYjRjNWU2ZjBj/M2E1MTQ3NWEwNmEw/MWI3OWZlYWE0ZGM4/M2Q5YWZjMGE0OWM3/N2ZjMzFmNTBmZDky/OWQwZWUyMC9hcGl1/bWh1Yi5jb20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "apiumhub.com",
                            "hostname": "apiumhub.com",
                            "favicon": "https://imgs.search.brave.com/yf6zJ2Vg4a-MRPec9FiDdaq6Aqr-Ha6MuWgPy8ui1-k/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYjRjNWU2ZjBj/M2E1MTQ3NWEwNmEw/MWI3OWZlYWE0ZGM4/M2Q5YWZjMGE0OWM3/N2ZjMzFmNTBmZDky/OWQwZWUyMC9hcGl1/bWh1Yi5jb20v",
                            "path": "  › home  › migrating to swift 6: the strict concurrency you must adopt"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/quUi8GO_NcjdpKkSJX3mpkKjOOXdeqfLDuMPkYEnxas/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9hcGl1/bWh1Yi5jb20vd3At/Y29udGVudC91cGxv/YWRzLzIwMjQvMTAv/QXBpdW1odWItQkxP/Ry5qcGc",
                            "original": "https://apiumhub.com/wp-content/uploads/2024/10/Apiumhub-BLOG.jpg",
                            "logo": false
                        },
                        "age": "October 25, 2024"
                    },
                    {
                        "title": "Swift.org - Enabling Complete Concurrency Checking",
                        "url": "https://www.swift.org/documentation/concurrency/",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "<strong>Swift</strong> is a general-purpose programming language built using a modern approach to safety, performance, and software design patterns.",
                        "profile": {
                            "name": "Swift",
                            "url": "https://www.swift.org/documentation/concurrency/",
                            "long_name": "swift.org",
                            "img": "https://imgs.search.brave.com/qS6eqT-1xh3t9vgDeRsL1_PW8OsnOCNqpL9te9JIVUQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvN2RjZWEyMTMx/MzBmN2Q2NWY1OGFi/MTBhOWFkMjYyNWQx/ZTJiZTc1ZDUyYWZh/YzU5NGJhZjRhYTc4/MmEzYmRiMi93d3cu/c3dpZnQub3JnLw"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "swift.org",
                            "hostname": "www.swift.org",
                            "favicon": "https://imgs.search.brave.com/qS6eqT-1xh3t9vgDeRsL1_PW8OsnOCNqpL9te9JIVUQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvN2RjZWEyMTMx/MzBmN2Q2NWY1OGFi/MTBhOWFkMjYyNWQx/ZTJiZTc1ZDUyYWZh/YzU5NGJhZjRhYTc4/MmEzYmRiMi93d3cu/c3dpZnQub3JnLw",
                            "path": "› documentation  › concurrency"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/TnfzlZh8IvHxn8enF3y3A5tzUGjNeKQr56YSJKlQ36k/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9zd2lm/dC5vcmcvYXBwbGUt/dG91Y2gtaWNvbi0x/ODB4MTgwLnBuZw",
                            "original": "https://swift.org/apple-touch-icon-180x180.png",
                            "logo": false
                        }
                    },
                    {
                        "title": "More concurrency changes – available from Swift 5.6",
                        "url": "https://www.hackingwithswift.com/swift/5.6/preconcurrency",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "<strong>Swift</strong> 5.5 added a lot of features around <strong>concurrency</strong>, and 5.<strong>6</strong> continues the process of refining those features to make them safer and more consistent, while also <strong>working</strong> towards bigger, breaking changes coming <strong>in</strong> <strong>Swift</strong> <strong>6</strong>.",
                        "profile": {
                            "name": "Hacking with Swift",
                            "url": "https://www.hackingwithswift.com/swift/5.6/preconcurrency",
                            "long_name": "hackingwithswift.com",
                            "img": "https://imgs.search.brave.com/JTWLNUlqRfoXanoYwOU4mSggf7c_duVttaxs1rzmYnY/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYzJkNzI1NWFl/M2M4MjA5YWIxNTM0/MTFjOWE2OTY4MDc4/MDIzMTRmOWE2OTcx/ZGI0YWJhODAxODFj/MjM1NzY3Ni93d3cu/aGFja2luZ3dpdGhz/d2lmdC5jb20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "hackingwithswift.com",
                            "hostname": "www.hackingwithswift.com",
                            "favicon": "https://imgs.search.brave.com/JTWLNUlqRfoXanoYwOU4mSggf7c_duVttaxs1rzmYnY/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYzJkNzI1NWFl/M2M4MjA5YWIxNTM0/MTFjOWE2OTY4MDc4/MDIzMTRmOWE2OTcx/ZGI0YWJhODAxODFj/MjM1NzY3Ni93d3cu/aGFja2luZ3dpdGhz/d2lmdC5jb20v",
                            "path": "› swift  › 5.6  › preconcurrency"
                        }
                    },
                    {
                        "title": "Enabling Swift 6 Features and Concurrency in Xcode 16 | Swift Published",
                        "url": "https://swiftpublished.com/article/strict-concurrency-in-swift-6-part-2",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "However, <strong>Swift</strong> <strong>6</strong> addresses this by introducing the Sending keyword. This keyword relates to Sendable protocol conformance but <strong>works</strong> differently. It signifies that when a non-Sendable value is passed into trySend(), ownership of that value is transferred, allowing it to be safely passed to another <strong>concurrency</strong> ...",
                        "profile": {
                            "name": "Swiftpublished",
                            "url": "https://swiftpublished.com/article/strict-concurrency-in-swift-6-part-2",
                            "long_name": "swiftpublished.com",
                            "img": "https://imgs.search.brave.com/sDA_l_zb85sS317qu7R2aE3_sWTvBjNdiTybdDt0JNk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMjliMWNiY2Fk/MjY2NjQyMmY0MDli/NGJmYTBlNmNlYzY0/ODBmZjZlZDUwZTNl/ZDVhMWQ3OTQzMjkx/OTJjMmFlMS9zd2lm/dHB1Ymxpc2hlZC5j/b20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "swiftpublished.com",
                            "hostname": "swiftpublished.com",
                            "favicon": "https://imgs.search.brave.com/sDA_l_zb85sS317qu7R2aE3_sWTvBjNdiTybdDt0JNk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMjliMWNiY2Fk/MjY2NjQyMmY0MDli/NGJmYTBlNmNlYzY0/ODBmZjZlZDUwZTNl/ZDVhMWQ3OTQzMjkx/OTJjMmFlMS9zd2lm/dHB1Ymxpc2hlZC5j/b20v",
                            "path": "› article  › strict-concurrency-in-swift-6-part-2"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/2MiQoeZggsnJC8sgVoW1HMQh7yl_m-X8toB1e4SAJ_k/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9yZXMu/Y2xvdWRpbmFyeS5j/b20vc3dpZnRwdWJs/aXNoZWQvaW1hZ2Uv/dXBsb2FkL3YxNzI3/MTAyMzQ0L1hjb2Rl/MTZzd2lmdDE2bmV3/X3J3ZnpyZi5naWY.jpeg",
                            "original": "https://res.cloudinary.com/swiftpublished/image/upload/v1727102344/Xcode16swift16new_rwfzrf.gif",
                            "logo": false
                        }
                    },
                    {
                        "title": "Concurrency - Documentation - Swift.org",
                        "url": "https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "This document is made available under a Creative Commons Attribution 4.0 International (CC BY 4.0) License · <strong>Swift</strong> and the <strong>Swift</strong> logo are trademarks of Apple Inc",
                        "profile": {
                            "name": "Swift",
                            "url": "https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/",
                            "long_name": "docs.swift.org",
                            "img": "https://imgs.search.brave.com/aTDFKKhwI-_iQsrAXfnyvTYp4F5jxdJl48-whis7oOE/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYjNmNDk2NzVk/Y2JhZGNkYWUzNjBm/NDc4YjIzODE3Yzkx/ZGE5ZjMxNjdkMzJh/ZGJjOTMyOWYwOGM0/MTMzYzhlYS9kb2Nz/LnN3aWZ0Lm9yZy8"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "docs.swift.org",
                            "hostname": "docs.swift.org",
                            "favicon": "https://imgs.search.brave.com/aTDFKKhwI-_iQsrAXfnyvTYp4F5jxdJl48-whis7oOE/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYjNmNDk2NzVk/Y2JhZGNkYWUzNjBm/NDc4YjIzODE3Yzkx/ZGE5ZjMxNjdkMzJh/ZGJjOTMyOWYwOGM0/MTMzYzhlYS9kb2Nz/LnN3aWZ0Lm9yZy8",
                            "path": "› swift-book  › documentation  › the-swift-programming-language  › concurrency"
                        }
                    },
                    {
                        "title": "Introduction to Strict Concurrency in Swift 6 | Swift Published",
                        "url": "https://swiftpublished.com/article/strict-concurrency-in-swift-6-part-1",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "An introduction to <strong>Swift</strong> <strong>Concurrency</strong>, it will touch upon basic concepts like async-await, Task, actor, Sendable etc &amp; prepare a roadmap for the migration to Strict <strong>Concurrency</strong> <strong>in</strong> <strong>Swift</strong> <strong>6</strong>.",
                        "profile": {
                            "name": "Swiftpublished",
                            "url": "https://swiftpublished.com/article/strict-concurrency-in-swift-6-part-1",
                            "long_name": "swiftpublished.com",
                            "img": "https://imgs.search.brave.com/sDA_l_zb85sS317qu7R2aE3_sWTvBjNdiTybdDt0JNk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMjliMWNiY2Fk/MjY2NjQyMmY0MDli/NGJmYTBlNmNlYzY0/ODBmZjZlZDUwZTNl/ZDVhMWQ3OTQzMjkx/OTJjMmFlMS9zd2lm/dHB1Ymxpc2hlZC5j/b20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "swiftpublished.com",
                            "hostname": "swiftpublished.com",
                            "favicon": "https://imgs.search.brave.com/sDA_l_zb85sS317qu7R2aE3_sWTvBjNdiTybdDt0JNk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMjliMWNiY2Fk/MjY2NjQyMmY0MDli/NGJmYTBlNmNlYzY0/ODBmZjZlZDUwZTNl/ZDVhMWQ3OTQzMjkx/OTJjMmFlMS9zd2lm/dHB1Ymxpc2hlZC5j/b20v",
                            "path": "› article  › strict-concurrency-in-swift-6-part-1"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/XkJluodrJSmWapuv6dwWhOs8y21lIZz_mUhhKA-3erk/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9yZXMu/Y2xvdWRpbmFyeS5j/b20vc3dpZnRwdWJs/aXNoZWQvaW1hZ2Uv/dXBsb2FkL3YxNzI3/ODk1NDM4L1N3aWZ0/X0NvbmN1cnJlbmN5/X3VtZ3R0Zi53ZWJw",
                            "original": "https://res.cloudinary.com/swiftpublished/image/upload/v1727895438/Swift_Concurrency_umgttf.webp",
                            "logo": false
                        }
                    },
                    {
                        "title": "Should You Enable Swift’s Complete Concurrency Checking? | massicotte.org",
                        "url": "https://www.massicotte.org/complete-checking",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "I think many people believe you ... <strong>Swift</strong> <strong>6</strong>. And, yes, that is true! But, I do not think this is the most compelling reason today. You turn on complete checking to learn <strong>how</strong> <strong>Swift</strong> <strong>concurrency</strong> actually <strong>works</strong>. When you write code the compiler complains if your syntax is wrong. So you look at the errors and they help you fix things. That’s feedback! Finally you get things sorted and can run the program. But of course it doesn’t <strong>work</strong> right ...",
                        "page_age": "2024-02-14T00:00:00",
                        "profile": {
                            "name": "Massicotte",
                            "url": "https://www.massicotte.org/complete-checking",
                            "long_name": "massicotte.org",
                            "img": "https://imgs.search.brave.com/qOSL0psa-cfT2sSJWDniBf-mginOjaw-zgIMKfBIJSQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTc1MDNjNTI5/YWE1MGNiOGJmMjQz/NDJmZmFjZmZjN2Rl/MjYwM2Q5NGNjMGEz/OGM0NmZiNTA2YTYw/MWY4ZjcyYS93d3cu/bWFzc2ljb3R0ZS5v/cmcv"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "massicotte.org",
                            "hostname": "www.massicotte.org",
                            "favicon": "https://imgs.search.brave.com/qOSL0psa-cfT2sSJWDniBf-mginOjaw-zgIMKfBIJSQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTc1MDNjNTI5/YWE1MGNiOGJmMjQz/NDJmZmFjZmZjN2Rl/MjYwM2Q5NGNjMGEz/OGM0NmZiNTA2YTYw/MWY4ZjcyYS93d3cu/bWFzc2ljb3R0ZS5v/cmcv",
                            "path": "› complete-checking"
                        },
                        "age": "February 14, 2024"
                    },
                    {
                        "title": "Migrate your app to Swift 6 - WWDC24 - Videos - Apple Developer",
                        "url": "https://developer.apple.com/videos/play/wwdc2024/10169/",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "In this talk, we’re going to ... <strong>Swift</strong> <strong>6</strong> <strong>in</strong> an app that we already refactored previously to use <strong>Swift</strong> <strong>concurrency</strong>. So we start with enabling complete checking. What does complete checking enable? If you’ve already been using <strong>Swift</strong> <strong>Concurrency</strong> <strong>in</strong> your app, you’ve probably seen warnings or errors from the <strong>Swift</strong> compiler about <strong>concurrency</strong> issues that came up as you adopted <strong>Swift</strong>’<strong>s</strong> <strong>concurrency</strong> features. For example, here we’re <strong>working</strong> on adding ...",
                        "profile": {
                            "name": "Apple Developer",
                            "url": "https://developer.apple.com/videos/play/wwdc2024/10169/",
                            "long_name": "developer.apple.com",
                            "img": "https://imgs.search.brave.com/ZCU4M7z669FUgINSItxXnji8XrpE77lxnSTW2a_3TZk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYmY4MjZlMTk0/MzlmMDhhOGNiMDQw/N2EzNGRhOWM4YjQ4/NjAwNzk0MzY2NzEw/OWQ2Y2Y2YjZhN2Y4/YzQ3NGRiYi9kZXZl/bG9wZXIuYXBwbGUu/Y29tLw"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "developer.apple.com",
                            "hostname": "developer.apple.com",
                            "favicon": "https://imgs.search.brave.com/ZCU4M7z669FUgINSItxXnji8XrpE77lxnSTW2a_3TZk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvYmY4MjZlMTk0/MzlmMDhhOGNiMDQw/N2EzNGRhOWM4YjQ4/NjAwNzk0MzY2NzEw/OWQ2Y2Y2YjZhN2Y4/YzQ3NGRiYi9kZXZl/bG9wZXIuYXBwbGUu/Y29tLw",
                            "path": "› videos  › play  › wwdc2024  › 10169"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/LOwZtPfulYqhnrnyXeoI-HmDWUDClA79kKpYHg3JW5M/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9kZXZp/bWFnZXMtY2RuLmFw/cGxlLmNvbS93d2Rj/LXNlcnZpY2VzL2lt/YWdlcy9DMDNFNkU2/RC1BMzJBLTQxRDAt/OUU1MC1DM0M2MDU5/ODIwQUEvOTI5OS85/Mjk5X3dpZGVfMjUw/eDE0MV8yeC5qcGc",
                            "original": "https://devimages-cdn.apple.com/wwdc-services/images/C03E6E6D-A32A-41D0-9E50-C3C6059820AA/9299/9299_wide_250x141_2x.jpg",
                            "logo": false
                        }
                    },
                    {
                        "title": "r/swift on Reddit: Beginner questions about Swift 6/Concurrency",
                        "url": "https://www.reddit.com/r/swift/comments/1e4zilg/beginner_questions_about_swift_6concurrency/",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "I am really stuck at the most basic things when trying to migrate to <strong>Swift</strong> <strong>6</strong>. <strong>How</strong> can I properly reference another function from a class inside a…",
                        "page_age": "2024-07-16T20:50:51",
                        "profile": {
                            "name": "Reddit",
                            "url": "https://www.reddit.com/r/swift/comments/1e4zilg/beginner_questions_about_swift_6concurrency/",
                            "long_name": "reddit.com",
                            "img": "https://imgs.search.brave.com/U-eHNCapRHVNWWCVPPMTIvOofZULh0_A_FQKe8xTE4I/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvN2ZiNTU0M2Nj/MTFhZjRiYWViZDlk/MjJiMjBjMzFjMDRk/Y2IzYWI0MGI0MjVk/OGY5NzQzOGQ5NzQ5/NWJhMWI0NC93d3cu/cmVkZGl0LmNvbS8"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "qa",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "reddit.com",
                            "hostname": "www.reddit.com",
                            "favicon": "https://imgs.search.brave.com/U-eHNCapRHVNWWCVPPMTIvOofZULh0_A_FQKe8xTE4I/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvN2ZiNTU0M2Nj/MTFhZjRiYWViZDlk/MjJiMjBjMzFjMDRk/Y2IzYWI0MGI0MjVk/OGY5NzQzOGQ5NzQ5/NWJhMWI0NC93d3cu/cmVkZGl0LmNvbS8",
                            "path": "  › r/swift  › beginner questions about swift 6/concurrency"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/A5H_aQiEBuUODR0lNeU8iDfhrWUvO8oEmRGE_mcS_gM/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly93d3cu/cmVkZGl0c3RhdGlj/LmNvbS9pY29uLnBu/Zw",
                            "original": "https://www.redditstatic.com/icon.png",
                            "logo": false
                        },
                        "age": "July 16, 2024"
                    },
                    {
                        "title": "Strict Concurrency in Swift 6 & Understanding Xcode 16 and Swift 6 Compiler, Language Version | Swift Published",
                        "url": "https://swiftpublished.com/article/enabling-strict-concurrency-in-swift-6",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "To upgrade your package to <strong>Swift</strong> <strong>6</strong>, you need to explicitly adopt the following <strong>Swift</strong> setting: ... This is the first ever World&#x27;s Northernmost Apple Developers&#x27; Conference with One day of workshops, two days of tech-talks, Sauna 🧖, ice swimming 🏊, northern lights 🗻, and drinks to help you forget about <strong>work</strong> and connect with like-minded professionals, it is organised by Jesse Sipola Get your tickets! ... If you only want to enable strict <strong>concurrency</strong> ...",
                        "profile": {
                            "name": "Swiftpublished",
                            "url": "https://swiftpublished.com/article/enabling-strict-concurrency-in-swift-6",
                            "long_name": "swiftpublished.com",
                            "img": "https://imgs.search.brave.com/sDA_l_zb85sS317qu7R2aE3_sWTvBjNdiTybdDt0JNk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMjliMWNiY2Fk/MjY2NjQyMmY0MDli/NGJmYTBlNmNlYzY0/ODBmZjZlZDUwZTNl/ZDVhMWQ3OTQzMjkx/OTJjMmFlMS9zd2lm/dHB1Ymxpc2hlZC5j/b20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "swiftpublished.com",
                            "hostname": "swiftpublished.com",
                            "favicon": "https://imgs.search.brave.com/sDA_l_zb85sS317qu7R2aE3_sWTvBjNdiTybdDt0JNk/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMjliMWNiY2Fk/MjY2NjQyMmY0MDli/NGJmYTBlNmNlYzY0/ODBmZjZlZDUwZTNl/ZDVhMWQ3OTQzMjkx/OTJjMmFlMS9zd2lm/dHB1Ymxpc2hlZC5j/b20v",
                            "path": "› article  › enabling-strict-concurrency-in-swift-6"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/3OUBcZEauGM25_xpVdn4pu9g3C-1uCYsnuql932AM8k/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMudW5zcGxhc2gu/Y29tL3Bob3RvLTE1/NTgzNDY1NDctNDQz/OTQ2N2JkMWQ1P2l4/bGliPXJiLTQuMC4z/JnE9ODUmZm09anBn/JmNyb3A9ZW50cm9w/eSZjcz1zcmdi",
                            "original": "https://images.unsplash.com/photo-1558346547-4439467bd1d5?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb",
                            "logo": false
                        }
                    },
                    {
                        "title": "A Comprehensive Overview of Swift Concurrency",
                        "url": "https://www.dhiwise.com/post/deep-dive-into-swift-concurrency-asynchronous-programming",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Let&#x27;s delve into the world of <strong>Swift</strong> <strong>concurrency</strong>, exploring its modern language features such as async/await, structured <strong>concurrency</strong>, <strong>and</strong> <strong>Swift</strong> actors.",
                        "profile": {
                            "name": "Dhiwise",
                            "url": "https://www.dhiwise.com/post/deep-dive-into-swift-concurrency-asynchronous-programming",
                            "long_name": "dhiwise.com",
                            "img": "https://imgs.search.brave.com/AJfeW2draqNDi9DwY70eU95tjzT4ZcTR5WRXGg6qqsQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMDI2YWViYmM0/NmE4NzJmNmEzMWVk/MWY2YzNkNjQ3Y2Q5/YTQ4NDY0MmU3YWRh/NDAwNjgxZTU1MmQ5/ZDRhYmIyMy93d3cu/ZGhpd2lzZS5jb20v"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "dhiwise.com",
                            "hostname": "www.dhiwise.com",
                            "favicon": "https://imgs.search.brave.com/AJfeW2draqNDi9DwY70eU95tjzT4ZcTR5WRXGg6qqsQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvMDI2YWViYmM0/NmE4NzJmNmEzMWVk/MWY2YzNkNjQ3Y2Q5/YTQ4NDY0MmU3YWRh/NDAwNjgxZTU1MmQ5/ZDRhYmIyMy93d3cu/ZGhpd2lzZS5jb20v",
                            "path": "› post  › deep-dive-into-swift-concurrency-asynchronous-programming"
                        },
                        "thumbnail": {
                            "src": "https://imgs.search.brave.com/KXOFX7TMeeYN8yrKaAFwjc31qM1jYXb6z5ZZg8BQijI/rs:fit:200:200:1:0/g:ce/aHR0cHM6Ly9zdHJh/cGkuZGhpd2lzZS5j/b20vdXBsb2Fkcy9C/bG9nX0NvbW1vbl9J/bWFnZV9JT1NfT0df/SW1hZ2VfN2NhNmJh/OWVhNy5wbmc",
                            "original": "https://strapi.dhiwise.com/uploads/Blog_Common_Image_IOS_OG_Image_7ca6ba9ea7.png",
                            "logo": false
                        }
                    },
                    {
                        "title": "Problematic Swift Concurrency Patterns | massicotte.org",
                        "url": "https://www.massicotte.org/problematic-patterns",
                        "is_source_local": false,
                        "is_source_both": false,
                        "description": "Recently, someone asked me about best practices when using <strong>Swift</strong> <strong>concurrency</strong>. I have mixed feelings about the concept of a “best practice”. I’ll get to that in a bit. But, in this case, I said that the technology is still very young and we’re all still figuring it out.",
                        "page_age": "2024-10-29T00:00:00",
                        "profile": {
                            "name": "Massicotte",
                            "url": "https://www.massicotte.org/problematic-patterns",
                            "long_name": "massicotte.org",
                            "img": "https://imgs.search.brave.com/qOSL0psa-cfT2sSJWDniBf-mginOjaw-zgIMKfBIJSQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTc1MDNjNTI5/YWE1MGNiOGJmMjQz/NDJmZmFjZmZjN2Rl/MjYwM2Q5NGNjMGEz/OGM0NmZiNTA2YTYw/MWY4ZjcyYS93d3cu/bWFzc2ljb3R0ZS5v/cmcv"
                        },
                        "language": "en",
                        "family_friendly": true,
                        "type": "search_result",
                        "subtype": "generic",
                        "is_live": false,
                        "meta_url": {
                            "scheme": "https",
                            "netloc": "massicotte.org",
                            "hostname": "www.massicotte.org",
                            "favicon": "https://imgs.search.brave.com/qOSL0psa-cfT2sSJWDniBf-mginOjaw-zgIMKfBIJSQ/rs:fit:32:32:1:0/g:ce/aHR0cDovL2Zhdmlj/b25zLnNlYXJjaC5i/cmF2ZS5jb20vaWNv/bnMvOTc1MDNjNTI5/YWE1MGNiOGJmMjQz/NDJmZmFjZmZjN2Rl/MjYwM2Q5NGNjMGEz/OGM0NmZiNTA2YTYw/MWY4ZjcyYS93d3cu/bWFzc2ljb3R0ZS5v/cmcv",
                            "path": "› problematic-patterns"
                        },
                        "age": "October 29, 2024"
                    }
                ],
                "family_friendly": true
            }
        }
        """#
        let body = try BraveWebSearchResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(body.web?.results?.first?.url, "https://www.hackingwithswift.com/swift/6.0/concurrency")
    }
}

