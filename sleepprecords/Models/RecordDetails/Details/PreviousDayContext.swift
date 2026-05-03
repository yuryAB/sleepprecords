//
//  PreviousDayContext.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct PreviousDayContext: Codable, Equatable {
    var acuteStressEvent: Bool?
    var illnessOrFever: Bool?
    var travel: Bool?
    var factorsResponse: PreviousDayFactorsResponse?

    var pruned: PreviousDayContext? {
        guard acuteStressEvent == true ||
                illnessOrFever == true ||
                travel == true ||
                factorsResponse != nil else {
            return nil
        }

        if factorsResponse != nil {
            return PreviousDayContext(factorsResponse: factorsResponse)
        }

        return PreviousDayContext(
            acuteStressEvent: acuteStressEvent == true ? true : nil,
            illnessOrFever: illnessOrFever == true ? true : nil,
            travel: travel == true ? true : nil
        )
    }
}
