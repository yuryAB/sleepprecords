//
//  ExperienceSetterView.swift
//  sleepprecords
//
//  Created by yury antony on 24/05/25.
//

import SwiftUI

struct ExperienceSetterView: View {
    @Binding var selectedExperiences: [Experience]
    @Binding var experienceIntensities: [Experience: Int]
    @Binding var showingPicker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if selectedExperiences.isEmpty {
                Text("detail.experienceeSectionSetter.title")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !selectedExperiences.isEmpty {
                ForEach(selectedExperiences, id: \.self) { experience in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            Text(experience.emoji)
                                .font(.title2)
                            Text(experience.label)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.primary)
                        }

                        CompactLevelSlider(
                            label: "detail.experienceIntensity.caption",
                            value: intensityBinding(for: experience),
                            range: 1...5,
                            minimumLabel: "level.anchor.low",
                            maximumLabel: "level.anchor.high"
                        )
                    }

                    if experience != selectedExperiences.last {
                        Divider()
                    }
                }
            }
        }
        .sheet(isPresented: $showingPicker) {
            ExperiencePickerView(
                selectedExperiences: $selectedExperiences,
                experienceIntensities: $experienceIntensities
            )
        }
    }

    private func intensityBinding(for experience: Experience) -> Binding<Int?> {
        Binding(
            get: { experienceIntensities[experience] },
            set: { newValue in
                experienceIntensities[experience] = newValue
            }
        )
    }
}
