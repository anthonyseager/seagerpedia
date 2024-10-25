---
title: GitLab CI - YAML Fun
tags:
  - bash
  - ci/cd
  - gitlab
  - yaml
---
## Pipeline failing at `grep` or when capturing `$?`

### Problem
GitLab sets a bunch of shell options by default. Among these are `errexit` (aka `set -e`) and `pipefail`.  This means that if any part of your script returns a *fail* status the pipeline fails. For example:
```bash
error_count=$(grep -c "Error: " log_file)
```
If there are no matches for `"Error: "` in `log_file`, the `grep` returns an exit status of `1`, which which causes the pipeline to fail. Another, more complex example is the following:
```bash
kubectl get pods | grep "something"
if [ $? -eq 1 ]; then
  echo "couldn't find something!"
fi
```
Usually, we'd expect the if statement to be tripped if the grep fails. However, due to the shell options set by GitLab the pipeline will fail before it hits the if statement.

### Solution
If we want to ignore the exit status, like in the first case, we can simply add `|| true` like so:
```bash
error_count=$(grep -c "Error: " log_file) || true
```
If we want to store the exit status we need to put it in one line so that GitLab doesn't detect it. So for the second example:
```bash
return_code=0; kubectl get pods | grep "something" || return_code=$?
if [ $return_code -eq 1 ]; then
  echo "couldn't find something!"
fi
```
We can of course capture output simultaneously as well:
```bash
return_code=0; error_count=$(grep -c "Error: " log_file) || return_code=$?
```
