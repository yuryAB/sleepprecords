//
//  FeedView.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import SwiftData

struct FeedView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.occurrences.isEmpty {
                    nonOccurrenceNotice
                } else {
                    OccurrenceListView(viewModel: viewModel)
                }
                
                AddButton(threshold: 300) {
                    viewModel.addOccurrence(context: context)
                }
            }
            .animation(.easeInOut, value: viewModel.occurrences)
            .navigationTitle("Sleepp Records")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                sortOrderToolbarItem
            }
            .onAppear {
                viewModel.fetchOccurrences(context: context)
            }
        }
        .tint(.awake)
    }
    
    var nonOccurrenceNotice: some View {
        VStack(spacing: 12) {
            Text("No records yet.")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("When you've experienced a sleep paralysis episode, swipe to log it.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

            Text("If you have notes made outside the app, create a new record and later edit details like the date.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(30)
    }
    
    var addMockEpisodesButton: some View {
        Button {
            viewModel.mockOccurrences(context: context)
        } label: {
            Image(systemName: "wand.and.stars")
        }
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            FeedOptions(viewModel: viewModel)
            //addMockEpisodesButton
        }
    }
}
