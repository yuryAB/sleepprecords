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
    let onRemove: (() -> Void)
    
    var body: some View {
        Section(header: header) {
            content
        }
    }
    
    private var header: some View {
        HStack {
            removeButton
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
        Text("detail.sleepStartSection.footerLabel")
            .font(.footnote)
    }
    
    private var removeButton: some View {
        Button(action: {
            withAnimation {
                onRemove()
            }
        }) {
            Image(systemName: "minus")
                .font(.title2)
                .foregroundStyle(.dormant)
        }
    }
    
    private var content: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundStyle(.primary)
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
