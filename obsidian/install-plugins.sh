#!/usr/bin/env bash
# Install Obsidian community plugins listed in community-plugins.json.
# Looks each plugin ID up in the official registry, then downloads
# main.js / manifest.json / styles.css from the latest GitHub release.
set -euo pipefail

VAULT="${1:-$HOME/Documents/notes}"
PLUGINS_LIST="$(dirname "$0")/.obsidian/community-plugins.json"
REGISTRY_URL="https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json"

if [ ! -f "$PLUGINS_LIST" ]; then
	echo "error: $PLUGINS_LIST not found" >&2
	exit 1
fi

if [ ! -d "$VAULT" ]; then
	echo "error: vault not found at $VAULT" >&2
	exit 1
fi

registry="$(mktemp)"
trap 'rm -f "$registry"' EXIT

echo "==> Fetching plugin registry"
curl -fsSL "$REGISTRY_URL" -o "$registry"

plugin_ids="$(jq -r '.[]' "$PLUGINS_LIST")"

if [ -z "$plugin_ids" ]; then
	echo "no plugins listed in $PLUGINS_LIST"
	exit 0
fi

while IFS= read -r id; do
	repo="$(jq -r --arg id "$id" '.[] | select(.id == $id) | .repo' "$registry")"
	if [ -z "$repo" ] || [ "$repo" = "null" ]; then
		echo "  ! $id: not found in registry, skipping"
		continue
	fi

	tag="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')"
	if [ -z "$tag" ] || [ "$tag" = "null" ]; then
		echo "  ! $id: no releases on $repo, skipping"
		continue
	fi

	dest="$VAULT/.obsidian/plugins/$id"
	mkdir -p "$dest"

	echo "==> $id ($repo @ $tag) -> $dest"
	base="https://github.com/$repo/releases/download/$tag"
	curl -fsSL "$base/manifest.json" -o "$dest/manifest.json"
	curl -fsSL "$base/main.js" -o "$dest/main.js"
	# styles.css is optional
	curl -fsSL "$base/styles.css" -o "$dest/styles.css" 2>/dev/null || rm -f "$dest/styles.css"
done <<< "$plugin_ids"

echo "Done. Restart Obsidian (or use 'Reload app without saving') to load."
