---
title: GitLab CI
tags:
  - "#yaml"
  - bash
  - ci/cd
  - gitlab
  - grep
---

## `grep` and capturing exit status in CI scripts
GitLab sets a bunch of shell options by default. These default options include `errexit` (aka `set -e`) and `pipefail`. The combination of these two means that if the script involves anything that returns a non-zero exit status, the pipeline fails.

