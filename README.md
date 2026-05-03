# Sleep Records

Sleep Records is an iOS app for logging sleep paralysis episodes. It gives people a structured place to record when an episode happened, what they experienced, how long the paralysis seemed to last, and any notes that may help identify patterns over time.

The app is designed as a self-knowledge tool. It does not diagnose, treat, prevent, or cure any medical condition. Records can be useful as a personal history or as supporting context in conversations with qualified healthcare professionals.

## Project Purpose

The purpose of Sleep Records is to encourage adoption among people who experience recurring sleep paralysis episodes. People who have a single isolated episode may not need a dedicated logging tool; the app is intended for those who experience this condition repeatedly and can benefit from recording patterns over time. By making it simple and respectful to record episodes, the project aims to help as many people with recurring episodes as possible use the app and, with explicit consent in future dataset features, contribute to a broader data foundation for research and studies about sleep paralysis.

## Features

- Create sleep paralysis records with date, time, and an editable name.
- Generate default record names from the episode date and time of day.
- Organize records by month in a chronological feed.
- Sort records by ascending or descending date.
- Edit record details after creation.
- Delete records with confirmation.
- Add optional sleep start time.
- Select from a catalog of sleep paralysis experiences, including visual, auditory, bodily, emotional, and sensory experiences.
- Record estimated paralysis duration.
- Add free-form notes with a character limit.
- Add optional episode details individually, including experiences, sleep context, pre-sleep context, post-episode impact, coping, interpretation, and notes.
- Use English or Brazilian Portuguese localization based on device settings.
- Store records locally on the device with SwiftData.

## Privacy and Data

Sleep Records does not require an account and does not include a network service layer. Records are stored locally on the device through SwiftData.

The project may later include an optional dataset platform for sleep paralysis records. That future work is intended for users who choose to participate and explicitly agree to provide their information. It is not part of the current app behavior, and local records should not be shared by default.

Because records may describe sensitive personal experiences, changes to persistence, export, sync, backup, analytics, dataset contribution, or logging behavior should be reviewed carefully. Any feature that moves data off-device should be documented clearly and should require explicit user consent, including what data is collected, how it is used, and how users can decline participation.

## Requirements

- Xcode 16.2 or newer is recommended.
- iOS 18.0 or newer.
- Swift 6.
- No third-party package dependencies are currently configured.

## Getting Started

1. Clone the repository.
2. Open `sleepprecords.xcodeproj` in Xcode.
3. Select the `sleepprecords` target.
4. Choose an iOS simulator or device running iOS 18.0 or newer.
5. Build and run from Xcode.

## Project Structure

```text
sleepprecords/
  Assets.xcassets/        App icons, launch image, and color assets
  Components/             Shared SwiftUI components
  Extensions/             Small language extensions
  Features/
    Feed/                 Record list, sorting, and record creation
    Detail/               Record editing, optional sections, and deletion
    Onboard/              First-launch creator note
  Managers/               Localization and record-name helpers
  Models/                 SwiftData models and domain enums
  Services/               App logging
  Localizable.xcstrings   English and Brazilian Portuguese strings
  SleeppRecordsApp.swift  App entry point and SwiftData container
```

## Architecture

The app is organized by feature and follows an MVVM-style structure:

- Models define the persisted record data and domain options.
- Views define the SwiftUI screens and reusable UI sections.
- View models coordinate state, validation, persistence actions, and display formatting.

SwiftData is used for local persistence. The primary persisted model is `Record`; optional episode details are stored as a versioned `RecordDetails` payload.

## Localization

The app currently supports:

- English
- Brazilian Portuguese

Localized strings are managed in `sleepprecords/Localizable.xcstrings`. User-facing copy, screen names, and domain terms should stay consistent with the product language already used in the app.

## Contributing

Contributions should preserve the app's role as a local, user-controlled record of sleep paralysis episodes. When proposing changes, describe the user-facing behavior, business rules, and UX impact before implementation details.

Useful contribution areas include:

- Improving accessibility.
- Refining localization.
- Adding tests.
- Improving SwiftData migration safety.
- Clarifying health and privacy language.
- Refining record creation and editing flows.

Before changing the bundle identifier, data model, persistence behavior, or any behavior that could affect existing local records, document the migration impact and expected user outcome.

## Development Notes

- There is currently no test target configured.
- Do not commit local Xcode user state files.
- Keep generated or personal development artifacts out of version control.
- See `AGENTS.md` for repository-specific collaboration guidance for coding agents.

## License

This repository does not currently include a license file. Add a license before distributing the project as open source or accepting external contributions.
