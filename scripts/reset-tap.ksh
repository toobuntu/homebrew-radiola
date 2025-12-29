#!/bin/ksh

# SPDX-FileCopyrightText: Copyright 2025 Todd Schulman
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -euo pipefail

# reset-tap.sh — Reset the Homebrew tap clone for clean testing.
#
# Homebrew maintains its own clone of a tap under:
#   "$(brew --repo "$TAP")"
#
# This script resets the tap clone to match origin/main exactly and
# optionally removes stale metadata snapshots.
#
# Homebrew’s tap clone is volatile. It can accumulate partial rebases,
# stashed changes, preimage files, conflict markers and untracked files
# created during flight‑block evaluation. These artifacts can interfere
# with uninstall/reinstall testing.
#
# Because `brew uninstall` uses a previously created metadata snapshot,
# stale state in the tap clone or Caskroom can cause confusing behavior.
# Resetting the tap clone ensures a clean, reproducible test environment.
#
# Avoid rewriting history on the live tap. Homebrew auto‑updates taps
# using `git rebase`, and rewritten history can cause conflicts in the
# tap clone, leaving merge markers in cask files and breaking uninstall
# testing. To iterate safely, use a local filesystem tap for development.
#
# Recommended workflow:
#   - Uninstall the cask before testing uninstall logic
#   - Edit the cask in a development repo on the local filesystem
#     (not in the Homebrew-managed tap clone)
#   - Run this script if testing uninstall logic or if anything behaves oddly
#   - brew install
#   - brew uninstall
#   - When satisfied, copy changes to the live repo and push normally (no force pushing)

typeset -r TAP="toobuntu/radiola"
typeset -r CASK="radiola@8"

print "==> $0 is starting..."
print "==> Resetting Homebrew tap clone for $TAP"

typeset -r TAP_DIR="$(brew --repo "$TAP")"
if [[ ! -d "$TAP_DIR/.git" ]]; then
  print -u2 "[reset-tap] Tap directory not found or not a git repo: $TAP_DIR"
  /bin/ls -lAhF "$TAP_DIR"
  exit 1
fi

print "[reset-tap] Tap directory: $TAP_DIR"
/bin/ls -lAhF "$TAP_DIR"

print "==> Aborting any in-progress rebase/merge"
git -C "$TAP_DIR" rebase --abort 2>/dev/null || true
git -C "$TAP_DIR" merge --abort 2>/dev/null || true

print "==> Fetching latest from origin"
git -C "$TAP_DIR" fetch origin

print "==> Resetting to origin/main"
git -C "$TAP_DIR" reset --hard origin/main

print "==> Cleaning untracked files and directories"
git -C "$TAP_DIR" clean -fd

# Optional: remove stale metadata
typeset -r CASKROOM="$(brew --caskroom "$TAP/$CASK" 2>/dev/null || true)"

if [[ -n "$CASKROOM" && -d "$CASKROOM" ]]; then
  print
  print "==> Metadata directory detected:"
  print "      $CASKROOM"
  printf "Remove it for a clean uninstall test? [y/N]: "
  read -r -n1 ans
  print

  case "$ans" in
    y|Y)
      print "[reset-tap] Removing metadata directory"
      /bin/rm -rf "$CASKROOM"
      ;;
    *)
      print "[reset-tap] Leaving metadata directory intact"
      ;;
  esac
else
  print "==> No Caskroom metadata directory found"
fi

print "==> Tap reset complete. You can now run:"
print "      brew install --cask $TAP/$CASK"
print "==> $0 is finished..."
