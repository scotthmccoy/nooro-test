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
}

// Note: Codable for AppStorage
struct Weather: Hashable, Codable {
    let locationId: Int
    let name: String
    let weatherIconUrl: URL
    let temperature: Int
    let humidityPercent: Int
    let uvIndex: Int
    let feelsLikeTemperature: Int
    let sunrise: String?
    let sunset: String?
}


struct Astronomy: Hashable {
    let sunrise: String
    let sunset: String
}

extension Weather {
    static var stub: Self {
        Weather(
            locationId: 12345,
            name: "Hyderabad",
            weatherIconUrl: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/113.png")!,
            temperature: 31,
            humidityPercent: 20,
            uvIndex: 4,
            feelsLikeTemperature: 38,
            sunrise: "10:00am",
            sunset: "10:00pm"
        )
    }
}
