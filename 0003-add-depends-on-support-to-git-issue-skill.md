---
id: 3
created: 2026-09-02
depends-on: [1, 2]
---

# Add depends-on support to git-issue skill

## Description

Allows for displaying the issues list in implementation order. Falls back to ascending ID for independent issues.

## Acceptance criteria

- [ ] Displays issues in implementation order
- [ ] Colorizes open/closed status
- [ ] Displays blocking issue IDs inline, colorized according to their status
