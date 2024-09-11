//
//  ReplicateTrainingResponseBodyTests.swift
//
//
//  Created by Lou Zell on 9/7/24.
//

import XCTest
import Foundation
@testable import AIProxy

final class ReplicateTrainingResponseBodyTests: XCTestCase {

    func testPolledTrainingResponseIsDecodable() throws {
        let responseBody = #"""
        {
          "id": "z4bc1tcp51rm00chtetae3jcx8",
          "model": "ostris/flux-dev-lora-trainer",
          "version": "6029be968faad5bcc6d44e827af89eee22d61c35f3b5d0950751815506a9db04",
          "input": {
            "input_images": "",
            "steps": 100
          },
          "logs": "2024-09-08T22:15:17Z | INFO  | [ Initiating ] chunk_size=150M dest=. url=https://weights.replicate.delivery/default/black-forest-labs/FLUX.1-dev/files.tar\n",
          "output": null,
          "data_removed": false,
          "error": null,
          "status": "processing",
          "created_at": "2024-09-08T22:15:13.192Z",
          "started_at": "2024-09-08T22:15:13.277924347Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/z4bc1tcp51rm00chtetae3jcx8/cancel",
            "get": "https://api.replicate.com/v1/predictions/z4bc1tcp51rm00chtetae3jcx8"
          }
        }
        """#
        let res = try ReplicateTrainingResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual(
            .processing,
            res.status
        )
    }

    // Replicate's training response includes invalid JSON.
    // We work around replicate's bad response by stripping out the fields with invalid
    // JSON before passing the data to Decodable.
    func testTrainingResponseWithLogs() throws {
        let responseBody = #"""
        {
          "id": "60ynm77gfhrm20chv9barz11b0",
          "model": "ostris/flux-dev-lora-trainer",
          "version": "6029be968faad5bcc6d44e827af89eee22d61c35f3b5d0950751815506a9db04",
          "input": {
            "input_images": "https://api.replicate.com/v1/files/ODJhODE1YmMtYWExYi00MDIzLTg4MjktNGRmYWI0ZDNlOTRl/download?expiry=1725948616&owner=lzell&signature=DGo4XbqbKZR4m3TRiY%252FXqMSSKNr7XW1qcCi%252FdyasEO4%253D",
            "steps": 4
          },
          "logs": "2024-09-10T05:10:35Z | INFO  | [ Initiating ] chunk_size=150M dest=. url=https://weights.replicate.delivery/default/black-forest-labs/FLUX.1-dev/files.tar\n2024-09-10T05:11:01Z | INFO  | [ Complete ] dest=. size=\"34 GB\" total_elapsed=26.188s url=https://weights.replicate.delivery/default/black-forest-labs/FLUX.1-dev/files.tar\nDownloaded base weights in 26.606263875961304 seconds\nExtracted 5 files from zip to input_images\nStarting train job\n{\n\"type\": \"custom_sd_trainer\",\n\"training_folder\": \"output\",\n\"device\": \"cuda:0\",\n\"trigger_word\": \"TOK\",\n\"network\": {\n\"type\": \"lora\",\n\"linear\": 16,\n\"linear_alpha\": 16\n},\n\"save\": {\n\"dtype\": \"float16\",\n\"save_every\": 5,\n\"max_step_saves_to_keep\": 1\n},\n\"datasets\": [\n{\n\"folder_path\": \"input_images\",\n\"caption_ext\": \"txt\",\n\"caption_dropout_rate\": 0.05,\n\"shuffle_tokens\": false,\n\"cache_latents_to_disk\": false,\n\"cache_latents\": true,\n\"resolution\": [\n512,\n768,\n1024\n]\n}\n],\n\"train\": {\n\"batch_size\": 1,\n\"steps\": 4,\n\"gradient_accumulation_steps\": 1,\n\"train_unet\": true,\n\"train_text_encoder\": false,\n\"content_or_style\": \"balanced\",\n\"gradient_checkpointing\": true,\n\"noise_scheduler\": \"flowmatch\",\n\"optimizer\": \"adamw8bit\",\n\"lr\": 0.0004,\n\"ema_config\": {\n\"use_ema\": true,\n\"ema_decay\": 0.99\n},\n\"dtype\": \"bf16\"\n},\n\"model\": {\n\"name_or_path\": \"FLUX.1-dev\",\n\"is_flux\": true,\n\"quantize\": true\n},\n\"sample\": {\n\"sampler\": \"flowmatch\",\n\"sample_every\": 5,\n\"width\": 1024,\n\"height\": 1024,\n\"prompts\": [],\n\"neg\": \"\",\n\"seed\": 42,\n\"walk_seed\": true,\n\"guidance_scale\": 3.5,\n\"sample_steps\": 28\n}\n}\nUsing EMA\n#############################################\n# Running job: flux_train_replicate\n#############################################\nRunning  1 process\n/src/ai-toolkit/extensions_built_in/sd_trainer/SDTrainer.py:61: FutureWarning: `torch.cuda.amp.GradScaler(args...)` is deprecated. Please use `torch.amp.GradScaler('cuda', args...)` instead.\nself.scaler = torch.cuda.amp.GradScaler()\nLoading Flux model\nLoading transformer\nQuantizing transformer\nLoading vae\nLoading t5\n",
          "output": null,
          "data_removed": false,
          "error": null,
          "status": "processing",
          "created_at": "2024-09-10T05:10:16.444Z",
          "started_at": "2024-09-10T05:10:35.195332906Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/60ynm77gfhrm20chv9barz11b0/cancel",
            "get": "https://api.replicate.com/v1/predictions/60ynm77gfhrm20chv9barz11b0"
          }
        }
        """#
        let res = try ReplicateTrainingResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual(
            "https://api.replicate.com/v1/predictions/60ynm77gfhrm20chv9barz11b0",
            res.urls?.get?.absoluteString
        )
    }

    // Replicate's training response includes invalid JSON.
    // We work around replicate's bad response by stripping out the fields with invalid
    // JSON before passing the data to Decodable.
    func testFailedTrainingResponseIsDecodable() throws {
        let responseBody = #"""
        {
          "id": "e8060w1za1rm00chtfdvbz25m4",
          "model": "ostris/flux-dev-lora-trainer",
          "version": "6029be968faad5bcc6d44e827af89eee22d61c35f3b5d0950751815506a9db04",
          "input": {
            "input_images": "data:application/zip;base64,UEsDBBQAAAAA==",
            "steps": 1
          },
          "logs": "",
          "output": null,
          "data_removed": false,
          "error": "Prediction input failed validation: {\"detail\":[{\"loc\":[\"body\",\"input\",\"steps\"],\"msg\":\"ensure this value is greater than or equal to 3\",\"type\":\"value_error.number.not_ge\",\"ctx\":{\"limit_value\":3}}]}",
          "status": "failed",
          "created_at": "2024-09-08T22:57:26.864Z",
          "started_at": "2024-09-08T22:57:26.893227142Z",
          "completed_at": "2024-09-08T22:57:26.893227142Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/e8060w1za1rm00chtfdvbz25m4/cancel",
            "get": "https://api.replicate.com/v1/predictions/e8060w1za1rm00chtfdvbz25m4"
          }
        }
        """#
        let res = try ReplicateTrainingResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual(
            .failed,
            res.status
        )
    }

    func testCreateTrainingResponseIsDecodable() throws {
        let responseBody = """
        {
          "id": "bjcdnn0zanrm00cht0kvf5nx6c",
          "model": "ostris/flux-dev-lora-trainer",
          "version": "6029be968faad5bcc6d44e827af89eee22d61c35f3b5d0950751815506a9db04",
          "input": {
            "input_images": "data:application/zip;base64,UEsDBBQAAAAA",
            "steps": 100
          },
          "logs": "",
          "output": null,
          "data_removed": false,
          "error": null,
          "status": "starting",
          "created_at": "2024-09-08T05:41:50.549Z",
          "urls": {
            "cancel": "https://api.replicate.com/v1/predictions/bjcdnn0zanrm00cht0kvf5nx6c/cancel",
            "get": "https://api.replicate.com/v1/predictions/bjcdnn0zanrm00cht0kvf5nx6c"
          }
        }
        """
        let res = try ReplicateTrainingResponseBody.deserialize(
            from: responseBody
        )
        XCTAssertEqual(
            "https://api.replicate.com/v1/predictions/bjcdnn0zanrm00cht0kvf5nx6c",
            res.urls?.get?.absoluteString
        )
    }
}
