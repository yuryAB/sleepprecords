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
    @Published var records: [Occurrence] = []
    @Published var sortDescending: Bool = true
    
    func fetchRecords(context: ModelContext) {
        let descriptor = FetchDescriptor<Occurrence>(
            sortBy: [.init(\.date, order: sortDescending ? .reverse : .forward)]
        )
        records = (try? context.fetch(descriptor)) ?? []
    }
    
    func addRecord(context: ModelContext, date: Date = Date()) {
        let name = getRecordName(for: date)
        let newRecord = Occurrence(date: date, name: name)
        context.insert(newRecord)
        try? context.save()
        fetchRecords(context: context)
    }
    
    func getRecordName(for date: Date = Date()) -> String {
        RecordNameManager.generateRecordName(for: date)
    }
    
    func deleteRecord(_ record: Occurrence, context: ModelContext) {
        context.delete(record)
        try? context.save()
        fetchRecords(context: context)
    }
    
    func updateRecord(
        _ record: Occurrence,
        newDate: Date,
        newName: String,
        newNote: String,
        newExperiences: [Experience]?,
        context: ModelContext
    ) {
        record.date = newDate
        record.name = newName
        record.note = newNote
        record.experiences = newExperiences
        try? context.save()
        fetchRecords(context: context)
    }
    
    func mockRecords(context: ModelContext) {
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
            
            addRecord(context: context, date: date)
        }
    }
    
    func formattedDateTime(for date: Date) -> String {
        let locale: Locale
        switch LocalizationManager.currentLanguage {
        case .portuguese:
            locale = Locale(identifier: "pt_BR")
        case .english:
            locale = Locale(identifier: "en_US")
        }

        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateStyle = .long
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }
    
    func formattedRecordName(from record: Occurrence) -> String? {
        return RecordNameManager.generateRecordDisplayName(from: record)
    }
}
