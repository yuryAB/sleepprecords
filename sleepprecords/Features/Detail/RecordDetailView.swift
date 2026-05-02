//
//  RecordDetailView.swift
//  sleepprecords
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import os

struct RecordDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RecordDetailViewModel()

    let record: Record

    var body: some View {
        VStack(spacing: 0) {
            formBody
            bottomBar
        }
        .scrollDismissesKeyboard(.immediately)
        .onChange(of: viewModel.trackDate) { viewModel.syncNameIfNeeded() }
        .onChange(of: viewModel.date) { viewModel.syncNameIfNeeded() }
        .navigationTitle("detail.navigationTitle")
        .onAppear {
            viewModel.bind(record: record)
            viewModel.updateVisibleSections(from: record)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(deleteAlert)
    }
}

extension RecordDetailView {
    private var formBody: some View {
        Form {
            nameSection
            dateAndTimeSection

            sleepStartSection
            paralysisDurationSection
            noteSection
            experienceSection
            routineMetricsSection
            sleepMetricsSection
        }
        .scrollContentBackground(.hidden)
    }

    private var dateAndTimeSection: some View {
        DateAndTimeSectionView(
            date: $viewModel.date,
            locale: viewModel.currentLocale
        )
    }

    private var nameSection: some View {
        NameSectionView(
            name: $viewModel.name,
            trackDate: $viewModel.trackDate,
            computeAutoName: { viewModel.getRecordName(for: viewModel.date) },
            characterLimit: viewModel.nameCharacterLimit
        )
    }

    private var sleepStartSection: some View {
        SleepStartSectionView(
            sleepStart: $viewModel.sleepStart,
            locale: viewModel.currentLocale,
            isEnabled: viewModel.visibleSections.contains(.sleepStart),
            onToggle: { viewModel.toggleSection(.sleepStart) }
        )
    }

    private var noteSection: some View {
        NoteSectionView(
            note: $viewModel.note,
            characterLimit: viewModel.noteCharacterLimit,
            isEnabled: viewModel.visibleSections.contains(.note),
            onToggle: { viewModel.toggleSection(.note) }
        )
    }

    private var experienceSection: some View {
        ExperienceSectionView(
            selectedExperiences: $viewModel.selectedExperiences,
            showingPicker: $viewModel.showExperienceSelector,
            isEnabled: viewModel.visibleSections.contains(.experience),
            onToggle: { viewModel.toggleSection(.experience) }
        )
    }

    private var paralysisDurationSection: some View {
        ParalysisDurationSectionView(
            selectedDuration: $viewModel.selectedParalysisDuration,
            isEnabled: viewModel.visibleSections.contains(.paralysisDuration),
            onToggle: { viewModel.toggleSection(.paralysisDuration) }
        )
    }

    private var routineMetricsSection: some View {
        RoutineMetricsSectionView(
            routineMetrics: $viewModel.routineMetrics,
            isEnabled: viewModel.visibleSections.contains(.routineMetrics),
            onToggle: { viewModel.toggleSection(.routineMetrics) }
        )
    }

    private var sleepMetricsSection: some View {
        SleepMetricsSectionView(
            sleepMetrics: $viewModel.sleepMetrics,
            isEnabled: viewModel.visibleSections.contains(.sleepMetrics),
            onToggle: { viewModel.toggleSection(.sleepMetrics) }
        )
    }

    private var bottomBar: some View {
        AppBottomBar {
            HStack(spacing: 12) {
                Button {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxHeight: .infinity)
                        .frame(width: AppBottomBar<EmptyView>.contentHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.dormant.opacity(0.8))
                        )
                }

                Button {
                    AppLog.info(.detail, "User tapped Save for record id: \(record.id)")
                    viewModel.save(record: record, context: context)
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.bold))
                        Text("common.save")
                            .font(.subheadline).bold()
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                viewModel.canSave(for: record)
                                    ? RadialGradient(
                                        gradient: Gradient(colors: [.awake, .dormant]),
                                        center: .leading,
                                        startRadius: -30,
                                        endRadius: 200
                                    )
                                    : RadialGradient(
                                        gradient: Gradient(colors: [.gray.opacity(0.4), .gray.opacity(0.3)]),
                                        center: .leading,
                                        startRadius: -30,
                                        endRadius: 200
                                    )
                            )
                    )
                }
                .disabled(!viewModel.canSave(for: record))
            }
        }
    }
}

extension RecordDetailView {
    private var deleteAlert: some View {
        DeleteAlertView(
            isPresented: $viewModel.showDeleteConfirmation,
            record: record
        ) {
            AppLog.info(.detail, "User confirmed deletion of record id: \(record.id)")
            viewModel.delete(record: record, context: context)
            dismiss()
        }
    }
}
