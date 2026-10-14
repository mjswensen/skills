---
name: smoke-test
description: Insert a temporary hack into the codebase for smoke-testing UI changes
---

# smoke-test

Insert a temporary hack into the code that allows the user to smoke-test the UI.

## When to use

Use this skill when the user requests a temporary hack for smoke testing a particular file or prior code change.

## Instructions

1. Locate the best area of the code for introducing a minimal hack to display the desired UI, and make the change. It is OK if the change is poor quality and would never be appropriate for real production usage.
2. Since this code is a temporary hack that will never get committed, do not write or run tests, linting, or other checks. Do not add explanatory comments or `dev` environment conditionals. Remember, this is throwaway code.
3. Output the URL where the UI code can be smoke-tested manually.
