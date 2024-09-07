//
//  ReplicatePredictionResponseBodyTests.swift
//
//
//  Created by Lou Zell on 8/25/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicatePredictionResponseBodyTests: XCTestCase {

    func testCreatePredictionResponseIsDecodable() throws {
        let responseBody = """
        {
          "id": "bn8tbjmn9srgg0chh1xt7zy8xw",
          "model": "stability-ai/sdxl",
          "version": "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
          "input": {
            "prompt": "the lone ranger"
          },
          "logs": "",
          "output": null,
          "data_removed": false,
          "error": null,
          "status": "starting",
          "created_at": "2024-08-25T07:41:26.222Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/bn8tbjmn9srgg0chh1xt7zy8xw/cancel",
            "get": "https://api.replicate.com/v1/predictions/bn8tbjmn9srgg0chh1xt7zy8xw"
          }
        }
        """
        let res = try ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>.deserialize(
            from: responseBody
        )
        XCTAssertEqual(
            "https://api.replicate.com/v1/predictions/bn8tbjmn9srgg0chh1xt7zy8xw",
            res.urls?.get?.absoluteString
        )
    }

    func testPollResponseIsDecodable() throws {
        let responseBody = """
        {
          "id": "y4azg2rc11rgj0chj848dwg3cr",
          "model": "stability-ai/sdxl",
          "version": "7762fd07cf82c948538e41f63f77d685e02b063e37e496e96eefd46c929f9bdc",
          "input": {
            "prompt": "the lone ranger"
          },
          "logs": "50/50 [00:10<00:00,  4.79it/s]\n100%|██████████|",
          "output": [
            "https://replicate.delivery/pbxt/qYcfkg5JpaS2Paeu1e5unMmcPIm04qQSVeJ1e9SyrTJUfDs1E/out-0.png"
          ],
          "data_removed": false,
          "error": null,
          "status": "succeeded",
          "created_at": "2024-08-27T04:11:26.6Z",
          "started_at": "2024-08-27T04:11:26.610278754Z",
          "completed_at": "2024-08-27T04:11:38.588127861Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/y4azg2rc11rgj0chj848dwg3cr/cancel",
            "get": "https://api.replicate.com/v1/predictions/y4azg2rc11rgj0chj848dwg3cr"
          },
          "metrics": {
            "predict_time": 11.977849107
          }
        }
        """
        let res = try ReplicatePredictionResponseBody<ReplicateSDXLOutputSchema>.deserialize(
            from: responseBody
        )
        XCTAssertEqual(
            "https://replicate.delivery/pbxt/qYcfkg5JpaS2Paeu1e5unMmcPIm04qQSVeJ1e9SyrTJUfDs1E/out-0.png",
            res.output?.first?.absoluteString
        )
    }

    func testReplicateFluxProResponseIsDecodable() throws {
        let responseBody = """
        {
          "id": "kyzk126n5srgc0chs88tpfy69g",
          "model": "replicate/flux-pro-internal-model",
          "version": "dp-0fe4d06839aa41bab865d51e5f782609",
          "input": {
            "prompt": "Monument valley, Utah. High res",
            "safety_tolerance": 2
          },
          "logs": "Using seed: 62044\nRunning prediction... \nGenerating image...\n",
          "output": "https://replicate.delivery/czjl/PxBiGkp8kYbNLpY0acmT04rsduBjEOGTdUrmweKtrl7E5KtJA/output.webp",
          "data_removed": false,
          "error": null,
          "status": "succeeded",
          "created_at": "2024-09-07T01:20:52.014Z",
          "started_at": "2024-09-07T01:20:52.021805583Z",
          "completed_at": "2024-09-07T01:21:13.910476435Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/kyzk126n5srgc0chs88tpfy69g/cancel",
            "get": "https://api.replicate.com/v1/predictions/kyzk126n5srgc0chs88tpfy69g"
          },
          "metrics": {
            "image_count": 1,
            "predict_time": 21.888670827
          }
        }
        """
        let res = try ReplicatePredictionResponseBody<ReplicateFluxProOutputSchema>.deserialize(from: responseBody)
        XCTAssertEqual(
            "https://replicate.delivery/czjl/PxBiGkp8kYbNLpY0acmT04rsduBjEOGTdUrmweKtrl7E5KtJA/output.webp",
            res.output?.absoluteString
        )
    }
}
