//
//  TimedAmount.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct TimedAmount: Codable, Equatable {
    var amountLevel: Int?
    var timingBeforeSleep: PreSleepTiming?
    var notSure: Bool?
    var amountNotSure: Bool?

    var pruned: TimedAmount? {
        guard amountLevel != nil || timingBeforeSleep != nil || notSure == true || amountNotSure == true else {
            return nil
        }

        return TimedAmount(
            amountLevel: amountNotSure == true ? nil : amountLevel,
            timingBeforeSleep: timingBeforeSleep,
            notSure: notSure == true ? true : nil,
            amountNotSure: amountNotSure == true ? true : nil
        )
    }
}
