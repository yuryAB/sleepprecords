//
//  NoteDetails.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct NoteDetails: Codable, Equatable {
    var text: String?

    var pruned: NoteDetails? {
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmedText, !trimmedText.isEmpty else {
            return nil
        }
        return NoteDetails(text: trimmedText)
    }
}
