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
        Text("Sleep start time")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var footer: some View {
        Text("Você lembra que horas foi dormir nesse dia?")
            .font(.footnote)
    }
    
    private var content: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundStyle(.primary)
            Text("Hora que foi dormir")
            Spacer()
            TimeBasedIconView(date: $sleepStart)
            Spacer()
            DatePicker("", selection: $sleepStart, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .environment(\.locale, locale)
        }
    }
}
