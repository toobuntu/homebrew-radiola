<!--
SPDX-FileCopyrightText: Copyright 2025 Todd Schulman

SPDX-License-Identifier: GPL-3.0-or-later
-->

# Contributing

This tap contains the legacy `radiola@8` cask. Because Homebrew maintains its own clone of this tap and uses metadata snapshots during uninstall, testing flight‑block changes requires a clean environment.

## Workflow

1. Edit the cask in your development clone.
1. Commit and push normally (no force-pushes to `main`).
1. Uninstall Radiola before testing.
1. Reset the Homebrew tap clone if you are testing uninstall logic or if anything behaves unexpectedly:

   ```sh
   scripts/reset-tap.ksh
   ```

1. Test install/uninstall:

   ```sh
   brew install --cask toobuntu/radiola/radiola@8
   brew uninstall --cask toobuntu/radiola/radiola@8
   ```

   `brew reinstall` uses the previous metadata snapshot, so it is not suitable for testing uninstall or `uninstall_postflight` changes.

## When to use `reset-tap.ksh`

You do not need to run the reset script for every edit. It is useful when:
- you are testing uninstall or `uninstall_postflight` behavior
- Homebrew reports merge conflicts in the tap clone
- uninstall/reinstall behavior seems inconsistent
- you want a guaranteed clean slate

If you always uninstall before testing and the tap clone is clean, the reset script is optional.

## Local testing tap

<!-- Ref https://github.com/orgs/Homebrew/discussions/4864 -->

It is a good idea to iterate without touching this tap by copying your changes to a testing tap on your local filesystem. Install/uninstall from that tap until you are ready to push changes here. Always uninstall Radiola before starting a new test cycle.

```sh
brew tap-new <user>/testing
cd "$(brew --repo <user>/testing)"
/bin/rm -rf \
  .github \
  Formula
/bin/mkdir Casks
sed -i '' \
  -e 's/formulae/casks/g' \
  -e 's/formula/cask/g' \
  -e 's/brew "<cask>"/cask "<cask>"/g' \
  README.md
```

## Style checks

```sh
brew style --cask --changed
ruby -c Casks/r/radiola@8.rb
brew audit --cask --strict --online toobuntu/radiola/radiola@8
```

## Optional: pre-commit hook

You can enable the provided pre-commit hook, which runs the style checks before each commit:

```sh
# Git resolves hook symlinks relative to .git/hooks/
cd .git/hooks/
ln -s ../../scripts/pre-commit.ksh ./pre-commit
cd ../../
```

## Metadata snapshots

Homebrew uses a metadata snapshot of the cask during uninstall. To avoid stale snapshots:

- uninstall before testing
- reset the tap clone when needed
- optionally remove the Caskroom metadata directory

See `scripts/reset-tap.ksh`.
