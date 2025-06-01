//
//  Experience.swift
//  REM
//
//  Created by yury antony on 24/05/25.
//

import Foundation

enum Experience: String, Codable, CaseIterable, Identifiable {
    case auditoryHallucination
    case beingPulled
    case bodyPressure
    case calm
    case compression
    case visualHallucination
    case nasalObstruction
    case oralObstruction
    case externalObstruction
    case throatTightness
    case panic
    case helplessness
    case floating
    case falling
    case externalTouch
    case palpitation
    case senseOfPresence
    case timeDistortion
    case limbTingling
    case musclePain
    
    var id: String { self.rawValue }
    
    var label: String {
        let key = "Experience.\(rawValue).label"
        return key.localizable
    }
    
    var emoji: String {
        switch self {
        case .visualHallucination: "👁️"
        case .auditoryHallucination: "👂"
        case .nasalObstruction: "🤧"
        case .oralObstruction: "😤"
        case .externalObstruction: "🛌"
        case .throatTightness: "🤐"
        case .panic: "😰"
        case .helplessness: "🥺"
        case .calm: "🧘"
        case .floating: "🎈"
        case .falling: "🍃"
        case .beingPulled: "🧲"
        case .externalTouch: "✋"
        case .bodyPressure: "🏋️"
        case .compression: "🪢"
        case .palpitation: "❤️‍🔥"
        case .senseOfPresence: "👻"
        case .timeDistortion: "⏳"
        case .limbTingling: "🦶"
        case .musclePain: "🤕"
        }
    }
    
    var description: String {
        let key = "Experience.\(rawValue).description"
        return key.localizable
    }
}
