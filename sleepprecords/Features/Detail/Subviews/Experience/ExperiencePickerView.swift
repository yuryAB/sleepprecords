//
//  ExperiencePickerView.swift
//  sleepprecords
//
//  Created by yury antony on 24/05/25.
//

import SwiftUI
import os

struct ExperiencePickerView: View {
    @Binding var selectedExperiences: [Experience]
    @Binding var experienceIntensities: [Experience: Int]
    @State private var tempSelectedExperiences: [Experience]
    @State private var tempExperienceIntensities: [Experience: Int]
    @Environment(\.dismiss) private var dismiss

    init(
        selectedExperiences: Binding<[Experience]>,
        experienceIntensities: Binding<[Experience: Int]>
    ) {
        self._selectedExperiences = selectedExperiences
        self._experienceIntensities = experienceIntensities
        self._tempSelectedExperiences = State(initialValue: selectedExperiences.wrappedValue)
        self._tempExperienceIntensities = State(initialValue: experienceIntensities.wrappedValue)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("common.cancel") {
                    AppLog.info(.experience, "Cancel button tapped in ExperiencePickerView")
                    dismiss()
                }
                .foregroundColor(.red)
                .textCase(nil)

                Spacer()

                Text("detail.experienceeSectionSetter.title")
                    .foregroundColor(.gray)

                Spacer()

                Button("common.select") {
                    AppLog.info(.experience, "Select button tapped with \(tempSelectedExperiences.count) selected experiences")
                    selectedExperiences = tempSelectedExperiences
                    experienceIntensities = tempExperienceIntensities.filter { tempSelectedExperiences.contains($0.key) }
                    dismiss()
                }
                .disabled(
                    tempSelectedExperiences == selectedExperiences &&
                    tempExperienceIntensities == experienceIntensities
                )
                .fontWeight(.bold)
                .textCase(nil)
            }
            .padding()

            Divider()

            VStack() {
                List {
                    Text("detail.experienceeSection.footerLabel")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    ForEach(pickerExperiences) { feeling in
                        ExperienceRowView(
                            Experience: feeling,
                            selectedExperiences: $tempSelectedExperiences,
                            experienceIntensities: $tempExperienceIntensities
                        )
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            AppLog.info(.experience, "ExperiencePickerView appeared")
        }
    }

    private var pickerExperiences: [Experience] {
        let legacySelected = tempSelectedExperiences.filter { !Experience.selectableCases.contains($0) }
        return Experience.selectableCases + legacySelected
    }
}
