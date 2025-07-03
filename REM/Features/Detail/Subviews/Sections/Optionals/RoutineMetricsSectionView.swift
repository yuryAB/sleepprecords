//
//  RoutineMetricsSectionView.swift
//  REM
//
//  Created by yury antony on 20/06/25.
//


import SwiftUI

struct RoutineMetricsSectionView: View {
    @Binding var routineMetrics: RoutineMetrics
    @State private var showEditor: Bool = false
    let onRemove: (() -> Void)

    var body: some View {
        Section(header: header, footer: footer) {
            content
        }
    }

    private var header: some View {
        HStack {
            removeButton
            title
            Spacer()
            actionButton
        }
    }

    private var title: some View {
        Text("detail.routineMetricsSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var actionButton: some View {
        Button {
            withAnimation(.default) {
                showEditor.toggle()
            }
        } label: {
            Image(systemName: "square.and.pencil")
                .font(.title2)
                .foregroundStyle(.awake)
        }
        .sheet(isPresented: $showEditor) {
            RoutineMetricsView(routineMetrics: $routineMetrics)
        }
    }
    
    private var removeButton: some View {
        Button(action: {
            withAnimation {
                onRemove()
            }
        }) {
            Image(systemName: "minus")
                .font(.title2)
                .foregroundStyle(.dormant)
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            metricRow("Stress level", routineMetrics.stressLevel)
            metricRow("Caffeine", routineMetrics.caffeineConsumption)
            metricRow("Alcohol", routineMetrics.alcoholConsumption)
            metricRow("Physical activity", routineMetrics.physicalActivityLevel)
            metricRow("Screen use", routineMetrics.screenUseLevel)
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
        Text("detail.routineMetricsSection.footerLabel")
            .font(.footnote)
    }
}
