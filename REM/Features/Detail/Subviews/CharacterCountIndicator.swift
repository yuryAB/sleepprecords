//
//  CharacterCountIndicator.swift
//  REM
//
//  Created by yury antony on 19/06/25.
//

import SwiftUI

struct CharacterCountIndicator: View {
    let currentCount: Int
    let characterLimit: Int

    var body: some View {
        let remaining = characterLimit - currentCount

        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.3)
                .foregroundColor(.gray)
            Circle()
                .trim(from: 0.0, to: min(CGFloat(currentCount) / CGFloat(characterLimit), 1.0))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(remaining < 0 ? .red : .awake)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut(duration: 0.3), value: currentCount)
            Text("\(remaining)")
                .font(.footnote)
                .foregroundColor(remaining < 0 ? .red : .secondary)
        }
        .frame(width: 24, height: 24)
    }
}
