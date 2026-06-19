# sfz-lutheal

Luthéal piano SFZ instrument — cimbalom (all stops) registration with pedal and release layers.

## Install (Debian 12 / Raspberry Pi OS Bookworm)

Add the [APT repository](https://github.com/jamesmittlerii/aptrepo) if you have not already:

```bash
# Desktop amd64
echo "deb [trusted=yes arch=amd64] https://jamesmittlerii.github.io/aptrepo/ bookworm main" \
  | sudo tee /etc/apt/sources.list.d/jamesmittlerii-apt.list

# Raspberry Pi 64-bit
echo "deb [trusted=yes arch=arm64] https://jamesmittlerii.github.io/aptrepo/ bookworm main" \
  | sudo tee /etc/apt/sources.list.d/jamesmittlerii-apt.list
```

Then:

```bash
sudo apt update
sudo apt install sfz-lutheal
```

On first install, `postinst` downloads ~1 GiB of FLAC samples from the matching GitHub release (uncompressed tar — FLAC is already compressed).

The instrument is installed to:

```text
/usr/share/sfz/pianos/lutheal/
  lutheal-cimbalom.sfz
  samples/
    attack/    # 1360 velocity layers
    release/   # 949 release samples
    pedal/     # 16 pedal noise samples
```

Point your SFZ player at `/usr/share/sfz/pianos/lutheal/lutheal-cimbalom.sfz`.

Re-download samples after a version bump:

```bash
sudo rm -f /usr/share/sfz/pianos/lutheal/samples/.installed
sudo apt install --reinstall sfz-lutheal
```

## Build locally

On Debian Bookworm:

```bash
sudo apt install devscripts debhelper
./scripts/verify-package.sh
./scripts/build-samples-tar.sh
dpkg-buildpackage -us -uc -b -d
```

## CI / publishing

Pushes to `main` build the `.deb` and sample tarball, publish the package to [aptrepo](https://github.com/jamesmittlerii/aptrepo) gh-pages, and attach release assets.

Set `APTREPO_PUSH_TOKEN` on this repository (fine-grained PAT with **Contents: Read and write** on `jamesmittlerii/aptrepo`).

## Layout notes

Source SFZ paths use accented directory names from the Kontakt export. The packaged SFZ rewrites them to ASCII paths under `samples/` so installs are portable on Linux.
