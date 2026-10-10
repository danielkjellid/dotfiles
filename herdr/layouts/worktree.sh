#!/usr/bin/env bash
# Lays out a worktree workspace: a "Server" tab split in two, a "Claude" tab running
# claude. Every pane starts in the worktree. Usage: worktree.sh [workspace-id]
set -euo pipefail

SERVER_TAB=Server
CLAUDE_TAB=Claude
# Top pane share of the Server tab.
SERVER_TOP_RATIO=0.67
CLAUDE_COMMAND=${CLAUDE_COMMAND:-claude}

herdr=${HERDR_BIN_PATH:-herdr}

workspace=${1:-${HERDR_WORKSPACE_ID:-}}
if [[ -z $workspace ]]; then
  workspace=$("$herdr" workspace list | jq -r '.result.workspaces[] | select(.focused) | .workspace_id')
fi
if [[ -z $workspace ]]; then
  echo "layout: no workspace given and none focused" >&2
  exit 1
fi

tabs=$("$herdr" tab list --workspace "$workspace")
if printf '%s\n' "$tabs" | jq -e --arg l "$CLAUDE_TAB" '.result.tabs[] | select(.label == $l)' >/dev/null; then
  echo "layout: $workspace already has a $CLAUDE_TAB tab"
  exit 0
fi

first_tab=$(printf '%s\n' "$tabs" | jq -r '.result.tabs | sort_by(.number) | .[0].tab_id')
first_pane=$("$herdr" pane list --workspace "$workspace" |
  jq -r --arg t "$first_tab" '[.result.panes[] | select(.tab_id == $t)][0]')
first_pane_id=$(printf '%s\n' "$first_pane" | jq -r '.pane_id')
first_pane_cwd=$(printf '%s\n' "$first_pane" | jq -r '.cwd')

# The worktree herdr has open in this workspace; a plain workspace uses its first pane's cwd.
cwd=$("$herdr" worktree list --cwd "$first_pane_cwd" --json 2>/dev/null |
  jq -r --arg w "$workspace" '.result.worktrees[]? | select(.open_workspace_id == $w) | .path' |
  head -n1 || true)
cwd=${cwd:-$first_pane_cwd}

if [[ $first_pane_cwd != "$cwd" ]]; then
  "$herdr" pane run "$first_pane_id" "cd $(printf '%q' "$cwd")" >/dev/null
fi

"$herdr" tab rename "$first_tab" "$SERVER_TAB" >/dev/null
"$herdr" pane split "$first_pane_id" --direction down --ratio "$SERVER_TOP_RATIO" --cwd "$cwd" --no-focus >/dev/null

claude_pane=$("$herdr" tab create --workspace "$workspace" --cwd "$cwd" --label "$CLAUDE_TAB" --focus |
  jq -r '.result.root_pane.pane_id')
"$herdr" pane run "$claude_pane" "$CLAUDE_COMMAND" >/dev/null
