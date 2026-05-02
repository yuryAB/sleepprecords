# AGENTS.md

## General Rules

- **Do not run builds** (`xcodebuild`, etc.) unless a maintainer explicitly requests it.
- **Do not create worktrees** unless a maintainer explicitly requests it.
- **Work on the active branch** unless a maintainer explicitly asks for a different branch.
- **Do not create, switch, or choose branches on your own**. If another branch is needed, wait for explicit maintainer instructions.
- **Read `Docs/PersistenceGuidelines.md` before any work involving local persistence**. This includes tests, additions, bug fixes, refactors, migrations, SwiftData models, local storage keys, record deletion, export/sync behavior, or anything that could affect existing user data stored on-device.

## Commits

- Before preparing a commit, summarize the branch changes by describing product behavior, business rules, and UX decisions.
- This product/UX summary is the default standard for all commit-related responses.
- Do not focus the summary on low-level technical details unless they are necessary to explain user-facing behavior, business impact, or UX impact.
- Commit titles and messages must follow the project's commit language convention and must be imperative and scoped.
- Commit titles should stay concise, but clarity about product impact matters more than being short at all costs.
- Preserve the project's product language for user-facing copy, screen names, and domain terms.
