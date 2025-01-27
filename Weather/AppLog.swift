//
//  AppLog.swift
//  ANF Code Test
//
//  Created by Scott McCoy on 1/13/25.
//

import Foundation

func AppLog(
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line,
    column: UInt = #column,
    function: StaticString = #function
) {
    //Tokenize file by "/", get the last element
    let shortFile = file.description.components(separatedBy: "/").last ?? "NO FILE"
    print("📱\(Date()) \(shortFile) \(function) [Line \(line)] \(message)")
}
