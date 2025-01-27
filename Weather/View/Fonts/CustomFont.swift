//
//  Fonts.swift
//  ANF Code Test
//
//  Created by Scott McCoy on 1/13/25.
//

import SwiftUI

// List of custom fonts added to the application
// Exposes allFonts and likelyCustomFontNames to help find their internal names at app launch

enum CustomFont: CaseIterable {

    case poppinsRegular
    case poppinsMedium
    case poppinsSemiBold
    case poppinsBold

    var internalName: String {
        switch self {
            case .poppinsRegular:
                return "Poppins-Regular"
            case .poppinsMedium:
                return "Poppins-Medium"
            case .poppinsSemiBold:
                return "Poppins-SemiBold"
            case .poppinsBold:
                return "Poppins-Bold"
        }
    }
    
    
    static func allFonts() -> [String] {        
        UIFont.familyNames.flatMap {
            UIFont.fontNames(forFamilyName: $0)
        }
    }
    
    static func likelyCustomFontNames() -> [String] {
        allFonts().filter {
            let lowercased = $0.lowercased()
            return lowercased.contains("opp")
        }
    }
}
