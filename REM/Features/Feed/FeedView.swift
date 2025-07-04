//
//  FeedView.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import SwiftData
import os

struct FeedView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.records.isEmpty {
                    nonRecordNotice
                } else {
                    RecordListView(viewModel: viewModel)
                }
                
                AddButton(threshold: 300) {
                    AppLog.info(.feed, "AddButton tapped, adding new record")
                    viewModel.addRecord(context: context)
                }
            }
            .animation(.easeInOut, value: viewModel.records)
            .navigationTitle("Sleepp Records")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                sortOrderToolbarItem
            }
            .onAppear {
                AppLog.info(.feed, "FeedView appeared")
                viewModel.fetchRecords(context: context)
            }
        }
        .tint(.awake)
    }
    
    var nonRecordNotice: some View {
        VStack(spacing: 12) {
            Image("SleeppRecordsLaunch")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top)
            
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
    
    var addMockRecordsButton: some View {
        Button {
            viewModel.mockRecords(context: context)
        } label: {
            Image(systemName: "wand.and.stars")
        }
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            FeedOptions(viewModel: viewModel)
            //addMockRecordsButton
        }
    }
}
