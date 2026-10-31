# Fonts

The desktop uses an Apple-style font stack with Linux fallbacks. Proprietary font binaries are not included in this repository.

## Families

| Role | Primary family | Source |
|---|---|---|
| UI sans, small text | SF Pro Text | AUR `otf-apple-sf-pro` |
| UI sans, display text | SF Pro Display | AUR `otf-apple-sf-pro` |
| Serif | New York Small / Medium / Large / Extra Large | `scripts/install-apple-new-york.sh` |
| Emoji | Apple Color Emoji | AUR `ttf-apple-emoji` |
| Monospace | JetBrainsMono Nerd Font Mono | `ttf-jetbrains-mono-nerd` |
| Fallback sans | Noto Sans | `noto-fonts` |
| Fallback serif | Source Serif 4, Noto Serif | distro packages |
| Fallback mono | Noto Sans Mono | `noto-fonts` |

## Fontconfig layers

- System rendering defaults live in `/etc/fonts/`.
- User family mappings live in `home/.config/fontconfig/fonts.conf`.
- The Apple emoji override lives in `home/.config/fontconfig/conf.d/75-apple-color-emoji.conf`.
- `FREETYPE_PROPERTIES` in `/etc/environment` disables CFF stem darkening for the autohinter.

The user config intentionally handles family selection, while rendering settings such as antialiasing, hinting, RGBA, and LCD filtering remain system-level.

## Install

```bash
sudo pacman -S --needed ttf-jetbrains-mono-nerd
paru -S --needed otf-apple-sf-pro ttf-apple-emoji
```

Install New York separately:

```bash
bash scripts/install-apple-new-york.sh
fc-cache -f
```

The New York installer downloads Apple's DMG, extracts the OTF files, and writes them to:

```text
/usr/share/fonts/apple-new-york
```

It requires `curl`, `7zip`, `libarchive`, and `sudo`.

## Verify

```bash
fc-match sans
fc-match serif
fc-match monospace
fc-match emoji
```

Expected highlights:

- `sans` resolves to SF Pro Text/Display.
- `serif` resolves to New York on this setup.
- `monospace` resolves to JetBrainsMono Nerd Font Mono.
- `emoji` resolves to Apple Color Emoji.

Check the full policy with:

```bash
fc-match -v sans | less
```

## Notes

- SF Pro and Apple Color Emoji are proprietary Apple assets. Confirm that your use and redistribution comply with Apple's license.
- The New York installer downloads directly from Apple's CDN rather than bundling font files.
- If a website or application requests a competitor emoji family, the user fontconfig remaps it to Apple Color Emoji.
- DejaVu's emoji range is removed from fontconfig's scanned charset to prevent black-and-white emoji from winning fallback.
