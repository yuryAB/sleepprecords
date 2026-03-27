//
//  AppBottomBar.swift
//  REM
//
//  Created by yury antony on 26/03/26.
//

import SwiftUI

struct AppBottomBar<Content: View>: View {
    static var contentHeight: CGFloat { 56 }

    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content
                .frame(height: Self.contentHeight)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
    }
}
