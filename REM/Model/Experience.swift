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
    case externalObstruction
    case externalTouch
    case falling
    case floating
    case helplessness
    case tingling
    case musclePain
    case nasalObstruction
    case oralObstruction
    case palpitation
    case panic
    case falsePresence
    case throatTightness
    case timeDistortion
    case visualHallucination
    case crawlingBiting
    case drowningSinking
    case proprioceptiveDistortion
    case olfactoryHallucination
    case gustatoryHallucination
    case thermalSensation
    case outOfBodyExperience
 
    var id: String { self.rawValue }
    
    var label: String {
        let key = "experience.label.\(rawValue)"
        return key.localized
    }
    
    var description: String {
        let key = "experience.description.\(rawValue)"
        return key.localized
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
        case .falsePresence: "👻"
        case .timeDistortion: "⏳"
        case .tingling: "🦶"
        case .musclePain: "🤕"
        case .crawlingBiting: "🐜"
        case .drowningSinking: "🌊"
        case .proprioceptiveDistortion: "🔄"
        case .olfactoryHallucination: "👃"
        case .gustatoryHallucination: "👅"
        case .thermalSensation: "🌡️"
        case .outOfBodyExperience: "🌌"
        }
    }
}
