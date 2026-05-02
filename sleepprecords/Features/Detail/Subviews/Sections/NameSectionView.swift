//
//  NameSectionView.swift
//  sleepprecords
//
//  Created by yury antony on 07/06/25.
//

import SwiftUI

struct NameSectionView: View {
    @Binding var name: String
    @Binding var trackDate: Bool
    @FocusState private var isFocused: Bool
    let computeAutoName: () -> String
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
        Text("detail.nameSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }

    private var actionButton: some View {
        Group {
            Text("detail.nameSection.trackDateLabel")
            Toggle("", isOn: $trackDate)
                .labelsHidden()
                .tint(.awake)
        }
    }

    private var content: some View {
        VStack {
            TextField("detail.nameSection.title", text: $name)
                .focused($isFocused)
                .onChange(of: name) {
                    let autoName = computeAutoName()
                    if trackDate && name != autoName {
                        trackDate = false
                    }
                }
                .toolbar {
                    if isFocused {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            CharacterCountIndicator(currentCount: name.count, characterLimit: characterLimit)
                        }
                    }
                }
        }
    }
}
