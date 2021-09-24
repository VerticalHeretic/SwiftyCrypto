//
//  Info.swift
//  Info
//
//  Created by Łukasz Stachnik on 24/09/2021.
//

import Foundation

final class Info {
    
    static func log(_ message: String, function: String = #function) {
        print("✅[INFO] \(message) from \(function)")
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("❌[ERROR] \(message) from \(function) on line: \(line) in file: \(file)")
    }
    
    static func debug(_ message: String, function: String = #function, line: Int = #line) {
        print("🤬[DEBUG] \(message) from \(function) on line: \(line)")
    }
    
    
    
    
}
