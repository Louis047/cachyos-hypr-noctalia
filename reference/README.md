# Reference data

These files preserve context from the live system. They are **not** part of the normal home-directory restore.

## `noctalia-settings.toml`

Raw copy of:

```text
~/.local/state/noctalia/settings.toml
```

This is Noctalia's app-managed override layer. It wins over declarative config, so copying it into the state directory during a normal restore would override `home/.config/noctalia/config.toml`.

It is included to preserve exact GUI state and to help debug differences between the exported config and the live shell.

Paths under the original home directory were normalized to `~`. No credentials, calendar accounts, or token fields were present in this snapshot.

## `dconf-interface.ini`

Text export of:

```bash
dconf dump /org/gnome/desktop/interface/
```

Restore it with:

```bash
dconf load /org/gnome/desktop/interface/ < reference/dconf-interface.ini
```

This contains theme, font, cursor, and toolbar preferences used by GTK/GNOME applications.

## Not included

- `~/.local/state/noctalia/state.toml`
- Clipboard and notification history
- Plugin source repositories and materialized plugin caches
- Downloaded community palette and template catalogs
- Browser profiles and password-manager data
