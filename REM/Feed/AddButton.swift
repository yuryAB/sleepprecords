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
            backgroundView
            pill
        }
        .padding(.horizontal)
    }
    
    private var backgroundView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayREM)
            
            HStack(spacing: 45) {
                
                ForEach(0..<5, id: \.self) { _ in
                    ChevronRight()
                        .frame(width: 15, height: 23)
                        .foregroundColor(Color.grayREM)
                }
            }
            .frame(maxWidth: .infinity)
            .shimmering(
                duration: 2,
                delay: 4.0,
                gradientColors:[
                    .awake,
                    .dormant
                ],
                angle: 0,
                direction: .horizontal,
                beamWidthMultiplier: 1.0
            )
            
            Text("Swipe to record")
                .font(.subheadline)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
    }
    
    var pill: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.awake,
                        Color.dormant]),
                    center: .leading,
                    startRadius: -30,
                    endRadius: 60
                )
            )
            .frame(width: 20, height: 50)
            .offset(x: pillOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !thresholdReached else { return }
                        let translation = value.translation.width
                        let newOffset = max(0, min(translation, threshold))
                        pillOffset = newOffset
                        
                        if newOffset >= threshold {
                            thresholdReached = true
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation(.spring()) {
                                pillOffset = 0
                            }
                            action()
                        }
                    }
                    .onEnded { _ in
                        if !thresholdReached {
                            withAnimation(.spring()) {
                                pillOffset = 0
                            }
                        }
                        thresholdReached = false
                    }
            )
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
