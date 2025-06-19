//
//  RoutineMetrics.swift
//  REM
//
//  Created by yury antony on 06/06/25.
//

import Foundation
import SwiftData

@Model
final class RoutineMetrics {
    @Attribute(.unique) var id: UUID
    var record: Record?

    var stressLevel: Int?
    var caffeineConsumption: Int?
    var alcoholConsumption: Int?
    var physicalActivityLevel: Int?
    var screenUseLevel: Int?

    init(
        id: UUID = UUID(),
        stressLevel: Int? = nil,
        caffeineConsumption: Int? = nil,
        alcoholConsumption: Int? = nil,
        physicalActivityLevel: Int? = nil,
        screenUseLevel: Int? = nil
    ) {
        self.id = id
        self.stressLevel = stressLevel
        self.caffeineConsumption = caffeineConsumption
        self.alcoholConsumption = alcoholConsumption
        self.physicalActivityLevel = physicalActivityLevel
        self.screenUseLevel = screenUseLevel
    }
}
