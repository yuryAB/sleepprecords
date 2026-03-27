//
//  CompactLevelSlider.swift
//  REM
//
//  Created by yury antony on 27/03/26.
//

import SwiftUI

struct CompactLevelSlider: View {
    let label: LocalizedStringKey
    @Binding var value: Int?
    var range: ClosedRange<Int> = 0...5

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                if let v = value {
                    Text("\(v)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 6) {
                ForEach(range.lowerBound...range.upperBound, id: \.self) { level in
                    levelDot(level)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func levelDot(_ level: Int) -> some View {
        let isSelected = level <= (value ?? -1)

        return Circle()
            .fill(isSelected ? Color.awake : Color.secondary.opacity(0.25))
            .frame(height: 10)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottom) {
                if level == range.lowerBound || level == range.upperBound {
                    Text("\(level)")
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                        .offset(y: 14)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    if value == level {
                        value = nil
                    } else {
                        value = level
                    }
                }
            }
    }
}
