//
//  AstronomyDataObject.swift
//  Weather
//
//  Created by Scott McCoy on 2/3/25.
//

import Foundation



struct AstronomyResponse : Codable {
    var astronomy: AstronomyDataObject?
    
    var domainObject: Astronomy? {
        
        guard let sunrise = astronomy?.astro?.sunrise,
        let sunset = astronomy?.astro?.sunset else {
            return nil
        }
        
        return Astronomy(
            sunrise: sunrise,
            sunset: sunset
        )
    }
}

struct AstronomyDataObject : Codable {
    var astro: AstroDataObject?
}

struct AstroDataObject : Codable {
    var sunrise: String?
    var sunset: String?
}
