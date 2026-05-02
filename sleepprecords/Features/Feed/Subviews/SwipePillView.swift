//
//  SwipePillView.swift
//  sleepprecords
//
//  Created by yury antony on 06/07/25.
//

import SwiftUI

struct SwipePillView: View {
    let threshold: CGFloat
    let action: () -> Void
    
    private enum Const {
        static let size = CGSize(width: 20, height: 50)
        static let cornerRadius: CGFloat = 12
        static let gradient = RadialGradient(
            gradient: Gradient(colors: [.awake, .dormant]),
            center: .leading,
            startRadius: -30,
            endRadius: 60
        )
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var pillOffset: CGFloat = 0
    @State private var thresholdReached: Bool = false
    
    // Chevron is visible only when the pill is at rest
    private var showChevron: Bool { pillOffset == 0 }
    
    var body: some View {
        HStack(spacing: 6) {
            pill
            chevron
        }
        .onAppear { feedbackGenerator.prepare() }
    }
    
    private var pill: some View {
        RoundedRectangle(cornerRadius: Const.cornerRadius)
            .fill(Const.gradient)
            .frame(width: Const.size.width, height: Const.size.height)
            .offset(x: pillOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !thresholdReached else { return }
                        let translation = value.translation.width
                        pillOffset = max(0, min(translation, threshold))
                        
                        if pillOffset >= threshold {
                            thresholdReached = true
                            feedbackGenerator.impactOccurred()
                            withAnimation(.spring()) { pillOffset = 0 }
                            action()
                        }
                    }
                    .onEnded { _ in
                        if !thresholdReached {
                            withAnimation(.spring()) { pillOffset = 0 }
                        }
                        thresholdReached = false
                    }
            )
    }
    
    private var chevron: some View {
        TimelineView(.animation) { context in
            let wiggleDuration:Double = 0.6
            let pauseDuration:Double = 2.0
            let cycle = wiggleDuration + pauseDuration
            
            let phase = context.date.timeIntervalSinceReferenceDate
                .truncatingRemainder(dividingBy: cycle)
            let isWiggling = phase < wiggleDuration
            
            Image(systemName: "chevron.right")
                .font(.body.weight(.bold))
                .foregroundStyle(.secondary)
                .symbolEffect(.wiggle, value: isWiggling)
                .opacity(showChevron ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: showChevron)
        }
    }
}
