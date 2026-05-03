//
//  RecordDetails.swift
//  sleepprecords
//
//  Created by yury antony on 02/05/26.
//

import Foundation

struct RecordDetails: Codable, Equatable {
    static let currentVersion = 1

    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    var version: Int = currentVersion
    var note: NoteDetails?
    var episode: EpisodeDetails?
    var experiences: ExperienceDetails?
    var sleepContext: SleepContext?
    var preSleepContext: PreSleepContext?
    var previousDayContext: PreviousDayContext?
    var postEpisodeImpact: PostEpisodeImpact?
    var coping: CopingDetails?
    var interpretation: InterpretationDetails?
    var sensitiveContext: SensitiveContext?

    var pruned: RecordDetails {
        var copy = self
        copy.version = Self.currentVersion
        copy.note = note?.pruned
        copy.episode = episode?.pruned
        copy.experiences = experiences?.pruned
        copy.sleepContext = sleepContext?.pruned
        copy.preSleepContext = preSleepContext?.pruned
        copy.previousDayContext = previousDayContext?.pruned
        copy.postEpisodeImpact = postEpisodeImpact?.pruned
        copy.coping = coping?.pruned
        copy.interpretation = interpretation?.pruned
        copy.sensitiveContext = sensitiveContext?.pruned
        return copy
    }

    var isEmpty: Bool {
        note == nil &&
        episode == nil &&
        experiences == nil &&
        sleepContext == nil &&
        preSleepContext == nil &&
        previousDayContext == nil &&
        postEpisodeImpact == nil &&
        coping == nil &&
        interpretation == nil &&
        sensitiveContext == nil
    }
}
