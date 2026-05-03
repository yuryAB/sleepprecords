//
//  EpisodeDetails.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct EpisodeDetails: Codable, Equatable {
    var moment: EpisodeMoment?
    var paralysisDuration: ParalysisDuration?
    var bodyPosition: BodyPosition?
    var fearDistressLevel: Int?
    var fearDistressNotSure: Bool?
    var breathingImpact: BreathingImpact?

    var pruned: EpisodeDetails? {
        guard moment != nil ||
                paralysisDuration != nil ||
                bodyPosition != nil ||
                fearDistressLevel != nil ||
                fearDistressNotSure == true ||
                breathingImpact != nil else {
            return nil
        }
        var copy = self
        copy.fearDistressNotSure = fearDistressNotSure == true ? true : nil
        return copy
    }
}
