#!/usr/bin/env bash
# Sanity-checks that a compiled CV PDF's text layer is parseable by
# ATS/résumé-scanning software: section headers, email, and phone number
# must all be extractable as plain text, not only visible as rendered glyphs.
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "usage: $0 <pdf-file> [<pdf-file> ...]" >&2
  exit 2
fi

fail=0

for pdf in "$@"; do
  echo "Checking $pdf"
  text=$(pdftotext -layout "$pdf" -)

  for heading in "Work Experience" "Technical Skills" "Selected Projects" "Other Experience"; do
    if ! grep -qF "$heading" <<< "$text"; then
      echo "  FAIL: missing section heading '$heading' in extracted text"
      fail=1
    fi
  done

  if ! grep -qE '[[:alnum:].+_-]+@[[:alnum:]-]+\.[[:alnum:].-]+' <<< "$text"; then
    echo "  FAIL: no extractable email address found"
    fail=1
  fi

  if ! grep -qE '[0-9]{3}.*[0-9]{3}.*[0-9]{4}' <<< "$text"; then
    echo "  FAIL: no extractable phone number found"
    fail=1
  fi
done

exit $fail
