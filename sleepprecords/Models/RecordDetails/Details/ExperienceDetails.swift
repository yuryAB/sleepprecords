//
//  ExperienceDetails.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct ExperienceDetails: Codable, Equatable {
    var selectedExperiences: [Experience] = []
    var intensityByExperience: [ExperienceIntensity] = []

    var pruned: ExperienceDetails? {
        let uniqueExperiences = selectedExperiences.reduce(into: [Experience]()) { result, experience in
            if !result.contains(experience) {
                result.append(experience)
            }
        }
        let filteredIntensities = intensityByExperience.filter {
            uniqueExperiences.contains($0.experience) && (0...5).contains($0.intensity)
        }

        guard !uniqueExperiences.isEmpty || !filteredIntensities.isEmpty else {
            return nil
        }

        return ExperienceDetails(
            selectedExperiences: uniqueExperiences,
            intensityByExperience: filteredIntensities
        )
    }
}
