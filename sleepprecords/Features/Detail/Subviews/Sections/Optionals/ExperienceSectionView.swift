//
//  ExperienceSectionView.swift
//  sleepprecords
//
//  Created by yury antony on 07/06/25.
//

import SwiftUI

struct ExperienceSectionView: View {
    @Binding var selectedExperiences: [Experience]
    @Binding var showingPicker: Bool
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        Section {
            content
                .optionalSection(isEnabled: isEnabled)
        } header: {
            header
        } footer: {
            if !isEnabled {
                Text("detail.experienceeSection.footerLabel")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
    }

    private var header: some View {
        HStack {
            toggleButton
            title
            Spacer()
            if isEnabled {
                actionButton
            }
        }
    }

    private var title: some View {
        Text("detail.experienceeSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var actionButton: some View {
        Button(action: {
            withAnimation(.default) {
                self.showingPicker.toggle()
            }
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundStyle(.awake)
        }
    }

    private var toggleButton: some View {
        Button(action: {
            withAnimation {
                onToggle()
            }
        }) {
            Image(systemName: isEnabled ? "minus" : "plus")
                .font(.title2)
                .foregroundStyle(isEnabled ? .dormant : .awake)
        }
    }

    private var content: some View {
        ExperienceSetterView(
            selectedExperiences: $selectedExperiences,
            showingPicker: $showingPicker
        )
    }

}
