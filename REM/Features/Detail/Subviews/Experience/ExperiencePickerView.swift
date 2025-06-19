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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Do you remember experiencing any of these at that moment?")
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
                        AppLog.info(.experience, "Close button tapped in ExperiencePickerView")
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Select") {
                        AppLog.info(.experience, "Select button tapped with selectedExperiences: \(selectedExperiences)")
                        dismiss()
                    }
                    .disabled(selectedExperiences.isEmpty)
                }
            }
        }
        .onAppear {
            AppLog.info(.experience, "ExperiencePickerView appeared")
        }
    }
}
