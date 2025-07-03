//
//  RecordDetailView.swift
//  REM
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
        formBody
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: viewModel.trackDate) { viewModel.syncNameIfNeeded() }
            .onChange(of: viewModel.date) { viewModel.syncNameIfNeeded() }
            .navigationTitle("Edit Record")
            .onAppear {
                viewModel.bind(record: record)
                viewModel.updateVisibleSections(from: record)
            }
            .toolbar { headerToolbar }
            .background(deleteAlert)
    }
}

extension RecordDetailView {
    private var formBody: some View {
        VStack {
            Form {
                nameSection
                dateAndTimeSection
                
                if viewModel.visibleSections.contains(.sleepStart) {
                    sleepStartSection
                }
                
                if viewModel.visibleSections.contains(.paralysisDuration) {
                    paralysisDurationSection
                }
                
                if viewModel.visibleSections.contains(.note) {
                    noteSection
                }
                
                if viewModel.visibleSections.contains(.experience) {
                    experienceSection
                }
                
//                if viewModel.visibleSections.contains(.routineMetrics) {
//                    routineMetricsSection
//                }
//
//                if viewModel.visibleSections.contains(.sleepMetrics) {
//                    sleepMetricsSection
//                }
            }
            .listStyle(PlainListStyle())
            .listRowInsets(EdgeInsets(top: 2, leading: 16, bottom: 4, trailing: 16))
            Spacer()
            actionSection
        }
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
            onRemove: { viewModel.hideSection(.sleepStart) }
        )
    }
    
    private var noteSection: some View {
        NoteSectionView(
            note: $viewModel.note,
            characterLimit: viewModel.noteCharacterLimit,
            onRemove: { viewModel.hideSection(.note) }
        )
    }
    
    private var experienceSection: some View {
        ExperienceSectionView(
            selectedExperiences: $viewModel.selectedExperiences,
            showingPicker: $viewModel.showExperienceSelector,
            onRemove: { viewModel.hideSection(.experience) }
        )
    }
    
    private var paralysisDurationSection: some View {
        ParalysisDurationSectionView(
            selectedDuration: $viewModel.selectedParalysisDuration,
            onRemove: { viewModel.hideSection(.paralysisDuration) }
        )
    }
    
    private var routineMetricsSection: some View {
        RoutineMetricsSectionView(
            routineMetrics: $viewModel.routineMetrics,
            onRemove: { viewModel.hideSection(.experience) }
        )
    }
    
    private var actionSection: some View {
        Section {
            HStack(spacing: 16) {
                Button(role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Label("Delete record", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                .tint(.red.opacity(0.7))

                Spacer()

                Button {
                    AppLog.info(.detail, "User tapped Save for record id: \(record.id)")
                    viewModel.save(record: record, context: context)
                    dismiss()
                } label: {
                    Label("common.save", systemImage: "checkmark.circle.fill")
                }
                .buttonStyle(.bordered)
                .tint(.awake)
                .disabled(!viewModel.canSave(for: record))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
    
    private var sleepMetricsSection: some View {
        HStack {
            Color.white
        }
    }
}

extension RecordDetailView {
    private var headerToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                ForEach(RecordDetailSection.allCases, id: \.self) { section in
                    Toggle(isOn: Binding<Bool>(
                        get: { viewModel.visibleSections.contains(section) },
                        set: { isOn in
                            if isOn {
                                viewModel.visibleSections.insert(section)
                            } else {
                                viewModel.visibleSections.remove(section)
                            }
                        }
                    )) {
                        Label(section.title, systemImage: section.icon)
                    }
                }
            } label: {
                Image(systemName: "list.bullet.clipboard")
            }
        }
    }
    
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
