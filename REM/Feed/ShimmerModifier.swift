//
//  ShimmerModifier.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    let active: Bool
    let duration: Double
    let delay: Double
    let gradientColors: [Color]
    let angle: Double
    let direction: Axis
    let beamWidthMultiplier: CGFloat

    func body(content: Content) -> some View {
        if active {
            content
                .overlay(
                    GeometryReader { geometry in
                        let width = geometry.size.width
                        let height = geometry.size.height

                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(
                            width: direction == .horizontal ? width * beamWidthMultiplier : width * 1.6,
                            height: direction == .vertical ? height * beamWidthMultiplier : height * 1.6
                        )
                        .rotationEffect(.degrees(angle))
                        .offset(
                            x: direction == .horizontal ? phase * width * 2 : 0,
                            y: direction == .vertical ? phase * height * 2 : 0
                        )
                    }
                    .clipped()
                )
                .mask(content)
                .onAppear {
                    withAnimation(
                        Animation.linear(duration: duration)
                            .delay(delay)
                            .repeatForever(autoreverses: false)
                    ) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func shimmering(
        active: Bool = true,
        duration: Double = 1.5,
        delay: Double = 1.0,
        gradientColors: [Color] = [
            .white.opacity(0.3),
            .white.opacity(0.9),
            .white.opacity(0.3)
        ],
        angle: Double = 40,
        direction: Axis = .horizontal,
        beamWidthMultiplier: CGFloat = 1.6
    ) -> some View {
        modifier(ShimmerModifier(
            active: active,
            duration: duration,
            delay: delay,
            gradientColors: gradientColors,
            angle: angle,
            direction: direction,
            beamWidthMultiplier: beamWidthMultiplier
        ))
    }
}
