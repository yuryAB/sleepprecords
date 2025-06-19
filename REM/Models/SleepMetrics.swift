//
//  SleepMetrics.swift
//  REM
//
//  Created by yury antony on 06/06/25.
//

import Foundation
import SwiftData

@Model
final class SleepMetrics {
    @Attribute(.unique) var id: UUID
    var record: Record?

    var sleepQuality: Int?
    var noiseLevel: Int?
    var lightLevel: Int?
    var temperatureLevel: Int?

    init(
        id: UUID = UUID(),
        sleepQuality: Int? = nil,
        noiseLevel: Int? = nil,
        lightLevel: Int? = nil,
        temperatureLevel: Int? = nil
    ) {
        self.id = id
        self.sleepQuality = sleepQuality
        self.noiseLevel = noiseLevel
        self.lightLevel = lightLevel
        self.temperatureLevel = temperatureLevel
    }
}
