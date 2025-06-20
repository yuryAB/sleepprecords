//
//  ExperienceSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//


import SwiftUI

struct ExperienceSectionView: View {
    @Binding var selectedExperiences: [Experience]
    @Binding var showingPicker: Bool
    
    var body: some View {
        Section(header: header, footer: footer) {
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
        Text("detail.experienceeSection.title")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var footer: some View {
        Text("detail.experienceeSection.footerLabel")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    private var actionButton: some View {
        Button(action: {
            withAnimation(.default) {
                self.showingPicker.toggle()
            }}) {
                
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.awake)
            }
    }
    
    private var content: some View {
        ExperienceSetterView(
            selectedExperiences: $selectedExperiences,
            showingPicker: $showingPicker
        )
    }
}
