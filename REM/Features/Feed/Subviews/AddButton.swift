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
    private let shimmerDuration: Double = 3
    private let shimmerDelay: Double = 2
    
    var body: some View {
        ZStack(alignment: .leading) {
            backgroundView
            SwipePillView(threshold: threshold, action: action)
        }
        .padding(.horizontal)
    }
    
    private var backgroundView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayREM)
            
            Text("Swipe to record")
                .font(.subheadline).bold()
                .padding(.horizontal, 6)
                .foregroundStyle(Color.primary)
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
    }
}

struct ChevronRight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let lineWidth: CGFloat = min(rect.width, rect.height) * 0.3
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path.strokedPath(.init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
    }
}
