# git-issues agent skill

A generic Agent Skill for keeping project issues as Markdown in Git, without an external issue tracker or source-working-tree clutter.

## What it does

- Stores Markdown issues on an orphan `issues` branch.
- Exposes that branch locally at `.issues/` as a linked Git worktree.
- Derives issue status entirely from commit history reachable from the current `HEAD`.
- Uses `Refs: N` and `Resolves: N` Git trailers as the source/issue relationship contract.
- Records dependencies with `depends-on: [N, ...]` frontmatter and can list blockers first.
- Synchronizes the issue branch through ordinary Git remotes.
- Requires no issue database or hosted service.

## Skill layout

```text
git-issues/
├── SKILL.md
├── README.md
├── references/
│   └── CONTRACT.md
└── scripts/
    ├── git-issue
    └── install.sh
```

The layout follows the open Agent Skills convention: `SKILL.md` is the required entry point, with optional executable helpers in `scripts/` and detailed documentation in `references/`.

## Install the helper

The skill can instruct agents to run `scripts/git-issue` directly. For a nicer human workflow, install the helper somewhere on `PATH`:

```sh
./scripts/install.sh
```

Then Git automatically resolves `git issue ...` to the `git-issue` executable:

```sh
git issue init
git issue new "Add dark mode"
git issue list  # dependency order, with blocker status at a glance
git issue show 1
```

## Data portability

The helper is not the database. The durable format is simply Markdown on `refs/heads/issues` plus Git commit trailers in source history, so the repository remains usable even if this script or skill disappears.
