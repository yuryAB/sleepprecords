//
//  BodyPosition.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum BodyPosition: String, Codable, CaseIterable, Identifiable {
    case back
    case side
    case stomach
    case sitting
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.bodyPosition.\(rawValue)" }
}
