#!/usr/bin/env bash
# Regenerate docs/index.html from docs/books.tsv (one book per line, tab-separated:
# slug<TAB>title<TAB>blurb). The landing lists each book as a card linking to its
# rendered mdBook under docs/<slug>/. Called by add-book.sh; also runnable alone.
set -euo pipefail

here="$(cd "$(dirname "$0")/.." && pwd)"
docs="$here/docs"
manifest="$docs/books.tsv"
out="$docs/index.html"

cards=""
if [[ -s "$manifest" ]]; then
  while IFS=$'\t' read -r slug title blurb; do
    [[ -z "$slug" ]] && continue
    cards+="        <a class=\"book\" href=\"./${slug}/\">
          <h2>${title}</h2>
          <p>${blurb}</p>
        </a>
"
  done < "$manifest"
fi
body="${cards:-        <p class=\"empty\">No books yet.</p>}"

cat > "$out" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>sol-babelfish · book previews</title>
<style>
  :root { --bg:#0d1117; --fg:#c9d1d9; --muted:#8b949e; --accent:#3fb950; --card:#161b22; --border:#30363d; }
  * { box-sizing: border-box; }
  body { margin:0; background:var(--bg); color:var(--fg); font-family:system-ui,-apple-system,sans-serif; line-height:1.6; }
  .wrap { max-width:52rem; margin:0 auto; padding:4rem 1.25rem; }
  header h1 { font-size:2rem; margin:0 0 .25rem; letter-spacing:-.01em; }
  header .tag { color:var(--muted); font-family:ui-monospace,SFMono-Regular,monospace; }
  .lede { color:var(--muted); margin:1.5rem 0 2.5rem; }
  .books { display:grid; gap:1rem; }
  a.book { display:block; text-decoration:none; color:inherit; background:var(--card); border:1px solid var(--border); border-radius:10px; padding:1.1rem 1.25rem; transition:border-color .15s, transform .15s; }
  a.book:hover { border-color:var(--accent); transform:translateY(-2px); }
  a.book h2 { margin:0 0 .25rem; font-size:1.15rem; color:var(--accent); }
  a.book p { margin:0; color:var(--muted); }
  footer { color:var(--muted); font-family:ui-monospace,SFMono-Regular,monospace; margin-top:3rem; font-size:.9rem; }
  .empty { color:var(--muted); font-style:italic; }
</style>
</head>
<body>
  <div class="wrap">
    <header>
      <h1>sol-babelfish</h1>
      <div class="tag">book previews</div>
    </header>
    <p class="lede">Executed documentation: every example below is a passing test, and every result is captured from a real run. Sequence diagrams, call trees, authority and ownership graphs, all rendered from the witness, not written by hand.</p>
    <div class="books">
${body}
    </div>
    <footer>Don't Panic. The test is the specification.</footer>
  </div>
</body>
</html>
HTML

echo "wrote $out"
