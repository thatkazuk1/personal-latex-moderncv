# personal-latex-moderncv

Multi-variant CV/résumé built with LaTeX. Compiles three role-targeted PDFs from a single source using conditional flags.

## Table of Contents

- [About the Project](#about-the-project)
- [Project Status](#project-status)
- [Getting Started](#getting-started)
  - [Dependencies](#dependencies)
  - [Technology Stack](#technology-stack)
  - [Third-party Services](#third-party-services)
- [Installation & Development](#installation--development)
  - [Setting Up](#setting-up)
  - [Development](#development)
  - [Testing](#testing)
- [How to Get Help](#how-to-get-help)
- [Contributing](#contributing)
- [Authors](#authors)
  - [Repo Activity](#repo-activity)

## About the Project

A personal CV built with the LaTeX `moderncv` package (classic style) and the `moderntimeline` package for a visual career timeline.
The build system supports three role-targeted variants from a single source file, selected via LaTeX conditionals
(`\ifbackend` / `\ifplatform` / `\iffullstack`):

| Variant | Target roles | Build command |
|---|---|---|
| `backend` | Backend / API / Server Engineer (default) | `make backend` |
| `platform` | Platform / DevOps / Infra Engineer | `make platform` |
| `fullstack` | Full-Stack Engineer (backend-heavy) | `make fullstack` |

Each variant adjusts the professional summary, skills ordering, and project emphasis to match what recruiters for that role type scan
for first. All three share the same work history and project entries.

## Project Status

[![Compile & Release](https://github.com/thatkazuk1/personal-latex-moderncv/actions/workflows/action.yml/badge.svg)](https://github.com/thatkazuk1/personal-latex-moderncv/actions/workflows/action.yml)
[![Latest Release](https://img.shields.io/github/v/release/thatkazuk1/personal-latex-moderncv?label=Latest%20PDF)](https://github.com/thatkazuk1/personal-latex-moderncv/releases/latest)

## Getting Started

### Dependencies

- A TeX distribution with `pdflatex` (TeX Live 2022+ or MiKTeX)
- The following LaTeX packages (included in most full TeX distributions):
  - `moderncv`
  - `moderntimeline`
  - `geometry`
  - `inputenc`
  - `lmodern`
  - `xpatch`
  - `pdfpages`
  - `graphicx`, `color`
- GNU Make (optional, for multi-variant builds)
- `aspell`, `poppler-utils` (`pdfinfo`/`pdftotext`), and `latexdiff` (optional, only needed
  to run the CI checks locally — see [Testing](#testing))

### Technology Stack

| Component | Tool |
|---|---|
| Typesetting | LaTeX (`pdflatex`) |
| CV template | `moderncv` (classic style) |
| Timeline | `moderntimeline` |
| Build system | GNU Make |
| CI/CD | GitHub Actions |
| Release | `softprops/action-gh-release` |

### Third-party Services

- **GitHub Actions** — compiles all three variants on push to `master` and attaches the PDFs to a GitHub Release.

## Installation & Development

### Setting Up

```bash
git clone https://github.com/thatkazuk1/personal-latex-moderncv.git
cd personal-latex-moderncv
```

Ensure `pdflatex` is available:

```bash
pdflatex --version
```

On Ubuntu/Debian:

```bash
sudo apt-get install texlive-latex-extra texlive-fonts-extra
```

On macOS (via Homebrew):

```bash
brew install --cask mactex
```

### Development

Build a single variant:

```bash
make backend    # → build/desmond_edem_backend.pdf
make platform   # → build/desmond_edem_platform.pdf
make fullstack  # → build/desmond_edem_fullstack.pdf
```

Build all variants:

```bash
make all
```

Or compile directly without Make:

```bash
pdflatex main.tex                                   # default (backend) variant
pdflatex "\def\variantplatform{}\input{main.tex}"    # platform variant
pdflatex "\def\variantfullstack{}\input{main.tex}"   # fullstack variant
```

Run `pdflatex` twice per variant — the timeline needs a second pass to resolve its cross-references. Output is
written to `build/` when using `make`. Run `make clean` to remove build artifacts.

### Testing

CI (`.github/workflows/action.yml`) automatically checks, on every push to `master`:

- **Spell check** — `aspell --mode=tex` against `main.tex`, using `.aspell.en.pws` as the
  personal dictionary for names/tools/jargon. Add new proper nouns there if the check
  starts failing on a real word.
- **Page budget** — `scripts/check-page-count.sh` fails the build if any compiled variant
  exceeds 2 pages.
- **ATS text-extraction check** — `scripts/ats-check.sh` runs `pdftotext` against each PDF
  and confirms section headings, the email address, and the phone number are all present
  as extractable plain text (not only as rendered glyphs).

A separate workflow (`.github/workflows/diff-preview.yml`) compiles a `latexdiff` preview
PDF on pull requests that touch `main.tex` and uploads it as a build artifact, so reviewers
can see a redline of the change. It's best-effort and non-blocking — `latexdiff`'s markup
can conflict with itemize/list boundaries on large restructuring diffs and fail to compile
cleanly; that's a known `latexdiff` limitation, not a sign anything else is wrong.

To run the same checks locally before compiling:

```bash
aspell --mode=tex --lang=en_US --personal=./.aspell.en.pws list < main.tex
./scripts/check-page-count.sh build/desmond_edem_backend.pdf
./scripts/ats-check.sh build/desmond_edem_backend.pdf
```

Also verify manually:

- Timeline renders correctly (no overlapping entries)
- No overfull `\hbox` warnings in the build log
- Links (email, GitHub, LinkedIn) are clickable in the PDF

## How to Get Help

Notice a bug or formatting issue? Please [open an issue](https://github.com/thatkazuk1/personal-latex-moderncv/issues).
There are templates for bug reports and feature requests.

## Contributing

This is a personal CV, so external contributions are not expected. However, if you'd like to fork this setup for
your own CV, feel free — the structure and build system are reusable.

## Authors

- **[Desmond Edem](https://github.com/thatkazuk1)**

### Repo Activity

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/thatkazuk1/personal-latex-moderncv)
