#!/bin/ksh

# SPDX-FileCopyrightText: Copyright 2025 Todd Schulman
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

typeset -r TAP="toobuntu/radiola"

# Only run in the tap repo, not if someone copies this elsewhere
if ! [ -f "Casks/r/radiola@8.rb" ]; then
  exit 0
fi

typeset -a changed_casks
while IFS= read -r path; do
  # Only consider staged, added/modified cask files
  if [[ "$path" == Casks/*.rb ]]; then
    changed_casks+=("$path")
  fi
done < <(git diff --cached --name-only --diff-filter=ACM)

if [ ${#changed_casks[@]} -eq 0 ]; then
  exit 0
fi

print -u2 "pre-commit: checking casks:"
printf >&2 '  %s\n' "${changed_casks[@]}"

# Run style on all changed casks (Homebrew understands paths)
print -u2 "pre-commit: running brew style --cask --changed ..."
brew style --cask --changed

# Syntax check each changed cask with Ruby
print -u2 "pre-commit: running ruby -c to check syntax ..."
for cask in "${changed_casks[@]}"; do
  ruby -c "$cask"
done

# Run audit on each changed cask
print -u2 "pre-commit: running brew audit --cask --strict --online ..."
for cask in "${changed_casks[@]}"; do
  typeset cask_filename="${cask##*/}"
  brew audit --cask --strict --online --skip-style --display-filename "${TAP}/${cask_filename%.rb}"
done

print -u2 "pre-commit: all cask checks passed."

exit 0
