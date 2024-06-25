//
//  AIProxyIntegration.swift
//  AIColorPalette
//
//  Created by Todd Hamilton on 6/20/24.
//

import AIProxy // The AIProxy SPM package is found at https://github.com/lzell/AIProxySwift
import Foundation
import UIKit

struct AIProxyIntegration {

    // Visit http://airoxy.pro to get a new partial key and DeviceCheck bypass token.
    //
    // See the README at https://github.com/lzell/AIProxySwift for instructions on
    // adding a DeviceCheck bypass token as an environment variable (which is required
    // for AIProxy to work in the iOS simulator)
    #warning("You must replace the placeholder below")
    static let openAIService = AIProxy.openAIService(
        partialKey: "<placeholder>"
    )

    static func getColorPalette(forImage image: UIImage) async -> String? {
        let message = "generate a color palette based on the provided image, return 4 colors in valid JSON, nothing else. Here's an example of the JSON format: 'colors': [{red: 0.85, green: 0.85, blue: 0.85}, {red: 0.85, green: 0.85, blue: 0.85}, {red: 0.85, green: 0.85, blue: 0.85}, {red: 0.85, green: 0.85, blue: 0.85}, {red: 0.85, green: 0.85, blue: 0.85}]."

        let localURL = createOpenAILocalURL(forImage: image)!
        do {
            let response = try await openAIService.chatCompletionRequest(body: .init(
                model: "gpt-4o",
                messages: [
                    .init(
                        role: "system",
                        content: .text(message)
                    ),
                    .init(
                        role: "user",
                        content: .parts(
                            [
                                .imageURL(localURL)
                            ]
                        )
                    )
                ],
                responseFormat: .type("json_object")
            ))
            return response.choices.first?.message.content
        }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
            print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    private init() {
        fatalError("This type is not intended to be instantiated")
    }
}

func createOpenAILocalURL(forImage image: UIImage) -> URL? {
    // Attempt to get JPEG data from the UIImage
    guard let jpegData = image.jpegData(compressionQuality: 0.4) else {
        return nil
    }

    // Encode the JPEG data to a base64 string
    let base64String = jpegData.base64EncodedString()

    // Create the data URL string
    let urlString = "data:image/jpeg;base64,\(base64String)"

    // Return the URL constructed from the data URL string
    return URL(string: urlString)
}
