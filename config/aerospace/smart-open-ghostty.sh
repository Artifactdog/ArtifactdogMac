#!/usr/bin/env bash
set -euo pipefail

if command -v aerospace >/dev/null 2>&1; then
  AEROSPACE_BIN="$(command -v aerospace)"
elif [ -x /opt/homebrew/bin/aerospace ]; then
  AEROSPACE_BIN=/opt/homebrew/bin/aerospace
elif [ -x /usr/local/bin/aerospace ]; then
  AEROSPACE_BIN=/usr/local/bin/aerospace
else
  exit 1
fi

LOCK_DIR="${TMPDIR:-/tmp}/artifactdog-aerospace-ghostty.lock"
deadline="$(($(date +%s) + 3))"

# A rapid Caps+Enter burst must not let multiple launches observe the same
# old window count. mkdir is an atomic lock on macOS filesystems.
while ! mkdir "$LOCK_DIR" 2>/dev/null; do
  if [ "$(date +%s)" -ge "$deadline" ]; then
    exit 1
  fi
  sleep 0.03
done
cleanup() {
  rmdir "$LOCK_DIR" 2>/dev/null || true
}
trap cleanup EXIT

focused_workspace="$($AEROSPACE_BIN list-workspaces --focused --format '%{workspace}' 2>/dev/null || printf '')"
workspace_window_count=0
if [ -n "$focused_workspace" ]; then
  workspace_window_count="$($AEROSPACE_BIN list-windows --workspace "$focused_workspace" --count 2>/dev/null || printf '0')"
fi
case "$workspace_window_count" in
  ''|*[!0-9]*) workspace_window_count=0 ;;
esac

if [ "$workspace_window_count" -eq 0 ]; then
  # An empty workspace has no focused node to split yet.
  /usr/bin/open -na Ghostty
elif [ "$workspace_window_count" -eq 1 ]; then
  # The first split is always left/right, even on a portrait display.
  "$AEROSPACE_BIN" split horizontal
  /usr/bin/open -na Ghostty
else
  if [ "$workspace_window_count" -eq 2 ]; then
    # Closing a nested leaf can leave a one-child container behind. Repair
    # that exact two-window state before choosing the next BSP branch.
    "$AEROSPACE_BIN" flatten-workspace-tree --workspace "$focused_workspace"
    "$AEROSPACE_BIN" layout --workspace "$focused_workspace" --root horizontal
  fi
  # Split the focused leaf across the opposite axis of its parent. This is
  # what makes left-active and right-active panes branch downward locally,
  # then alternate direction as more terminals are opened.
  "$AEROSPACE_BIN" split opposite
  /usr/bin/open -na Ghostty
fi

# Keep the lock until the new window is visible, so the next rapid launch sees
# the updated tree and chooses the next orientation instead of repeating the
# first split.
deadline="$(($(date +%s) + 3))"
while [ "$(date +%s)" -lt "$deadline" ]; do
  current_count="$($AEROSPACE_BIN list-windows --workspace "$focused_workspace" --count 2>/dev/null || printf '0')"
  case "$current_count" in
    ''|*[!0-9]*) current_count=0 ;;
  esac
  if [ "$current_count" -gt "$workspace_window_count" ]; then
    exit 0
  fi
  sleep 0.03
done
