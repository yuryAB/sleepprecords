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
        Section(header: header) {
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
        Text("detail.dateAndTimeSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var content: some View {
        VStack(spacing: 15) {
            DatePicker("detail.dateAndTimeSection.dateLabel",
                       selection: $date,
                       displayedComponents: .date)
            .environment(\.locale, locale)

            HStack {
                Text("detail.dateAndTimeSection.timeLabel")
                Spacer()

                DatePicker("", selection: $date,
                           displayedComponents: .hourAndMinute)
                .labelsHidden()
                .environment(\.locale, locale)
                TimeBasedIconView(date: $date)
                    .padding(.leading, 10)
            }
        }
    }
}
