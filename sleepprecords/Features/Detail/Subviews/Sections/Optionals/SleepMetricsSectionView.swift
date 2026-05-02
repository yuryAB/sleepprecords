//
//  SleepMetricsSectionView.swift
//  sleepprecords
//
//  Created by yury antony on 26/03/26.
//

import SwiftUI

struct SleepMetricsSectionView: View {
    @Binding var sleepMetrics: SleepMetrics
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        Section {
            content
                .optionalSection(isEnabled: isEnabled)
        } header: {
            header
        } footer: {
            if !isEnabled {
                Text("detail.sleepMetricsSection.footerLabel")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
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
        Text("detail.sleepMetricsSection.title")
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
        VStack(alignment: .leading, spacing: 16) {
            CompactLevelSlider(
                label: "detail.sleepMetricsSection.sleepQuality",
                value: $sleepMetrics.sleepQuality
            )
            CompactLevelSlider(
                label: "detail.sleepMetricsSection.noiseLevel",
                value: $sleepMetrics.noiseLevel
            )
            CompactLevelSlider(
                label: "detail.sleepMetricsSection.lightLevel",
                value: $sleepMetrics.lightLevel
            )
            CompactLevelSlider(
                label: "detail.sleepMetricsSection.temperatureLevel",
                value: $sleepMetrics.temperatureLevel
            )
        }
        .padding(.bottom, 8)
    }
}
