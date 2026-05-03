//
//  ParalysisDuration.swift
//  sleepprecords
//
//  Created by yury antony on 20/06/25.
//

import Foundation

enum ParalysisDuration: Int, Codable, CaseIterable, Identifiable {
    case upTo10Seconds = 0
    case from20To30Seconds = 1
    case from30To60Seconds = 2
    case moreThan1Minute = 3
    case notSure = 4
    case from10To20Seconds = 5
    case from1To2Minutes = 6
    case from2To5Minutes = 7
    case moreThan5Minutes = 8

    var id: Int { rawValue }

    static var currentCases: [ParalysisDuration] {
        [
            .upTo10Seconds,
            .from10To20Seconds,
            .from20To30Seconds,
            .from30To60Seconds,
            .from1To2Minutes,
            .from2To5Minutes,
            .moreThan5Minutes,
            .notSure
        ]
    }

    var descriptionKey: String {
        switch self {
        case .upTo10Seconds: return "paralysisDuration.label.upTo10Seconds"
        case .from10To20Seconds: return "paralysisDuration.label.from10To20Seconds"
        case .from20To30Seconds: return "paralysisDuration.label.from20To30Seconds"
        case .from30To60Seconds: return "paralysisDuration.label.from30To60Seconds"
        case .from1To2Minutes: return "paralysisDuration.label.from1To2Minutes"
        case .from2To5Minutes: return "paralysisDuration.label.from2To5Minutes"
        case .moreThan1Minute: return "paralysisDuration.label.moreThan1Minute"
        case .moreThan5Minutes: return "paralysisDuration.label.moreThan5Minutes"
        case .notSure: return "paralysisDuration.label.notSure"
        }
    }

    var description: String {
        descriptionKey.localized
    }
}
