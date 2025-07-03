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
    let onRemove: (() -> Void)
    
    var body: some View {
        Section(header: header, footer: footer) {
            content
        }
    }
    
    private var header: some View {
        HStack {
            removeButton
            title
            Spacer()
            actionButton
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
            }}) {
                
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .foregroundStyle(.awake)
            }
            .sheet(isPresented: $showEditor) {
                NoteTextEditView(text: $note, maxCharacters: characterLimit)
            }
    }
    
    private var removeButton: some View {
        Button(action: {
            withAnimation {
                onRemove()
            }
        }) {
            Image(systemName: "minus")
                .font(.title2)
                .foregroundStyle(.dormant)
        }
    }
    
    private var content: some View {
        ZStack(alignment: .topLeading) {
            if note.isEmpty {
                Text("detail.noteSection.contentLabel")
                    .foregroundColor(.secondary.opacity(0.5))
                    .padding(8)
            }
            Text(note)
                .padding(8)
                .frame(maxWidth: .infinity, minHeight: 30, alignment: .topLeading)
        }
    }
    
    private var footer: some View {
        Text("detail.noteSection.footerLabel")
            .font(.footnote)
    }
}
