//
//  LocalizationManager.swift
//  REM
//
//  Created by yury antony on 27/05/25.
//

import Foundation

final class LocalizationManager {
    enum SupportedLanguage: String, CaseIterable {
        case english = "en"
        case portuguese = "pt"
    }

    static var currentLanguage: SupportedLanguage {
        guard let code = Locale.current.language.languageCode?.identifier,
              let _ = SupportedLanguage(rawValue: code) else {
            return .english
        }
        
        return SupportedLanguage(rawValue: code) ?? .english
    }

    static func perform<T>(for language: SupportedLanguage, block: () -> T) -> T? {
        guard currentLanguage == language else { return nil }
        return block()
    }
}
