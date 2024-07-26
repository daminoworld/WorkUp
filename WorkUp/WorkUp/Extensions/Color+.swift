//
//  Color+.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, opacity: opacity)
    }
    
    init(r: CGFloat, g: CGFloat, b: CGFloat) {
            self.init(red: r/255, green: g/255, blue: b/255)
        }
}

