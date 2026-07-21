#!/usr/bin/env bash
# git-search: search commit history for a string
# Usage:
#   git search <text>
#   git search <text> --all-branches
#   git search <text> HEAD..1234asdf
#   git search <text> some-branch

set -euo pipefail

TEXT=""
ALL_BRANCHES=false
REF=""

for arg in "$@"; do
  case "$arg" in
    --all-branches)
      ALL_BRANCHES=true
      ;;
    -*)
      echo "Unknown flag: $arg" >&2
      exit 1
      ;;
    *)
      if [[ -z "$TEXT" ]]; then
        TEXT="$arg"
      else
        REF="$arg"
      fi
      ;;
  esac
done

if [[ -z "$TEXT" ]]; then
  echo "Usage: git search <text> [--all-branches] [<ref-or-range>]" >&2
  exit 1
fi

cmd=(git log --oneline -S"$TEXT")

if $ALL_BRANCHES; then
  cmd+=(--all)
elif [[ -n "$REF" ]]; then
  cmd+=("$REF")
fi

"${cmd[@]}"