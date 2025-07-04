//
//  CreatorNoteView.swift
//  REM
//
//  Created by yury antony on 02/07/25.
//


import SwiftUI

struct CreatorNoteView: View {
    @AppStorage("hasSeenCreatorNote") private var hasSeenCreatorNote = false
    var body: some View {
        VStack {
            Image("SleeppRecordsLaunch")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top)
            Text("creatorNote.title")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Text("creatorNote.subheadline")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("creatorNote.text")
                }
                .padding(.horizontal, 30)
            }

            Spacer()

            Button(action: {
                hasSeenCreatorNote = true
            }) {
                Text("creatorNote.buttonLabel")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.dormant)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
