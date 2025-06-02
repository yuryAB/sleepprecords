//
//  RecordListView.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import SwiftData

struct RecordListView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var viewModel: FeedViewModel
    
    private var groupedByMonth: [DateComponents: [Occurrence]] {
        Dictionary(grouping: viewModel.records) { record in
            Calendar.current.dateComponents([.year, .month], from: record.date)
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
        let records = groupedByMonth[monthComponents] ?? []
        let dateString = monthDate.formatted(.dateTime.month(.abbreviated).year())
        let title = records.count >= 2
        ? "\(records.count) " + "records on".localized + " \(dateString)"
        : dateString
        return Text(title)
    }

    @ViewBuilder
    private func row(for record: Occurrence) -> some View {
        NavigationLink {
            RecordDetailView(record: record)
        } label: {
            VStack(alignment: .leading) {
                Text(viewModel.formattedRecordName(from: record) ?? record.name)
                    .font(.headline)
                Text(viewModel.formattedDateTime(for: record.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    var body: some View {
        List {
            ForEach(sortedMonths, id: \.self) { monthComponents in
                Section(header: header(for: monthComponents)) {
                    ForEach(groupedByMonth[monthComponents] ?? []) { record in
                        row(for: record)
                    }
                    .onDelete { indexSet in
                        indexSet.map { groupedByMonth[monthComponents]![$0] }
                                .forEach { viewModel.deleteRecord($0, context: context) }
                    }
                }
            }
        }
        .animation(.easeInOut, value: viewModel.records)
    }
}
