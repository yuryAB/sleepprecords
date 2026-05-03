//
//  PreSleepContext.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct PreSleepContext: Codable, Equatable {
    var stressLevel: Int?
    var stressLevelNotSure: Bool?
    var screenUse: TimedLevel?
    var physicalActivity: TimedLevel?
    var consumption: PreSleepConsumption?

    var pruned: PreSleepContext? {
        let prunedScreenUse = screenUse?.pruned
        let prunedPhysicalActivity = physicalActivity?.pruned
        let prunedConsumption = consumption?.pruned

        guard stressLevel != nil ||
                stressLevelNotSure == true ||
                prunedScreenUse != nil ||
                prunedPhysicalActivity != nil ||
                prunedConsumption != nil else {
            return nil
        }

        return PreSleepContext(
            stressLevel: stressLevelNotSure == true ? nil : stressLevel,
            stressLevelNotSure: stressLevelNotSure == true ? true : nil,
            screenUse: prunedScreenUse,
            physicalActivity: prunedPhysicalActivity,
            consumption: prunedConsumption
        )
    }
}
