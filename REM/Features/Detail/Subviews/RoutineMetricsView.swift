//
//  RoutineMetricsView.swift
//  REM
//
//  Created by yury antony on 20/06/25.
//

import SwiftUI

struct RoutineMetricsView: View {
    @Binding var routineMetrics: RoutineMetrics

    var body: some View {
        Section(header: Text("Routine Metrics")) {
            metricSlider(title: "Stress level", value: $routineMetrics.stressLevel)
            metricSlider(title: "Caffeine consumption", value: $routineMetrics.caffeineConsumption)
            metricSlider(title: "Alcohol consumption", value: $routineMetrics.alcoholConsumption)
            metricSlider(title: "Physical activity level", value: $routineMetrics.physicalActivityLevel)
            metricSlider(title: "Screen use level", value: $routineMetrics.screenUseLevel)
        }
        .padding()
    }

    @ViewBuilder
    private func metricSlider(title: String, value: Binding<Int?>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            Slider(value: Binding(
                get: { Double(value.wrappedValue ?? 0) },
                set: { value.wrappedValue = Int($0) }
            ), in: 0...5, step: 1)
                .tint(.accentColor)

            HStack {
                ForEach(0...5, id: \.self) { level in
                    Spacer()
                    Text("\(level)").font(.caption)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 4)
    }
}
