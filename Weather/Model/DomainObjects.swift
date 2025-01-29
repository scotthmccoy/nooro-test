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

struct Weather: Hashable {
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
            name: "Los Angeles",
            weatherIconUrl: URL(string: "https://cdn.weatherapi.com/weather/64x64/day/113.png")!,
            temperature: 73,
            humidityPercent: 46,
            uvIndex: 10,
            feelsLikeTemperature: 70
        )
    }
}
