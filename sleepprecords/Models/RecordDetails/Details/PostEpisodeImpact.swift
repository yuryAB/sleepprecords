//
//  PostEpisodeImpact.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct PostEpisodeImpact: Codable, Equatable {
    var sleepOutcome: PostEpisodeSleepOutcome?
    var lingeringAnxiety: Int?
    var lingeringAnxietyNotSure: Bool?
    var nextDayTiredness: Int?
    var nextDayTirednessNotSure: Bool?

    var pruned: PostEpisodeImpact? {
        guard sleepOutcome != nil ||
                lingeringAnxiety != nil ||
                lingeringAnxietyNotSure == true ||
                nextDayTiredness != nil ||
                nextDayTirednessNotSure == true else {
            return nil
        }

        var copy = self
        copy.lingeringAnxiety = lingeringAnxietyNotSure == true ? nil : lingeringAnxiety
        copy.lingeringAnxietyNotSure = lingeringAnxietyNotSure == true ? true : nil
        copy.nextDayTiredness = nextDayTirednessNotSure == true ? nil : nextDayTiredness
        copy.nextDayTirednessNotSure = nextDayTirednessNotSure == true ? true : nil
        return copy
    }
}
