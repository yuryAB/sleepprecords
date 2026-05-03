//
//  SleepContext.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct SleepContext: Codable, Equatable {
    var sleepStart: Date?
    var wakeTime: Date?
    var estimatedSleepDuration: SleepDurationEstimate?
    var sleepQuality: Int?
    var sleepQualityNotSure: Bool?
    var awakenings: Awakenings?
    var hadNap: Bool?
    var sleepDeprivation: Bool?
    var irregularSchedule: Bool?
    var dayFactorsResponse: SleepDayFactorsResponse?
    var environment: SleepEnvironment?

    var pruned: SleepContext? {
        let prunedEnvironment = environment?.pruned
        guard sleepStart != nil ||
                wakeTime != nil ||
                estimatedSleepDuration != nil ||
                sleepQuality != nil ||
                sleepQualityNotSure == true ||
                awakenings != nil ||
                hadNap == true ||
                sleepDeprivation == true ||
                irregularSchedule == true ||
                dayFactorsResponse != nil ||
                prunedEnvironment != nil else {
            return nil
        }

        var copy = self
        copy.sleepQuality = sleepQualityNotSure == true ? nil : sleepQuality
        copy.sleepQualityNotSure = sleepQualityNotSure == true ? true : nil
        copy.hadNap = hadNap == true ? true : nil
        copy.sleepDeprivation = sleepDeprivation == true ? true : nil
        copy.irregularSchedule = irregularSchedule == true ? true : nil
        if dayFactorsResponse != nil {
            copy.hadNap = nil
            copy.sleepDeprivation = nil
            copy.irregularSchedule = nil
        }
        copy.environment = prunedEnvironment
        return copy
    }
}
