# Ferrite Engineering Homebrew tap

Homebrew casks for the EDACrux suite (WaveCrux, NetCrux, LintCrux and SimCrux),
plus a formula for the LintCrux headless CLI.

## Install

```sh
brew install --cask ferrite-engineering/tap/wavecrux
brew install --cask ferrite-engineering/tap/netcrux
brew install --cask ferrite-engineering/tap/lintcrux
brew install --cask ferrite-engineering/tap/simcrux

brew install ferrite-engineering/tap/lintcrux-cli     # from 1.0
```

Use the full name. Homebrew 7 loads nothing from a third-party tap until you
trust it, and naming a cask or formula in full trusts that one entry. Upgrade
with `brew upgrade`.

| Name | What it is | Platforms |
|---|---|---|
| `wavecrux` | Waveform viewer for VCD, FST, GHW and LXT dumps | macOS 12+ |
| `netcrux` | Hierarchical RTL schematic browser and signal tracer | macOS 12+ |
| `lintcrux` | One dashboard for Verilator, Verible, Slang, GHDL, Yosys and svlint | macOS 12+ |
| `simcrux` | Regression dashboard for Icarus, Verilator, GHDL and cocotb | macOS 12+ |
| `lintcrux-cli` | The LintCrux engines with no window, for CI pipelines | macOS Apple Silicon, Linux x86_64 (glibc 2.34+); from 1.0 |

The casks install the same signed and notarized DMG that each product's
download page serves. The apps check for updates themselves and tell you when
one is out; with a Homebrew install, `brew upgrade` is how you take it.

The apps drive open-source engines that you install separately, for example
`brew install verilator icarus-verilog yosys svlint` and
`brew install --cask ghdl`.

Windows and Linux builds of the desktop apps are on each product's download
page: [wavecrux.app](https://wavecrux.app/download),
[netcrux.app](https://netcrux.app/download),
[lintcrux.app](https://lintcrux.app/download),
[simcrux.app](https://simcrux.app/download).

## How this tap is kept current

Nobody edits the files in `Casks/` or `Formula/` by hand.
[`tool/bump.py`](tool/bump.py) generates them from each product's update
manifest (`https://updates.<product>.app/manifest.json`), which is the file the
installed apps poll. It refuses to write anything unless the manifest's
checksum and the release's own `SHA256SUMS` agree.

[`follow-manifests.yml`](.github/workflows/follow-manifests.yml) runs it every
six hours, and on demand. When something changed, CI runs `brew style` and a
strict online `brew audit`. It installs every cask, validates each DMG's stapled
notarization ticket and checks the app's signing team. It installs the CLI on
macOS and Linux and checks that it reports the version it was published as. The
casks and the CLI are committed separately, each only if its own checks pass, so
a broken CLI build cannot hold back the apps. A release reaches this tap after
its manifest goes live, never before, and never broken.

To change a cask or the formula, edit its template in `tool/bump.py` and push.
CI renders, verifies and commits the result. To try an edit locally first:

```sh
tool/tap-checkout.sh      # point ferrite-engineering/tap at this checkout
python3 tool/bump.py      # render
brew style ferrite-engineering/tap
brew audit --strict --online --cask ferrite-engineering/tap/wavecrux
brew untap ferrite-engineering/tap
```
