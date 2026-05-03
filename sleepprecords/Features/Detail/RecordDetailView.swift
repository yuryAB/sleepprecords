//
//  RecordDetailView.swift
//  sleepprecords
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import os

struct RecordDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = RecordDetailViewModel()
    @State private var showDetailSectionPicker = false
    @State private var activeDetailField: RecordDetailSection?

    let record: Record

    var body: some View {
        VStack(spacing: 0) {
            formBody
            bottomBar
        }
        .scrollDismissesKeyboard(.immediately)
        .onChange(of: viewModel.trackDate) { viewModel.syncNameIfNeeded() }
        .onChange(of: viewModel.date) { viewModel.syncNameIfNeeded() }
        .onChange(of: viewModel.selectedExperiences) { viewModel.pruneExperienceIntensities() }
        .navigationTitle("detail.navigationTitle")
        .onAppear {
            viewModel.bind(record: record)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(deleteAlert)
        .sheet(isPresented: $showDetailSectionPicker) {
            DetailSectionPickerView(
                selectedSections: $viewModel.visibleSections,
                sectionHasContent: { viewModel.hasContent(in: $0) },
                toggleSection: { viewModel.toggleSection($0) },
                sectionsInGroup: { viewModel.sections(in: $0) },
                groups: RecordDetailSectionGroup.allCases,
                titleKey: detailSectionPickerTitleKey,
                introKey: "detail.optionalDetails.addSheet.intro",
                doneKey: "detail.optionalDetails.addSheet.done"
            )
        }
        .sheet(item: $activeDetailField) { section in
            DetailFieldEditorSheet(
                section: section,
                viewModel: viewModel
            )
        }
        .sheet(isPresented: $viewModel.showExperienceSelector) {
            ExperiencePickerView(
                selectedExperiences: $viewModel.selectedExperiences,
                experienceIntensities: $viewModel.experienceIntensities
            )
        }
    }
}

extension RecordDetailView {
    private var formBody: some View {
        Form {
            nameSection
            dateAndTimeSection

            if activeGroups.isEmpty {
                emptyEpisodeDetailsSection
            } else {
                ForEach(activeGroups) { group in
                    compactDetailsSection(for: group)
                }

                manageFieldsSection
            }
        }
        .scrollContentBackground(.hidden)
    }

    private var dateAndTimeSection: some View {
        DateAndTimeSectionView(
            date: $viewModel.date,
            locale: viewModel.currentLocale
        )
    }

    private var detailSectionPickerTitleKey: String {
        activeGroups.isEmpty ? "detail.optionalDetails.addSheet.title" : "detail.optionalDetails.manageSheet.title"
    }

    private var emptyEpisodeDetailsSection: some View {
        Section {
            Text("detail.episodeDetails.emptyText")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                showDetailSectionPicker = true
            } label: {
                Label("detail.optionalDetails.addDetails", systemImage: "plus.circle.fill")
            }
        } header: {
            Text("detail.episodeDetails.title")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    @ViewBuilder
    private func compactDetailsSection(for group: RecordDetailSectionGroup) -> some View {
        let sections = activeSections(in: group)

        Section {
            ForEach(sections) { section in
                detailRow(for: section)
            }
        } header: {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(titleKey(for: group)))
                    .font(.footnote)
                    .foregroundColor(.gray)

                if group == .episode {
                    Text("detail.optionalDetails.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                } else if group == .sleep {
                    Text("detail.sleepDetails.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                } else if group == .preSleep {
                    Text("detail.preSleep.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                } else if group == .previousDay {
                    Text("detail.previousDay.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                } else if group == .postEpisode {
                    Text("detail.postEpisode.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                } else if group == .interpretation {
                    Text("detail.interpretation.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                } else if group == .sensitive {
                    Text("detail.sensitive.activeText")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(nil)
                }
            }
        }
    }

    private var manageFieldsSection: some View {
        Section {
            Button {
                showDetailSectionPicker = true
            } label: {
                Label("detail.optionalDetails.manageFields", systemImage: "slider.horizontal.3")
            }
            .font(.subheadline.weight(.semibold))
        }
    }

    private var activeGroups: [RecordDetailSectionGroup] {
        RecordDetailSectionGroup.allCases.filter { !activeSections(in: $0).isEmpty }
    }

    private func activeSections(in group: RecordDetailSectionGroup) -> [RecordDetailSection] {
        RecordDetailSection.orderedCases.filter {
            $0.group == group && viewModel.visibleSections.contains($0)
        }
    }

    private func detailRow(for section: RecordDetailSection) -> some View {
        let value = detailValue(for: section)
        let displayValue = value ?? "detail.optionalDetails.addValue".localized

        return Button {
            if section == .experiences {
                viewModel.showExperienceSelector = true
            } else {
                activeDetailField = section
            }
        } label: {
            HStack(spacing: 12) {
                Text(LocalizedStringKey(section.titleKey))
                    .foregroundStyle(.primary)

                Spacer()

                Text(displayValue)
                    .lineLimit(1)
                    .foregroundStyle(value == nil ? Color.awake : Color.secondary)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(section.titleKey.localized), \(displayValue)"))
        .accessibilityAddTraits(.isButton)
    }

    private func titleKey(for group: RecordDetailSectionGroup) -> String {
        switch group {
        case .episode:
            return "detail.episodeDetails.title"
        default:
            return group.titleKey
        }
    }

    private func detailValue(for section: RecordDetailSection) -> String? {
        switch section {
        case .episodeMoment:
            return viewModel.episodeMoment?.titleKey.localized
        case .paralysisDuration:
            return viewModel.selectedParalysisDuration?.descriptionKey.localized
        case .bodyPosition:
            return viewModel.bodyPosition?.titleKey.localized
        case .fearDistress:
            if viewModel.fearDistressNotSure {
                return "detail.episodeDetails.option.notSure".localized
            }
            guard let level = viewModel.fearDistressLevel else {
                return nil
            }
            return fearDistressValueKey(for: level).localized
        case .breathingImpact:
            return viewModel.breathingImpact?.titleKey.localized
        case .sleepPeriodAndDuration:
            return sleepPeriodAndDurationSummary
        case .sleepStart:
            return formattedTime(viewModel.sleepStart)
        case .wakeTime:
            return formattedTime(viewModel.wakeTime)
        case .estimatedSleepDuration:
            return viewModel.estimatedSleepDuration?.titleKey.localized
        case .experiences:
            return experiencesSummary
        case .sleepQuality:
            return sleepQualitySummary
        case .awakenings:
            return viewModel.awakenings?.titleKey.localized
        case .sleepDayFactors:
            return sleepDayFactorsSummary
        case .hadNap:
            return presenceSummary(viewModel.hadNap)
        case .sleepDeprivation:
            return presenceSummary(viewModel.sleepDeprivation)
        case .irregularSchedule:
            return presenceSummary(viewModel.irregularSchedule)
        case .sleepEnvironment:
            return sleepEnvironmentSummary
        case .noiseLevel:
            return levelSummary(viewModel.noiseLevel)
        case .lightLevel:
            return levelSummary(viewModel.lightLevel)
        case .temperatureLevel:
            return levelSummary(viewModel.temperatureLevel)
        case .stressLevel:
            return preSleepStressSummary
        case .preSleepActivities:
            return preSleepActivitiesSummary
        case .screenUse:
            return timedLevelSummary(level: viewModel.screenUseLevel, timing: viewModel.screenUseTiming)
        case .physicalActivity:
            return timedLevelSummary(level: viewModel.physicalActivityLevel, timing: viewModel.physicalActivityTiming)
        case .preSleepFoodAndDrinks:
            return preSleepFoodAndDrinksSummary
        case .caffeineConsumption:
            return consumptionSummary(level: viewModel.caffeineAmountLevel, timing: viewModel.caffeineTiming, notSure: viewModel.caffeineNotSure)
        case .alcoholConsumption:
            return consumptionSummary(level: viewModel.alcoholAmountLevel, timing: viewModel.alcoholTiming, notSure: viewModel.alcoholNotSure)
        case .foodConsumption:
            return consumptionSummary(level: viewModel.foodAmountLevel, timing: viewModel.foodTiming, notSure: viewModel.foodNotSure)
        case .previousDayFactors:
            return previousDayFactorsSummary
        case .acuteStressEvent:
            return presenceSummary(viewModel.acuteStressEvent)
        case .illnessOrFever:
            return presenceSummary(viewModel.illnessOrFever)
        case .travel:
            return presenceSummary(viewModel.travel)
        case .postEpisodeSleep:
            return viewModel.sleepOutcome?.titleKey.localized
        case .postEpisodeEffects:
            return postEpisodeEffectsSummary
        case .sleepOutcome:
            return viewModel.sleepOutcome?.titleKey.localized
        case .lingeringAnxiety:
            return postEpisodeAnxietySummary
        case .nextDayTiredness:
            return postEpisodeTirednessSummary
        case .coping:
            return copingSummary
        case .interpretationSummary:
            return interpretationSummary
        case .recognizedSleepParalysis:
            return presenceSummary(viewModel.recognizedSleepParalysis)
        case .supernaturalInterpretation:
            return presenceSummary(viewModel.supernaturalInterpretation)
        case .fearedDying:
            return presenceSummary(viewModel.fearedDying)
        case .otherInterpretation:
            return trimmedPreview(viewModel.otherInterpretation)
        case .note:
            return trimmedPreview(viewModel.noteText)
        case .sensitiveContext:
            return sensitiveSummary
        }
    }

    private var experiencesSummary: String? {
        guard !viewModel.selectedExperiences.isEmpty else {
            return nil
        }
        if viewModel.selectedExperiences.count == 1 {
            return viewModel.selectedExperiences[0].label
        }
        return countSummary(viewModel.selectedExperiences.count, singularKey: "detail.optionalDetails.experienceCount.singular", pluralKey: "detail.optionalDetails.experienceCount.plural")
    }

    private var copingSummary: String? {
        if let strategy = viewModel.copingStrategies.first, viewModel.copingStrategies.count == 1 {
            return strategy.titleKey.localized
        }
        if !viewModel.copingStrategies.isEmpty {
            return countSummary(viewModel.copingStrategies.count, singularKey: "detail.optionalDetails.strategyCount.singular", pluralKey: "detail.optionalDetails.strategyCount.plural")
        }
        return viewModel.copingHelpfulness?.titleKey.localized
    }

    private var interpretationSummary: String? {
        if viewModel.interpretationNotSure {
            return "detail.episodeDetails.option.notSure".localized
        }

        let items = interpretationSummaryItems
        switch items.count {
        case 0:
            return nil
        case 1:
            return items[0].title
        case 2:
            let kinds = Set(items.map(\.kind))
            if kinds == [.sleepParalysis, .supernatural] {
                return "detail.interpretation.summary.paralysisAndSupernatural".localized
            }
            if kinds == [.sleepParalysis, .serious] {
                return "detail.interpretation.summary.paralysisAndSerious".localized
            }
            if kinds == [.supernatural, .serious] {
                return "detail.interpretation.summary.supernaturalAndSerious".localized
            }
            if kinds == [.sleepParalysis, .other] {
                return "detail.interpretation.summary.paralysisAndOther".localized
            }
            if kinds == [.supernatural, .other] {
                return "detail.interpretation.summary.supernaturalAndOther".localized
            }
            if kinds == [.serious, .other] {
                return "detail.interpretation.summary.seriousAndOther".localized
            }
            return countSummary(2, singularKey: "detail.interpretation.count.singular", pluralKey: "detail.interpretation.count.plural")
        default:
            return countSummary(items.count, singularKey: "detail.interpretation.count.singular", pluralKey: "detail.interpretation.count.plural")
        }
    }

    private var sensitiveSummary: String? {
        switch viewModel.sensitiveChangeResponse {
        case .some(.yes):
            if viewModel.sensitivePrefersNotToSpecify == true {
                return "detail.sensitive.summary.unspecified".localized
            }
            if viewModel.sensitiveMedicationChange == true, viewModel.sensitiveSubstanceChange == true {
                return "detail.sensitive.summary.medicationAndSubstance".localized
            }
            if viewModel.sensitiveMedicationChange == true {
                return "detail.sensitive.summary.medication".localized
            }
            if viewModel.sensitiveSubstanceChange == true {
                return "detail.sensitive.summary.substance".localized
            }
            return "detail.sensitive.summary.registered".localized
        case .some(.no):
            return "detail.sensitive.summary.noChange".localized
        case .some(.unsure):
            return "detail.episodeDetails.option.notSure".localized
        case nil:
            if viewModel.medicationOrSubstanceChange == true ||
                trimmedPreview(viewModel.sensitiveDescription) != nil ||
                viewModel.sensitiveMedicationChange == true ||
                viewModel.sensitiveSubstanceChange == true ||
                viewModel.sensitivePrefersNotToSpecify == true {
                return "detail.sensitive.summary.registered".localized
            }
            return nil
        }
    }

    private func formattedTime(_ date: Date?) -> String? {
        guard let date else { return nil }
        let formatter = DateFormatter()
        formatter.locale = viewModel.currentLocale
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }

    private var sleepPeriodAndDurationSummary: String? {
        let sleepStart = formattedTime(viewModel.sleepStart)
        let wakeTime = formattedTime(viewModel.wakeTime)
        let duration = viewModel.estimatedSleepDuration

        if let sleepStart, let wakeTime {
            let timeRange = "\(sleepStart)–\(wakeTime)"
            if let duration {
                return "\(timeRange) · \(sleepDurationSummary(duration, compact: true))"
            }
            return timeRange
        }

        if let sleepStart {
            let summary = String(format: "detail.sleep.period.sleepStartSummary".localized, sleepStart)
            if let duration {
                return "\(summary) · \(sleepDurationSummary(duration, compact: true))"
            }
            return summary
        }

        if let wakeTime {
            let summary = String(format: "detail.sleep.period.wakeTimeSummary".localized, wakeTime)
            if let duration {
                return "\(summary) · \(sleepDurationSummary(duration, compact: true))"
            }
            return summary
        }

        if let duration {
            return sleepDurationSummary(duration, compact: false)
        }

        return nil
    }

    private var interpretationSummaryItems: [InterpretationSummaryItem] {
        [
            viewModel.recognizedSleepParalysis == true
                ? InterpretationSummaryItem(kind: .sleepParalysis, title: "detail.interpretation.summary.sleepParalysis".localized)
                : nil,
            viewModel.supernaturalInterpretation == true
                ? InterpretationSummaryItem(kind: .supernatural, title: "detail.interpretation.summary.supernatural".localized)
                : nil,
            viewModel.fearedDying == true
                ? InterpretationSummaryItem(kind: .serious, title: "detail.interpretation.summary.serious".localized)
                : nil,
            viewModel.didNotKnowWhatItWas == true
                ? InterpretationSummaryItem(kind: .unknown, title: "detail.interpretation.summary.unknown".localized)
                : nil,
            trimmedPreview(viewModel.otherInterpretation) != nil
                ? InterpretationSummaryItem(kind: .other, title: "detail.interpretation.summary.other".localized)
                : nil
        ].compactMap { $0 }
    }

    private var sleepQualitySummary: String? {
        if viewModel.sleepQualityNotSure {
            return "detail.episodeDetails.option.notSure".localized
        }
        guard let sleepQuality = viewModel.sleepQuality else {
            return nil
        }
        return sleepQualityValueKey(for: sleepQuality).localized
    }

    private var sleepDayFactorsSummary: String? {
        switch viewModel.sleepDayFactorsResponse {
        case .some(.none):
            return "detail.sleep.dayFactors.noneSummary".localized
        case .some(.unsure):
            return "detail.episodeDetails.option.notSure".localized
        case nil:
            break
        }

        let factors = sleepDayFactorSummaryKeys
        if factors.count == 1 {
            return factors[0].localized
        }
        if factors.count > 1 {
            return countSummary(factors.count, singularKey: "detail.sleep.dayFactors.count.singular", pluralKey: "detail.sleep.dayFactors.count.plural")
        }
        return nil
    }

    private var sleepEnvironmentSummary: String? {
        let conditions = [
            viewModel.noiseLevel.map(noiseValueKey),
            viewModel.lightLevel.map(lightValueKey),
            viewModel.temperatureLevel.map(temperatureValueKey)
        ].compactMap { $0 }

        if conditions.count == 1 {
            return conditions[0].localized
        }
        if conditions.count > 1 {
            return countSummary(conditions.count, singularKey: "detail.sleep.environment.count.singular", pluralKey: "detail.sleep.environment.count.plural")
        }
        return nil
    }

    private var preSleepStressSummary: String? {
        if viewModel.stressLevelNotSure {
            return "detail.episodeDetails.option.notSure".localized
        }
        guard let stressLevel = viewModel.stressLevel else {
            return nil
        }
        return preSleepStressValueKey(for: stressLevel).localized
    }

    private var preSleepActivitiesSummary: String? {
        let items = [screenUseSummaryItem, physicalActivitySummaryItem].compactMap { $0 }
        guard !items.isEmpty else {
            return nil
        }

        let relevantItems = items.filter(\.isRelevant)
        if relevantItems.count == 2 {
            if relevantItems.allSatisfy(\.isUncertain) {
                return "detail.episodeDetails.option.notSure".localized
            }
            return "detail.preSleep.activities.screenAndExercise".localized
        }
        if relevantItems.count == 1 {
            return relevantItems[0].title
        }
        if items.count > 1 {
            return "detail.preSleep.activities.none".localized
        }
        return items[0].title
    }

    private var screenUseSummaryItem: PreSleepSummaryItem? {
        let hasLevel = viewModel.screenUseLevel != nil || viewModel.screenUseLevelNotSure
        let hasTiming = viewModel.screenUseTiming != nil
        guard hasLevel || hasTiming else {
            return nil
        }

        if let level = viewModel.screenUseLevel {
            if level <= 0 {
                return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.noScreen".localized, isRelevant: false)
            }
            return PreSleepSummaryItem(title: preSleepScreenUseValueKey(for: level).localized)
        }

        if viewModel.screenUseLevelNotSure || viewModel.screenUseTiming == .notSure {
            return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.screenUncertain".localized, isRelevant: true, isUncertain: true)
        }

        guard let timing = viewModel.screenUseTiming else {
            return nil
        }
        if timing.isNearSleepForScreenUse {
            return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.screenNearSleep".localized)
        }
        return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.screenRegistered".localized)
    }

    private var physicalActivitySummaryItem: PreSleepSummaryItem? {
        let hasLevel = viewModel.physicalActivityLevel != nil || viewModel.physicalActivityLevelNotSure
        let hasTiming = viewModel.physicalActivityTiming != nil
        guard hasLevel || hasTiming else {
            return nil
        }

        if let level = viewModel.physicalActivityLevel {
            if level <= 0 {
                return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.noExercise".localized, isRelevant: false)
            }
            return PreSleepSummaryItem(title: preSleepExerciseValueKey(for: level).localized)
        }

        if viewModel.physicalActivityLevelNotSure || viewModel.physicalActivityTiming == .notSure {
            return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.exerciseUncertain".localized, isRelevant: true, isUncertain: true)
        }

        return PreSleepSummaryItem(title: "detail.preSleep.activities.summary.exerciseRegistered".localized)
    }

    private var preSleepFoodAndDrinksSummary: String? {
        let items = [
            consumptionSummaryItem(
                kind: .caffeine,
                amountLevel: viewModel.caffeineAmountLevel,
                amountNotSure: viewModel.caffeineAmountNotSure,
                timing: viewModel.caffeineTiming,
                legacyNotSure: viewModel.caffeineNotSure
            ),
            consumptionSummaryItem(
                kind: .alcohol,
                amountLevel: viewModel.alcoholAmountLevel,
                amountNotSure: viewModel.alcoholAmountNotSure,
                timing: viewModel.alcoholTiming,
                legacyNotSure: viewModel.alcoholNotSure
            ),
            consumptionSummaryItem(
                kind: .meal,
                amountLevel: viewModel.foodAmountLevel,
                amountNotSure: viewModel.foodAmountNotSure,
                timing: viewModel.foodTiming,
                legacyNotSure: viewModel.foodNotSure
            )
        ].compactMap { $0 }
        guard !items.isEmpty else {
            return nil
        }

        let relevantItems = items.filter(\.isRelevant)
        if relevantItems.isEmpty {
            if items.count == 1 {
                return items[0].title
            }
            return "detail.preSleep.foodAndDrinks.summary.none".localized
        }
        if relevantItems.count > 1, relevantItems.allSatisfy(\.isUncertain) {
            return "detail.episodeDetails.option.notSure".localized
        }
        if relevantItems.count == 1 {
            return relevantItems[0].title
        }
        if relevantItems.count == 3 {
            return countSummary(3, singularKey: "detail.preSleep.foodAndDrinks.count.singular", pluralKey: "detail.preSleep.foodAndDrinks.count.plural")
        }
        return foodAndDrinksPairSummary(for: relevantItems)
    }

    private var previousDayFactorsSummary: String? {
        switch viewModel.previousDayFactorsResponse {
        case .some(.none):
            return "detail.previousDay.factors.summary.none".localized
        case .some(.unsure):
            return "detail.episodeDetails.option.notSure".localized
        case nil:
            break
        }

        let factors = previousDayFactorSummaryKeys
        switch factors.count {
        case 0:
            return nil
        case 1:
            return factors[0].localized
        case 2:
            let factorSet = Set(factors)
            if factorSet == ["detail.previousDay.factors.summary.strongStress", "detail.previousDay.factors.summary.illnessOrFever"] {
                return "detail.previousDay.factors.summary.stressAndIllness".localized
            }
            if factorSet == ["detail.previousDay.factors.summary.strongStress", "detail.previousDay.factors.summary.travel"] {
                return "detail.previousDay.factors.summary.stressAndTravel".localized
            }
            if factorSet == ["detail.previousDay.factors.summary.illnessOrFever", "detail.previousDay.factors.summary.travel"] {
                return "detail.previousDay.factors.summary.illnessAndTravel".localized
            }
            return countSummary(2, singularKey: "detail.previousDay.factors.count.singular", pluralKey: "detail.previousDay.factors.count.plural")
        default:
            return countSummary(factors.count, singularKey: "detail.previousDay.factors.count.singular", pluralKey: "detail.previousDay.factors.count.plural")
        }
    }

    private var postEpisodeEffectsSummary: String? {
        let items = [postEpisodeAnxietySummaryItem, postEpisodeTirednessSummaryItem].compactMap { $0 }
        guard !items.isEmpty else {
            return nil
        }

        let relevantItems = items.filter(\.isRelevant)
        if relevantItems.count == 2 {
            if relevantItems.allSatisfy(\.isUncertain) {
                return "detail.episodeDetails.option.notSure".localized
            }
            if relevantItems.allSatisfy({ !$0.isUncertain }) {
                return "detail.postEpisode.effects.summary.anxietyAndTiredness".localized
            }
            return relevantItems.first { !$0.isUncertain }?.title
        }
        if relevantItems.count == 1 {
            return relevantItems[0].title
        }
        if items.count > 1 {
            return "detail.postEpisode.effects.summary.none".localized
        }
        return items[0].title
    }

    private var postEpisodeAnxietySummary: String? {
        postEpisodeAnxietySummaryItem?.title
    }

    private var postEpisodeTirednessSummary: String? {
        postEpisodeTirednessSummaryItem?.title
    }

    private var postEpisodeAnxietySummaryItem: PostEpisodeEffectSummaryItem? {
        if viewModel.lingeringAnxietyNotSure {
            return PostEpisodeEffectSummaryItem(title: "detail.postEpisode.effects.summary.anxietyUncertain".localized, isUncertain: true)
        }
        guard let level = viewModel.lingeringAnxiety else {
            return nil
        }
        if level <= 1 {
            return PostEpisodeEffectSummaryItem(title: "detail.postEpisode.effects.summary.noAnxiety".localized, isRelevant: false)
        }
        return PostEpisodeEffectSummaryItem(title: postEpisodeAnxietyValueKey(for: level).localized)
    }

    private var postEpisodeTirednessSummaryItem: PostEpisodeEffectSummaryItem? {
        if viewModel.nextDayTirednessNotSure {
            return PostEpisodeEffectSummaryItem(title: "detail.postEpisode.effects.summary.tirednessUncertain".localized, isUncertain: true)
        }
        guard let level = viewModel.nextDayTiredness else {
            return nil
        }
        if level <= 1 {
            return PostEpisodeEffectSummaryItem(title: "detail.postEpisode.effects.summary.noTiredness".localized, isRelevant: false)
        }
        return PostEpisodeEffectSummaryItem(title: postEpisodeTirednessValueKey(for: level).localized)
    }

    private func consumptionSummaryItem(
        kind: PreSleepConsumptionKind,
        amountLevel: Int?,
        amountNotSure: Bool,
        timing: PreSleepTiming?,
        legacyNotSure: Bool
    ) -> PreSleepSummaryItem? {
        let hasAmount = amountLevel != nil || amountNotSure || legacyNotSure
        let hasTiming = timing != nil || legacyNotSure
        guard hasAmount || hasTiming else {
            return nil
        }

        if let amountLevel {
            if amountLevel <= 0 {
                return PreSleepSummaryItem(title: kind.noneTitleKey.localized, kind: kind, isRelevant: false)
            }
            return PreSleepSummaryItem(title: kind.titleKey.localized, kind: kind)
        }

        if legacyNotSure || amountNotSure || timing == .notSure {
            return PreSleepSummaryItem(title: kind.uncertainTitleKey.localized, kind: kind, isRelevant: true, isUncertain: true)
        }

        if timing != nil {
            return PreSleepSummaryItem(title: kind.titleKey.localized, kind: kind)
        }
        return nil
    }

    private func levelSummary(_ level: Int?) -> String? {
        guard let level else { return nil }
        return "\(level)/5"
    }

    private func timedLevelSummary(level: Int?, timing: PreSleepTiming?) -> String? {
        [levelSummary(level), timing?.titleKey.localized]
            .compactMap { $0 }
            .joined(separator: ", ")
            .emptyAsNil
    }

    private func consumptionSummary(level: Int?, timing: PreSleepTiming?, notSure: Bool) -> String? {
        if notSure {
            return "detail.episodeDetails.option.notSure".localized
        }
        return timedLevelSummary(level: level, timing: timing)
    }

    private func presenceSummary(_ value: Bool?) -> String? {
        value == true ? "detail.optionalDetails.addedValue".localized : nil
    }

    private func trimmedPreview(_ text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return nil
        }
        if trimmed.count > 32 {
            return "\(trimmed.prefix(32))..."
        }
        return trimmed
    }

    private func countSummary(_ count: Int, singularKey: String, pluralKey: String) -> String {
        let format = (count == 1 ? singularKey : pluralKey).localized
        return String(format: format, count)
    }

    private func sleepDurationSummary(_ duration: SleepDurationEstimate, compact: Bool) -> String {
        if compact {
            return "detail.sleep.duration.\(duration.rawValue).compact".localized
        }
        return duration.titleKey.localized
    }

    private func preSleepStressValueKey(for level: Int) -> String {
        switch level {
        case ...0:
            return "detail.preSleep.stress.none"
        case 1:
            return "detail.preSleep.stress.low"
        case 2:
            return "detail.preSleep.stress.moderate"
        case 3:
            return "detail.preSleep.stress.high"
        default:
            return "detail.preSleep.stress.veryHigh"
        }
    }

    private func preSleepScreenUseValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.preSleep.activities.summary.screenLow"
        case 2:
            return "detail.preSleep.activities.summary.screenModerate"
        default:
            return "detail.preSleep.activities.summary.screenHigh"
        }
    }

    private func preSleepExerciseValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.preSleep.activities.summary.exerciseLight"
        case 2:
            return "detail.preSleep.activities.summary.exerciseModerate"
        default:
            return "detail.preSleep.activities.summary.exerciseIntense"
        }
    }

    private func foodAndDrinksPairSummary(for items: [PreSleepSummaryItem]) -> String? {
        let kinds = Set(items.compactMap(\.kind))
        if kinds == [.caffeine, .alcohol] {
            return "detail.preSleep.foodAndDrinks.summary.caffeineAndAlcohol".localized
        }
        if kinds == [.caffeine, .meal] {
            return "detail.preSleep.foodAndDrinks.summary.caffeineAndMeal".localized
        }
        if kinds == [.alcohol, .meal] {
            return "detail.preSleep.foodAndDrinks.summary.alcoholAndMeal".localized
        }
        return nil
    }

    private var sleepDayFactorSummaryKeys: [String] {
        [
            viewModel.hadNap == true ? "detail.sleep.dayFactors.summary.nap" : nil,
            viewModel.sleepDeprivation == true ? "detail.sleep.dayFactors.summary.sleepLoss" : nil,
            viewModel.irregularSchedule == true ? "detail.sleep.dayFactors.summary.irregular" : nil
        ].compactMap { $0 }
    }

    private var previousDayFactorSummaryKeys: [String] {
        [
            viewModel.acuteStressEvent == true ? "detail.previousDay.factors.summary.strongStress" : nil,
            viewModel.illnessOrFever == true ? "detail.previousDay.factors.summary.illnessOrFever" : nil,
            viewModel.travel == true ? "detail.previousDay.factors.summary.travel" : nil
        ].compactMap { $0 }
    }

    private func sleepQualityValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.sleep.quality.veryPoor"
        case 2:
            return "detail.sleep.quality.poor"
        case 3:
            return "detail.sleep.quality.regular"
        case 4:
            return "detail.sleep.quality.good"
        default:
            return "detail.sleep.quality.veryGood"
        }
    }

    private func postEpisodeAnxietyValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.postEpisode.effects.summary.noAnxiety"
        case 2:
            return "detail.postEpisode.effects.summary.anxietyMild"
        case 3:
            return "detail.postEpisode.effects.summary.anxietyModerate"
        case 4:
            return "detail.postEpisode.effects.summary.anxietyStrong"
        default:
            return "detail.postEpisode.effects.summary.anxietyVeryStrong"
        }
    }

    private func postEpisodeTirednessValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.postEpisode.effects.summary.noTiredness"
        case 2:
            return "detail.postEpisode.effects.summary.tirednessMild"
        case 3:
            return "detail.postEpisode.effects.summary.tirednessModerate"
        case 4:
            return "detail.postEpisode.effects.summary.tirednessStrong"
        default:
            return "detail.postEpisode.effects.summary.tirednessVeryStrong"
        }
    }

    private func noiseValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.sleep.environment.noise.silent"
        case 2:
            return "detail.sleep.environment.noise.low"
        case 3...4:
            return "detail.sleep.environment.noise.moderate"
        default:
            return "detail.sleep.environment.noise.high"
        }
    }

    private func lightValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.sleep.environment.light.dark"
        case 2:
            return "detail.sleep.environment.light.dim"
        case 3...4:
            return "detail.sleep.environment.light.light"
        default:
            return "detail.sleep.environment.light.veryLight"
        }
    }

    private func temperatureValueKey(for level: Int) -> String {
        switch level {
        case ...1:
            return "detail.sleep.environment.temperature.cold"
        case 2:
            return "detail.sleep.environment.temperature.pleasant"
        case 3...4:
            return "detail.sleep.environment.temperature.warm"
        default:
            return "detail.sleep.environment.temperature.hot"
        }
    }

    private func fearDistressValueKey(for level: Int) -> String {
        switch level {
        case ...0:
            return "detail.episodeDetails.intensity.none"
        case 1:
            return "detail.episodeDetails.intensity.mild"
        case 2:
            return "detail.episodeDetails.intensity.moderate"
        case 3:
            return "detail.episodeDetails.intensity.strong"
        default:
            return "detail.episodeDetails.intensity.extreme"
        }
    }

    private var nameSection: some View {
        NameSectionView(
            name: $viewModel.name,
            trackDate: $viewModel.trackDate,
            computeAutoName: { viewModel.getRecordName(for: viewModel.date) },
            characterLimit: viewModel.nameCharacterLimit
        )
    }

    private var bottomBar: some View {
        AppBottomBar {
            HStack(spacing: 12) {
                Button {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxHeight: .infinity)
                        .frame(width: AppBottomBar<EmptyView>.contentHeight)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.dormant.opacity(0.8))
                        )
                }

                Button {
                    AppLog.info(.detail, "User tapped Save for record id: \(record.id)")
                    viewModel.save(record: record, context: context)
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.bold))
                        Text("common.save")
                            .font(.subheadline).bold()
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                viewModel.canSave(for: record)
                                    ? RadialGradient(
                                        gradient: Gradient(colors: [.awake, .dormant]),
                                        center: .leading,
                                        startRadius: -30,
                                        endRadius: 200
                                    )
                                    : RadialGradient(
                                        gradient: Gradient(colors: [.gray.opacity(0.4), .gray.opacity(0.3)]),
                                        center: .leading,
                                        startRadius: -30,
                                        endRadius: 200
                                    )
                            )
                    )
                }
                .disabled(!viewModel.canSave(for: record))
            }
        }
    }
}

private struct DetailChoice: Hashable, Identifiable {
    let id: String
    let titleKey: String
}

private struct PreSleepSummaryItem {
    let title: String
    var kind: PreSleepConsumptionKind?
    var isRelevant: Bool = true
    var isUncertain: Bool = false
}

private struct PostEpisodeEffectSummaryItem {
    let title: String
    var isRelevant: Bool = true
    var isUncertain: Bool = false
}

private struct InterpretationSummaryItem {
    let kind: InterpretationSummaryKind
    let title: String
}

private enum InterpretationSummaryKind: Hashable {
    case sleepParalysis
    case supernatural
    case serious
    case unknown
    case other
}

private enum PreSleepConsumptionKind: Hashable {
    case caffeine
    case alcohol
    case meal

    var titleKey: String {
        switch self {
        case .caffeine:
            return "detail.preSleep.foodAndDrinks.summary.caffeine"
        case .alcohol:
            return "detail.preSleep.foodAndDrinks.summary.alcohol"
        case .meal:
            return "detail.preSleep.foodAndDrinks.summary.meal"
        }
    }

    var uncertainTitleKey: String {
        switch self {
        case .caffeine:
            return "detail.preSleep.foodAndDrinks.summary.caffeineUncertain"
        case .alcohol:
            return "detail.preSleep.foodAndDrinks.summary.alcoholUncertain"
        case .meal:
            return "detail.preSleep.foodAndDrinks.summary.mealUncertain"
        }
    }

    var noneTitleKey: String {
        switch self {
        case .caffeine:
            return "detail.preSleep.foodAndDrinks.summary.noCaffeine"
        case .alcohol:
            return "detail.preSleep.foodAndDrinks.summary.noAlcohol"
        case .meal:
            return "detail.preSleep.foodAndDrinks.summary.noMeal"
        }
    }
}

private struct DetailFieldEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    let section: RecordDetailSection
    @ObservedObject var viewModel: RecordDetailViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(helperKey.localized)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                editorContent

                if viewModel.hasContent(in: section) {
                    Section {
                        Button("detail.optionalDetails.removeResponse") {
                            viewModel.clearResponse(in: section)
                            dismiss()
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .id(scrollResetID)
            .navigationTitle(sheetTitleKey.localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("common.done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var scrollResetID: String {
        switch section {
        case .preSleepActivities:
            return "preSleepActivities"
        case .preSleepFoodAndDrinks:
            return "preSleepFoodAndDrinks"
        default:
            return "default"
        }
    }

    @ViewBuilder
    private var editorContent: some View {
        switch section {
        case .episodeMoment, .paralysisDuration, .bodyPosition, .fearDistress, .breathingImpact:
            Section {
                ForEach(options) { option in
                    optionRow(option)
                }
        }
        case .sleepPeriodAndDuration:
            SleepPeriodAndDurationEditor(
                locale: viewModel.currentLocale,
                defaultDate: viewModel.date,
                sleepStart: $viewModel.sleepStart,
                wakeTime: $viewModel.wakeTime,
                estimatedSleepDuration: $viewModel.estimatedSleepDuration
            )
        case .sleepStart:
            Section {
                DirectTimePicker(
                    titleKey: "detail.optional.sleepStart.field",
                    locale: viewModel.currentLocale,
                    defaultDate: viewModel.date,
                    date: $viewModel.sleepStart
                )
        }
        case .wakeTime:
            Section {
                DirectTimePicker(
                    titleKey: "detail.optional.wakeTime.field",
                    locale: viewModel.currentLocale,
                    defaultDate: viewModel.date,
                    date: $viewModel.wakeTime
                )
            }
        case .estimatedSleepDuration:
            Section {
                ChoiceList(
                    options: Array(SleepDurationEstimate.allCases),
                    optionTitleKey: \.titleKey,
                    selection: $viewModel.estimatedSleepDuration,
                    dismissAfterSelection: { dismiss() }
                )
            }
        case .experiences:
            EmptyView()
        case .sleepQuality:
            Section {
                SleepQualityEditor(
                    sleepQuality: $viewModel.sleepQuality,
                    notSure: $viewModel.sleepQualityNotSure,
                    dismissAfterSelection: { dismiss() }
                )
            }
        case .awakenings:
            Section {
                ChoiceList(
                    options: Array(Awakenings.allCases),
                    optionTitleKey: \.titleKey,
                    selection: $viewModel.awakenings,
                    dismissAfterSelection: { dismiss() }
                )
            }
        case .sleepDayFactors:
            SleepDayFactorsEditor(
                hadNap: $viewModel.hadNap,
                sleepDeprivation: $viewModel.sleepDeprivation,
                irregularSchedule: $viewModel.irregularSchedule,
                response: $viewModel.sleepDayFactorsResponse
            )
        case .hadNap, .sleepDeprivation, .irregularSchedule, .acuteStressEvent, .illnessOrFever, .travel, .recognizedSleepParalysis, .supernaturalInterpretation, .fearedDying:
            EmptyView()
                .onAppear {
                    viewModel.prepareResponseIfNeeded(in: section)
                }
        case .sleepEnvironment:
            SleepEnvironmentEditor(
                noiseLevel: $viewModel.noiseLevel,
                lightLevel: $viewModel.lightLevel,
                temperatureLevel: $viewModel.temperatureLevel
            )
        case .noiseLevel:
            Section {
                CompactLevelSlider(label: "detail.optional.noiseLevel.level", value: $viewModel.noiseLevel)
            }
        case .lightLevel:
            Section {
                CompactLevelSlider(label: "detail.optional.lightLevel.level", value: $viewModel.lightLevel)
            }
        case .temperatureLevel:
            Section {
                CompactLevelSlider(label: "detail.optional.temperatureLevel.level", value: $viewModel.temperatureLevel)
            }
        case .stressLevel:
            Section {
                PreSleepStressEditor(
                    stressLevel: $viewModel.stressLevel,
                    notSure: $viewModel.stressLevelNotSure,
                    dismissAfterSelection: { dismiss() }
                )
            }
        case .preSleepActivities:
            PreSleepActivitiesEditor(
                screenUseLevel: $viewModel.screenUseLevel,
                screenUseLevelNotSure: $viewModel.screenUseLevelNotSure,
                screenUseTiming: $viewModel.screenUseTiming,
                physicalActivityLevel: $viewModel.physicalActivityLevel,
                physicalActivityLevelNotSure: $viewModel.physicalActivityLevelNotSure,
                physicalActivityTiming: $viewModel.physicalActivityTiming
            )
        case .screenUse:
            Section {
                TimedLevelEditor(
                    levelKey: "detail.optional.screenUse.level",
                    level: $viewModel.screenUseLevel,
                    timing: $viewModel.screenUseTiming
                )
            }
        case .physicalActivity:
            Section {
                TimedLevelEditor(
                    levelKey: "detail.optional.physicalActivity.level",
                    level: $viewModel.physicalActivityLevel,
                    timing: $viewModel.physicalActivityTiming
                )
            }
        case .preSleepFoodAndDrinks:
            PreSleepFoodAndDrinksEditor(
                caffeineAmountLevel: $viewModel.caffeineAmountLevel,
                caffeineAmountNotSure: $viewModel.caffeineAmountNotSure,
                caffeineTiming: $viewModel.caffeineTiming,
                caffeineLegacyNotSure: $viewModel.caffeineNotSure,
                alcoholAmountLevel: $viewModel.alcoholAmountLevel,
                alcoholAmountNotSure: $viewModel.alcoholAmountNotSure,
                alcoholTiming: $viewModel.alcoholTiming,
                alcoholLegacyNotSure: $viewModel.alcoholNotSure,
                foodAmountLevel: $viewModel.foodAmountLevel,
                foodAmountNotSure: $viewModel.foodAmountNotSure,
                foodTiming: $viewModel.foodTiming,
                foodLegacyNotSure: $viewModel.foodNotSure
            )
        case .previousDayFactors:
            PreviousDayFactorsEditor(
                acuteStressEvent: $viewModel.acuteStressEvent,
                illnessOrFever: $viewModel.illnessOrFever,
                travel: $viewModel.travel,
                response: $viewModel.previousDayFactorsResponse
            )
        case .caffeineConsumption:
            Section {
                ConsumptionEditor(
                    amountKey: "detail.optional.caffeineConsumption.amount",
                    amountLevel: $viewModel.caffeineAmountLevel,
                    timing: $viewModel.caffeineTiming,
                    notSure: $viewModel.caffeineNotSure
                )
            }
        case .alcoholConsumption:
            Section {
                ConsumptionEditor(
                    amountKey: "detail.optional.alcoholConsumption.amount",
                    amountLevel: $viewModel.alcoholAmountLevel,
                    timing: $viewModel.alcoholTiming,
                    notSure: $viewModel.alcoholNotSure
                )
            }
        case .foodConsumption:
            Section {
                ConsumptionEditor(
                    amountKey: "detail.optional.foodConsumption.amount",
                    amountLevel: $viewModel.foodAmountLevel,
                    timing: $viewModel.foodTiming,
                    notSure: $viewModel.foodNotSure
                )
            }
        case .postEpisodeSleep:
            Section {
                ChoiceList(
                    options: Array(PostEpisodeSleepOutcome.allCases),
                    optionTitleKey: \.titleKey,
                    selection: $viewModel.sleepOutcome,
                    dismissAfterSelection: { dismiss() }
                )
            }
        case .postEpisodeEffects:
            PostEpisodeEffectsEditor(
                lingeringAnxiety: $viewModel.lingeringAnxiety,
                lingeringAnxietyNotSure: $viewModel.lingeringAnxietyNotSure,
                nextDayTiredness: $viewModel.nextDayTiredness,
                nextDayTirednessNotSure: $viewModel.nextDayTirednessNotSure
            )
        case .sleepOutcome:
            Section {
                ChoiceList(
                    options: Array(PostEpisodeSleepOutcome.allCases),
                    optionTitleKey: \.titleKey,
                    selection: $viewModel.sleepOutcome,
                    dismissAfterSelection: { dismiss() }
                )
            }
        case .lingeringAnxiety:
            Section {
                CompactLevelSlider(
                    label: "detail.optional.lingeringAnxiety.level",
                    value: $viewModel.lingeringAnxiety,
                    minimumLabel: "level.anchor.none",
                    maximumLabel: "level.anchor.high"
                )
            }
        case .nextDayTiredness:
            Section {
                CompactLevelSlider(
                    label: "detail.optional.nextDayTiredness.level",
                    value: $viewModel.nextDayTiredness,
                    minimumLabel: "level.anchor.none",
                    maximumLabel: "level.anchor.high"
                )
            }
        case .coping:
            Section {
                ForEach(CopingStrategy.allCases) { strategy in
                    Button {
                        viewModel.toggleCopingStrategy(strategy)
                    } label: {
                        HStack {
                            Text(LocalizedStringKey(strategy.titleKey))
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: viewModel.copingStrategies.contains(strategy) ? "checkmark.circle.fill" : "circle")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(viewModel.copingStrategies.contains(strategy) ? Color.awake : Color.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            } footer: {
                Text("detail.optional.coping.strategiesFooter")
            }
            Section("detail.optional.coping.helpfulness") {
                ChoiceList(
                    options: Array(Helpfulness.allCases),
                    optionTitleKey: \.titleKey,
                    selection: $viewModel.copingHelpfulness
                )
            }
        case .interpretationSummary:
            InterpretationEditor(
                recognizedSleepParalysis: $viewModel.recognizedSleepParalysis,
                supernaturalInterpretation: $viewModel.supernaturalInterpretation,
                fearedDying: $viewModel.fearedDying,
                didNotKnowWhatItWas: $viewModel.didNotKnowWhatItWas,
                otherInterpretation: $viewModel.otherInterpretation,
                notSure: $viewModel.interpretationNotSure,
                characterLimit: viewModel.shortTextCharacterLimit
            )
        case .otherInterpretation:
            Section {
                ShortTextField(
                    titleKey: "detail.optional.otherInterpretation.placeholder",
                    characterLimit: viewModel.shortTextCharacterLimit,
                    text: $viewModel.otherInterpretation
                )
            }
        case .note:
            Section {
                MultilineTextField(
                    placeholderKey: "detail.noteSection.contentLabel",
                    characterLimit: viewModel.noteCharacterLimit,
                    text: $viewModel.noteText
                )
            }
        case .sensitiveContext:
            SensitiveContextEditor(
                legacyChange: $viewModel.medicationOrSubstanceChange,
                response: $viewModel.sensitiveChangeResponse,
                medicationChange: $viewModel.sensitiveMedicationChange,
                substanceChange: $viewModel.sensitiveSubstanceChange,
                prefersNotToSpecify: $viewModel.sensitivePrefersNotToSpecify,
                description: $viewModel.sensitiveDescription,
                characterLimit: viewModel.sensitiveTextCharacterLimit
            )
        }
    }

    private func optionRow(_ option: DetailChoice) -> some View {
        let isSelected = selectedID == option.id

        return Button {
            select(option)
            dismiss()
        } label: {
            HStack {
                Text(LocalizedStringKey(option.titleKey))
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.awake)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityValue(Text(LocalizedStringKey(isSelected ? "detail.episodeDetails.selectedAccessibility" : "")))
    }

    private var sheetTitleKey: String {
        switch section {
        case .episodeMoment:
            return "detail.episodeDetails.moment.sheetTitle"
        case .paralysisDuration:
            return "detail.episodeDetails.duration.sheetTitle"
        case .bodyPosition:
            return "detail.episodeDetails.bodyPosition.sheetTitle"
        case .fearDistress:
            return "detail.episodeDetails.fearDistress.sheetTitle"
        case .breathingImpact:
            return "detail.episodeDetails.breathing.sheetTitle"
        case .previousDayFactors:
            return "detail.optionalDetails.group.previousDay"
        case .postEpisodeSleep:
            return "detail.optional.postEpisodeSleep.title"
        case .postEpisodeEffects:
            return "detail.optional.postEpisodeEffects.title"
        case .interpretationSummary:
            return "detail.optionalDetails.group.interpretation"
        default:
            return section.titleKey
        }
    }

    private var helperKey: String {
        switch section {
        case .episodeMoment:
            return "detail.episodeDetails.moment.helper"
        case .paralysisDuration:
            return "detail.episodeDetails.duration.helper"
        case .bodyPosition:
            return "detail.episodeDetails.bodyPosition.helper"
        case .fearDistress:
            return "detail.episodeDetails.fearDistress.helper"
        case .breathingImpact:
            return "detail.episodeDetails.breathing.helper"
        case .sleepPeriodAndDuration:
            return "detail.sleep.period.helper"
        case .sleepQuality:
            return "detail.sleep.quality.helper"
        case .awakenings:
            return "detail.sleep.awakenings.helper"
        case .sleepDayFactors:
            return "detail.sleep.dayFactors.helper"
        case .sleepEnvironment:
            return "detail.sleep.environment.helper"
        case .stressLevel:
            return "detail.preSleep.stress.helper"
        case .preSleepActivities:
            return "detail.preSleep.activities.helper"
        case .preSleepFoodAndDrinks:
            return "detail.preSleep.foodAndDrinks.helper"
        case .previousDayFactors:
            return "detail.previousDay.factors.helper"
        case .postEpisodeSleep:
            return "detail.postEpisode.sleep.helper"
        case .postEpisodeEffects:
            return "detail.postEpisode.effects.helper"
        case .interpretationSummary:
            return "detail.interpretation.helper"
        case .sensitiveContext:
            return "detail.sensitive.sheet.helper"
        case .hadNap, .sleepDeprivation, .irregularSchedule, .acuteStressEvent, .illnessOrFever, .travel, .recognizedSleepParalysis, .supernaturalInterpretation, .fearedDying:
            return "detail.optionalDetails.presenceHelper"
        default:
            return "detail.optionalDetails.fieldHelper"
        }
    }

    private var options: [DetailChoice] {
        switch section {
        case .episodeMoment:
            return EpisodeMoment.allCases.map { DetailChoice(id: $0.rawValue, titleKey: $0.titleKey) }
        case .paralysisDuration:
            return ParalysisDuration.currentCases.map { DetailChoice(id: "\($0.rawValue)", titleKey: $0.descriptionKey) }
        case .bodyPosition:
            return BodyPosition.allCases.map { DetailChoice(id: $0.rawValue, titleKey: $0.titleKey) }
        case .fearDistress:
            return [
                DetailChoice(id: "0", titleKey: "detail.episodeDetails.intensity.none"),
                DetailChoice(id: "1", titleKey: "detail.episodeDetails.intensity.mild"),
                DetailChoice(id: "2", titleKey: "detail.episodeDetails.intensity.moderate"),
                DetailChoice(id: "3", titleKey: "detail.episodeDetails.intensity.strong"),
                DetailChoice(id: "4", titleKey: "detail.episodeDetails.intensity.extreme"),
                DetailChoice(id: "unsure", titleKey: "detail.episodeDetails.option.notSure")
            ]
        case .breathingImpact:
            return BreathingImpact.allCases.map { DetailChoice(id: $0.rawValue, titleKey: $0.titleKey) }
        default:
            return []
        }
    }

    private var selectedID: String? {
        switch section {
        case .episodeMoment:
            return viewModel.episodeMoment?.rawValue
        case .paralysisDuration:
            guard let selectedParalysisDuration = viewModel.selectedParalysisDuration else { return nil }
            return "\(selectedParalysisDuration.rawValue)"
        case .bodyPosition:
            return viewModel.bodyPosition?.rawValue
        case .fearDistress:
            if viewModel.fearDistressNotSure {
                return "unsure"
            }
            guard let level = viewModel.fearDistressLevel else { return nil }
            return "\(min(max(level, 0), 4))"
        case .breathingImpact:
            return viewModel.breathingImpact?.rawValue
        default:
            return nil
        }
    }

    private func select(_ option: DetailChoice) {
        switch section {
        case .episodeMoment:
            viewModel.episodeMoment = EpisodeMoment(rawValue: option.id)
        case .paralysisDuration:
            if let rawValue = Int(option.id) {
                viewModel.selectedParalysisDuration = ParalysisDuration(rawValue: rawValue)
            }
        case .bodyPosition:
            viewModel.bodyPosition = BodyPosition(rawValue: option.id)
        case .fearDistress:
            if option.id == "unsure" {
                viewModel.fearDistressNotSure = true
                viewModel.fearDistressLevel = nil
            } else if let level = Int(option.id) {
                viewModel.fearDistressNotSure = false
                viewModel.fearDistressLevel = level
            }
        case .breathingImpact:
            viewModel.breathingImpact = BreathingImpact(rawValue: option.id)
        default:
            break
        }
    }
}

private struct SleepPeriodAndDurationEditor: View {
    let locale: Locale
    let defaultDate: Date
    @Binding var sleepStart: Date?
    @Binding var wakeTime: Date?
    @Binding var estimatedSleepDuration: SleepDurationEstimate?

    var body: some View {
        Section {
            OptionalTimePickerRow(
                titleKey: "detail.sleep.period.sleepStart",
                addKey: "detail.sleep.period.addTime",
                locale: locale,
                defaultDate: defaultDate,
                date: $sleepStart
            )

            OptionalTimePickerRow(
                titleKey: "detail.sleep.period.wakeTime",
                addKey: "detail.sleep.period.addTime",
                locale: locale,
                defaultDate: defaultDate,
                date: $wakeTime
            )
        }

        Section("detail.sleep.period.duration") {
            ChoiceList(
                options: Array(SleepDurationEstimate.allCases),
                optionTitleKey: \.titleKey,
                selection: $estimatedSleepDuration
            )
        }
        .onChange(of: sleepStart) {
            syncEstimatedSleepDuration()
        }
        .onChange(of: wakeTime) {
            syncEstimatedSleepDuration()
        }
    }

    private func syncEstimatedSleepDuration() {
        guard let calculatedDuration else {
            return
        }
        estimatedSleepDuration = calculatedDuration
    }

    private var calculatedDuration: SleepDurationEstimate? {
        guard let sleepStart, let wakeTime else {
            return nil
        }

        let calendar = Calendar.current
        let sleepComponents = calendar.dateComponents([.hour, .minute], from: sleepStart)
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: wakeTime)
        guard let sleepHour = sleepComponents.hour,
              let sleepMinute = sleepComponents.minute,
              let wakeHour = wakeComponents.hour,
              let wakeMinute = wakeComponents.minute else {
            return nil
        }

        let sleepMinutes = sleepHour * 60 + sleepMinute
        let wakeMinutes = wakeHour * 60 + wakeMinute
        var elapsedMinutes = wakeMinutes - sleepMinutes
        if elapsedMinutes <= 0 {
            elapsedMinutes += 24 * 60
        }

        switch elapsedMinutes {
        case ..<240:
            return .lessThanFourHours
        case ..<360:
            return .fourToSixHours
        case ..<480:
            return .sixToEightHours
        default:
            return .moreThanEightHours
        }
    }
}

private struct OptionalTimePickerRow: View {
    let titleKey: LocalizedStringKey
    let addKey: LocalizedStringKey
    let locale: Locale
    let defaultDate: Date
    @Binding var date: Date?

    var body: some View {
        if date == nil {
            Button {
                date = Date()
            } label: {
                HStack {
                    Text(titleKey)
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(addKey)
                        .foregroundStyle(Color.awake)
                }
            }
            .buttonStyle(.plain)
        } else {
            DirectTimePicker(
                titleKey: titleKey,
                locale: locale,
                defaultDate: defaultDate,
                date: $date
            )
        }
    }
}

private struct SleepQualityEditor: View {
    @Binding var sleepQuality: Int?
    @Binding var notSure: Bool
    var dismissAfterSelection: (() -> Void)?

    private let options: [SleepQualityChoice] = [
        SleepQualityChoice(id: "1", titleKey: "detail.sleep.quality.veryPoor", value: 1, isNotSure: false),
        SleepQualityChoice(id: "2", titleKey: "detail.sleep.quality.poor", value: 2, isNotSure: false),
        SleepQualityChoice(id: "3", titleKey: "detail.sleep.quality.regular", value: 3, isNotSure: false),
        SleepQualityChoice(id: "4", titleKey: "detail.sleep.quality.good", value: 4, isNotSure: false),
        SleepQualityChoice(id: "5", titleKey: "detail.sleep.quality.veryGood", value: 5, isNotSure: false),
        SleepQualityChoice(id: "unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
    ]

    var body: some View {
        ForEach(options) { option in
            Button {
                if option.isNotSure {
                    sleepQuality = nil
                    notSure = true
                } else {
                    sleepQuality = option.value
                    notSure = false
                }
                dismissAfterSelection?()
            } label: {
                HStack {
                    Text(LocalizedStringKey(option.titleKey))
                        .foregroundStyle(.primary)
                    Spacer()
                    if isSelected(option) {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.awake)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityValue(Text(LocalizedStringKey(isSelected(option) ? "detail.episodeDetails.selectedAccessibility" : "")))
        }
    }

    private func isSelected(_ option: SleepQualityChoice) -> Bool {
        if option.isNotSure {
            return notSure
        }
        return !notSure && sleepQuality == option.value
    }
}

private struct SleepQualityChoice: Hashable, Identifiable {
    let id: String
    let titleKey: String
    let value: Int?
    let isNotSure: Bool
}

private struct SleepDayFactorsEditor: View {
    @Binding var hadNap: Bool?
    @Binding var sleepDeprivation: Bool?
    @Binding var irregularSchedule: Bool?
    @Binding var response: SleepDayFactorsResponse?

    var body: some View {
        Section {
            factorRow(
                titleKey: "detail.sleep.dayFactors.nap",
                isSelected: hadNap == true
            ) {
                toggleFactor($hadNap)
            }

            factorRow(
                titleKey: "detail.sleep.dayFactors.sleepLoss",
                isSelected: sleepDeprivation == true
            ) {
                toggleFactor($sleepDeprivation)
            }

            factorRow(
                titleKey: "detail.sleep.dayFactors.irregular",
                isSelected: irregularSchedule == true
            ) {
                toggleFactor($irregularSchedule)
            }
        }

        Section {
            factorRow(
                titleKey: "detail.sleep.dayFactors.none",
                isSelected: response == SleepDayFactorsResponse.none
            ) {
                toggleExclusiveResponse(.none)
            }

            factorRow(
                titleKey: "detail.episodeDetails.option.notSure",
                isSelected: response == SleepDayFactorsResponse.unsure
            ) {
                toggleExclusiveResponse(.unsure)
            }
        }
    }

    private func toggleFactor(_ factor: Binding<Bool?>) {
        response = nil
        factor.wrappedValue = factor.wrappedValue == true ? nil : true
    }

    private func toggleExclusiveResponse(_ newResponse: SleepDayFactorsResponse) {
        hadNap = nil
        sleepDeprivation = nil
        irregularSchedule = nil
        response = response == newResponse ? nil : newResponse
    }

    private func factorRow(titleKey: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(LocalizedStringKey(titleKey))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? Color.awake : Color.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityValue(Text(LocalizedStringKey(isSelected ? "detail.episodeDetails.selectedAccessibility" : "")))
    }
}

private struct PreviousDayFactorsEditor: View {
    @Binding var acuteStressEvent: Bool?
    @Binding var illnessOrFever: Bool?
    @Binding var travel: Bool?
    @Binding var response: PreviousDayFactorsResponse?

    var body: some View {
        Section {
            factorRow(
                titleKey: "detail.previousDay.factors.strongStress",
                isSelected: acuteStressEvent == true
            ) {
                toggleFactor($acuteStressEvent)
            }

            factorRow(
                titleKey: "detail.previousDay.factors.illnessOrFever",
                isSelected: illnessOrFever == true
            ) {
                toggleFactor($illnessOrFever)
            }

            factorRow(
                titleKey: "detail.previousDay.factors.travel",
                isSelected: travel == true
            ) {
                toggleFactor($travel)
            }
        }

        Section {
            factorRow(
                titleKey: "detail.previousDay.factors.none",
                isSelected: response == PreviousDayFactorsResponse.none
            ) {
                toggleExclusiveResponse(.none)
            }

            factorRow(
                titleKey: "detail.episodeDetails.option.notSure",
                isSelected: response == PreviousDayFactorsResponse.unsure
            ) {
                toggleExclusiveResponse(.unsure)
            }
        }
    }

    private func toggleFactor(_ factor: Binding<Bool?>) {
        response = nil
        factor.wrappedValue = factor.wrappedValue == true ? nil : true
    }

    private func toggleExclusiveResponse(_ newResponse: PreviousDayFactorsResponse) {
        acuteStressEvent = nil
        illnessOrFever = nil
        travel = nil
        response = response == newResponse ? nil : newResponse
    }

    private func factorRow(titleKey: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(LocalizedStringKey(titleKey))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? Color.awake : Color.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(LocalizedStringKey(titleKey)))
        .accessibilityValue(Text(LocalizedStringKey(isSelected ? "detail.episodeDetails.selectedAccessibility" : "")))
    }
}

private struct PostEpisodeEffectsEditor: View {
    @Binding var lingeringAnxiety: Int?
    @Binding var lingeringAnxietyNotSure: Bool
    @Binding var nextDayTiredness: Int?
    @Binding var nextDayTirednessNotSure: Bool

    var body: some View {
        effectSection(
            titleKey: "detail.postEpisode.effects.anxiety.title",
            options: [
                PostEpisodeEffectChoice(id: "anxiety-none", titleKey: "detail.postEpisode.effects.anxiety.none", value: 1, isNotSure: false),
                PostEpisodeEffectChoice(id: "anxiety-mild", titleKey: "detail.postEpisode.effects.anxiety.mild", value: 2, isNotSure: false),
                PostEpisodeEffectChoice(id: "anxiety-moderate", titleKey: "detail.postEpisode.effects.anxiety.moderate", value: 3, isNotSure: false),
                PostEpisodeEffectChoice(id: "anxiety-strong", titleKey: "detail.postEpisode.effects.anxiety.strong", value: 4, isNotSure: false),
                PostEpisodeEffectChoice(id: "anxiety-veryStrong", titleKey: "detail.postEpisode.effects.anxiety.veryStrong", value: 5, isNotSure: false),
                PostEpisodeEffectChoice(id: "anxiety-unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
            ],
            value: $lingeringAnxiety,
            notSure: $lingeringAnxietyNotSure
        )

        effectSection(
            titleKey: "detail.postEpisode.effects.tiredness.title",
            options: [
                PostEpisodeEffectChoice(id: "tiredness-none", titleKey: "detail.postEpisode.effects.tiredness.none", value: 1, isNotSure: false),
                PostEpisodeEffectChoice(id: "tiredness-mild", titleKey: "detail.postEpisode.effects.tiredness.mild", value: 2, isNotSure: false),
                PostEpisodeEffectChoice(id: "tiredness-moderate", titleKey: "detail.postEpisode.effects.tiredness.moderate", value: 3, isNotSure: false),
                PostEpisodeEffectChoice(id: "tiredness-strong", titleKey: "detail.postEpisode.effects.tiredness.strong", value: 4, isNotSure: false),
                PostEpisodeEffectChoice(id: "tiredness-veryStrong", titleKey: "detail.postEpisode.effects.tiredness.veryStrong", value: 5, isNotSure: false),
                PostEpisodeEffectChoice(id: "tiredness-unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
            ],
            value: $nextDayTiredness,
            notSure: $nextDayTirednessNotSure
        )
    }

    private func effectSection(
        titleKey: String,
        options: [PostEpisodeEffectChoice],
        value: Binding<Int?>,
        notSure: Binding<Bool>
    ) -> some View {
        Section(LocalizedStringKey(titleKey)) {
            ForEach(options) { option in
                Button {
                    select(option, value: value, notSure: notSure)
                } label: {
                    HStack {
                        Text(LocalizedStringKey(option.titleKey))
                            .foregroundStyle(.primary)
                        Spacer()
                        if isSelected(option, value: value, notSure: notSure) {
                            Image(systemName: "checkmark")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.awake)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("\(titleKey.localized), \(option.titleKey.localized)"))
                .accessibilityValue(Text(LocalizedStringKey(isSelected(option, value: value, notSure: notSure) ? "detail.episodeDetails.selectedAccessibility" : "")))
            }
        }
    }

    private func select(
        _ option: PostEpisodeEffectChoice,
        value: Binding<Int?>,
        notSure: Binding<Bool>
    ) {
        if isSelected(option, value: value, notSure: notSure) {
            value.wrappedValue = nil
            notSure.wrappedValue = false
            return
        }

        if option.isNotSure {
            value.wrappedValue = nil
            notSure.wrappedValue = true
        } else {
            value.wrappedValue = option.value
            notSure.wrappedValue = false
        }
    }

    private func isSelected(
        _ option: PostEpisodeEffectChoice,
        value: Binding<Int?>,
        notSure: Binding<Bool>
    ) -> Bool {
        if option.isNotSure {
            return notSure.wrappedValue
        }
        return !notSure.wrappedValue && value.wrappedValue == option.value
    }
}

private struct PostEpisodeEffectChoice: Hashable, Identifiable {
    let id: String
    let titleKey: String
    let value: Int?
    let isNotSure: Bool
}

private struct InterpretationEditor: View {
    @Binding var recognizedSleepParalysis: Bool?
    @Binding var supernaturalInterpretation: Bool?
    @Binding var fearedDying: Bool?
    @Binding var didNotKnowWhatItWas: Bool?
    @Binding var otherInterpretation: String
    @Binding var notSure: Bool
    let characterLimit: Int

    var body: some View {
        Section {
            interpretationRow(
                titleKey: "detail.interpretation.option.recognizedSleepParalysis",
                isSelected: recognizedSleepParalysis == true
            ) {
                toggleRecognizedSleepParalysis()
            }

            interpretationRow(
                titleKey: "detail.interpretation.option.supernatural",
                isSelected: supernaturalInterpretation == true
            ) {
                toggleMainOption($supernaturalInterpretation)
            }

            interpretationRow(
                titleKey: "detail.interpretation.option.serious",
                isSelected: fearedDying == true
            ) {
                toggleMainOption($fearedDying)
            }

            interpretationRow(
                titleKey: "detail.interpretation.option.unknown",
                isSelected: didNotKnowWhatItWas == true
            ) {
                toggleDidNotKnow()
            }
        }

        Section("detail.interpretation.other.title") {
            ShortTextField(
                titleKey: "detail.interpretation.other.placeholder",
                characterLimit: characterLimit,
                text: otherInterpretationBinding
            )
            .accessibilityLabel(Text("detail.interpretation.other.title"))
        }

        Section {
            interpretationRow(
                titleKey: "detail.episodeDetails.option.notSure",
                isSelected: notSure
            ) {
                toggleNotSure()
            }
        }
    }

    private var otherInterpretationBinding: Binding<String> {
        Binding(
            get: { otherInterpretation },
            set: { newValue in
                otherInterpretation = newValue
                if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    notSure = false
                }
            }
        )
    }

    private func toggleRecognizedSleepParalysis() {
        notSure = false
        let shouldSelect = recognizedSleepParalysis != true
        recognizedSleepParalysis = shouldSelect ? true : nil
        if shouldSelect {
            didNotKnowWhatItWas = nil
        }
    }

    private func toggleDidNotKnow() {
        notSure = false
        let shouldSelect = didNotKnowWhatItWas != true
        didNotKnowWhatItWas = shouldSelect ? true : nil
        if shouldSelect {
            recognizedSleepParalysis = nil
        }
    }

    private func toggleMainOption(_ option: Binding<Bool?>) {
        notSure = false
        option.wrappedValue = option.wrappedValue == true ? nil : true
    }

    private func toggleNotSure() {
        let shouldSelect = !notSure
        recognizedSleepParalysis = nil
        supernaturalInterpretation = nil
        fearedDying = nil
        didNotKnowWhatItWas = nil
        otherInterpretation = ""
        notSure = shouldSelect
    }

    private func interpretationRow(titleKey: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(LocalizedStringKey(titleKey))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? Color.awake : Color.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(LocalizedStringKey(titleKey)))
        .accessibilityValue(Text(LocalizedStringKey(isSelected ? "detail.episodeDetails.selectedAccessibility" : "")))
    }
}

private struct SensitiveContextEditor: View {
    @Binding var legacyChange: Bool?
    @Binding var response: SensitiveChangeResponse?
    @Binding var medicationChange: Bool?
    @Binding var substanceChange: Bool?
    @Binding var prefersNotToSpecify: Bool?
    @Binding var description: String
    let characterLimit: Int

    var body: some View {
        Section("detail.sensitive.response.question") {
            sensitiveRow(
                titleKey: "detail.sensitive.response.yes",
                accessibilityGroupKey: "detail.sensitive.response.question",
                isSelected: response == .yes
            ) {
                selectResponse(.yes)
            }

            sensitiveRow(
                titleKey: "detail.sensitive.response.no",
                accessibilityGroupKey: "detail.sensitive.response.question",
                isSelected: response == .no
            ) {
                selectResponse(.no)
            }

            sensitiveRow(
                titleKey: "detail.episodeDetails.option.notSure",
                accessibilityGroupKey: "detail.sensitive.response.question",
                isSelected: response == .unsure
            ) {
                selectResponse(.unsure)
            }
        }

        if response == .yes {
            Section("detail.sensitive.changeType.title") {
                sensitiveRow(
                    titleKey: "detail.sensitive.changeType.medication",
                    accessibilityGroupKey: "detail.sensitive.changeType.title",
                    isSelected: medicationChange == true
                ) {
                    toggleMedication()
                }

                sensitiveRow(
                    titleKey: "detail.sensitive.changeType.substance",
                    accessibilityGroupKey: "detail.sensitive.changeType.title",
                    isSelected: substanceChange == true
                ) {
                    toggleSubstance()
                }

                sensitiveRow(
                    titleKey: "detail.sensitive.changeType.unspecified",
                    accessibilityGroupKey: "detail.sensitive.changeType.title",
                    isSelected: prefersNotToSpecify == true
                ) {
                    togglePrefersNotToSpecify()
                }
            }
        }

        if response == .yes || response == .unsure {
            Section("detail.sensitive.context.title") {
                MultilineTextField(
                    placeholderKey: "detail.sensitive.context.placeholder",
                    characterLimit: characterLimit,
                    text: $description
                )
                .accessibilityLabel(Text("detail.sensitive.context.title"))
            }
        }
    }

    private func selectResponse(_ newResponse: SensitiveChangeResponse) {
        response = newResponse

        switch newResponse {
        case .yes:
            legacyChange = true
        case .no:
            legacyChange = nil
            medicationChange = nil
            substanceChange = nil
            prefersNotToSpecify = nil
            description = ""
        case .unsure:
            legacyChange = nil
            medicationChange = nil
            substanceChange = nil
            prefersNotToSpecify = nil
        }
    }

    private func toggleMedication() {
        response = .yes
        legacyChange = true
        prefersNotToSpecify = nil
        medicationChange = medicationChange == true ? nil : true
    }

    private func toggleSubstance() {
        response = .yes
        legacyChange = true
        prefersNotToSpecify = nil
        substanceChange = substanceChange == true ? nil : true
    }

    private func togglePrefersNotToSpecify() {
        response = .yes
        legacyChange = true
        let shouldSelect = prefersNotToSpecify != true
        prefersNotToSpecify = shouldSelect ? true : nil
        if shouldSelect {
            medicationChange = nil
            substanceChange = nil
        }
    }

    private func sensitiveRow(
        titleKey: String,
        accessibilityGroupKey: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(LocalizedStringKey(titleKey))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? Color.awake : Color.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("\(accessibilityGroupKey.localized), \(titleKey.localized)"))
        .accessibilityValue(Text(LocalizedStringKey(isSelected ? "detail.episodeDetails.selectedAccessibility" : "")))
    }
}

private struct SleepEnvironmentEditor: View {
    @Binding var noiseLevel: Int?
    @Binding var lightLevel: Int?
    @Binding var temperatureLevel: Int?

    var body: some View {
        environmentSection(
            titleKey: "detail.sleep.environment.noise.title",
            options: [
                SleepEnvironmentChoice(value: 0, titleKey: "detail.sleep.environment.noise.silent"),
                SleepEnvironmentChoice(value: 2, titleKey: "detail.sleep.environment.noise.low"),
                SleepEnvironmentChoice(value: 4, titleKey: "detail.sleep.environment.noise.moderate"),
                SleepEnvironmentChoice(value: 5, titleKey: "detail.sleep.environment.noise.high")
            ],
            selection: $noiseLevel
        )

        environmentSection(
            titleKey: "detail.sleep.environment.light.title",
            options: [
                SleepEnvironmentChoice(value: 0, titleKey: "detail.sleep.environment.light.dark"),
                SleepEnvironmentChoice(value: 2, titleKey: "detail.sleep.environment.light.dim"),
                SleepEnvironmentChoice(value: 4, titleKey: "detail.sleep.environment.light.light"),
                SleepEnvironmentChoice(value: 5, titleKey: "detail.sleep.environment.light.veryLight")
            ],
            selection: $lightLevel
        )

        environmentSection(
            titleKey: "detail.sleep.environment.temperature.title",
            options: [
                SleepEnvironmentChoice(value: 0, titleKey: "detail.sleep.environment.temperature.cold"),
                SleepEnvironmentChoice(value: 2, titleKey: "detail.sleep.environment.temperature.pleasant"),
                SleepEnvironmentChoice(value: 4, titleKey: "detail.sleep.environment.temperature.warm"),
                SleepEnvironmentChoice(value: 5, titleKey: "detail.sleep.environment.temperature.hot")
            ],
            selection: $temperatureLevel
        )
    }

    private func environmentSection(
        titleKey: LocalizedStringKey,
        options: [SleepEnvironmentChoice],
        selection: Binding<Int?>
    ) -> some View {
        Section(titleKey) {
            ForEach(options) { option in
                Button {
                    selection.wrappedValue = isSelected(option, selection: selection) ? nil : option.value
                } label: {
                    HStack {
                        Text(LocalizedStringKey(option.titleKey))
                            .foregroundStyle(.primary)
                        Spacer()
                        if isSelected(option, selection: selection) {
                            Image(systemName: "checkmark")
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.awake)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityValue(Text(LocalizedStringKey(isSelected(option, selection: selection) ? "detail.episodeDetails.selectedAccessibility" : "")))
            }
        }
    }

    private func isSelected(_ option: SleepEnvironmentChoice, selection: Binding<Int?>) -> Bool {
        guard let value = selection.wrappedValue else {
            return false
        }
        return normalizedEnvironmentValue(value) == option.value
    }

    private func normalizedEnvironmentValue(_ value: Int) -> Int {
        switch value {
        case ...1:
            return 0
        case 2:
            return 2
        case 3...4:
            return 4
        default:
            return 5
        }
    }
}

private struct SleepEnvironmentChoice: Hashable, Identifiable {
    let value: Int
    let titleKey: String

    var id: Int { value }
}

private struct PreSleepStressEditor: View {
    @Binding var stressLevel: Int?
    @Binding var notSure: Bool
    var dismissAfterSelection: (() -> Void)?

    var body: some View {
        PreSleepLevelChoiceList(
            options: [
                PreSleepLevelChoice(id: "0", titleKey: "detail.preSleep.stress.none", value: 0, isNotSure: false),
                PreSleepLevelChoice(id: "1", titleKey: "detail.preSleep.stress.low", value: 1, isNotSure: false),
                PreSleepLevelChoice(id: "2", titleKey: "detail.preSleep.stress.moderate", value: 2, isNotSure: false),
                PreSleepLevelChoice(id: "3", titleKey: "detail.preSleep.stress.high", value: 3, isNotSure: false),
                PreSleepLevelChoice(id: "4", titleKey: "detail.preSleep.stress.veryHigh", value: 4, isNotSure: false),
                PreSleepLevelChoice(id: "unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
            ],
            level: $stressLevel,
            notSure: $notSure,
            normalizedValue: { min(max($0, 0), 4) },
            dismissAfterSelection: dismissAfterSelection
        )
    }
}

private struct PreSleepActivitiesEditor: View {
    @Binding var screenUseLevel: Int?
    @Binding var screenUseLevelNotSure: Bool
    @Binding var screenUseTiming: PreSleepTiming?
    @Binding var physicalActivityLevel: Int?
    @Binding var physicalActivityLevelNotSure: Bool
    @Binding var physicalActivityTiming: PreSleepTiming?

    var body: some View {
        compactTimedLevelSection(
            titleKey: "detail.preSleep.activities.screenUse",
            levelTitleKey: "detail.preSleep.field.intensity",
            timingTitleKey: "detail.preSleep.field.timing",
            levelOptions: [
                PreSleepLevelChoice(id: "0", titleKey: "detail.preSleep.screenUse.intensity.none", value: 0, isNotSure: false),
                PreSleepLevelChoice(id: "1", titleKey: "detail.preSleep.screenUse.intensity.low", value: 1, isNotSure: false),
                PreSleepLevelChoice(id: "2", titleKey: "detail.preSleep.screenUse.intensity.moderate", value: 2, isNotSure: false),
                PreSleepLevelChoice(id: "3", titleKey: "detail.preSleep.screenUse.intensity.high", value: 3, isNotSure: false),
                PreSleepLevelChoice(id: "unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
            ],
            timingOptions: [
                PreSleepTimingChoice(value: .untilTryingToSleep, titleKey: "detail.preSleep.timing.untilTryingToSleep", accessibilityKey: "detail.preSleep.timing.accessibility.untilTryingToSleep"),
                PreSleepTimingChoice(value: .lessThanOneHour, titleKey: "detail.preSleep.timing.lessThanOneHour", accessibilityKey: "detail.preSleep.timing.accessibility.lessThanOneHour"),
                PreSleepTimingChoice(value: .oneToTwoHours, titleKey: "detail.preSleep.timing.oneToTwoHours", accessibilityKey: "detail.preSleep.timing.accessibility.oneToTwoHours"),
                PreSleepTimingChoice(value: .moreThanTwoHours, titleKey: "detail.preSleep.timing.moreThanTwoHours", accessibilityKey: "detail.preSleep.timing.accessibility.moreThanTwoHours"),
                PreSleepTimingChoice(value: .notSure, titleKey: "detail.preSleep.timing.notSure", accessibilityKey: "detail.preSleep.timing.notSure")
            ],
            level: $screenUseLevel,
            levelNotSure: $screenUseLevelNotSure,
            timing: $screenUseTiming
        )

        compactTimedLevelSection(
            titleKey: "detail.preSleep.activities.physicalActivity",
            levelTitleKey: "detail.preSleep.field.intensity",
            timingTitleKey: "detail.preSleep.field.timing",
            levelOptions: [
                PreSleepLevelChoice(id: "0", titleKey: "detail.preSleep.physicalActivity.intensity.none", value: 0, isNotSure: false),
                PreSleepLevelChoice(id: "1", titleKey: "detail.preSleep.physicalActivity.intensity.light", value: 1, isNotSure: false),
                PreSleepLevelChoice(id: "2", titleKey: "detail.preSleep.physicalActivity.intensity.moderate", value: 2, isNotSure: false),
                PreSleepLevelChoice(id: "3", titleKey: "detail.preSleep.physicalActivity.intensity.intense", value: 3, isNotSure: false),
                PreSleepLevelChoice(id: "unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
            ],
            timingOptions: [
                PreSleepTimingChoice(value: .lessThanTwoHours, titleKey: "detail.preSleep.timing.lessThanTwoHours", accessibilityKey: "detail.preSleep.timing.accessibility.lessThanTwoHours"),
                PreSleepTimingChoice(value: .twoToSixHours, titleKey: "detail.preSleep.timing.twoToSixHours", accessibilityKey: "detail.preSleep.timing.accessibility.twoToSixHours"),
                PreSleepTimingChoice(value: .moreThanSixHours, titleKey: "detail.preSleep.timing.moreThanSixHours", accessibilityKey: "detail.preSleep.timing.accessibility.moreThanSixHours"),
                PreSleepTimingChoice(value: .notSure, titleKey: "detail.preSleep.timing.notSure", accessibilityKey: "detail.preSleep.timing.notSure")
            ],
            level: $physicalActivityLevel,
            levelNotSure: $physicalActivityLevelNotSure,
            timing: $physicalActivityTiming
        )
    }

    private func compactTimedLevelSection(
        titleKey: String,
        levelTitleKey: String,
        timingTitleKey: String,
        levelOptions: [PreSleepLevelChoice],
        timingOptions: [PreSleepTimingChoice],
        level: Binding<Int?>,
        levelNotSure: Binding<Bool>,
        timing: Binding<PreSleepTiming?>
    ) -> some View {
        Section {
            PreSleepCompactLevelPicker(
                titleKey: levelTitleKey,
                blockTitleKey: titleKey,
                options: levelOptions,
                level: level,
                notSure: levelNotSure,
                normalizedValue: { min(max($0, 0), 3) },
                onNegativeSelection: {
                    timing.wrappedValue = nil
                }
            )

            if !isNegative(level: level.wrappedValue, notSure: levelNotSure.wrappedValue) {
                PreSleepCompactTimingPicker(
                    titleKey: timingTitleKey,
                    blockTitleKey: titleKey,
                    options: timingOptions,
                    selection: timing
                )
            }
        } header: {
            Text(titleKey.localized)
        }
    }

    private func isNegative(level: Int?, notSure: Bool) -> Bool {
        level == 0 && !notSure
    }
}

private struct PreSleepFoodAndDrinksEditor: View {
    @Binding var caffeineAmountLevel: Int?
    @Binding var caffeineAmountNotSure: Bool
    @Binding var caffeineTiming: PreSleepTiming?
    @Binding var caffeineLegacyNotSure: Bool
    @Binding var alcoholAmountLevel: Int?
    @Binding var alcoholAmountNotSure: Bool
    @Binding var alcoholTiming: PreSleepTiming?
    @Binding var alcoholLegacyNotSure: Bool
    @Binding var foodAmountLevel: Int?
    @Binding var foodAmountNotSure: Bool
    @Binding var foodTiming: PreSleepTiming?
    @Binding var foodLegacyNotSure: Bool

    var body: some View {
        amountSection(
            titleKey: "detail.preSleep.foodAndDrinks.caffeine",
            amountLabelKey: "detail.preSleep.field.amount",
            valueKeys: (
                none: "detail.preSleep.caffeine.amount.none",
                low: "detail.preSleep.caffeine.amount.low",
                moderate: "detail.preSleep.caffeine.amount.moderate",
                high: "detail.preSleep.caffeine.amount.high"
            ),
            amountLevel: $caffeineAmountLevel,
            amountNotSure: $caffeineAmountNotSure,
            timing: $caffeineTiming,
            legacyNotSure: $caffeineLegacyNotSure,
            timingOptions: caffeineAndAlcoholTimingOptions
        )

        amountSection(
            titleKey: "detail.preSleep.foodAndDrinks.alcohol",
            amountLabelKey: "detail.preSleep.field.amount",
            valueKeys: (
                none: "detail.preSleep.alcohol.amount.none",
                low: "detail.preSleep.alcohol.amount.low",
                moderate: "detail.preSleep.alcohol.amount.moderate",
                high: "detail.preSleep.alcohol.amount.high"
            ),
            amountLevel: $alcoholAmountLevel,
            amountNotSure: $alcoholAmountNotSure,
            timing: $alcoholTiming,
            legacyNotSure: $alcoholLegacyNotSure,
            timingOptions: caffeineAndAlcoholTimingOptions
        )

        amountSection(
            titleKey: "detail.preSleep.foodAndDrinks.meal",
            amountLabelKey: "detail.preSleep.field.size",
            valueKeys: (
                none: "detail.preSleep.meal.size.none",
                low: "detail.preSleep.meal.size.light",
                moderate: "detail.preSleep.meal.size.moderate",
                high: "detail.preSleep.meal.size.heavy"
            ),
            amountLevel: $foodAmountLevel,
            amountNotSure: $foodAmountNotSure,
            timing: $foodTiming,
            legacyNotSure: $foodLegacyNotSure,
            timingOptions: mealTimingOptions
        )
    }

    private var caffeineAndAlcoholTimingOptions: [PreSleepTimingChoice] {
        [
            PreSleepTimingChoice(value: .lessThanTwoHours, titleKey: "detail.preSleep.timing.lessThanTwoHours", accessibilityKey: "detail.preSleep.timing.accessibility.lessThanTwoHours"),
            PreSleepTimingChoice(value: .twoToSixHours, titleKey: "detail.preSleep.timing.twoToSixHours", accessibilityKey: "detail.preSleep.timing.accessibility.twoToSixHours"),
            PreSleepTimingChoice(value: .sixToTwelveHours, titleKey: "detail.preSleep.timing.sixToTwelveHours", accessibilityKey: "detail.preSleep.timing.accessibility.sixToTwelveHours"),
            PreSleepTimingChoice(value: .moreThanTwelveHours, titleKey: "detail.preSleep.timing.moreThanTwelveHours", accessibilityKey: "detail.preSleep.timing.accessibility.moreThanTwelveHours"),
            PreSleepTimingChoice(value: .notSure, titleKey: "detail.preSleep.timing.notSure", accessibilityKey: "detail.preSleep.timing.notSure")
        ]
    }

    private var mealTimingOptions: [PreSleepTimingChoice] {
        [
            PreSleepTimingChoice(value: .lessThanOneHour, titleKey: "detail.preSleep.timing.lessThanOneHour", accessibilityKey: "detail.preSleep.timing.accessibility.lessThanOneHour"),
            PreSleepTimingChoice(value: .oneToTwoHours, titleKey: "detail.preSleep.timing.oneToTwoHours", accessibilityKey: "detail.preSleep.timing.accessibility.oneToTwoHours"),
            PreSleepTimingChoice(value: .twoToFourHours, titleKey: "detail.preSleep.timing.twoToFourHours", accessibilityKey: "detail.preSleep.timing.accessibility.twoToFourHours"),
            PreSleepTimingChoice(value: .moreThanFourHours, titleKey: "detail.preSleep.timing.moreThanFourHours", accessibilityKey: "detail.preSleep.timing.accessibility.moreThanFourHours"),
            PreSleepTimingChoice(value: .notSure, titleKey: "detail.preSleep.timing.notSure", accessibilityKey: "detail.preSleep.timing.notSure")
        ]
    }

    private func amountSection(
        titleKey: String,
        amountLabelKey: String,
        valueKeys: (none: String, low: String, moderate: String, high: String),
        amountLevel: Binding<Int?>,
        amountNotSure: Binding<Bool>,
        timing: Binding<PreSleepTiming?>,
        legacyNotSure: Binding<Bool>,
        timingOptions: [PreSleepTimingChoice]
    ) -> some View {
        Section {
            PreSleepCompactLevelPicker(
                titleKey: amountLabelKey,
                blockTitleKey: titleKey,
                options: [
                    PreSleepLevelChoice(id: "0", titleKey: valueKeys.none, value: 0, isNotSure: false),
                    PreSleepLevelChoice(id: "1", titleKey: valueKeys.low, value: 1, isNotSure: false),
                    PreSleepLevelChoice(id: "2", titleKey: valueKeys.moderate, value: 2, isNotSure: false),
                    PreSleepLevelChoice(id: "3", titleKey: valueKeys.high, value: 3, isNotSure: false),
                    PreSleepLevelChoice(id: "unsure", titleKey: "detail.episodeDetails.option.notSure", value: nil, isNotSure: true)
                ],
                level: amountLevel,
                notSure: amountNotSure,
                legacyNotSure: legacyNotSure,
                normalizedValue: { min(max($0, 0), 3) },
                onNegativeSelection: {
                    timing.wrappedValue = nil
                }
            )

            if !isNegative(amountLevel: amountLevel.wrappedValue, amountNotSure: amountNotSure.wrappedValue, legacyNotSure: legacyNotSure.wrappedValue) {
                PreSleepCompactTimingPicker(
                    titleKey: "detail.preSleep.field.timing",
                    blockTitleKey: titleKey,
                    options: timingOptions,
                    selection: timing,
                    legacyNotSure: legacyNotSure
                )
            }
        } header: {
            Text(titleKey.localized)
        }
    }

    private func isNegative(amountLevel: Int?, amountNotSure: Bool, legacyNotSure: Bool) -> Bool {
        amountLevel == 0 && !amountNotSure && !legacyNotSure
    }
}

private struct PreSleepCompactLevelPicker: View {
    let titleKey: String
    let blockTitleKey: String
    let options: [PreSleepLevelChoice]
    @Binding var level: Int?
    @Binding var notSure: Bool
    var legacyNotSure: Binding<Bool>?
    var normalizedValue: (Int) -> Int = { $0 }
    var onNegativeSelection: (() -> Void)?

    var body: some View {
        PreSleepCompactChoiceGroup(
            titleKey: titleKey,
            blockTitleKey: blockTitleKey,
            options: options.map { option in
                PreSleepCompactChoice(
                    id: option.id,
                    titleKey: option.titleKey,
                    isSelected: isSelected(option)
                )
            },
            select: select
        )
    }

    private func select(_ choice: PreSleepCompactChoice) {
        guard let option = options.first(where: { $0.id == choice.id }) else {
            return
        }

        legacyNotSure?.wrappedValue = false
        if option.isNotSure {
            level = nil
            notSure = true
            return
        }

        level = option.value
        notSure = false
        if option.value == 0 {
            onNegativeSelection?()
        }
    }

    private func isSelected(_ option: PreSleepLevelChoice) -> Bool {
        if option.isNotSure {
            return notSure || legacyNotSure?.wrappedValue == true
        }
        guard let value = level, let optionValue = option.value, !notSure, legacyNotSure?.wrappedValue != true else {
            return false
        }
        return normalizedValue(value) == optionValue
    }
}

private struct PreSleepCompactTimingPicker: View {
    let titleKey: String
    let blockTitleKey: String
    let options: [PreSleepTimingChoice]
    @Binding var selection: PreSleepTiming?
    var legacyNotSure: Binding<Bool>?

    var body: some View {
        PreSleepCompactChoiceGroup(
            titleKey: titleKey,
            blockTitleKey: blockTitleKey,
            options: options.map { option in
                PreSleepCompactChoice(
                    id: option.value.rawValue,
                    titleKey: option.titleKey,
                    accessibilityKey: option.accessibilityKey,
                    isSelected: isSelected(option)
                )
            },
            select: select
        )
    }

    private func select(_ choice: PreSleepCompactChoice) {
        guard let option = options.first(where: { $0.value.rawValue == choice.id }) else {
            return
        }

        legacyNotSure?.wrappedValue = false
        selection = option.value
    }

    private func isSelected(_ option: PreSleepTimingChoice) -> Bool {
        selection == option.value || (legacyNotSure?.wrappedValue == true && option.value == .notSure)
    }
}

private struct PreSleepCompactChoice: Hashable, Identifiable {
    let id: String
    let titleKey: String
    var accessibilityKey: String?
    let isSelected: Bool
}

private struct PreSleepChipFlowLayout: Layout {
    var spacing: CGFloat = 8
    var rowSpacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? intrinsicWidth(for: subviews)
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var width: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX > 0, currentX + size.width > maxWidth {
                currentY += rowHeight + rowSpacing
                currentX = 0
                rowHeight = 0
            }

            width = max(width, currentX + size.width)
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: proposal.width ?? width, height: currentY + rowHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX > bounds.minX, currentX + size.width > bounds.maxX {
                currentY += rowHeight + rowSpacing
                currentX = bounds.minX
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )

            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }

    private func intrinsicWidth(for subviews: Subviews) -> CGFloat {
        subviews.reduce(CGFloat.zero) { width, subview in
            width + subview.sizeThatFits(.unspecified).width + spacing
        }
    }
}

private struct PreSleepCompactChoiceGroup: View {
    let titleKey: String
    let blockTitleKey: String
    let options: [PreSleepCompactChoice]
    let select: (PreSleepCompactChoice) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(titleKey.localized)
                .font(.subheadline.weight(.semibold))

            PreSleepChipFlowLayout(spacing: 8, rowSpacing: 8) {
                ForEach(options) { option in
                    Button {
                        select(option)
                    } label: {
                        HStack(spacing: 6) {
                            if option.isSelected {
                                Image(systemName: "checkmark")
                                    .font(.caption.weight(.bold))
                            }

                            Text(option.titleKey.localized)
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .font(.subheadline)
                        .foregroundStyle(option.isSelected ? Color.awake : Color.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(option.isSelected ? Color.awake.opacity(0.16) : Color.secondary.opacity(0.08))
                        )
                        .overlay(
                            Capsule()
                                .stroke(option.isSelected ? Color.awake : Color.secondary.opacity(0.22), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(accessibilityLabel(for: option))
                    .accessibilityAddTraits(.isButton)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func accessibilityLabel(for option: PreSleepCompactChoice) -> Text {
        let selected = option.isSelected ? ", \("detail.episodeDetails.selectedAccessibility".localized)" : ""
        let optionLabel = (option.accessibilityKey ?? option.titleKey).localized
        return Text("\(blockTitleKey.localized), \(titleKey.localized), \(optionLabel)\(selected)")
    }
}

private struct PreSleepLevelChoice: Hashable, Identifiable {
    let id: String
    let titleKey: String
    let value: Int?
    let isNotSure: Bool
}

private struct PreSleepLevelChoiceList: View {
    let options: [PreSleepLevelChoice]
    @Binding var level: Int?
    @Binding var notSure: Bool
    var legacyNotSure: Binding<Bool>?
    var normalizedValue: (Int) -> Int = { $0 }
    var dismissAfterSelection: (() -> Void)?

    var body: some View {
        ForEach(options) { option in
            Button {
                legacyNotSure?.wrappedValue = false
                if option.isNotSure {
                    level = nil
                    notSure = true
                } else {
                    level = option.value
                    notSure = false
                }
                dismissAfterSelection?()
            } label: {
                HStack {
                    Text(LocalizedStringKey(option.titleKey))
                        .foregroundStyle(.primary)
                    Spacer()
                    if isSelected(option) {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.awake)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityValue(Text(LocalizedStringKey(isSelected(option) ? "detail.episodeDetails.selectedAccessibility" : "")))
        }
    }

    private func isSelected(_ option: PreSleepLevelChoice) -> Bool {
        if option.isNotSure {
            return notSure || legacyNotSure?.wrappedValue == true
        }
        guard let value = level, let optionValue = option.value, !notSure, legacyNotSure?.wrappedValue != true else {
            return false
        }
        return normalizedValue(value) == optionValue
    }
}

private struct PreSleepTimingChoice: Hashable, Identifiable {
    let value: PreSleepTiming
    let titleKey: String
    var accessibilityKey: String?

    var id: PreSleepTiming { value }
}

private struct PreSleepTimingChoiceList: View {
    let options: [PreSleepTimingChoice]
    @Binding var selection: PreSleepTiming?
    var legacyNotSure: Binding<Bool>?

    var body: some View {
        ForEach(options) { option in
            Button {
                legacyNotSure?.wrappedValue = false
                selection = option.value
            } label: {
                HStack {
                    Text(LocalizedStringKey(option.titleKey))
                        .foregroundStyle(.primary)
                    Spacer()
                    if isSelected(option) {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.awake)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityValue(Text(LocalizedStringKey(isSelected(option) ? "detail.episodeDetails.selectedAccessibility" : "")))
        }
    }

    private func isSelected(_ option: PreSleepTimingChoice) -> Bool {
        selection == option.value || (legacyNotSure?.wrappedValue == true && option.value == .notSure)
    }
}

private struct ChoiceList<Option: Hashable & Identifiable>: View {
    let options: [Option]
    let optionTitleKey: (Option) -> String
    @Binding var selection: Option?
    var dismissAfterSelection: (() -> Void)?

    var body: some View {
        ForEach(options) { option in
            Button {
                selection = option
                dismissAfterSelection?()
            } label: {
                HStack {
                    Text(LocalizedStringKey(optionTitleKey(option)))
                        .foregroundStyle(.primary)
                    Spacer()
                    if selection == option {
                        Image(systemName: "checkmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.awake)
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}

private struct DirectTimePicker: View {
    let titleKey: LocalizedStringKey
    let locale: Locale
    let defaultDate: Date
    @Binding var date: Date?

    var body: some View {
        DatePicker(
            titleKey,
            selection: dateBinding,
            displayedComponents: .hourAndMinute
        )
        .environment(\.locale, locale)
    }

    private var dateBinding: Binding<Date> {
        Binding(
            get: { date ?? defaultDate },
            set: { date = $0 }
        )
    }
}

private struct TimedLevelEditor: View {
    let levelKey: LocalizedStringKey
    @Binding var level: Int?
    @Binding var timing: PreSleepTiming?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            CompactLevelSlider(
                label: levelKey,
                value: $level,
                minimumLabel: "level.anchor.none",
                maximumLabel: "level.anchor.high"
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("detail.optional.timingBeforeSleep")
                    .font(.subheadline.weight(.semibold))
                ChoiceList(
                    options: Array(PreSleepTiming.allCases),
                    optionTitleKey: \.titleKey,
                    selection: $timing
                )
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ConsumptionEditor: View {
    let amountKey: LocalizedStringKey
    @Binding var amountLevel: Int?
    @Binding var timing: PreSleepTiming?
    @Binding var notSure: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Toggle(isOn: $notSure) {
                Text("detail.optional.consumption.notSure")
            }
            .tint(.awake)

            if !notSure {
                CompactLevelSlider(
                    label: amountKey,
                    value: $amountLevel,
                    minimumLabel: "level.anchor.none",
                    maximumLabel: "level.anchor.high"
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("detail.optional.consumption.timing")
                        .font(.subheadline.weight(.semibold))
                    ChoiceList(
                        options: Array(PreSleepTiming.allCases),
                        optionTitleKey: \.titleKey,
                        selection: $timing
                    )
                }
            }
        }
        .padding(.vertical, 4)
        .onChange(of: notSure) {
            if notSure {
                amountLevel = nil
                timing = nil
            }
        }
    }
}

private extension String {
    var emptyAsNil: String? {
        isEmpty ? nil : self
    }
}

private extension PreSleepTiming {
    var isNearSleepForScreenUse: Bool {
        switch self {
        case .untilTryingToSleep, .lessThanOneHour, .oneToTwoHours, .lessThanTwoHours:
            return true
        case .twoToSixHours, .moreThanTwoHours, .twoToFourHours, .moreThanFourHours, .moreThanSixHours, .sixToTwelveHours, .moreThanTwelveHours, .notSure:
            return false
        }
    }
}

private extension Binding where Value == Bool? {
    var defaultingToFalse: Binding<Bool> {
        Binding<Bool>(
            get: { wrappedValue == true },
            set: { wrappedValue = $0 ? true : nil }
        )
    }
}

private struct DetailSectionPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedSections: Set<RecordDetailSection>
    let sectionHasContent: (RecordDetailSection) -> Bool
    let toggleSection: (RecordDetailSection) -> Void
    let sectionsInGroup: (RecordDetailSectionGroup) -> [RecordDetailSection]
    let groups: [RecordDetailSectionGroup]
    let titleKey: String
    let introKey: String?
    let doneKey: String

    @State private var pendingRemoval: RecordDetailSection?

    var body: some View {
        NavigationStack {
            List {
                if let introKey {
                    Section {
                        Text(LocalizedStringKey(introKey))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                ForEach(groups) { group in
                    Section {
                        ForEach(sectionsInGroup(group)) { section in
                            row(for: section)
                        }
                    } header: {
                        Text(LocalizedStringKey(group.titleKey))
                    } footer: {
                        if let footerKey = group.footerKey {
                            Text(LocalizedStringKey(footerKey))
                        }
                    }
                }
            }
            .navigationTitle(LocalizedStringKey(titleKey))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(LocalizedStringKey(doneKey)) {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("detail.optionalDetails.removeAlertTitle", isPresented: removalAlertPresented) {
                Button("common.cancel", role: .cancel) {
                    pendingRemoval = nil
                }
                Button("detail.optionalDetails.removeAction", role: .destructive) {
                    if let pendingRemoval {
                        toggleSection(pendingRemoval)
                    }
                    pendingRemoval = nil
                }
            } message: {
                Text("detail.optionalDetails.removeAlertMessage")
            }
        }
    }

    private var removalAlertPresented: Binding<Bool> {
        Binding(
            get: { pendingRemoval != nil },
            set: { isPresented in
                if !isPresented {
                    pendingRemoval = nil
                }
            }
        )
    }

    private func row(for section: RecordDetailSection) -> some View {
        Button {
            handleToggle(section)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.awake)
                    .frame(width: 24)

                Text(LocalizedStringKey(section.titleKey))
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: selectedSections.contains(section) ? "checkmark.circle.fill" : "circle")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(selectedSections.contains(section) ? Color.awake : Color.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    private func handleToggle(_ section: RecordDetailSection) {
        if selectedSections.contains(section), sectionHasContent(section) {
            pendingRemoval = section
        } else {
            toggleSection(section)
        }
    }
}

extension RecordDetailView {
    private var deleteAlert: some View {
        DeleteAlertView(
            isPresented: $viewModel.showDeleteConfirmation,
            record: record
        ) {
            AppLog.info(.detail, "User confirmed deletion of record id: \(record.id)")
            viewModel.delete(record: record, context: context)
            dismiss()
        }
    }
}
