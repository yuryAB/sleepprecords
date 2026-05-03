//
//  InterpretationDetails.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct InterpretationDetails: Codable, Equatable {
    var recognizedSleepParalysis: Bool? = nil
    var supernaturalInterpretation: Bool? = nil
    var fearedDying: Bool? = nil
    var didNotKnowWhatItWas: Bool? = nil
    var otherInterpretation: String? = nil
    var notSure: Bool? = nil

    var pruned: InterpretationDetails? {
        let trimmedOther = otherInterpretation?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard recognizedSleepParalysis == true ||
                supernaturalInterpretation == true ||
                fearedDying == true ||
                didNotKnowWhatItWas == true ||
                notSure == true ||
                (trimmedOther?.isEmpty == false) else {
            return nil
        }

        if notSure == true {
            return InterpretationDetails(notSure: true)
        }

        return InterpretationDetails(
            recognizedSleepParalysis: recognizedSleepParalysis == true ? true : nil,
            supernaturalInterpretation: supernaturalInterpretation == true ? true : nil,
            fearedDying: fearedDying == true ? true : nil,
            didNotKnowWhatItWas: didNotKnowWhatItWas == true ? true : nil,
            otherInterpretation: trimmedOther?.isEmpty == false ? trimmedOther : nil
        )
    }
}
