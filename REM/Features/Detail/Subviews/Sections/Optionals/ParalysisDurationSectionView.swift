//
//  ParalysisDurationSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//

import SwiftUI

struct ParalysisDurationSectionView: View {
    @Binding var selectedDuration: ParalysisDuration
    let isEnabled: Bool
    let onToggle: () -> Void

    init(selectedDuration: Binding<ParalysisDuration>, isEnabled: Bool, onToggle: @escaping () -> Void) {
        let originalDuration = selectedDuration.wrappedValue
        let initialDuration = originalDuration
        self._selectedDuration = Binding<ParalysisDuration>(
            get: { initialDuration },
            set: { newValue in
                selectedDuration.wrappedValue = newValue
            }
        )
        self.isEnabled = isEnabled
        self.onToggle = onToggle
    }

    var body: some View {
        Section {
            content
                .optionalSection(isEnabled: isEnabled)
        } header: {
            header
        } footer: {
            if !isEnabled {
                Text("detail.paralysisDurationSection.footerLabel")
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
        }
    }

    private var title: some View {
        Text("detail.paralysisDurationSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
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
        Picker(selection: $selectedDuration) {
            ForEach(ParalysisDuration.allCases) { option in
                Text(option.description).tag(option)
            }
        } label: {
            Text("common.duration")
        }
        .pickerStyle(.menu)
    }
}
