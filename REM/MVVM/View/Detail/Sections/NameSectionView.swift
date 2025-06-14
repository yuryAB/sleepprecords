//
//  NameSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//


import SwiftUI

struct NameSectionView: View {
    @Binding var name: String
    @Binding var trackDate: Bool
    let computeAutoName: () -> String
    let characterLimit: Int

    var body: some View {
        Section(
            header: HStack {
                Text("Name")
                Spacer()
                Text("Track date")
                Toggle("", isOn: $trackDate)
                    .labelsHidden()
                    .tint(.awake)
            },
            footer: Text("You can define a specific name for this record.")
                .font(.footnote)
        ) {
            TextField("Name", text: $name)
                .onChange(of: name) {
                    let autoName = computeAutoName()
                    if trackDate && name != autoName {
                        trackDate = false
                    }
                }
            let remaining = characterLimit - name.count
            Text("\(remaining)")
                .font(.footnote)
                .foregroundColor(remaining < 0 ? .red : .secondary)
                .padding(.top, 4)
        }
    }
}
