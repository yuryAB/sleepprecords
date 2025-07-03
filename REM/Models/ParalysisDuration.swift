//
//  ParalysisDuration.swift
//  REM
//
//  Created by yury antony on 20/06/25.
//

import Foundation

enum ParalysisDuration: Int, CaseIterable, Identifiable {
    case upTo10Seconds = 0
    case from20To30Seconds = 1
    case from30To60Seconds = 2
    case moreThan1Minute = 3
    case notSure = 4

    var id: Int { rawValue }

    var descriptionKey: String {
        switch self {
        case .upTo10Seconds: return "paralysisDuration.label.upTo10Seconds"
        case .from20To30Seconds: return "paralysisDuration.label.from20To30Seconds"
        case .from30To60Seconds: return "paralysisDuration.label.from30To60Seconds"
        case .moreThan1Minute: return "paralysisDuration.label.moreThan1Minute"
        case .notSure: return "paralysisDuration.label.notSure"
        }
    }

    var description: String {
        descriptionKey.localized
    }
}
