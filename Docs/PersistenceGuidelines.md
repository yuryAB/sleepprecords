# Local Persistence Guidelines

Sleep Records currently treats user data as local, private, and device-owned. Any change that touches persistence must protect existing local records first and treat data movement, deletion, or schema changes as product decisions, not routine refactors.

## Current Baseline

- The app persists data locally with SwiftData.
- There is no account system, network service layer, CloudKit sync, iCloud entitlement, export flow, or remote backup behavior in the current app.
- `Record` is the primary persisted model and represents a sleep paralysis episode.
- `Record` keeps only stable episode identity and UX fields directly in SwiftData.
- Optional episode details are stored as a versioned `RecordDetails` JSON payload in `Record.detailsData`.
- `@AppStorage("hasSeenCreatorNote")` stores only the local onboarding state.
- Episode fields beyond record identity, date/time, and name are optional by product design.

## Required Impact Review

Before changing anything related to persistence, agents must document the impact in plain product terms:

- Which persisted models, fields, enums, relationships, or storage keys are affected.
- Which screens and user flows read or write the affected data.
- What happens to users who already have local records on their device.
- Whether the change preserves, transforms, hides, exports, syncs, or deletes existing data.
- Whether the change requires a SwiftData migration, a compatibility layer, or explicit maintainer approval.

Preserve existing local records by default. If a change can cause data loss, duplicate records, inaccessible records, failed launches, or silent meaning changes in stored values, treat it as high risk.

## Hard Rules

- Do not rename, remove, or change the type of persisted `@Model` properties without a migration plan.
- Do not regenerate, replace, or reinterpret persisted `Record.id` values.
- Do not change persisted enum raw values for `Experience` or `ParalysisDuration`.
- Do not change the bundle identifier, SwiftData store location, App Group, CloudKit configuration, backup behavior, export behavior, sync behavior, or analytics behavior casually.
- Do not move user data off-device without explicit user consent, clear privacy copy, and a way for the user to decline.
- Do not add notes, experiences, metrics, record names, or other sensitive user content to public logs.
- Do not delete old fields only because the current UI no longer uses them. Deprecate, migrate, and validate first.
- Do not replace `nil` optional values with artificial defaults unless the product meaning is explicitly approved.
- Do not create new `@Model` relationships just to group episode detail fields. Use versioned `Codable` structs in `RecordDetails` unless the data has its own identity or lifecycle.

## Schema Change Guidelines

Prefer additive, backward-compatible schema changes:

- Add new persisted fields as optional or with safe defaults that make sense for existing records.
- Preserve the meaning of existing values, especially stored enum cases and integer buckets.
- Use rename-preservation strategies such as `@Attribute(originalName:)` when applicable.
- Plan `VersionedSchema` and `SchemaMigrationPlan` for nontrivial SwiftData changes.
- Keep relationships optional unless there is a clear product reason to require them.
- Review `@Relationship(deleteRule: .cascade)` before changing deletion behavior or related models.
- Treat `@Model` as an entity boundary, not as a general grouping tool for fields.
- For attributes or grouped details that only exist inside an episode, prefer versioned `Codable` structs inside `RecordDetails`.
- Include a payload version when the meaning or structure of details may change over time.

When adding a new model, confirm that the `ModelContainer` schema includes everything needed for the app to read and write that model safely. When changing a relationship, validate both records that already have related data and records that do not.

## Optional Field Semantics

For episode detail fields, `nil` means the user did not provide that information or disabled that section. This matters for both UX and future data analysis.

- `detailsData == nil` means no optional episode details are stored.
- A missing nested `RecordDetails` field means that specific detail was not recorded.
- Empty `RecordDetails` groups should be pruned instead of persisted as empty containers.

Do not silently convert "not recorded" into "zero", "not sure", or another meaningful value unless the user explicitly chose that value or a migration plan defines the change.

## Privacy And Logging

Sleep paralysis records can include sensitive health-adjacent personal experiences. Persistence work must preserve local-first privacy.

- Keep records local unless a future feature explicitly asks for export, sync, backup, or dataset contribution.
- Any future data-sharing feature must be opt-in and explain what data is collected, why, where it goes, and how the user can decline.
- Logs should describe technical events without exposing user-entered content or sensitive record details.
- Debug helpers that create, delete, reset, or mutate persisted data must not be exposed in production UI.

## Verification Checklist

Before shipping any persistence change, validate with existing local data from the previous app version:

- The app launches successfully with the old local store.
- The feed still loads records.
- Sorting still works.
- Record detail opens for old records.
- Editing and saving an old record still works.
- Deleting a record still behaves intentionally and does not delete unrelated data.
- Records with empty optional fields still work.
- Records with all optional fields populated still work.
- `hasSeenCreatorNote` survives an app update.
- No new sync, export, analytics, logging, or off-device data behavior appears without explicit consent.

If tests are added in the future, prefer in-memory `ModelContainer` coverage for CRUD, optional field semantics, relationship behavior, and migration scenarios. Do not run `xcodebuild` unless a maintainer explicitly requests it.

## References

- [Preserving your app's model data across launches](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches)
- [ModelContainer](https://developer.apple.com/documentation/swiftdata/modelcontainer)
- [ModelConfiguration](https://developer.apple.com/documentation/swiftdata/modelconfiguration)
