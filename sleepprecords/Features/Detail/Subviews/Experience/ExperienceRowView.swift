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

    var body: some View {
        let isSelected = selectedExperiences.contains(Experience)
        Button {
            if let index = selectedExperiences.firstIndex(of: Experience) {
                selectedExperiences.remove(at: index)
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
    }
}
