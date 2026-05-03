# AGENTS.md

## General Rules

- In this file, the human responsible for the task means the maintainer or contributor currently directing the work. It does not mean an LLM/agent, and it does not necessarily mean the original GitHub repository owner.
- **Do not run builds** (`xcodebuild`, etc.) unless the human responsible for the task explicitly requests it.
- **Do not create worktrees** unless the human responsible for the task explicitly requests it.
- **Work on the active branch** unless the human responsible for the task explicitly asks for a different branch.
- **Do not create, switch, or choose branches on your own**. If another branch is needed, wait for explicit human instructions.
- **Read `Docs/PersistenceGuidelines.md` before any work involving local persistence**. This includes tests, additions, bug fixes, refactors, migrations, SwiftData models, local storage keys, record deletion, export/sync behavior, or anything that could affect existing user data stored on-device.
- **Never put the LLM or agent name in Xcode/Swift file headers**. When adding or updating `Created by ...` comments, use the human maintainer or contributor responsible for that change, matching the existing project style.

## Commits

- Before preparing a commit, summarize the branch changes by describing product behavior, business rules, and UX decisions.
- This product/UX summary is the default standard for all commit-related responses.
- Do not focus the summary on low-level technical details unless they are necessary to explain user-facing behavior, business impact, or UX impact.
- Commit titles and messages must follow the project's commit language convention and must be imperative and scoped.
- Commit titles should stay concise, but clarity about product impact matters more than being short at all costs.
- Preserve the project's product language for user-facing copy, screen names, and domain terms.

## Pull Requests

- When the human responsible for the task asks for a pull request, create a clear title and a detailed description of what the branch changes.
- **Do not include any LLM, agent, model, tool, or provider name, signature, or prefix in pull request titles or descriptions** unless the human responsible for the task explicitly requests it. This applies to any agent in the open source workflow, not only this assistant. Avoid prefixes such as `[codex]`, `[claude]`, `[copilot]`, `[cursor]`, `[gemini]`, `[chatgpt]`, or similar.
- Pull request titles and descriptions must follow the same product/UX summary standard used for commits.
- Describe product behavior, business rules, UX decisions, and user-facing impact before implementation details.
- Keep technical details in the description only when they are necessary to explain product behavior, risk, migration impact, or review focus.
- Preserve the project's product language for user-facing copy, screen names, and domain terms.
