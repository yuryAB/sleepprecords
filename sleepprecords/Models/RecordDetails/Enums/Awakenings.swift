//
//  Awakenings.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum Awakenings: String, Codable, CaseIterable, Identifiable {
    case none
    case once
    case twoToThree
    case many
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.awakenings.\(rawValue)" }
}
