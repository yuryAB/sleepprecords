//
//  Occurrence.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import Foundation
import SwiftData

@Model
final class Occurrence {
    @Attribute(.unique) var id: UUID
    var date: Date
    var name: String
    var note: String
    var experiences: [Experience]?
    
    init(
        date: Date = Date(),
        name: String = "",
        note: String = "",
        experiences: [Experience]? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.name = name
        self.note = note
        self.experiences = experiences
    }
}
