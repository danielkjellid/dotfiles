#!/bin/sh
# Merges the versioned settings into ~/.claude/settings.json and installs their plugins.
# settings.json stays a real file: autoMode lives only there, since this repo is public.
set -eu

DIR=$(cd "$(dirname "$0")" && pwd)
SETTINGS="$HOME/.claude/settings.json"

mkdir -p "$HOME/.claude"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
jq -s '.[0] * .[1]' "$SETTINGS" "$DIR/settings.json" > "$SETTINGS.tmp"
mv "$SETTINGS.tmp" "$SETTINGS"

known=$(claude plugin marketplace list --json | jq -r '.[].name')
jq -r '.extraKnownMarketplaces | to_entries[] | "\(.key) \(.value.source.repo)"' "$DIR/settings.json" |
  while read -r name repo; do
    echo "$known" | grep -qx "$name" || claude plugin marketplace add "$repo"
  done

installed=$(claude plugin list --json | jq -r '.[] | select(.scope == "user") | .id')
jq -r '.enabledPlugins | to_entries[] | select(.value) | .key' "$DIR/settings.json" |
  while read -r plugin; do
    echo "$installed" | grep -qx "$plugin" || claude plugin install "$plugin"
  done
