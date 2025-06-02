//
//  RecordDetailView.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI

struct RecordDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = FeedViewModel()
    
    @State private var date: Date
    @State private var name: String
    @State private var note: String
    @State private var selectedFeelings: [Experience]
    @State private var trackDate = false
    
    @FocusState private var isEditing: Bool

    private let noteCharacterLimit = 500
    @State private var showDeleteConfirmation = false
    
    let record: Occurrence
    
    init(record: Occurrence) {
        self.record = record
        _date = State(initialValue: record.date)
        _name = State(initialValue: record.name)
        _note = State(initialValue: record.note)
        _selectedFeelings = State(initialValue: record.experiences ?? [])
    }
    
    private var isModified: Bool {
        date != record.date ||
        name != record.name ||
        note != record.note ||
        selectedFeelings != (record.experiences ?? [])
    }

    var body: some View {
        Form {
            Section("Date and time") {
                DatePicker(selection: $date, displayedComponents: [.date, .hourAndMinute]) {
                    Label("", systemImage: "clock")
                        .foregroundStyle(.primary)
                }
                .datePickerStyle(.compact)
            }
            
            Section(
                header: HStack {
                    Text("Name")
                    Spacer()
                    Text("Track date")
                    Toggle("", isOn: $trackDate)
                        .labelsHidden()
                        .tint(.awake)
                },
                footer: Text("You can define a specific name for this record.")
                    .font(.footnote)
            ) {
                TextField("Name", text: $name)
                    .focused($isEditing)
                    .disabled(trackDate)
            }
            
            Section("Note") {
                ZStack(alignment: .topLeading) {
                    if note.isEmpty {
                        Text("Feel free to leave a note about the experience you had, noting whatever details or thoughts you find helpful.")
                            .foregroundColor(.secondary)
                            .padding(8)
                    }
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .focused($isEditing)
                }
                Text("\(note.count) / \(noteCharacterLimit)")
                    .font(.footnote)
                    .foregroundColor(note.count > noteCharacterLimit ? .red : .secondary)
            }
            
            Section("Experience") {
                ExperienceSetterView(selectedExperiences: $selectedFeelings)
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Delete record", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: trackDate) {
            if trackDate {
                name = viewModel.getRecordName(for: date)
            }
        }
        .onChange(of: date) {
            if trackDate {
                name = viewModel.getRecordName(for: date)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .gesture(
            TapGesture().onEnded {
                isEditing = false
            },
            including: .none
        )
        .alert("Delete record?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteRecord(record, context: context)
                dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
        .navigationTitle("Edit Record")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.updateRecord(
                        record,
                        newDate: date,
                        newName: name,
                        newNote: note,
                        newExperiences: selectedFeelings,
                        context: context
                    )
                    dismiss()
                }
                .disabled(!isModified)
            }
        }
    }
}
