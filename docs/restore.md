# Restore guide

This repository is a snapshot, not an automated installer. Read this whole page before copying files back.

The target environment is a CachyOS/Arch-based laptop with Hyprland, Noctalia, GTK/Qt theming, and an Apple-style font stack.

## 0. Before you start

- Back up the existing home configuration.
- Review `packages/explicit-native.txt`: it includes kernels, firmware, GPU drivers, and base packages. Remove anything that does not match the target machine before bulk-installing.
- Do not copy `reference/noctalia-settings.toml` into `~/.local/state/noctalia/settings.toml` during a normal restore. It is raw app-managed state and would override the declarative Noctalia config.
- The wallpaper and avatar files are not included. See [`assets.md`](assets.md).

```bash
stamp="$(date +%Y%m%d-%H%M%S)"
backup="$HOME/dotfiles-backup-$stamp"
mkdir -p "$backup"
cp -a "$HOME/.config" "$backup/"
cp -a "$HOME/.local" "$backup/"
cp -a "$HOME/.zshrc" "$backup/" 2>/dev/null || true
```

## 1. Install packages

Enable the CachyOS repositories and `[multilib]` as appropriate for the target machine. Then review and install the native packages:

```bash
sudo pacman -S --needed $(< packages/explicit-native.txt)
```

Install the AUR packages with an AUR helper such as `paru` or `yay`:

```bash
paru -S --needed $(< packages/explicit-aur.txt)
```

`packages/all-packages.txt` contains the full versioned inventory and is for reference, not bulk installation.

`wayland-wheeltani` was installed from Cargo rather than pacman. Install it separately if you want the middle-button autoscroll service, or remove that user unit.

## 2. Copy the home files

From the repository root:

```bash
cp -a home/. "$HOME/"
```

This merges the archived configuration into the existing home directory. Restore executable bits on scripts if your copy method dropped them:

```bash
chmod +x "$HOME/.config/hypr/scripts/"*.sh
chmod +x scripts/install-apple-new-york.sh
```

## 3. Resolve path placeholders

Two applications need literal absolute paths. Replace the `__HOME__` token after copying:

```bash
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/qt6ct/qt6ct.conf"
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/shelly/config.json"
```

Verify that no placeholders remain:

```bash
grep -R '__HOME__' "$HOME/.config/qt6ct" "$HOME/.config/shelly" || true
```

Noctalia hooks are already home-relative and must remain that way:

```toml
[hooks]
battery_charging = "~/.config/hypr/scripts/power-refresh.sh"
battery_discharging = "~/.config/hypr/scripts/power-refresh.sh"
battery_plugged = "~/.config/hypr/scripts/power-refresh.sh"
started = "~/.config/hypr/scripts/power-refresh.sh"
```

## 4. Install fonts

Install the distro/AUR font packages first, then run the New York installer:

```bash
bash scripts/install-apple-new-york.sh
fc-cache -f
```

The New York script downloads Apple's DMG, extracts the OTF files into `/usr/share/fonts/apple-new-york`, and requires `curl`, `7zip`, `libarchive`, and `sudo`.

Verify the font mappings:

```bash
fc-match sans
fc-match serif
fc-match monospace
fc-match emoji
```

Expected families are documented in [`fonts.md`](fonts.md).

## 5. Apply GTK/dconf settings

```bash
dconf load /org/gnome/desktop/interface/ < reference/dconf-interface.ini
```

The GTK 3/4 settings, `xsettingsd`, and Noctalia-generated CSS are copied with `home/`.

## 6. Apply system snippets manually

These are documented, not committed as `/etc` files:

- `FREETYPE_PROPERTIES` in `/etc/environment`
- greetd/Plymouth override
- wayland-wheeltani udev rule
- `mkinitcpio.conf` Plymouth hooks
- Limine kernel command line
- CachyOS repository and `[multilib]` configuration

Copy the exact snippets from [`system-notes.md`](system-notes.md). Rebuild the initramfs and update the boot loader only after reviewing the target machine's own configuration:

```bash
sudo mkinitcpio -P
```

## 7. Enable user services

```bash
systemctl --user daemon-reload
systemctl --user enable --now shelly-notifications.service
systemctl --user enable --now wayland-wheeltani.service
```

`hyprland-session.target` is provided for session ordering. The wayland-wheeltani unit uses `%h`, so it does not contain a hard-coded home path.

## 8. Validate Noctalia

```bash
noctalia config validate "$HOME/.config/noctalia/config.toml"
```

Do not restore `reference/noctalia-settings.toml` unless you are deliberately restoring the exact GUI-managed state. The normal configuration comes from `home/.config/noctalia/config.toml`.

The current snapshot references an `HDMI-A-1` wallpaper and lock-screen widget. On a laptop-only setup, remove or update those entries in Noctalia after restoring.

## 9. Validate Hyprland

```bash
hyprctl reload
hyprctl configerrors
```

After a successful reload, test the keybinds, monitor mode, Noctalia bar, lock screen, screenshots, and power hooks.

## 10. Restore images manually

Create or copy the files listed in [`assets.md`](assets.md). If the filenames differ, update Noctalia's wallpaper, avatar, and lock-screen settings instead of renaming the files.

## 11. Verify laptop power behavior

The power script only runs on systems with a battery. On AC it selects the highest refresh rate and the `performance` power profile; on battery it selects 60 Hz and `balanced`.

Check that the required commands exist:

```bash
command -v jq
command -v powerprofilesctl
command -v hyprctl
```

Run the script manually once while watching the output:

```bash
~/.config/hypr/scripts/power-refresh.sh
```

See [`laptop-power.md`](laptop-power.md) for details and limitations.
