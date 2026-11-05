---
name: quick-win
description: Implement a small issue through verification, commit, and draft pull request when the user requests an end-to-end implementation.
---

# quick-win

Take a small issue, implement it, verify it, and open a draft pull request.

## When to use

Use this skill when the user requests an end-to-end implementation of a small issue, including verification, a commit, and a draft pull request.

## Instructions

Follow repository documentation and relevant available skills throughout. Work autonomously; ask for input only when a blocker requires it.

1. Identify the issue from the user's request and check the current Git branch. Reuse the branch if it belongs to the issue. If HEAD is detached or the current branch is the default branch or belongs to unrelated work, create a new branch from an up-to-date base such as `origin/main` after a `git fetch`. Preserve unrelated local changes.
    - If Linear or another issue tracker provides a suggested branch name, use it, applying the user's usual branch prefix and repository naming conventions.
    - Otherwise, derive a short branch name from the issue's title or description, following repository naming conventions.
2. Gather enough context to understand the requirements and relevant code. Develop an implementation plan using the simplest complete solution.
3. Implement the solution.
4. Verify the changes using the repository's standard checks, such as linting, formatting, and automated tests. Fix failures introduced by your changes, and report any pre-existing failures or checks you could not run.
5. Commit the changes for this issue. Follow repository conventions, using the user's recent commit messages as style references when available. Do not include a lengthy commit message body or a "Co-authored by" line.
6. Push the branch and create a draft pull request.
    - Follow the repository's pull request template and conventions, using the user's recent pull request descriptions as style references when available.
    - Include verification results and evidence appropriate to the change, such as screenshots or videos for UI changes or measurements for performance improvements.
7. Return the draft pull request link, a brief summary of the changes, and verification results, including any unresolved limitations.
