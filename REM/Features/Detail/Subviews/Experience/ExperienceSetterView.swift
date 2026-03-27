//
//  ExperienceSetterView.swift
//  REM
//
//  Created by yury antony on 24/05/25.
//

import SwiftUI

struct ExperienceSetterView: View {
    @Binding var selectedExperiences: [Experience]
    @Binding var showingPicker: Bool

    var body: some View {
        VStack(spacing: 0) {
            if selectedExperiences.isEmpty {
                Text("detail.experienceeSectionSetter.title")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if !selectedExperiences.isEmpty {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(selectedExperiences, id: \.self) { feeling in
                        VStack(spacing: 4) {
                            Text(feeling.emoji)
                                .font(.largeTitle)
                            Text(feeling.label)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                    }
                }
            }
        }
        .sheet(isPresented: $showingPicker) {
            ExperiencePickerView(selectedExperiences: $selectedExperiences)
        }
    }
}
