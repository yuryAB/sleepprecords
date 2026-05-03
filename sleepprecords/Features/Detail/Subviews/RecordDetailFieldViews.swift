//
//  RecordDetailFieldViews.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import SwiftUI

struct DetailFieldSection<Content: View>: View {
    let section: RecordDetailSection
    let contextKey: String?
    let footerKey: String?
    @ViewBuilder let content: Content

    init(
        section: RecordDetailSection,
        contextKey: String? = nil,
        footerKey: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.section = section
        self.contextKey = contextKey
        self.footerKey = footerKey
        self.content = content()
    }

    var body: some View {
        Section {
            content
        } header: {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(section.titleKey))
                    .font(.footnote)
                    .foregroundColor(.gray)

                if let contextKey {
                    Text(LocalizedStringKey(contextKey))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(nil)
                }
            }
        } footer: {
            if let footerKey {
                Text(LocalizedStringKey(footerKey))
                    .font(.footnote)
            }
        }
    }
}

struct ShortTextField: View {
    let titleKey: String
    let characterLimit: Int
    @Binding var text: String

    var body: some View {
        TextField(LocalizedStringKey(titleKey), text: limitedTextBinding)
            .textInputAutocapitalization(.sentences)
    }

    private var limitedTextBinding: Binding<String> {
        Binding(
            get: { text },
            set: { text = String($0.prefix(characterLimit)) }
        )
    }
}

struct MultilineTextField: View {
    let placeholderKey: String
    let characterLimit: Int
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(LocalizedStringKey(placeholderKey))
                    .foregroundStyle(.secondary.opacity(0.6))
                    .padding(.top, 8)
                    .padding(.horizontal, 5)
            }

            TextEditor(text: limitedTextBinding)
                .frame(minHeight: 92)
                .scrollContentBackground(.hidden)
        }
    }

    private var limitedTextBinding: Binding<String> {
        Binding(
            get: { text },
            set: { text = String($0.prefix(characterLimit)) }
        )
    }
}
