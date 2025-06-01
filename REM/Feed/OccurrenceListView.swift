//
//  OccurrenceListView.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import SwiftData

struct OccurrenceListView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: FeedViewModel
    
    private var groupedByMonth: [DateComponents: [Occurrence]] {
        Dictionary(grouping: viewModel.occurrences) { occurrence in
            Calendar.current.dateComponents([.year, .month], from: occurrence.date)
        }
    }

    private var sortedMonths: [DateComponents] {
        groupedByMonth.keys.sorted { a, b in
            guard let dateA = Calendar.current.date(from: a),
                  let dateB = Calendar.current.date(from: b) else { return false }
            return viewModel.sortDescending ? dateA > dateB : dateA < dateB
        }
    }

    private func header(for monthComponents: DateComponents) -> Text {
        guard let monthDate = Calendar.current.date(from: monthComponents) else {
            return Text("")
        }
        let occurrences = groupedByMonth[monthComponents] ?? []
        let dateString = monthDate.formatted(.dateTime.month(.abbreviated).year())
        let title = occurrences.count >= 2
        ? "\(occurrences.count) " + "records on".localizable + " \(dateString)"
        : dateString
        return Text(title)
    }

    @ViewBuilder
    private func row(for occurrence: Occurrence) -> some View {
        NavigationLink {
            OccurrenceDetailView(occurrence: occurrence)
        } label: {
            VStack(alignment: .leading) {
                Text(occurrence.name)
                    .font(.headline)
                Text(occurrence.date.formatted(date: .numeric, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        List {
            ForEach(sortedMonths, id: \.self) { monthComponents in
                Section(header: header(for: monthComponents)) {
                    ForEach(groupedByMonth[monthComponents] ?? []) { occurrence in
                        row(for: occurrence)
                    }
                    .onDelete { indexSet in
                        indexSet.map { groupedByMonth[monthComponents]![$0] }
                                .forEach { viewModel.deleteOccurrence($0, context: context) }
                    }
                }
            }
        }
        .animation(.easeInOut, value: viewModel.occurrences)
    }
}
