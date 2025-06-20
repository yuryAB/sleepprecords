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
                
                if viewModel.visibleSections.contains(.note) {
                    noteSection
                }
                if viewModel.visibleSections.contains(.experience) {
                    experienceSection
                }
                if viewModel.visibleSections.contains(.paralysisDuration) {
                    paralysisDurationSection
                }
                if viewModel.visibleSections.contains(.routineMetrics) {
                    routineMetricsSection
                }
                if viewModel.visibleSections.contains(.sleepMetrics) {
                    sleepMetricsSection
                }
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
            locale: viewModel.currentLocale
        )
    }
    
    private var noteSection: some View {
        NoteSectionView(
            note: $viewModel.note,
            characterLimit: viewModel.noteCharacterLimit
        )
    }
    
    private var experienceSection: some View {
        ExperienceSectionView(
            selectedExperiences: $viewModel.selectedExperiences,
            showingPicker: $viewModel.showExperienceSelector
        )
    }
    
    private var paralysisDurationSection: some View {
        ParalysisDurationSectionView(
            selectedDuration: $viewModel.selectedParalysisDuration
        )
    }
    
    private var actionSection: some View {
        Section {
            HStack {
                Spacer()
                Button("Delete record", role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                }
                Spacer()
                Button("Save") {
                    AppLog.info(.detail, "User tapped Save for record id: \(record.id)")
                    viewModel.save(record: record, context: context)
                    dismiss()
                }
                .disabled(!viewModel.canSave(for: record))
                Spacer()
            }
        }
    }
    
    private var routineMetricsSection: some View {
        HStack {
            Color.white
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
