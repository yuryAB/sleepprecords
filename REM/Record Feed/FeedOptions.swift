//
//  FeedOptions.swift
//  REM
//
//  Created by yury antony on 27/05/25.
//

import SwiftUI
import UIKit

struct FeedOptions: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: FeedViewModel
    @State private var showingLanguageAlert = false
    
    var body: some View {
        Menu {
            sortSubMenu
            languageSubMenu
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
                .foregroundStyle(.awake)
        }
        .alert("Language change", isPresented: $showingLanguageAlert) {
            Button("No", role: .cancel) { }
            Button("Yes") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
        } message: {
            Text("You will be redirected to the app settings in the system, do you want to continue?")
        }
    }
    
    var sortSubMenu: some View {
        Menu {
            Button(action: {
                viewModel.sortDescending = true
                viewModel.fetchRecords(context: context)
            }) {
                HStack {
                    if viewModel.sortDescending {
                        Image(systemName: "checkmark")
                    }
                    Text("Descending by date")
                }
            }
            Button(action: {
                viewModel.sortDescending = false
                viewModel.fetchRecords(context: context)
            }) {
                HStack {
                    if !viewModel.sortDescending {
                        Image(systemName: "checkmark")
                    }
                    Text("Ascending by date")
                }
            }
        } label: {
            Label("Order by", systemImage: "arrow.up.arrow.down")
            Text(viewModel.sortDescending ? "Descending" : "Ascending")
                .font(.subheadline)
        }
    }
    
    var languageSubMenu: some View {
        Button {
            showingLanguageAlert = true
        } label: {
            Label("App language", systemImage: "globe")
        }
    }
    
    var notificationsSubMenu: some View {
        Label("Notifications", systemImage: "bell")
    }
}
