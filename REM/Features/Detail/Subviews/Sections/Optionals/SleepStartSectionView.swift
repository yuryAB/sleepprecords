//
//  SleepStartSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//

import SwiftUI

struct SleepStartSectionView: View {
    @Binding var sleepStart: Date
    let locale: Locale
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        Section(header: header, footer: footer) {
            content
                .opacity(isEnabled ? 1 : 0.35)
                .disabled(!isEnabled)
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
        Text("detail.sleepStartSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var footer: some View {
        Group {
            if !isEnabled {
                Text("detail.sleepStartSection.footerLabel")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
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
        HStack {
            Text("detail.sleepStartSection.contentLabel")
            Spacer()
            DatePicker("", selection: $sleepStart, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .environment(\.locale, locale)
            TimeBasedIconView(date: $sleepStart)
                .padding(.leading, 10)
        }
    }
}
