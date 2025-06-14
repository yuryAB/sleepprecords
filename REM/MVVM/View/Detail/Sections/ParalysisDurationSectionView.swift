//
//  ParalysisDurationSectionView.swift
//  REM
//
//  Created by yury antony on 07/06/25.
//


import SwiftUI

struct ParalysisDurationSectionView: View {
    @Binding var selectedDuration: String

    private let durations = [
        "Less than 30 seconds",
        "30 s – 1 minute",
        "1 – 2 minutes",
        "More than 2 minutes",
        "Not sure"
    ]

    var body: some View {
        Section("Paralysis duration") {
            ForEach(durations, id: \.self) { option in
                HStack {
                    Text(option)
                    Spacer()
                    if selectedDuration == option {
                        Image(systemName: "checkmark")
                            .foregroundColor(.awake)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedDuration = option
                }
            }
        }
    }
}

struct ParalysisDurationSectionView_Previews: PreviewProvider {
    @State static var selection = ""

    static var previews: some View {
        Form {
            ParalysisDurationSectionView(selectedDuration: $selection)
        }
    }
}