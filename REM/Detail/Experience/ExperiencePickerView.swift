//
//  ExperiencePickerView.swift
//  REM
//
//  Created by yury antony on 24/05/25.
//

import SwiftUI

struct ExperiencePickerView: View {
    @Binding var selectedExperiences: [Experience]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("What experiences did you have at that moment?")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                List {
                    ForEach(Experience.allCases) { feeling in
                        ExperienceRowView(Experience: feeling, selectedExperiences: $selectedExperiences)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Your Experiences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Select") {
                        dismiss()
                    }
                    .disabled(selectedExperiences.isEmpty)
                }
            }
        }
    }
}
