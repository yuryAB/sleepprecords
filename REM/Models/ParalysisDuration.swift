//
//  ParalysisDuration.swift
//  REM
//
//  Created by yury antony on 20/06/25.
//

import Foundation

enum ParalysisDuration: Int, CaseIterable, Identifiable {
    case upTo10Seconds = 0
    case from30To60Seconds = 1
    case moreThan1Minute = 2
    case notSure = 3

    var id: Int { rawValue }

    var descriptionKey: String {
        switch self {
        case .upTo10Seconds: return "paralysisDuration.label.upTo10Seconds"
        case .from30To60Seconds: return "paralysisDuration.label.from30To60Seconds"
        case .moreThan1Minute: return "paralysisDuration.label.moreThan1Minute"
        case .notSure: return "paralysisDuration.label.notSure"
        }
    }

    var description: String {
        descriptionKey.localized
    }
}
