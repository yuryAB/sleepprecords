//
//  DateAndTimeSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//


import SwiftUI

struct DateAndTimeSectionView: View {
    @Binding var date: Date
    let locale: Locale
    
    var body: some View {
        Section("Momento do registro") {
            content
        }
    }
    
    private var content: some View {
        VStack(spacing: 15) {
            HStack() {
                Image(systemName: "calendar")
                    .foregroundStyle(.primary)
                DatePicker("Registro em:", selection: $date, displayedComponents: .date)
                    .environment(\.locale, locale)
            }
            
            HStack() {
                Image(systemName: "clock")
                    .foregroundStyle(.primary)
                Text("Hora do registro: ")
                Spacer()
                TimeBasedIconView(date: $date)
                Spacer()
                DatePicker("", selection: $date,
                           displayedComponents: .hourAndMinute)
                .labelsHidden()
                    .environment(\.locale, locale)
            }
        }
    }
}
