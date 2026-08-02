#!/usr/bin/env bash
# Fails CI if any given PDF exceeds the CV's 2-page budget.
set -euo pipefail

MAX_PAGES=2

if [ $# -eq 0 ]; then
  echo "usage: $0 <pdf-file> [<pdf-file> ...]" >&2
  exit 2
fi

fail=0

for pdf in "$@"; do
  pages=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')
  if [ "$pages" -gt "$MAX_PAGES" ]; then
    echo "FAIL: $pdf is $pages pages (budget: $MAX_PAGES)"
    fail=1
  else
    echo "OK: $pdf is $pages page(s)"
  fi
done

exit $fail
