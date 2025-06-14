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
        ZStack {
            Form {
                dateAndTimeSection
                nameSection
                sleepStartSection
                noteSection
                experienceSection
                paralysisDurationSection
                deleteSection
            }
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: viewModel.trackDate) { viewModel.syncNameIfNeeded() }
            .onChange(of: viewModel.date) { viewModel.syncNameIfNeeded() }
            .navigationTitle("Edit Record")
            .onAppear { viewModel.bind(record: record) }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        AppLog.info(.detail, "User tapped Save for record id: \(record.id)")
                        viewModel.save(record: record, context: context)
                        dismiss()
                    }
                    .disabled(!viewModel.canSave(for: record))
                }
            }

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
}

extension RecordDetailView {
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
    
    private var deleteSection: some View {
        Section {
            HStack {
                Spacer()
                Button("Delete record", role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                }
                Spacer()
            }
        }
    }
}

struct DeleteAlertView: View {
    @Binding var isPresented: Bool
    let record: Record
    let onConfirm: () -> Void

    var body: some View {
        Color.clear
            .alert("Delete record?", isPresented: $isPresented) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    onConfirm()
                }
            } message: {
                Text("This action cannot be undone.")
            }
    }
}
