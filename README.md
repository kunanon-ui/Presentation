# Presentation

Static site for **HTML slide decks** on GitHub Pages. The home page lists projects; each deck lives in its own folder.

- **Fando AI Agent** — `fando/` — multi-source sports video discovery pipeline (12 slides).

## Live site (GitHub Pages)

**https://kunanon-ui.github.io/Presentation/** — hub with links to each deck and slide.

**Direct deck:** […/Presentation/fando/](https://kunanon-ui.github.io/Presentation/fando/)

### Slide URLs (hash routing)

From the hub, use “Jump to slide”, or open URLs like:

- `…/fando/#slide-1` … `…/fando/#slide-12`
- `…/fando/?s=4` (same as `#slide-4`)

The hash updates as you move through the deck so links stay shareable.

## Repository

**https://github.com/kunanon-ui/Presentation**

## Local preview

```bash
python3 -m http.server 8765
```

Open [http://localhost:8765/](http://localhost:8765/) for the hub, or [http://localhost:8765/fando/](http://localhost:8765/fando/) for the deck.

## Deploy to GitHub Pages

```bash
bash deploy_to_github.sh
```

Deploys `index.html` (hub) and `fando/index.html` to the `gh-pages` branch.

Requires [GitHub CLI](https://cli.github.com/) authentication (`gh auth login`) or a `GITHUB_TOKEN` for API steps.
