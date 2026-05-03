//
//  SensitiveContext.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct SensitiveContext: Codable, Equatable {
    var medicationOrSubstanceChange: Bool? = nil
    var changeResponse: SensitiveChangeResponse? = nil
    var medicationChange: Bool? = nil
    var substanceChange: Bool? = nil
    var prefersNotToSpecifyChangeType: Bool? = nil
    var description: String? = nil

    var pruned: SensitiveContext? {
        let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasChangeType = medicationChange == true ||
            substanceChange == true ||
            prefersNotToSpecifyChangeType == true
        let resolvedResponse = changeResponse ?? legacyResponse(
            trimmedDescription: trimmedDescription,
            hasChangeType: hasChangeType
        )

        guard resolvedResponse != nil ||
                hasChangeType ||
                (trimmedDescription?.isEmpty == false) else {
            return nil
        }

        if resolvedResponse == .no {
            return SensitiveContext(changeResponse: .no)
        }

        if resolvedResponse == .unsure {
            return SensitiveContext(
                changeResponse: .unsure,
                description: trimmedDescription?.isEmpty == false ? trimmedDescription : nil
            )
        }

        return SensitiveContext(
            medicationOrSubstanceChange: resolvedResponse == .yes ? true : nil,
            changeResponse: resolvedResponse,
            medicationChange: prefersNotToSpecifyChangeType == true ? nil : (medicationChange == true ? true : nil),
            substanceChange: prefersNotToSpecifyChangeType == true ? nil : (substanceChange == true ? true : nil),
            prefersNotToSpecifyChangeType: prefersNotToSpecifyChangeType == true ? true : nil,
            description: trimmedDescription?.isEmpty == false ? trimmedDescription : nil
        )
    }

    private func legacyResponse(trimmedDescription: String?, hasChangeType: Bool) -> SensitiveChangeResponse? {
        if medicationOrSubstanceChange == true || hasChangeType || trimmedDescription?.isEmpty == false {
            return .yes
        }
        return nil
    }
}
