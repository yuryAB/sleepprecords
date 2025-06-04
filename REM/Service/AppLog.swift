//
//  AppLog.swift
//  REM
//
//  Created by yury antony on 04/06/25.
//

import os
import Foundation

extension Logger: @unchecked Sendable {}

public enum LogLevel {
    case debug, info, error
}

public enum Feature: String, CaseIterable {
    case feed       = "feedView"
    case feedVM     = "feedVM"
    case detail     = "detail"
    case experience = "experience"
}

private struct LoggersContainer: @unchecked Sendable {
    let dict: [Feature: Logger]
    
    init() {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.unknown.app"
        var tmp = [Feature: Logger]()
        for feature in Feature.allCases {
            tmp[feature] = Logger(subsystem: subsystem,
                                   category: feature.rawValue)
        }
        self.dict = tmp
    }
}

public class AppLog {
    private static let container = LoggersContainer()
    
    private static func logger(for feature: Feature) -> Logger {
        return container.dict[feature]!
    }
    
    // Core logging method including file, function, and line
    private static func log(
        _ level: LogLevel,
        feature: Feature,
        _ message: String,
        file: String,
        function: String,
        line: Int
    ) {
        let logger = self.logger(for: feature)
        let fileName = (file as NSString).lastPathComponent
        let fullMessage = "File: \(fileName) Function: \(function) Line: \(line) \nMessage: \(message)"
        switch level {
        case .debug:
            logger.debug("\(fullMessage, privacy: .public)")
        case .info:
            logger.info("\(fullMessage, privacy: .public)")
        case .error:
            logger.error("\(fullMessage, privacy: .public)")
        }
    }
    
    public static func debug(
        _ feature: Feature,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.debug, feature: feature, message, file: file, function: function, line: line)
    }
    
    public static func info(
        _ feature: Feature,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.info, feature: feature, message, file: file, function: function, line: line)
    }
    
    public static func error(
        _ feature: Feature,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.error, feature: feature, message, file: file, function: function, line: line)
    }
}
