//
//  ColorData.swift
//  AIColorPalette
//
//  Created by Todd Hamilton on 6/21/24.
//

import SwiftUI

// Define the structure for the JSON data
struct ColorData: Codable {
    let red: Double
    let green: Double
    let blue: Double

    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }
}

struct Colors: Codable {
    let colors: [ColorData]
}
