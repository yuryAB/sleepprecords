//
//  OptionalSectionModifier.swift
//  REM
//
//  Created by yury antony on 27/03/26.
//

import SwiftUI

struct OptionalSectionModifier: ViewModifier {
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isEnabled ? 1 : 0.35)
            .disabled(!isEnabled)
            .listRowBackground(
                Color(.secondarySystemGroupedBackground)
                    .opacity(isEnabled ? 1 : 0.35)
            )
    }
}

extension View {
    func optionalSection(isEnabled: Bool) -> some View {
        modifier(OptionalSectionModifier(isEnabled: isEnabled))
    }
}
