//
//  PostEpisodeSleepOutcome.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum PostEpisodeSleepOutcome: String, Codable, CaseIterable, Identifiable {
    case wentBackToSleep
    case stayedAwake
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.postEpisodeSleepOutcome.\(rawValue)" }
}
