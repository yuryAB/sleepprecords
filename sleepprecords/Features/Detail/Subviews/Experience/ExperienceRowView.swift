//
//  ExperienceRowView.swift
//  sleepprecords
//
//  Created by yury antony on 26/05/25.
//

import SwiftUI

struct ExperienceRowView: View {
    let Experience: Experience
    @Binding var selectedExperiences: [Experience]
    @Binding var experienceIntensities: [Experience: Int]

    var body: some View {
        let isSelected = selectedExperiences.contains(Experience)
        VStack(alignment: .leading, spacing: 10) {
            Button {
                if let index = selectedExperiences.firstIndex(of: Experience) {
                    selectedExperiences.remove(at: index)
                    experienceIntensities[Experience] = nil
                } else {
                    selectedExperiences.append(Experience)
                }
            } label: {
                HStack(spacing: 12) {
                    Text(Experience.emoji)
                    VStack(alignment: .leading) {
                        Text(Experience.label)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                        Text(Experience.description)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .awake : .dormant)
                        .contentTransition(.symbolEffect(.replace))
                }
                .padding(.vertical, 4)
            }

            if isSelected {
                CompactLevelSlider(
                    label: "detail.experienceIntensity.caption",
                    value: intensityBinding,
                    range: 1...5,
                    minimumLabel: "level.anchor.low",
                    maximumLabel: "level.anchor.high"
                )
                .padding(.leading, 34)
            }
        }
    }

    private var intensityBinding: Binding<Int?> {
        Binding(
            get: { experienceIntensities[Experience] },
            set: { experienceIntensities[Experience] = $0 }
        )
    }
}
