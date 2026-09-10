#!/usr/bin/env bash
set -euo pipefail

# Launch Finder directly and open the home folder without AppleScript
# automation or application-name lookup.
/usr/bin/open -a /System/Library/CoreServices/Finder.app "$HOME"
