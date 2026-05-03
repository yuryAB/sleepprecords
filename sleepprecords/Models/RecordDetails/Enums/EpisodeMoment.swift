//
//  EpisodeMoment.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum EpisodeMoment: String, Codable, CaseIterable, Identifiable {
    case fallingAsleep
    case wakingDuringSleep
    case wakingUp
    case nap
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.episodeMoment.\(rawValue)" }
}
