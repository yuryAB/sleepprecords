# AGENTS.md

## General Rules

- **Never run builds** (`xcodebuild`, etc.). The user does that manually.
- **Never create worktrees**.
- **Always work on the branch indicated by the user**.
- **Do not create, switch, or choose branches on your own**. If another branch is needed, wait for explicit instructions from the user.

## Commits

- When the user types `cap`, it means: create a commit and push it.
- Before any commit request, including `cap`, summarize the branch changes by describing product behavior, business rules, and UX decisions.
- This product/UX summary is the default standard for all commit-related responses, not a special case only for `cap`.
- Do not focus the summary on low-level technical details unless they are necessary to explain user-facing behavior, business impact, or UX impact.
- Commit titles and messages must follow the project's commit language convention and must be imperative and scoped.
- Commit titles should stay concise, but clarity about product impact matters more than being short at all costs.
- Preserve the project's product language for user-facing copy, screen names, and domain terms.
