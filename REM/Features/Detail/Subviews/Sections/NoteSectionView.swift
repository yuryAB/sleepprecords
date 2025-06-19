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
        Section(header: header) {
            content
        }
    }
    
    private var header: some View {
        HStack {
            title
            Spacer()
            actionButton
        }
    }
    
    private var title: some View {
        Text("Note")
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
    
    private var content: some View {
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
