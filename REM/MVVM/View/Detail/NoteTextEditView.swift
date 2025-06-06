//
//  NoteTextEditView.swift
//  REM
//
//  Created by yury antony on 05/06/25.
//


import SwiftUI

struct NoteTextEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var text: String
    private let maxCharacters: Int

    init(text: Binding<String>,
         maxCharacters: Int = 500) {
        self._text = text
        self.maxCharacters = maxCharacters
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Leave your note…")
                            .foregroundColor(.secondary)
                            .padding(8)
                    }
                    TextEditor(text: $text)
                        .padding(4)
                        .onChange(of: text) {
                            if text.count > maxCharacters {
                                text = String(text.prefix(maxCharacters))
                            }
                        }
                }
                
                Divider()
                HStack {
                    let noteRemaining = maxCharacters - text.count
                    Text("\(noteRemaining)")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(noteRemaining < 0 ? .red : .secondary)
                        .padding(.top, 4)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
