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
        Section("Sleep start time") {
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(.primary)
                
                DatePicker("", selection: $sleepStart, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .environment(\.locale, locale)
            }
        }
    }
}
