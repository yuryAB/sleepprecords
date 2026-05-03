//
//  CopingStrategy.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum CopingStrategy: String, Codable, CaseIterable, Identifiable {
    case focusedOnBreathing
    case triedToMove
    case triedToMakeSound
    case waitedItOut
    case prayerOrSpiritual
    case grounding
    case other

    var id: String { rawValue }
    var titleKey: String { "recordDetails.copingStrategy.\(rawValue)" }
}
