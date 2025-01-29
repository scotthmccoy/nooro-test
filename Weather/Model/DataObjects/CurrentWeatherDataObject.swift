//
//  DataObject2.swift
//  Weather
//
//  Created by Scott McCoy on 1/28/25.
//

import Foundation


// MARK: - CurrentWeatherDataObject
struct CurrentWeatherDataObject: Codable {
    let location: LocationDataObject?
    let current: CurrentDataObject?
    
    func weather(locationId: String) -> Weather? {
        
        
        guard let locationName = location?.name else {
            AppLog("No location name")
            return nil
        }
        guard let weatherIconUrlString = current?.condition?.icon else {
            AppLog("No icon")
            return nil
        }
        
        let hiResWeatherIconUrlString = weatherIconUrlString.replacingOccurrences(of: "64x64", with: "128x128")
        guard let weatherIconUrl = URL(string: "https:" + hiResWeatherIconUrlString) else {
            AppLog("Could not make icon url")
            return nil
        }
        guard let temperature = current?.temp_f else {
            AppLog("No temperature")
            return nil
        }
        guard let humidityPercent = current?.humidity else {
            AppLog("No humidityPercent")
            return nil
        }
        guard let uvIndex = current?.uv else {
            AppLog("No uvIndex")
            return nil
        }
        guard let feelsLikeTemperature = current?.feelslike_f else {
            AppLog("No feelsLikeTemperature")
            return nil
        }
        
        return Weather (
            locationId: locationId,
            name: locationName,
            weatherIconUrl: weatherIconUrl,
            temperature: Int(temperature.rounded()),
            humidityPercent: humidityPercent,
            uvIndex: Int(uvIndex.rounded()),
            feelsLikeTemperature: Int(feelsLikeTemperature)
        )
    }
}


struct CurrentDataObject: Codable {
    let last_updated_epoch: Int?
    let last_updated: String? //Format: 2025-01-27 17:15
    let temp_c: Double?
    let temp_f: Double?
    let is_day: Int?
    let condition: ConditionDataObject?
    let wind_mph: Double?
    let wind_kph: Double?
    let wind_degree: Int?
    let wind_dir: String?
    let pressure_mb: Int?
    let pressure_in: Double?
    let precip_mm, precip_in, humidity, cloud: Int?
    let feelslike_c, feelslike_f, windchill_c, windchill_f: Double?
    let heatindex_c, heatindex_f, dewpoint_c, dewpoint_f: Double?
    let vis_km, vis_miles: Double?
    let uv: Double?
    let gust_mph, gust_kph: Double?
}

struct ConditionDataObject: Codable {
    let text, icon: String?
    let code: Int?
}

struct LocationDataObject: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tz_id: String?
    let localtime_epoch: Int?
    let localtime: String?
}
