# Credits

xCloud Dotfiles Settings is a rebranded personal fork of
[**ml4w-dotfiles-settings**](https://github.com/mylinuxforwork/ml4w-dotfiles-settings)
by **Stephan Raabe** ([@mylinuxforwork](https://github.com/mylinuxforwork)).

The overwhelming majority of the logic in this repository (the CLI settings menu, the
file-patching engine in `lib/utils.sh`, and the Quickshell UI in `lib/quickshell/`)
originates from that upstream project. This fork strips ML4W-specific branding,
retargets config/install paths to `xcloud-dotfiles-settings`, and switches the default
profile ID to `gg.xcloud.dotfiles` (xCloud's own) — it does not represent original
design work beyond that, plus one small correctness fix: `CustomTheme/Theme.qml`'s
`Component.onCompleted: reloadTheme()` was re-enabled (it shipped upstream commented
out, so the Quickshell UI showed hardcoded default colors until some other event
happened to trigger a theme reload).

Licensed under the GNU General Public License v3.0, same as upstream (see `LICENSE`).
Per GPLv3 section 5, this notice states that the files have been modified from the
original.

Copyright (C) 2026 Marius Kristiansen <marius@xcloud.gg> for the modifications.
Copyright (C) Stephan Raabe for the original work.

Used by [xc0sh/dotfiles](https://github.com/xc0sh/dotfiles), itself a fork of
[mylinuxforwork/dotfiles](https://github.com/mylinuxforwork/dotfiles) — see that
repository's own `CREDITS.md`.
