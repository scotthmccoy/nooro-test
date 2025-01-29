//
//  Color.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//


import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}


extension Color {
    
    static var textFieldBackground: Self {
        Color(hex: 0xf2f2f2)
    }

    static var textFieldSuggestionTextColor: Self {
        Color(hex: 0xcccccc)
    }
    
    static var weatherStatsKeyTextColor: Self {
        Color(hex: 0xC4C4C4)
    }

    static var weatherStatsValueTextColor: Self {
        Color(hex: 0x9A9A9A)
    }
}
