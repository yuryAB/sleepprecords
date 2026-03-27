//
//  SleepMetricsSectionView.swift
//  REM
//
//  Created by yury antony on 26/03/26.
//

import SwiftUI

struct SleepMetricsSectionView: View {
    @Binding var sleepMetrics: SleepMetrics
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        Section(header: header, footer: footer) {
            content
                .opacity(isEnabled ? 1 : 0.35)
                .disabled(!isEnabled)
        }
    }

    private var header: some View {
        HStack {
            toggleButton
            title
            Spacer()
        }
    }

    private var title: some View {
        Text("Sleep Metrics")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var toggleButton: some View {
        Button(action: {
            withAnimation {
                onToggle()
            }
        }) {
            Image(systemName: isEnabled ? "minus" : "plus")
                .font(.title2)
                .foregroundStyle(isEnabled ? .dormant : .awake)
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            metricRow("Sleep quality", sleepMetrics.sleepQuality)
            metricRow("Noise level", sleepMetrics.noiseLevel)
            metricRow("Light level", sleepMetrics.lightLevel)
            metricRow("Temperature", sleepMetrics.temperatureLevel)
        }
        .padding(.vertical, 4)
    }

    private func metricRow(_ label: String, _ value: Int?) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value.map(String.init) ?? "-")
                .foregroundColor(.secondary)
        }
    }

    private var footer: some View {
        Group {
            if !isEnabled {
                Text("Sleep Metrics")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
    }
}
