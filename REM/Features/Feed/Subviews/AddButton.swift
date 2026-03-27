//
//  AddButton.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI

struct AddButton: View {
    let threshold: CGFloat
    let action: () -> Void
    
    @State private var pillOffset: CGFloat = 0
    @State private var thresholdReached: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            background
            pill
        }
        .padding(.horizontal, 0)
    }
    
    private var pill: some View {
        SwipePillView(threshold: threshold, action: action)
    }
    
    private var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayREM)

            Text("Swipe to record")
                .font(.subheadline).bold()
                .padding(.horizontal, 6)
                .foregroundStyle(Color.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
