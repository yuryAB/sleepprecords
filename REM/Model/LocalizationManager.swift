//
//  LocalizationManager.swift
//  REM
//
//  Created by yury antony on 27/05/25.
//

import Foundation

final class LocalizationManager {
    enum SupportedLanguage: CaseIterable {
        case english
        case portuguese
    }

    static var currentLanguage: SupportedLanguage {
        guard let preferredLanguage = Locale.preferredLanguages.first?.lowercased() else {
            return .english
        }

        if preferredLanguage.starts(with: "pt-br") {
            return .portuguese
        } else if preferredLanguage.starts(with: "en-us") {
            return .english
        } else {
            return .english
        }
    }

    static func perform<T>(for language: SupportedLanguage, block: () -> T) -> T? {
        guard currentLanguage == language else { return nil }
        return block()
    }
}
