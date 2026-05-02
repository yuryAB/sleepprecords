//
//  NoteSectionView.swift
//  sleepprecords
//
//  Created by yury antony on 07/06/25.
//

import SwiftUI

struct NoteSectionView: View {
    @Binding var note: String
    @State private var showEditor: Bool = false
    let characterLimit: Int
    let isEnabled: Bool
    let onToggle: () -> Void

    init(
        note: Binding<String>,
        characterLimit: Int,
        isEnabled: Bool,
        onToggle: @escaping () -> Void
    ) {
        self._note = note
        self.characterLimit = characterLimit
        self.isEnabled = isEnabled
        self.onToggle = onToggle
    }

    var body: some View {
        Section {
            content
                .optionalSection(isEnabled: isEnabled)
        } header: {
            header
        } footer: {
            if !isEnabled {
                Text("detail.noteSection.footerLabel")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
    }

    private var header: some View {
        HStack {
            toggleButton
            title
            Spacer()
            if isEnabled {
                actionButton
            }
        }
    }

    private var title: some View {
        Text("detail.noteSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var actionButton: some View {
        Button(action: {
            withAnimation(.default) {
                self.showEditor.toggle()
            }
        }) {
            Image(systemName: "square.and.pencil")
                .font(.title2)
                .foregroundStyle(.awake)
        }
        .sheet(isPresented: $showEditor) {
            NoteTextEditView(text: $note, maxCharacters: characterLimit)
        }
    }

    private var toggleButton: some View {
        Button(action: {
            withAnimation {
                onToggle()
            }
        }) {
            Image(systemName: isEnabled ? "minus" : "plus")
                .font(.title2)
                .foregroundStyle(isEnabled ? .dormant : .awake)
        }
    }

    private var content: some View {
        ZStack(alignment: .topLeading) {
            if note.isEmpty {
                Text("detail.noteSection.contentLabel")
                    .foregroundColor(.secondary.opacity(0.5))
            }
            Text(note)
                .frame(maxWidth: .infinity, minHeight: 30, alignment: .topLeading)
        }
    }

}
