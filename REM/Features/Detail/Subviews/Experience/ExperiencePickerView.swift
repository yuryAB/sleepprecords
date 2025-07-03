//
//  ExperiencePickerView.swift
//  REM
//
//  Created by yury antony on 24/05/25.
//

import SwiftUI
import os

struct ExperiencePickerView: View {
    @Binding var selectedExperiences: [Experience]
    @State private var tempSelectedExperiences: [Experience]
    @Environment(\.dismiss) private var dismiss

    init(selectedExperiences: Binding<[Experience]>) {
        self._selectedExperiences = selectedExperiences
        self._tempSelectedExperiences = State(initialValue: selectedExperiences.wrappedValue)
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
                    AppLog.info(.experience, "Select button tapped with selectedExperiences: \(tempSelectedExperiences)")
                    selectedExperiences = tempSelectedExperiences
                    dismiss()
                }
                .disabled(tempSelectedExperiences.isEmpty)
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
                    
                    ForEach(Experience.allCases) { feeling in
                        ExperienceRowView(Experience: feeling, selectedExperiences: $tempSelectedExperiences)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            AppLog.info(.experience, "ExperiencePickerView appeared")
        }
    }
}
