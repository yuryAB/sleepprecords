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
        Section(header: header,footer: footer) {
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
        Text("detail.nameSection.title") //Name
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var actionButton: some View {
        Group {
            Text("detail.nameSection.trackDateLabel") //Track date
            Toggle("", isOn: $trackDate)
                .labelsHidden()
                .tint(.awake)
        }
    }
    
    private var footer: some View {
        Text("detail.nameSection.footerLabel") //You can define a specific name for this record.
            .font(.footnote)
    }
    
    private var content: some View {
        VStack {
            TextField("detail.nameSection.title", text: $name)
                .onChange(of: name) {
                    let autoName = computeAutoName()
                    if trackDate && name != autoName {
                        trackDate = false
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        CharacterCountIndicator(currentCount: name.count, characterLimit: characterLimit)
                    }
                }
        }
    }
}
