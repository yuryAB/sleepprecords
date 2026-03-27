//
//  NoteTextEditView.swift
//  REM
//
//  Created by yury antony on 05/06/25.
//

import SwiftUI

struct NoteTextEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var text: String
    @FocusState private var isFocused: Bool
    private let maxCharacters: Int
    @State private var editableText: String
    
    init(text: Binding<String>,
         maxCharacters: Int = 200) {
        self._text = text
        self.maxCharacters = maxCharacters
        self._editableText = State(initialValue: text.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("common.cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
                .textCase(nil)
                Spacer()
                Text("detail.noteSection.title")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                Button("common.save") {
                    text = editableText
                    dismiss()
                }
                .fontWeight(.bold)
                .textCase(nil)
            }
            .padding()
            
            Divider()
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $editableText)
                    .padding(4)
                    .focused($isFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.isFocused = true
                        }
                    }
                    .onChange(of: editableText) {
                        if editableText.count > maxCharacters {
                            editableText = String(editableText.prefix(maxCharacters))
                        }
                    }
                    .toolbar {
                        if isFocused {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                CharacterCountIndicator(currentCount: editableText.count, characterLimit: maxCharacters)
                            }
                        }
                    }
            }
        }
        .padding(.top, 12)
        .padding(.horizontal)
    }
}
