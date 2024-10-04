//
//  FalQueueResponseTests.swift
//
//
//  Created by Lou Zell on 9/13/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class FalQueueResponseTests: XCTestCase {
    func testThis() {
//        {"status": "COMPLETED", "request_id": "365f4013-3e2c-46cf-9351-083406730e77", "response_url": "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/365f4013-3e2c-46cf-9351-083406730e77", "status_url": "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/365f4013-3e2c-46cf-9351-083406730e77/status", "cancel_url": "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/365f4013-3e2c-46cf-9351-083406730e77/cancel", "logs": null, "metrics": {"inference_time": 132.09963178634644}}

    }

    func testResponseBodyIsDecodable() throws {
        let sampleResponse = """
        {
          "status": "IN_QUEUE",
          "request_id": "df301040-a3a3-4b14-936f-6ea1d9e4fa94",
          "response_url": "https://queue.fal.run/fal-ai/fast-sdxl/requests/df301040-a3a3-4b14-936f-6ea1d9e4fa94",
          "status_url": "https://queue.fal.run/fal-ai/fast-sdxl/requests/df301040-a3a3-4b14-936f-6ea1d9e4fa94/status",
          "cancel_url": "https://queue.fal.run/fal-ai/fast-sdxl/requests/df301040-a3a3-4b14-936f-6ea1d9e4fa94/cancel",
          "logs": null,
          "metrics": {},
          "queue_position": 0
        }
        """
        let res = try FalQueueResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(
            "https://queue.fal.run/fal-ai/fast-sdxl/requests/df301040-a3a3-4b14-936f-6ea1d9e4fa94/status",
            res.statusURL?.absoluteString
        )
    }

    func testAllStatusesAreDecodable() throws {
        let res1 = try FalQueueResponseBody.deserialize(from: #"{"status": "IN_QUEUE"}"#)
        let res2 = try FalQueueResponseBody.deserialize(from: #"{"status": "IN_PROGRESS"}"#)
        let res3 = try FalQueueResponseBody.deserialize(from: #"{"status": "COMPLETED"}"#)
        XCTAssertEqual(.inQueue, res1.status)
        XCTAssertEqual(.inProgress, res2.status)
        XCTAssertEqual(.completed, res3.status)
    }

    func testCompletedResponseIsDecodable() throws {
        let sampleResponse = """
        {
          "status": "COMPLETED",
          "request_id": "4af3d8a1-da6c-434c-8a9d-819a6d47d733",
          "response_url": "https://queue.fal.run/fal-ai/fast-sdxl/requests/4af3d8a1-da6c-434c-8a9d-819a6d47d733",
          "status_url": "https://queue.fal.run/fal-ai/fast-sdxl/requests/4af3d8a1-da6c-434c-8a9d-819a6d47d733/status",
          "cancel_url": "https://queue.fal.run/fal-ai/fast-sdxl/requests/4af3d8a1-da6c-434c-8a9d-819a6d47d733/cancel",
          "logs": null,
          "metrics": {
            "inference_time": 2.1722686290740967
          }
        }
        """
        let res = try FalQueueResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(
            2.1722686290740967,
            res.metrics?.inferenceTime
        )
    }

    func testTrainingQueueResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "status": "COMPLETED",
          "request_id": "78386d79-a969-46e7-a590-793f8970aa3b",
          "response_url": "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/78386d79-a969-46e7-a590-793f8970aa3b",
          "status_url": "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/78386d79-a969-46e7-a590-793f8970aa3b/status",
          "cancel_url": "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/78386d79-a969-46e7-a590-793f8970aa3b/cancel",
          "logs": null,
          "metrics": {}
        }
        """#
        let res = try FalQueueResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual(.completed, res.status)
        XCTAssertEqual(
            "https://queue.fal.run/fal-ai/flux-lora-fast-training/requests/78386d79-a969-46e7-a590-793f8970aa3b",
            res.responseURL?.absoluteString
        )
    }
}

