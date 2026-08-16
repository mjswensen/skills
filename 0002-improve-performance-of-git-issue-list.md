---
id: 2
created: 2026-08-16
---

# Improve performance of git issue list

## Description

There is a noticable lag when listing issues, likely due to the big O problem with calculating issue statuses.

## Acceptance criteria

- [ ] Use memoization or another technique to improve big O of issue status calculation
