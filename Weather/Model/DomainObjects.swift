//
//  SearchResult.swift
//  Weather
//
//  Created by Scott McCoy on 1/27/25.
//

import Foundation


struct SearchResult: Hashable {
    let id: Int
    let name: String
    let locationId: String
}

// Note: Codable for AppStorage
struct Weather: Hashable, Codable {
    var id = UUID()
    let locationId: String
    let name: String
    let weatherIconUrl: URL
    let temperature: Int
    let humidityPercent: Int
    let uvIndex: Int
    let feelsLikeTemperature: Int
}


extension Weather {
    static var stub: Self {
        Weather(
            locationId: "Los Angeles",
            name: "Hyderabad",
            weatherIconUrl: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/113.png")!,
            temperature: 31,
            humidityPercent: 20,
            uvIndex: 4,
            feelsLikeTemperature: 38
        )
    }
}
