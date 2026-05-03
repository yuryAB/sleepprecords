//
//  BreathingImpact.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum BreathingImpact: String, Codable, CaseIterable, Identifiable {
    case none
    case mild
    case moderate
    case severe
    case veryDifficult
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.breathingImpact.\(rawValue)" }
}
