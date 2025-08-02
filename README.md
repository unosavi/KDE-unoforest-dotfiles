# KDE Dotfiles (Plasma 6) — Setup Guide

This repository contains user-level KDE/Plasma configuration assets and custom packages. It is curated to be safe to share publicly by avoiding sensitive materials (pairing keys, tokens, caches). Follow this guide to reproduce the environment on a new machine.

Note: The current tree already includes:
- local Plasma Look-and-Feel package: local/plasma/look-and-feel/archsimpleblue
- multiple custom plasmoids under local/plasma/plasmoids/*
- theming assets like local/color-schemes/ and wallpapers under unoforest_wallpapers/
- app-specific configs: config/fastfetch/, config/ghostty/, config/spicetify/, and panel-colorizer presets
- utility script: a.sh (Wayland: toggle KWin opacity rules, switch wallpapers, sync Ghostty transparency)

If something is missing, see the "Recommended KDE files to include" section and add as needed.

## Target Environment

- KDE Plasma: 6.x
- KDE Frameworks: 6.x
- Display session: Wayland (primary), X11 fallback is fine
- Distro: Arch Linux (but steps are generic for other distros)

Record actual Plasma/Framework versions from your system and update here if necessary.

## Contents Overview

- config/
  - fastfetch/ (profiles)
  - ghostty/ (terminal config)
  - spicetify/ (Spotify theming)
  - panel-colorizer/ (panel colorizer presets)
- local/
  - color-schemes/ (KDE color schemes)
  - plasma/
    - look-and-feel/archsimpleblue (custom Look-and-Feel package)
    - plasmoids/
      - 12menu (custom launcher)
      - KdeControlStation (control center)
      - luisbocanegra.panel.colorizer (panel colorizer)
      - luisbocanegra.panelspacer.extended (panel spacer)
      - org.dhruv8sh.kara (kara widget)
- symbol/ (symbols/icons if used)
- unoforest_wallpapers/ (wallpapers)
- a.sh (Wayland utility to toggle window opacity and wallpaper, and sync Ghostty)

## What’s Not Here (By Design)

Do NOT store these in the repo:
- Secrets/tokens/keys (e.g., kdeconnect private keys)
- Session state, caches, lock files
- Recently used files history
- Machine-local hardware/monitor geometry caches (e.g., KScreen with serials), unless you really need deterministic screen layout

## Recommended KDE files to include

To fully reproduce a KDE desktop, consider tracking these files from $HOME (review before adding):

Core Plasma and Shell
- ~/.config/kdeglobals           — global appearance (colors, icons, fonts, locale)
- ~/.config/plasmarc             — Plasma shell settings
- ~/.config/ksmserverrc          — session manager
- ~/.config/plasma-org.kde.plasma.desktop-appletsrc — panel and widget layout
- ~/.config/kwinrc               — KWin (window manager), Wayland gestures/effects
- ~/.config/kwinrulesrc          — KWin window rules
- ~/.local/share/kscreen/*.json  — monitor layouts (optional; machine-specific)

Input, Shortcuts, Fonts
- ~/.config/kglobalshortcutsrc   — global shortcuts
- ~/.config/khotkeysrc           — advanced hotkeys
- ~/.config/kxkbrc               — keyboard layouts
- ~/.config/kcminputrc           — mouse/touchpad/cursor
- ~/.config/kcmfonts             — font settings
- ~/.config/fontconfig/*.conf    — fontconfig overrides

Power and Locale
- ~/.config/powermanagementprofilesrc
- ~/.config/plasma-localerc      — locale/format overrides

Autostart & User Services
- ~/.config/autostart/*.desktop
- ~/.config/systemd/user/*.service, *.timer
- ~/.config/plasma-workspace/env/*.sh or ~/.config/environment.d/*.conf

KDE Applications (optional but useful)
- Dolphin: ~/.config/dolphinrc and ~/.local/share/dolphin/view_properties/global/.directory
- Spectacle: ~/.config/spectaclerc
- Kate: ~/.config/katerc, ~/.config/kateprojectsrc
- Okular: ~/.config/okularpartrc
- Gwenview: ~/.config/gwenviewrc
- Konsole (if used): ~/.config/konsolerc, ~/.local/share/konsole/*.profile

GTK Consistency (optional)
- ~/.config/gtk-3.0/settings.ini
- ~/.config/gtk-4.0/settings.ini
- Corresponding GTK themes/icons

Input Method (if used)
- ~/.config/fcitx5/* (config, profile, addon.conf)

## Sensitive Patterns to Exclude

When versioning dotfiles, exclude the following:
- kdeconnect keys: ~/.config/kdeconnect/privateKey.pem, device-specific directories
- any *.mo compiled translation binaries inside plasmoid contents/locale/
- cache/state: ~/.cache/**, ~/.local/state/**, plasma shell caches
- recent files lists: ~/.local/share/RecentDocuments/**

Add a .gitignore with these patterns if not already present.

## Install Guide

This guide assumes the repository is cloned into a workspace directory and you want to deploy to your $HOME. If you prefer a symlink-managed dotfiles setup, switch to the "Symlink mode" below.

Prerequisites
- Plasma 6 desktop session installed
- Optional: plasma-sdk (for plasmoidviewer), spicetify, fastfetch, ghostty
- Arch Linux users can install via pacman/aur as needed

Assets Deployment
1) Look-and-Feel package
- Copy the entire local/plasma/look-and-feel/archsimpleblue directory to:
  ~/.local/share/plasma/look-and-feel/archsimpleblue
- In System Settings → Appearance → Global Theme, select “Arch Simple Blue” (or set only Splash if that’s the provided asset).

2) Plasmoids (widgets)
- Copy each directory under local/plasma/plasmoids/* to:
  ~/.local/share/plasma/plasmoids/<packageId>
  For example:
  - 12menu → ~/.local/share/plasma/plasmoids/12menu
  - KdeControlStation → ~/.local/share/plasma/plasmoids/KdeControlStation
  - luisbocanegra.panel.colorizer → ~/.local/share/plasma/plasmoids/luisbocanegra.panel.colorizer
  - luisbocanegra.panelspacer.extended → ~/.local/share/plasma/plasmoids/luisbocanegra.panelspacer.extended
  - org.dhruv8sh.kara → ~/.local/share/plasma/plasmoids/org.dhruv8sh.kara

3) Color schemes and wallpapers
- Copy local/color-schemes/*.colors to:
  ~/.local/share/color-schemes/
- Copy unoforest_wallpapers/ contents to a wallpapers location and ensure your Plasma background points to the correct path. Prefer a relative path within ~/.local/share/wallpapers or keep the same folder structure and adjust the appletsrc references if needed.

4) App configs
- Merge or symlink config/fastfetch/ to ~/.config/fastfetch/
- Merge or symlink config/ghostty/ to ~/.config/ghostty/
- Merge or symlink config/spicetify/ to ~/.config/spicetify/
- Merge or symlink config/panel-colorizer/ to a compatible location for the plasmoid if required by the specific widget.

5) Plasma layout and settings (optional, advanced)
- If you decide to track files like plasma-org.kde.plasma.desktop-appletsrc, kdeglobals, kwinrc, ensure that:
  - Referenced plasmoids listed in appletsrc exist in ~/.local/share/plasma/plasmoids
  - ColorScheme in kdeglobals matches a file in ~/.local/share/color-schemes/
  - Wallpaper paths are valid
- After placing configs, restart plasmashell or log out/in.

Symlink Mode (Recommended for repeatable setups)
- From the repo root, create symlinks into $HOME. Example:
  ln -s <repo>/config/ghostty ~/.config/ghostty
  ln -s <repo>/local/plasma/plasmoids/12menu ~/.local/share/plasma/plasmoids/12menu
- Prefer directory-level symlinks for entire components to keep updates trivial.
- Before linking, back up any existing directories.

Systemd user services (if you add any)
- Place units under ~/.config/systemd/user/
- Reload daemon and enable/start:
  systemctl --user daemon-reload
  systemctl --user enable --now service-name.service

## a.sh Utility Script

a.sh provides a quick toggle between “nominal” (opaque) and “stealth” (transparent) modes by changing KWin rules, switching wallpapers, and syncing Ghostty transparency/blur.

What it does
- Reads and updates ~/.config/kwinrulesrc opacityactive/opacityinactive values (85 ↔ 100)
- Changes wallpaper using plasma-apply-wallpaperimage if available; otherwise falls back to kwriteconfig5 + DBus refresh
- Updates Ghostty (~/.config/ghostty/config) keys:
  - background-opacity (0.85 when stealth; commented when nominal)
  - background-blur (50 when stealth; commented when nominal)
- Triggers KWin reconfigure and sends a desktop notification

Script location
- Repo root: ./a.sh

Requirements
- KDE Plasma 6 session (Wayland)
- Tools: plasma-apply-wallpaperimage (optional but preferred), kwriteconfig5, dbus-send, notify-send
- Ghostty installed to use terminal transparency sync (optional)

Usage
- Make executable:
  chmod +x ./a.sh
- Run:
  ./a.sh
- Behavior:
  - If current opacity is 85 → switches to 100 (nominal/opaque) and applies NOMINAL_WALLPAPER
  - Else → switches to 85 (stealth/transparent) and applies STEALTH_WALLPAPER

Customize
- Edit variables at the top of a.sh:
  - CONFIG_FILE (default: ~/.config/kwinrulesrc)
  - GHOSTTY_CONFIG (default: ~/.config/ghostty/config)
  - NOMINAL_WALLPAPER, STEALTH_WALLPAPER — set to your images
- Tip: Replace hard-coded /home/unoverse paths with $HOME for portability

Caveats
- The fallback kwriteconfig5 path assumes specific containment/group ids and may differ per system
- Ensure the wallpaper files exist to avoid notify-send errors
- Back up kwinrulesrc before first use

## Post-Install Checks

- Global Theme loads without fallback to Breeze
- Panel and widgets appear in the expected positions
- Shortcut bindings respond as expected
- Fonts/icons/theme consistent across KDE and GTK apps
- Ghostty/fastfetch/spicetify behave with provided configs
- No broken wallpaper references

## Maintenance

- Update plasmoid packages and keep metadata.json/metadata.desktop consistent
- When changing wallpapers or color schemes, align kdeglobals and appletsrc references
- Avoid committing caches, local history, and sensitive keys
- Track version changes of Plasma/Frameworks that may affect config keys

## License Notes

- Third-party packages have their own licenses. For example:
  - local/plasma/look-and-feel/archsimpleblue is GPLv3 (see included LICENSE)
  - Each plasmoid carries its own license in metadata

## Missing Items You May Want To Add Next

- ~/.config/kdeglobals, ~/.config/plasma-org.kde.plasma.desktop-appletsrc snapshots (after cleaning sensitive paths)
- ~/.config/kwinrc (gestures/effects/rules), ~/.config/kglobalshortcutsrc
- ~/.config/powermanagementprofilesrc, ~/.config/plasma-localerc
- Autostart entries under ~/.config/autostart/
- ~/.config/gtk-3.0/settings.ini and ~/.config/gtk-4.0/settings.ini
- If using fcitx5: ~/.config/fcitx5/* (without tokens)

When adding them, scrub user-specific secrets and machine-only caches.
