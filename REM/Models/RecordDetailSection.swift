//
//  RecordDetailSection.swift
//  REM
//
//  Created by yury antony on 14/06/25.
//

import Foundation

enum RecordDetailSection: CaseIterable, Hashable {
    case sleepStart
    case note
    case experience
    case paralysisDuration
    case routineMetrics
    case sleepMetrics

    var title: String {
        switch self {
        case .sleepStart:
            return "detail.sleepStartSection.title".localized
        case .note:
            return "Note"
        case .experience:
            return "Experience"
        case .paralysisDuration:
            return "Paralysis Duration"
        case .routineMetrics:
            return "Routine Metrics"
        case .sleepMetrics:
            return "Sleep Metrics"
        }
    }
    
    var icon: String {
        switch self {
        case .sleepStart:
            return "bed.double"
        case .note:
            return "note.text"
        case .experience:
            return "face.smiling"
        case .paralysisDuration:
            return "hourglass"
        case .routineMetrics:
            return "chart.bar.xaxis"
        case .sleepMetrics:
            return "waveform.path.ecg"
        }
    }
}
