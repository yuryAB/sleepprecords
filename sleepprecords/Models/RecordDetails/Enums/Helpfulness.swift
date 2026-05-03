//
//  Helpfulness.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

enum Helpfulness: String, Codable, CaseIterable, Identifiable {
    case helped
    case didNotHelp
    case unsure

    var id: String { rawValue }
    var titleKey: String { "recordDetails.helpfulness.\(rawValue)" }
}
