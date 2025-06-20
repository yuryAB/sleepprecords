//
//  DeleteAlertView.swift
//  REM
//
//  Created by yury antony on 14/06/25.
//

import SwiftUI

struct DeleteAlertView: View {
    @Binding var isPresented: Bool
    let record: Record
    let onConfirm: () -> Void
    
    var body: some View {
        Color.clear
            .alert("Delete record?", isPresented: $isPresented) {
                Button("common.cancel", role: .cancel) { }
                Button("common.delete", role: .destructive) {
                    onConfirm()
                }
            } message: {
                Text("This action cannot be undone.")
            }
    }
}
