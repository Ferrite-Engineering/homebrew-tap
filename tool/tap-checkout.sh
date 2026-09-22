#!/usr/bin/env bash
# Point Homebrew's ferrite-engineering/tap at this checkout, so every brew
# command runs against the files in the working tree rather than a clone of
# main. CI uses it to verify exactly what tool/bump.py rendered; locally it lets
# you audit and install an edit before pushing it. `brew untap
# ferrite-engineering/tap` undoes it, and removes only the link.
set -euo pipefail

checkout="$(cd "$(dirname "${0}")/.." && pwd)"
tap="$(brew --repository)/Library/Taps/ferrite-engineering/homebrew-tap"

mkdir -p "$(dirname "${tap}")"
rm -rf "${tap}"
ln -s "${checkout}" "${tap}"
echo "ferrite-engineering/tap -> ${checkout}"
