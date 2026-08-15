#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file="$script_dir/git-issue"
target_dir=${1:-"$HOME/.local/bin"}
target="$target_dir/git-issue"

mkdir -p "$target_dir"
cp "$source_file" "$target"
chmod +x "$target"

printf 'Installed git-issue to %s\n' "$target"
case ":$PATH:" in
  *":$target_dir:"*) ;;
  *) printf 'Add %s to PATH to use: git issue ...\n' "$target_dir" ;;
esac
