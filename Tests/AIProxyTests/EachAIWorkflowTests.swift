//
//  EachAIWorkflowTests.swift
//
//
//  Created by Lou Zell on 12/7/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class EachAIWorkflowTests: XCTestCase {

    func testTriggerWorkflowResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "status": "success",
          "message": "Workflow triggered successfully",
          "trigger_id": "mp0tnsxinwymncyio"
        }
        """#
        let res = try EachAITriggerWorkflowResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("mp0tnsxinwymncyio", res.triggerID)
        XCTAssertEqual("success", res.status)
        XCTAssertEqual("Workflow triggered successfully", res.message)
    }

    func testFlowExecutionResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "flow_id": "bda5f7e3-d146-454d-bdb6-befb47adb2b1",
          "average_percent": 100,
          "flow_name": "1940's - Clone",
          "organization_id": "1049",
          "api_key": "MP1019YB1TSIBUCMOWNQL3V54NY2CC6GZGXM",
          "execution_id": "mp53sjtsdgl83y2wm",
          "source_ip_address": "",
          "parameters": [
            {
              "name": "img",
              "value": "https://storage.googleapis.com/magicpoint/models/women.png"
            }
          ],
          "step_results": [
            {
              "step_id": "step1",
              "step_name": "Face Analyzer",
              "model": "1019-face-analyzer",
              "version": "0.0.1",
              "started_at": "2024-12-07T21:09:37Z",
              "ended_at": "2024-12-07T21:09:45Z",
              "status": "succeeded",
              "output": "{\"age\":27,\"gender\":\"Woman\",\"race\":\"white\"}",
              "output_json": null,
              "input": "{\"image_url\":\"https://storage.googleapis.com/magicpoint/models/women.png\"}"
            },
            {
              "step_id": "step2",
              "step_name": "Image Generation",
              "model": "photomaker",
              "version": "0.0.1",
              "started_at": "2024-12-07T21:09:59Z",
              "ended_at": "2024-12-07T21:11:04Z",
              "status": "succeeded",
              "output": "\"https://storage.googleapis.com/1019uploads/output/1959357c-fba7-4c96-aada-0eb6c8a05474/0.png\"",
              "output_json": null,
              "input": "{\"guidance_scale\":5,\"input_image\":\"https://storage.googleapis.com/magicpoint/models/women.png\",\"negative_prompt\":\"nsfw, lowres, bad anatomy, hand, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry\",\"num_outputs\":1,\"num_steps\":20,\"prompt\":\" Vintage 1920s portrait of a flapper 27-year-old white {{step1.output.gender} img with a bob haircut, captured with a Graflex Speed Graphic camera, f/4.5 lens, 1/50 sec exposure, black and white, grainy, soft focus.\",\"style_name\":\"Photographic (Default)\",\"style_strength_ratio\":20}"
            },
            {
              "step_id": "step3",
              "step_name": "Face Swap",
              "model": "face-swap-new",
              "version": "0.0.1",
              "started_at": "2024-12-07T21:11:13Z",
              "ended_at": "2024-12-07T21:11:28Z",
              "status": "succeeded",
              "output": "\"https://storage.googleapis.com/1019uploads/output/af240bcd-e993-4479-9722-db9251564b08/0.jpeg\"",
              "output_json": null,
              "input": "{\"input_image\":\"https://storage.googleapis.com/1019uploads/output/1959357c-fba7-4c96-aada-0eb6c8a05474/0.png\",\"swap_image\":\"https://storage.googleapis.com/magicpoint/models/women.png\"}"
            }
          ],
          "status": "succeeded",
          "output": "\"https://storage.googleapis.com/1019uploads/output/af240bcd-e993-4479-9722-db9251564b08/0.jpeg\"",
          "output_json": null,
          "created_at": "2024-12-07T21:09:30Z",
          "started_at": "2024-12-07T21:09:30Z",
          "ended_at": "2024-12-07T21:11:28Z",
          "updated_at": "",
          "deleted_at": ""
        }
        """#
        let res = try EachAIWorkflowExecutionResponseBody.deserialize(from: sampleResponse)
        XCTAssertEqual("\"https://storage.googleapis.com/1019uploads/output/af240bcd-e993-4479-9722-db9251564b08/0.jpeg\"", res.output)
        XCTAssertEqual("Face Swap", res.stepResults?.last?.stepName)
    }

    func testPendingFlowExecutionResponseIsDecodable() throws {
        let sampleResponse = #"""
        {
          "flow_id": "bda5f7e3-d146-454d-bdb6-befb47adb2b1",
          "average_percent": 9.816666666666666,
          "flow_name": "1940's - Clone",
          "organization_id": "1049",
          "api_key": "MP1019YB1TSIBUCMOWNQL3V54NY2CC6GZGXM",
          "execution_id": "mpzzednstsokliyjz",
          "source_ip_address": "",
          "parameters": [
            {
              "name": "img",
              "value": "https://storage.googleapis.com/magicpoint/models/women.png"
            }
          ],
          "step_results": [
            {
              "step_id": "step1",
              "step_name": "Face Analyzer",
              "model": "1019-face-analyzer",
              "version": "0.0.1",
              "started_at": "2024-12-08T09:50:34Z",
              "ended_at": "2024-12-08T09:50:40Z",
              "status": "succeeded",
              "output": "{\"age\":27,\"gender\":\"Woman\",\"race\":\"white\"}",
              "output_json": null,
              "input": "{\"image_url\":\"https://storage.googleapis.com/magicpoint/models/women.png\"}"
            },
            {
              "step_id": "step2",
              "step_name": "Image Generation",
              "model": "photomaker",
              "version": "0.0.1",
              "started_at": "",
              "ended_at": "",
              "status": "queued",
              "output": "",
              "output_json": null,
              "input": ""
            },
            {
              "step_id": "step3",
              "step_name": "Face Swap",
              "model": "face-swap-new",
              "version": "0.0.1",
              "started_at": "",
              "ended_at": "",
              "status": "queued",
              "output": "",
              "output_json": null,
              "input": ""
            }
          ],
          "status": "running",
          "output": "",
          "output_json": null,
          "created_at": "2024-12-08T09:50:29Z",
          "started_at": "2024-12-08T09:50:29Z",
          "ended_at": "",
          "updated_at": "",
          "deleted_at": ""
        }
        """#
        let _ = try EachAIWorkflowExecutionResponseBody.deserialize(from: sampleResponse)
    }
}

