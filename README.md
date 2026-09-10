# Artifactdog's macOS setup

A reproducible Linux-style macOS rice built around AeroSpace, JankyBorders,
Ghostty, Karabiner-Elements, and the native macOS menu bar.

## Install

Prerequisite: macOS and [Homebrew](https://brew.sh). Then run one command from
the checkout:

```bash
./install.sh
```

The installer installs the required packages, backs up existing managed
configuration, copies this repository's configuration into `~/.config`, and
starts AeroSpace and JankyBorders. It also removes the old Yabai/skhd and
custom Space-indicator setup when those legacy files are present.

Afterward, follow the short manual checklist in
[POST-INSTALL.md](POST-INSTALL.md). The most important steps are granting
macOS permissions and enabling the Karabiner Hyper-key rule.

## Read next

- [HOTKEYS.md](HOTKEYS.md) — the everyday shortcut cheat sheet.
- [POST-INSTALL.md](POST-INSTALL.md) — permissions, verification, and known
  behavior.
- `config/` — the source-of-truth configuration copied by the installer.
- `Brewfile` — the Homebrew dependencies used by `install.sh`.

## Design choices

- AeroSpace provides tiling, focus, virtual workspaces, and hotkeys.
- JankyBorders provides the focused/inactive colored window outlines; it is a
  visual layer, not another window manager.
- Ghostty is transparent and uses native macOS blur.
- The native menu bar stays enabled. Native macOS Spaces are not required;
  AeroSpace workspaces avoid their system Space-switch animation.
- No SIP change is required. This setup does not use Yabai, skhd, or a custom
  menu-bar Space indicator.
- The current layout uses 12px inner/side/bottom gaps, a 7px top gap, and 7px
  borders.

AeroSpace intentionally moves inactive-workspace windows out of the active
area rather than using native Spaces. On some macOS versions a tiny corner can
remain visible; completely hiding those windows requires native Spaces and
their system-managed transition behavior.

## Useful links

- [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide)
- [AeroSpace repository](https://github.com/nikitabobko/AeroSpace)
- [JankyBorders repository](https://github.com/FelixKratz/JankyBorders)
- [Ghostty documentation](https://ghostty.org/docs)
- [Karabiner-Elements documentation](https://karabiner-elements.pqrs.org/docs/)
- [Homebrew](https://brew.sh)
