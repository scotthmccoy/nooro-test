//
//  SearchResultDataObject.swift
//  WeatherUITests
//
//  Created by Scott McCoy on 1/27/25.
//

import Foundation

struct SearchResultDataObject: Codable {
    let id: Int?
    let name, region, country: String?
    let lat, lon: Double?
    let url: String?
    
    var searchResult: SearchResult {
        
    }
}
