//
//  SleepDurationEstimate.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum SleepDurationEstimate: String, Codable, CaseIterable, Identifiable {
    case lessThanFourHours
    case fourToSixHours
    case sixToEightHours
    case moreThanEightHours
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.sleepDuration.\(rawValue)" }
}
