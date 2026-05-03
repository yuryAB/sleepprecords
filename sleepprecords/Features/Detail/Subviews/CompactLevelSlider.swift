//
//  CompactLevelSlider.swift
//  sleepprecords
//
//  Created by yury antony on 27/03/26.
//

import SwiftUI

struct CompactLevelSlider: View {
    let label: LocalizedStringKey
    @Binding var value: Int?
    var range: ClosedRange<Int> = 0...5
    var minimumLabel: LocalizedStringKey = "level.anchor.low"
    var maximumLabel: LocalizedStringKey = "level.anchor.high"

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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

            HStack {
                Text(minimumLabel)
                Spacer()
                Text(maximumLabel)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func levelDot(_ level: Int) -> some View {
        let isSelected = level <= (value ?? -1)

        return Circle()
            .fill(isSelected ? Color.awake : Color.secondary.opacity(0.25))
            .frame(height: 10)
            .frame(maxWidth: .infinity)
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
