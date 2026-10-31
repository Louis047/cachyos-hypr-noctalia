# Package manifests

Generated from the snapshot on **2026-10-31**.

| File | Command | Count |
|---|---|---|
| `explicit-native.txt` | `pacman -Qenq` | 259 |
| `explicit-aur.txt` | `pacman -Qemq` | 7 |
| `all-packages.txt` | `pacman -Q` | 1,333 |

## `explicit-native.txt`

Explicitly installed repository packages. This includes base packages, kernels, firmware, GPU drivers, desktop packages, and libraries. Review it before bulk installation; remove kernel, driver, and microcode packages that do not match the target machine.

## `explicit-aur.txt`

Foreign/AUR packages:

```text
apple_cursor
grabit-git
noctalia-git
otf-apple-sf-pro
ps_mem
ttf-apple-emoji
zapfast-bin
```

`wayland-wheeltani` is not in this list because it was installed from Cargo rather than pacman. Install it separately if the user service is needed.

## `all-packages.txt`

A versioned inventory of every installed package. It is useful for identifying exact versions from the snapshot but is not intended for bulk installation.

## Reinstall commands

From the repository root:

```bash
sudo pacman -S --needed $(< packages/explicit-native.txt)
paru -S --needed $(< packages/explicit-aur.txt)
```

Use `yay` instead of `paru` if preferred. Ensure the CachyOS repositories and `[multilib]` are enabled first.

AUR package versions move independently of this snapshot. If an AUR build fails later, check the package's current build instructions rather than assuming the archived version is still available.
