//
//  WeatherApp.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    init() {
        AppLog("Fonts: \(CustomFont.likelyCustomFontNames())")
    }
}
