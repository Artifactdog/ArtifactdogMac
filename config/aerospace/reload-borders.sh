#!/usr/bin/env bash
set -euo pipefail

if command -v brew >/dev/null 2>&1; then
  BREW_BIN="$(command -v brew)"
elif [ -x /opt/homebrew/bin/brew ]; then
  BREW_BIN=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
  BREW_BIN=/usr/local/bin/brew
else
  exit 1
fi

# Restart the service so it rereads ~/.config/borders/bordersrc.
"$BREW_BIN" services restart borders >/dev/null 2>&1
