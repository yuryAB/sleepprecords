//
//  RecordDetailSection.swift
//  sleepprecords
//
//  Created by yury antony on 14/06/25.
//

import Foundation

enum RecordDetailSectionGroup: CaseIterable, Identifiable {
    case episode
    case experiences
    case sleep
    case preSleep
    case previousDay
    case postEpisode
    case coping
    case interpretation
    case note
    case sensitive

    var id: Self { self }

    var titleKey: String {
        switch self {
        case .episode: return "detail.optionalDetails.group.episode"
        case .experiences: return "detail.optionalDetails.group.experiences"
        case .sleep: return "detail.optionalDetails.group.sleep"
        case .preSleep: return "detail.optionalDetails.group.preSleep"
        case .previousDay: return "detail.optionalDetails.group.previousDay"
        case .postEpisode: return "detail.optionalDetails.group.postEpisode"
        case .coping: return "detail.optionalDetails.group.coping"
        case .interpretation: return "detail.optionalDetails.group.interpretation"
        case .note: return "detail.optionalDetails.group.note"
        case .sensitive: return "detail.optionalDetails.group.sensitive"
        }
    }

    var footerKey: String? {
        switch self {
        case .sensitive:
            return "detail.optionalDetails.group.sensitive.footer"
        default:
            return nil
        }
    }
}

enum RecordDetailSection: CaseIterable, Hashable, Identifiable {
    case episodeMoment
    case sleepPeriodAndDuration
    case sleepStart
    case wakeTime
    case estimatedSleepDuration
    case paralysisDuration
    case bodyPosition
    case fearDistress
    case breathingImpact
    case experiences
    case sleepQuality
    case awakenings
    case sleepDayFactors
    case hadNap
    case sleepDeprivation
    case irregularSchedule
    case sleepEnvironment
    case noiseLevel
    case lightLevel
    case temperatureLevel
    case stressLevel
    case preSleepActivities
    case screenUse
    case physicalActivity
    case preSleepFoodAndDrinks
    case caffeineConsumption
    case alcoholConsumption
    case foodConsumption
    case previousDayFactors
    case acuteStressEvent
    case illnessOrFever
    case travel
    case postEpisodeSleep
    case postEpisodeEffects
    case sleepOutcome
    case lingeringAnxiety
    case nextDayTiredness
    case coping
    case interpretationSummary
    case recognizedSleepParalysis
    case supernaturalInterpretation
    case fearedDying
    case otherInterpretation
    case note
    case sensitiveContext

    var id: Self { self }

    static let episodeCases: [RecordDetailSection] = [
        .episodeMoment,
        .paralysisDuration,
        .bodyPosition,
        .fearDistress,
        .breathingImpact
    ]

    static var orderedCases: [RecordDetailSection] {
        [
            .episodeMoment,
            .paralysisDuration,
            .bodyPosition,
            .fearDistress,
            .breathingImpact,
            .experiences,
            .sleepPeriodAndDuration,
            .sleepQuality,
            .awakenings,
            .sleepDayFactors,
            .sleepEnvironment,
            .stressLevel,
            .preSleepActivities,
            .preSleepFoodAndDrinks,
            .previousDayFactors,
            .postEpisodeSleep,
            .postEpisodeEffects,
            .coping,
            .interpretationSummary,
            .note,
            .sensitiveContext
        ]
    }

    var group: RecordDetailSectionGroup {
        switch self {
        case .episodeMoment, .paralysisDuration, .bodyPosition, .fearDistress, .breathingImpact:
            return .episode
        case .experiences:
            return .experiences
        case .sleepPeriodAndDuration, .sleepStart, .wakeTime, .estimatedSleepDuration, .sleepQuality, .awakenings, .sleepDayFactors, .hadNap, .sleepDeprivation, .irregularSchedule, .sleepEnvironment, .noiseLevel, .lightLevel, .temperatureLevel:
            return .sleep
        case .stressLevel, .preSleepActivities, .screenUse, .physicalActivity, .preSleepFoodAndDrinks, .caffeineConsumption, .alcoholConsumption, .foodConsumption:
            return .preSleep
        case .previousDayFactors, .acuteStressEvent, .illnessOrFever, .travel:
            return .previousDay
        case .postEpisodeSleep, .postEpisodeEffects, .sleepOutcome, .lingeringAnxiety, .nextDayTiredness:
            return .postEpisode
        case .coping:
            return .coping
        case .interpretationSummary, .recognizedSleepParalysis, .supernaturalInterpretation, .fearedDying, .otherInterpretation:
            return .interpretation
        case .note:
            return .note
        case .sensitiveContext:
            return .sensitive
        }
    }

    var isEpisodeField: Bool {
        Self.episodeCases.contains(self)
    }

    var titleKey: String {
        switch self {
        case .episodeMoment:
            return "detail.optional.episodeMoment.title"
        case .sleepPeriodAndDuration:
            return "detail.optional.sleepPeriodAndDuration.title"
        case .sleepStart:
            return "detail.optional.sleepStart.title"
        case .wakeTime:
            return "detail.optional.wakeTime.title"
        case .estimatedSleepDuration:
            return "detail.optional.estimatedSleepDuration.title"
        case .paralysisDuration:
            return "detail.optional.paralysisDuration.title"
        case .bodyPosition:
            return "detail.optional.bodyPosition.title"
        case .fearDistress:
            return "detail.optional.fearDistress.title"
        case .breathingImpact:
            return "detail.optional.breathingImpact.title"
        case .experiences:
            return "detail.optional.experiences.title"
        case .sleepQuality:
            return "detail.optional.sleepQuality.title"
        case .awakenings:
            return "detail.optional.awakenings.title"
        case .sleepDayFactors:
            return "detail.optional.sleepDayFactors.title"
        case .hadNap:
            return "detail.optional.hadNap.title"
        case .sleepDeprivation:
            return "detail.optional.sleepDeprivation.title"
        case .irregularSchedule:
            return "detail.optional.irregularSchedule.title"
        case .sleepEnvironment:
            return "detail.optional.sleepEnvironment.title"
        case .noiseLevel:
            return "detail.optional.noiseLevel.title"
        case .lightLevel:
            return "detail.optional.lightLevel.title"
        case .temperatureLevel:
            return "detail.optional.temperatureLevel.title"
        case .stressLevel:
            return "detail.optional.stressLevel.title"
        case .preSleepActivities:
            return "detail.optional.preSleepActivities.title"
        case .screenUse:
            return "detail.optional.screenUse.title"
        case .physicalActivity:
            return "detail.optional.physicalActivity.title"
        case .preSleepFoodAndDrinks:
            return "detail.optional.preSleepFoodAndDrinks.title"
        case .caffeineConsumption:
            return "detail.optional.caffeineConsumption.title"
        case .alcoholConsumption:
            return "detail.optional.alcoholConsumption.title"
        case .foodConsumption:
            return "detail.optional.foodConsumption.title"
        case .previousDayFactors:
            return "detail.optional.previousDayFactors.title"
        case .acuteStressEvent:
            return "detail.optional.acuteStressEvent.title"
        case .illnessOrFever:
            return "detail.optional.illnessOrFever.title"
        case .travel:
            return "detail.optional.travel.title"
        case .postEpisodeSleep:
            return "detail.optional.postEpisodeSleep.title"
        case .postEpisodeEffects:
            return "detail.optional.postEpisodeEffects.title"
        case .sleepOutcome:
            return "detail.optional.sleepOutcome.title"
        case .lingeringAnxiety:
            return "detail.optional.lingeringAnxiety.title"
        case .nextDayTiredness:
            return "detail.optional.nextDayTiredness.title"
        case .coping:
            return "detail.optional.coping.title"
        case .interpretationSummary:
            return "detail.optional.interpretationSummary.title"
        case .recognizedSleepParalysis:
            return "detail.optional.recognizedSleepParalysis.title"
        case .supernaturalInterpretation:
            return "detail.optional.supernaturalInterpretation.title"
        case .fearedDying:
            return "detail.optional.fearedDying.title"
        case .otherInterpretation:
            return "detail.optional.otherInterpretation.title"
        case .note:
            return "detail.optional.note.title"
        case .sensitiveContext:
            return "detail.optional.sensitiveContext.title"
        }
    }
    
    var icon: String {
        switch self {
        case .episodeMoment:
            return "moon.zzz"
        case .sleepPeriodAndDuration:
            return "clock"
        case .sleepStart:
            return "bed.double"
        case .wakeTime:
            return "sun.max"
        case .estimatedSleepDuration:
            return "clock"
        case .paralysisDuration:
            return "hourglass"
        case .bodyPosition:
            return "figure.stand"
        case .fearDistress:
            return "heart.text.square"
        case .breathingImpact:
            return "lungs"
        case .experiences:
            return "face.smiling"
        case .sleepQuality:
            return "moon.stars"
        case .awakenings:
            return "alarm"
        case .sleepDayFactors:
            return "calendar.badge.clock"
        case .hadNap:
            return "moon.circle"
        case .sleepDeprivation:
            return "battery.25"
        case .irregularSchedule:
            return "calendar.badge.clock"
        case .sleepEnvironment:
            return "bed.double.circle"
        case .noiseLevel:
            return "waveform"
        case .lightLevel:
            return "lightbulb"
        case .temperatureLevel:
            return "thermometer.medium"
        case .stressLevel:
            return "bolt.heart"
        case .preSleepActivities:
            return "figure.walk"
        case .screenUse:
            return "iphone"
        case .physicalActivity:
            return "figure.run"
        case .preSleepFoodAndDrinks:
            return "fork.knife"
        case .caffeineConsumption:
            return "cup.and.saucer"
        case .alcoholConsumption:
            return "wineglass"
        case .foodConsumption:
            return "fork.knife"
        case .previousDayFactors:
            return "calendar.badge.clock"
        case .acuteStressEvent:
            return "exclamationmark.triangle"
        case .illnessOrFever:
            return "thermometer.medium"
        case .travel:
            return "airplane"
        case .postEpisodeSleep:
            return "bed.double.circle"
        case .postEpisodeEffects:
            return "heart.circle"
        case .sleepOutcome:
            return "bed.double.circle"
        case .lingeringAnxiety:
            return "heart.circle"
        case .nextDayTiredness:
            return "sun.horizon"
        case .coping:
            return "lifepreserver"
        case .interpretationSummary:
            return "text.bubble"
        case .recognizedSleepParalysis:
            return "lightbulb"
        case .supernaturalInterpretation:
            return "sparkles"
        case .fearedDying:
            return "heart.slash"
        case .otherInterpretation:
            return "text.bubble"
        case .note:
            return "note.text"
        case .sensitiveContext:
            return "lock.shield"
        }
    }
}
