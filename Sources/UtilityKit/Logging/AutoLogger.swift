//
//  AutoLogger.swift
//  UtilityKit
//
//  Created by Sushant Verma on 12/4/2026.
//

@_exported import os.log
import Foundation

class AutoLogger {

    static func unifiedLogger(category: String = #function) -> os.Logger {
        os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "UtilityKit",
                  category: category)
    }
}
