//
//  OccurrenceDetailView.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI

struct OccurrenceDetailView: View {
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
    
    let occurrence: Occurrence
    
    init(occurrence: Occurrence) {
        self.occurrence = occurrence
        _date = State(initialValue: occurrence.date)
        _name = State(initialValue: occurrence.name)
        _note = State(initialValue: occurrence.note)
        _selectedFeelings = State(initialValue: occurrence.experiences ?? [])
    }
    
    private var isModified: Bool {
        date != occurrence.date ||
        name != occurrence.name ||
        note != occurrence.note ||
        selectedFeelings != (occurrence.experiences ?? [])
    }

    var body: some View {
        Form {
            Section("Date and Time") {
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
                footer: Text("You can define a specific name for this occurrence.")
                    .font(.footnote)
            ) {
                TextField("Name", text: $name)
                    .focused($isEditing)
                    .disabled(trackDate)
            }
            
            Section("Note") {
                ZStack(alignment: .topLeading) {
                    if note.isEmpty {
                        Text("Feel free to detail what happened to you.")
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
                    Button("Delete Occurrence", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: trackDate) {
            if trackDate {
                name = viewModel.getOccurrenceName(for: date)
            }
        }
        .onChange(of: date) {
            if trackDate {
                name = viewModel.getOccurrenceName(for: date)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .gesture(
            TapGesture().onEnded {
                isEditing = false
            },
            including: .none
        )
        .alert("Delete this occurrence?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteOccurrence(occurrence, context: context)
                dismiss()
            }
        }
        .navigationTitle("Edit Occurrence")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.updateOccurrence(
                        occurrence,
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
