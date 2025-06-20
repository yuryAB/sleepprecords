//
//  ParalysisDurationSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//

import SwiftUI

struct ParalysisDurationSectionView: View {
    @Binding var selectedDuration: ParalysisDuration

    init(selectedDuration: Binding<ParalysisDuration>) {
        let originalDuration = selectedDuration.wrappedValue
        let initialDuration = originalDuration
        self._selectedDuration = Binding<ParalysisDuration>(
            get: { initialDuration },
            set: { newValue in
                selectedDuration.wrappedValue = newValue
            }
        )
    }

    var body: some View {
        Section(header: header, footer: footer) {
            content
        }
    }
    
    private var header: some View {
        HStack {
            title
            Spacer()
        }
    }
    
    private var title: some View {
        Text("detail.paralysisDurationSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var footer: some View {
        Text("detail.paralysisDurationSection.footerLabel")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var content: some View {
        Picker(selection: $selectedDuration) {
            ForEach(ParalysisDuration.allCases) { option in
                Text(option.description).tag(option)
            }
        } label: {
            HStack {
                Image(systemName: "hourglass")
                    .foregroundStyle(.primary)
                Text("common.duration")
                Spacer()
            }
        }
        .pickerStyle(.menu)
    }
}
