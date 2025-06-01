//
//  ExperienceSetterView.swift
//  REM
//
//  Created by yury antony on 24/05/25.
//

import SwiftUI

struct ExperienceSetterView: View {
    @Binding var selectedExperiences: [Experience]
    @State private var showingPicker = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(
                    selectedExperiences.isEmpty
                    ? "If you want, select any experiences you had."
                    : "Your Experiences"
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                Spacer()
                Button {
                    showingPicker = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.awake)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)

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
                .padding(.vertical, 12)
            }
        }
        .sheet(isPresented: $showingPicker) {
            ExperiencePickerView(selectedExperiences: $selectedExperiences)
        }
    }
}
