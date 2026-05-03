//
//  SleepEnvironment.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct SleepEnvironment: Codable, Equatable {
    var noiseLevel: Int?
    var lightLevel: Int?
    var temperatureLevel: Int?

    var pruned: SleepEnvironment? {
        guard noiseLevel != nil || lightLevel != nil || temperatureLevel != nil else {
            return nil
        }
        return self
    }
}
