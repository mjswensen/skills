---
name: git-issues
description: Manage lightweight, Git-native issues stored as Markdown on an orphan `issues` branch and exposed through a `.issues/` worktree. Use when creating, reading, editing, listing, pushing, pulling, or implementing repository issues, or when commits should reference/close issues using Git trailers such as `Refs: 42` and `Resolves: 42`.
compatibility: Requires Git, a POSIX shell, and an editor. No issue service, database, or runtime dependency is required.
---

# Git Issues

Use this skill for repositories that keep issues as Markdown in a separate Git history instead of GitHub Issues, Linear, Jira, or another external tracker.

The bundled `scripts/git-issue` helper exposes the workflow as `git issue ...` when installed on `PATH`. If it is not installed, run it directly from this skill directory.

## Core model

- Store issue documents on an orphan branch named `issues`.
- Mount that branch as a linked worktree at `.issues/` in the repository root.
- Keep `.issues/` out of the source worktree using Git's local `info/exclude`; do not add tracker files to the source branch.
- Treat issue Markdown as the issue description, not as a mutable status database.
- Derive status from commits reachable from the **current `HEAD`**:
  - `open`: no reachable commit resolves the issue.
  - `closed`: a reachable commit contains a recognized resolving trailer for the issue.
- Switching branches can therefore change an issue's derived status. This is intentional: status answers “is this issue resolved from the perspective of the history I currently have checked out?”

Read [references/CONTRACT.md](references/CONTRACT.md) when you need the exact storage format, trailer grammar, or status semantics.

## Commands

Prefer the helper when available:

```sh
git issue init
git issue new "Add dark mode"
git issue list
git issue show 42
git issue edit 42
git issue save
git issue pull
git issue push
```

`git issue init` creates or attaches the `issues` branch and `.issues/` worktree. It must not switch or rewrite the user's current source branch.

`git issue new` creates a Markdown issue and returns without opening an editor or committing it.

`git issue edit` is optional editor convenience only; it opens the existing Markdown file when an editor is explicitly configured and never commits it.

`git issue save` stages all pending issue-file changes and commits them to the `issues` branch.

`git issue list` and `git issue show` derive status from the current source worktree's `HEAD`; they do not write status into issue files.

`git issue pull` and `git issue push` synchronize only the `issues` branch with the `origin` remote.

## Working an issue

When asked to implement issue `N`:

1. Run `git issue show N` and read the full issue before changing source code.
2. Implement the requested work in the current source worktree/branch.
3. If a commit is related but does not finish the issue, add the trailer:

   ```text
   Refs: N
   ```

4. When a commit completes the issue, add the canonical resolving trailer:

   ```text
   Resolves: N
   ```

5. Do not edit a `status` field or otherwise mark the Markdown issue closed. Closure is derived from reachable commit history.
6. Before reporting completion, verify `git issue show N` reports the expected status from the current `HEAD`.

For multiple issues, use comma-separated IDs:

```text
Refs: 12, 19
Resolves: 42, 47
```

Keep trailers in the commit trailer block at the end of the commit message so Git's `interpret-trailers` can parse them.

## Editing issues

Issue files are ordinary Markdown. Edit them directly when useful, including through the user's editor of choice. Preserve the issue `id` once created. Do not add a `status` field.

If the helper is unavailable but `.issues/` already exists, agents may read and edit `.issues/*.md` directly and commit those edits from the `.issues/` worktree with ordinary Git commands.

## Safety and invariants

- Never commit `.issues/` onto the source branch.
- Never infer closure from issue-file checkboxes, prose, labels, filenames, or metadata.
- Never close an issue merely because code appears to satisfy it; closure requires the commit-message contract.
- Never mutate source history solely to update issue metadata.
- Never assume `main`, `master`, or another base branch determines status. Always use the current `HEAD`.
- Do not require GitHub or any particular hosting provider; any Git remote that carries the `issues` branch is valid.
