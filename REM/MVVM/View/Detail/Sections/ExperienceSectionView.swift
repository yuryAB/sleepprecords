//
//  ExperienceSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//


import SwiftUI

struct ExperienceSectionView: View {
    @Binding var selectedExperiences: [Experience]
    @Binding var showingPicker: Bool

    var body: some View {
        Section(
            header: HStack {
                Text("Experience")
                Spacer()
                Button {
                    showingPicker = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.awake)
                }
            }
        ) {
            ExperienceSetterView(
                selectedExperiences: $selectedExperiences,
                showingPicker: $showingPicker
            )
        }
    }
}

struct ExperienceSectionView_Previews: PreviewProvider {
    @State static var experiences: [Experience] = []
    @State static var showing = false

    static var previews: some View {
        Form {
            ExperienceSectionView(
                selectedExperiences: $experiences,
                showingPicker: $showing
            )
        }
    }
}