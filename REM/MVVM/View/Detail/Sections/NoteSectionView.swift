//
//  NoteSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//


import SwiftUI

struct NoteSectionView: View {
    @Binding var note: String
    @State private var showEditor: Bool = false
    let characterLimit: Int

    var body: some View {
        VStack(spacing: 0) {
            Section(
                header: HStack {
                    Text("Note")
                    Spacer()
                    Button {
                        showEditor = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .foregroundStyle(.awake)
                    }
                }
            ) {
                ZStack(alignment: .topLeading) {
                    if note.isEmpty {
                        Text("Feel free to leave a note about the experience you had, noting whatever details or thoughts you find helpful.")
                            .foregroundColor(.secondary)
                            .padding(8)
                    }
                    Text(note)
                        .padding(8)
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            NoteTextEditView(text: $note, maxCharacters: characterLimit)
        }
    }
}
