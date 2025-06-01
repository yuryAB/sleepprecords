//
//  FeedViewModel.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import Foundation
import SwiftData

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var occurrences: [Occurrence] = []
    @Published var sortDescending: Bool = true
    
    func fetchOccurrences(context: ModelContext) {
        let descriptor = FetchDescriptor<Occurrence>(
            sortBy: [.init(\.date, order: sortDescending ? .reverse : .forward)]
        )
        occurrences = (try? context.fetch(descriptor)) ?? []
    }
    
    func addOccurrence(context: ModelContext, date: Date = Date()) {
        let name = getOccurrenceName(for: date)
        let newOccurrence = Occurrence(date: date, name: name)
        context.insert(newOccurrence)
        try? context.save()
        fetchOccurrences(context: context)
    }
    
    func getOccurrenceName(for date: Date = Date()) -> String {
        OccurrenceNameManager.generateOccurrenceName(for: date)
    }
    
    func deleteOccurrence(_ occurrence: Occurrence, context: ModelContext) {
        context.delete(occurrence)
        try? context.save()
        fetchOccurrences(context: context)
    }
    
    func updateOccurrence(
        _ occurrence: Occurrence,
        newDate: Date,
        newName: String,
        newNote: String,
        newExperiences: [Experience]?,
        context: ModelContext
    ) {
        occurrence.date = newDate
        occurrence.name = newName
        occurrence.note = newNote
        occurrence.experiences = newExperiences
        try? context.save()
        fetchOccurrences(context: context)
    }
    
    func mockOccurrences(context: ModelContext) {
        for _ in 1...50 {
            let year = Int.random(in: 2024...2025)
            let month = Int.random(in: 1...12)
            let day = Int.random(in: 1...28)
            
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = Int.random(in: 0...23)
            dateComponents.minute = Int.random(in: 0...59)
            
            let date = Calendar.current.date(from: dateComponents) ?? Date()
            
            addOccurrence(context: context, date: date)
        }
    }
}
