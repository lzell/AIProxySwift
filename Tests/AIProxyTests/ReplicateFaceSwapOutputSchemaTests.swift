//
//  ReplicateFaceSwapOutputSchemaTests.swift
//  AIProxy
//
//  Created by Lou Zell on 1/1/25.
//

import XCTest
import Foundation
@testable import AIProxy


final class ReplicateFaceSwapOutputSchemaTests: XCTestCase {

    func testIsDecodable() throws {
        let responseBody = #"""
        {
          "id": "4aqzy7706nrmc0cm4gjsj9ckh4",
          "model": "xiankgx/face-swap",
          "version": "cff87316e31787df12002c9e20a78a017a36cb31fde9862d8dedd15ab29b7288",
          "input": {
            "cache_days": 10,
            "det_thresh": 0.1,
            "local_source": "data:image/jpeg;base64,...",
            "local_target": "data:image/jpeg;base64,...",
            "weight": 0.5
          },
          "logs": "snip",
          "output": {
            "code": 500,
            "image": "",
            "msg": "no face",
            "status": "failed"
          },
          "data_removed": false,
          "error": null,
          "status": "succeeded",
          "created_at": "2025-01-01T23:14:09.589Z",
          "started_at": "2025-01-01T23:14:09.821850689Z",
          "completed_at": "2025-01-01T23:14:09.959570548Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/4aqzy7706nrmc0cm4gjsj9ckh4/cancel",
            "get": "https://api.replicate.com/v1/predictions/4aqzy7706nrmc0cm4gjsj9ckh4"
          },
          "metrics": {
            "predict_time": 0.137719858
          }
        }
        """#
        let res = try ReplicateSynchronousAPIOutput<ReplicateFaceSwapOutputSchema>.deserialize(
            from: responseBody
        )
        XCTAssertEqual(res.output?.status, "failed")
    }

    func testSuccessIsDecodable() throws {
        let responseBody = #"""
        {
          "id": "9yvaqs786xrma0cm4khtmarsxm",
          "model": "xiankgx/face-swap",
          "version": "cff87316e31787df12002c9e20a78a017a36cb31fde9862d8dedd15ab29b7288",
          "input": {
            "cache_days": 10,
            "det_thresh": 0.1,
            "local_source": "data:image/jpeg;base64,...",
            "local_target": "data:image/jpeg;base64,...",
            "weight": 0.5
          },
          "logs": "",
          "output": {
            "code": 200,
            "image": "https://replicate.delivery/xezq/kb1dyZhMBn4dAxg9G7fQfocJL8HrD1KwXjj7w0wfCejdurDQB/cf78130a-eda9-412d-a959-027c4b5743dd.jpg",
            "msg": "succeed",
            "status": "succeed"
          },
          "data_removed": false,
          "error": null,
          "status": "processing",
          "created_at": "2025-01-02T02:41:43.479Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/9yvaqs786xrma0cm4khtmarsxm/cancel",
            "get": "https://api.replicate.com/v1/predictions/9yvaqs786xrma0cm4khtmarsxm"
          }
        }
        """#

        let res = try ReplicateSynchronousAPIOutput<ReplicateFaceSwapOutputSchema>.deserialize(
            from: responseBody
        )
        XCTAssertEqual(res.output?.status, "succeed")
        XCTAssertNotNil(res.output?.imageURL)
    }
}
