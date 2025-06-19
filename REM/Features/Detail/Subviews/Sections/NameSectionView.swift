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
        Text("Name")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var actionButton: some View {
        Group {
            Text("Track date")
            Toggle("", isOn: $trackDate)
                .labelsHidden()
                .tint(.awake)
        }
    }
    
    private var footer: some View {
        Text("You can define a specific name for this record.")
            .font(.footnote)
    }
    
    private var content: some View {
        VStack {
            TextField("Name", text: $name)
                .onChange(of: name) {
                    let autoName = computeAutoName()
                    if trackDate && name != autoName {
                        trackDate = false
                    }
                }
            let remaining = characterLimit - name.count
            HStack {
                Text("\(remaining)")
                    .font(.footnote)
                    .foregroundColor(remaining < 0 ? .red : .secondary)
                    .padding(.top, 4)
                Spacer()
            }
            
        }
        
    }
}
