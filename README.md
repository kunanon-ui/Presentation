# Presentation

Static site for **HTML slide decks** on GitHub Pages. The home page lists projects; each deck lives in its own folder.

- **Fando AI Agent** — `fando/fando_presentation.html` — process & architecture deck for product/ops (14 slides). `fando/index.html` redirects here (hash preserved).

## Live site (GitHub Pages)

**https://kunanon-ui.github.io/Presentation/** — hub with links to each deck and slide.

**Direct deck:** […/Presentation/fando/fando_presentation.html](https://kunanon-ui.github.io/Presentation/fando/fando_presentation.html) (or […/fando/](https://kunanon-ui.github.io/Presentation/fando/) → redirect)

### Slide URLs (hash routing)

Open a deck from the hub, or deep-link slides, for example:

- `…/fando/fando_presentation.html#slide-1` … `#slide-14`
- `…/fando/?s=4` (redirects to deck with query + hash preserved)

The hash updates as you move through the deck so links stay shareable.

## Repository

**https://github.com/kunanon-ui/Presentation**

## Local preview

```bash
python3 -m http.server 8765
```

Open [http://localhost:8765/](http://localhost:8765/) for the hub, or [http://localhost:8765/fando/fando_presentation.html](http://localhost:8765/fando/fando_presentation.html) for the deck.

## Deploy to GitHub Pages

```bash
bash deploy_to_github.sh
```

Deploys `index.html` (hub), `fando/index.html` (redirect), and `fando/fando_presentation.html` (deck) to the `gh-pages` branch.

Requires [GitHub CLI](https://cli.github.com/) authentication (`gh auth login`) or a `GITHUB_TOKEN` for API steps.
