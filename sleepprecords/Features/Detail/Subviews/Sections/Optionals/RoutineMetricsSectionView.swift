//
//  RoutineMetricsSectionView.swift
//  sleepprecords
//
//  Created by yury antony on 20/06/25.
//

import SwiftUI

struct RoutineMetricsSectionView: View {
    @Binding var routineMetrics: RoutineMetrics
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
                Text("detail.routineMetricsSection.footerLabel")
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
        Text("detail.routineMetricsSection.title")
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
                label: "detail.routineMetricsSection.stressLevel",
                value: $routineMetrics.stressLevel
            )
            CompactLevelSlider(
                label: "detail.routineMetricsSection.caffeineConsumption",
                value: $routineMetrics.caffeineConsumption
            )
            CompactLevelSlider(
                label: "detail.routineMetricsSection.alcoholConsumption",
                value: $routineMetrics.alcoholConsumption
            )
            CompactLevelSlider(
                label: "detail.routineMetricsSection.physicalActivityLevel",
                value: $routineMetrics.physicalActivityLevel
            )
            CompactLevelSlider(
                label: "detail.routineMetricsSection.screenUseLevel",
                value: $routineMetrics.screenUseLevel
            )
        }
        .padding(.bottom, 8)
    }
}
