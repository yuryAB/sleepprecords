//
//  TimeBasedIconView.swift
//  REM
//
//  Created by yury antony on 18/06/25.
//


import SwiftUI

struct TimeBasedIconView: View {
    @Binding var date: Date

    private var iconName: String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<7:
            return "sunrise.fill"
        case 7..<17:
            return "sun.max.fill"
        case 17..<19:
            return "sunset.fill"
        case 19..<24:
            return "moon.fill"
        default:
            return "moon.dust"
        }
    }

    var body: some View {
        Image(systemName: iconName)
            .foregroundStyle(.primary)
            .contentTransition(.symbolEffect(.replace))
    }
}
