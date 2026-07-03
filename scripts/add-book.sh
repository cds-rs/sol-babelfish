#!/usr/bin/env bash
# Add (or refresh) a book preview from a squish program repo.
#
#   scripts/add-book.sh <slug> <squish-repo-path> [title] [blurb]
#
# Builds the repo's mdBook (`make book` there), renders it to static HTML, and
# copies it into docs/<slug>/. The repo itself is NOT shared here, so the source
# links on each scenario page are neutralized: the provenance text stays (it
# shows the example came from a real test), but the dead link to the private test
# source is dropped. Finally the landing index is regenerated.
set -euo pipefail

slug="${1:?usage: add-book.sh <slug> <repo> [title] [blurb]}"
repo="${2:?usage: add-book.sh <slug> <repo> [title] [blurb]}"
title="${3:-$slug}"
blurb="${4:-}"

here="$(cd "$(dirname "$0")/.." && pwd)"
docs="$here/docs"
mkdir -p "$docs"

command -v mdbook >/dev/null 2>&1 || {
  echo "need mdbook: cargo install mdbook mdbook-mermaid" >&2
  exit 1
}

echo "building $slug from $repo ..."
( cd "$repo" && make book )

# Render from a copy whose source links are neutralized (the repo is private).
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp -r "$repo/book" "$tmp/book"
for f in "$tmp/book/src/"*.md; do
  sed -E 's#\*\*Source:\*\* \[(`[^`]*`[^]]*)\]\([^)]*\)#**Source:** \1#' "$f" > "$f.tmp"
  mv "$f.tmp" "$f"
done
( cd "$tmp/book" && mdbook build >/dev/null )

rm -rf "${docs:?}/${slug}"
cp -r "$tmp/book/book" "$docs/$slug"

# Update the manifest (replace any existing row for this slug), then regen index.
manifest="$docs/books.tsv"
touch "$manifest"
tmpm="$(mktemp)"
awk -F'\t' -v s="$slug" '$1 != s' "$manifest" > "$tmpm" || true
printf '%s\t%s\t%s\n' "$slug" "$title" "$blurb" >> "$tmpm"
sort "$tmpm" -o "$manifest"
rm -f "$tmpm"

"$here/scripts/gen-index.sh"
echo "added $slug -> docs/$slug/"
