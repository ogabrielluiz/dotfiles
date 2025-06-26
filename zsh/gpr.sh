#!/bin/bash

function gpr() {
  if [ -z "$1" ]; then
    echo "Usage: gpr <pr_number_1> <pr_number_2> ..."
    return 1
  fi

  for pr_number in "$@"; do
    pr_info=$(gh pr view $pr_number --json state,mergeCommit)
    pr_state=$(echo $pr_info | jq -r .state)
    merge_commit=$(echo $pr_info | jq -r .mergeCommit.oid)

    if [ "$pr_state" != "MERGED" ]; then
      echo "PR #$pr_number is not merged. Skipping."
      continue
    fi

    if [ -z "$merge_commit" ]; then
      echo "Could not find merge commit for PR #$pr_number. Skipping."
      continue
    fi

    git cherry-pick $merge_commit
  done
}
