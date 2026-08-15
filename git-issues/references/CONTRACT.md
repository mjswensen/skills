# Git Issues Contract

This file defines the interoperable text and Git contract for the `git-issues` skill.

## Repository layout

The source worktree is a normal Git checkout. A second linked worktree is mounted inside it:

```text
repo/
├── .issues/          # worktree for refs/heads/issues; locally ignored
├── src/
├── ...
└── .git/
```

The `issues` branch has independent/orphan history and contains issue Markdown files directly at its root:

```text
0001-first-issue.md
0002-another-issue.md
...
```

The source branch does not contain `.issues/`.

## Issue identity

Each issue has a positive integer ID. Human-facing references use the plain integer, for example `42`. The trailer key supplies the issue namespace.

The filename convention is:

```text
<zero-padded-id>-<slug>.md
```

Four digits are the minimum padding, not a maximum ID size.

The issue's frontmatter contains its immutable numeric ID:

```markdown
---
id: 42
created: 2026-08-11
---

# Add dark mode

Describe the problem, desired outcome, context, and acceptance criteria here.
```

Additional frontmatter such as `priority` or `labels` is allowed. `status` is reserved and must not be stored because status is derived.

## Editing and persistence contract

The `.issues/` directory is a real linked Git worktree and acts as the editable issue workspace. Creating or editing a Markdown file does not itself create an issue-history commit.

The canonical lifecycle is:

```sh
git issue new "Add dark mode"
# edit .issues/0042-add-dark-mode.md with any editor/tool
git issue save
```

`git issue new` creates the correctly named Markdown file and initial frontmatter, then returns without invoking an editor or committing.

`git issue edit <id>` is optional convenience behavior only. It may open the file with an explicitly configured editor, but it must not commit when that editor exits. Tool interoperability must never depend on editor process behavior.

`git issue save` stages all changes in the issue worktree and creates one ordinary Git commit on the `issues` branch. Multiple created, modified, renamed, or deleted issue documents may be saved together.

Agents do not need editor integration. They may modify `.issues/*.md` directly and then run `git issue save`.

## Status semantics

Status is evaluated relative to the currently checked-out source history.

For issue `N` at source `HEAD = H`:

```text
closed  iff at least one commit reachable from H contains a recognized
        resolving trailer whose value references N

open    otherwise
```

Consequences:

- A resolving commit on the current feature branch resolves the issue from that branch's perspective immediately.
- Switching to a branch that cannot reach that commit makes the issue open again from that branch's perspective.
- Merging, rebasing, cherry-picking, or otherwise making a resolving commit reachable can change the derived status without modifying the issue document.
- The issue branch itself never stores closure state.

A commit that was later reverted is still reachable, so its resolving trailer still counts. If reverted work needs to be tracked as unresolved work, create a new issue rather than introducing a second mutable status mechanism.

## Commit-message contract

Use Git trailers in the final trailer block of a commit message.

### Reference without resolving

Canonical form:

```text
Refs: 42
```

This establishes a relationship but does not affect status.

### Resolve

Canonical form:

```text
Resolves: 42
```

This makes issue `42` closed anywhere that commit is reachable.

Only the canonical `Resolves:` trailer is recognized. Aliases such as `Fixes:` or `Closes:` are intentionally not part of the contract.

### Multiple IDs

A trailer may reference multiple comma-separated IDs:

```text
Refs: 12, 19
Resolves: 42, 47
```

Multiple trailer lines are also valid:

```text
Resolves: 42
Resolves: 47
```

Parsers should recognize only positive integer IDs in the canonical comma-separated trailer value grammar. Prefixes such as `#42` are intentionally not recognized.

### Example

```text
Add configurable application theme

Detect the system appearance and persist the user's explicit override.

Refs: 38
Resolves: 42
```

## Synchronization contract

The issue database is the ordinary Git branch:

```text
refs/heads/issues
```

To publish it:

```sh
git -C .issues push origin HEAD:refs/heads/issues
```

To update it:

```sh
git -C .issues fetch origin refs/heads/issues
git -C .issues merge --ff-only FETCH_HEAD
```

No GitHub-specific API or issue service is part of the contract.

## Portability

The Markdown files and commit trailers are the durable format. The `git-issue` helper is convenience tooling, not the data format. Any editor, shell script, AI agent, or future tool can implement this contract using ordinary Git operations and text parsing.
