//
//  PreSleepTiming.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum PreSleepTiming: String, Codable, CaseIterable, Identifiable {
    case untilTryingToSleep
    case lessThanOneHour
    case oneToTwoHours
    case lessThanTwoHours
    case twoToSixHours
    case moreThanTwoHours
    case twoToFourHours
    case moreThanFourHours
    case moreThanSixHours
    case sixToTwelveHours
    case moreThanTwelveHours
    case notSure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.preSleepTiming.\(rawValue)" }
}
