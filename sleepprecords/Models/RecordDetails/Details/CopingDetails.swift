//
//  CopingDetails.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct CopingDetails: Codable, Equatable {
    var strategiesUsed: [CopingStrategy] = []
    var helpfulness: Helpfulness?

    var pruned: CopingDetails? {
        let uniqueStrategies = strategiesUsed.reduce(into: [CopingStrategy]()) { result, strategy in
            if !result.contains(strategy) {
                result.append(strategy)
            }
        }

        guard !uniqueStrategies.isEmpty || helpfulness != nil else {
            return nil
        }

        return CopingDetails(strategiesUsed: uniqueStrategies, helpfulness: helpfulness)
    }
}
