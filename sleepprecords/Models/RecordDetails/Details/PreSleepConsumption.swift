//
//  PreSleepConsumption.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct PreSleepConsumption: Codable, Equatable {
    var caffeine: TimedAmount?
    var alcohol: TimedAmount?
    var food: TimedAmount?

    var pruned: PreSleepConsumption? {
        let prunedCaffeine = caffeine?.pruned
        let prunedAlcohol = alcohol?.pruned
        let prunedFood = food?.pruned

        guard prunedCaffeine != nil || prunedAlcohol != nil || prunedFood != nil else {
            return nil
        }

        return PreSleepConsumption(caffeine: prunedCaffeine, alcohol: prunedAlcohol, food: prunedFood)
    }
}
