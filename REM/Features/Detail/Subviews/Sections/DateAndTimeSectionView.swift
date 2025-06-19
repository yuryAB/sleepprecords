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
        Section("detail.dateAndTimeSection.title") {
            content
        }
    }
    
    private var content: some View {
        VStack(spacing: 15) {
            HStack() {
                Image(systemName: "calendar")
                    .foregroundStyle(.primary)
                DatePicker("detail.dateAndTimeSection.dateLabel",
                           selection: $date,
                           displayedComponents: .date)
                .environment(\.locale, locale)
            }
            
            HStack() {
                Image(systemName: "clock")
                    .foregroundStyle(.primary)
                Text("detail.dateAndTimeSection.timeLabel")
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
