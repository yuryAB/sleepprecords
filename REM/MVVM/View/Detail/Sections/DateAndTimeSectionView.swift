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
        Section("Date and time") {
            HStack(spacing: 15) {
                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.primary)
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .labelsHidden()
                        .environment(\.locale, locale)
                }
                
                
                Spacer()
                
                HStack(spacing: 10) {
                    Image(systemName: "clock")
                        .foregroundStyle(.primary)
                    DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .environment(\.locale, locale)
                }
                
                Spacer()
            }
        }
    }
}
