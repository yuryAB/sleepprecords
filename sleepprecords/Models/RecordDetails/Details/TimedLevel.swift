//
//  TimedLevel.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct TimedLevel: Codable, Equatable {
    var level: Int?
    var levelNotSure: Bool?
    var timingBeforeSleep: PreSleepTiming?

    var pruned: TimedLevel? {
        guard level != nil || levelNotSure == true || timingBeforeSleep != nil else {
            return nil
        }

        var copy = self
        copy.level = levelNotSure == true ? nil : level
        copy.levelNotSure = levelNotSure == true ? true : nil
        return copy
    }
}
