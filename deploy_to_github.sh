#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Fando AI Agent — GitHub Pages deploy script
# Run: GITHUB_TOKEN=ghp_xxx bash deploy_to_github.sh
# Or:  use `gh auth login` and run: bash deploy_to_github.sh  (git push only path)
# Requires: git, curl (for API), optional GITHUB_TOKEN for repo/Pages API
# ─────────────────────────────────────────────────────────────

set -e

TOKEN="${GITHUB_TOKEN:-}"
# In GitHub Actions, GITHUB_REPOSITORY is owner/repo (override local defaults).
if [ -n "${GITHUB_REPOSITORY:-}" ]; then
  USER="${GITHUB_REPOSITORY%%/*}"
  REPO="${GITHUB_REPOSITORY#*/}"
else
  USER="kunanon-ui"
  REPO="Presentation"
fi
BRANCH="gh-pages"

echo ""
echo "🚀  Presentation site — GitHub Pages deploy"
echo "──────────────────────────────────────────"

# ── 1. Check site files exist ───────────────────────────────────
if [ ! -f "index.html" ] || [ ! -f "fando/fando_presentation.html" ]; then
  echo "❌  Need index.html (hub) and fando/fando_presentation.html (deck)."
  exit 1
fi
if [ ! -f "fando/index.html" ]; then
  echo "❌  Need fando/index.html (redirect to deck)."
  exit 1
fi
if [ ! -f "tbh-ai-adoption/TBH_AI_Adoption_Strategy.html" ]; then
  echo "❌  Need tbh-ai-adoption/TBH_AI_Adoption_Strategy.html"
  exit 1
fi
if [ ! -f "slide-template.html" ]; then
  echo "❌  Need slide-template.html (hub footer + author starter deck)"
  exit 1
fi
echo "✅  Found index.html + fando (redirect + fando_presentation) + tbh-ai-adoption deck"

# ── 2. Create repo via GitHub API (optional; local PAT only — not GITHUB_ACTIONS) ─
if [ -n "$TOKEN" ] && [ -z "${GITHUB_ACTIONS:-}" ]; then
  echo ""
  echo "📦  Ensuring repo $USER/$REPO exists ..."
  HTTP=$(curl -s -o /tmp/gh_repo.json -w "%{http_code}" \
    -X POST \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/repos \
    -d "{
      \"name\": \"$REPO\",
      \"description\": \"Fando AI Video Agent — presentation (GitHub Pages)\",
      \"homepage\": \"https://$USER.github.io/$REPO\",
      \"private\": false,
      \"auto_init\": false
    }")

  if [ "$HTTP" = "201" ]; then
    echo "✅  Repo created: https://github.com/$USER/$REPO"
  elif [ "$HTTP" = "422" ]; then
    echo "ℹ️   Repo already exists — continuing"
  else
    echo "⚠️   Repo creation API returned HTTP $HTTP — continuing if repo exists"
  fi
else
  echo ""
  echo "ℹ️   GITHUB_TOKEN not set — skipping repo create API (use existing repo)"
fi

# ── 3. Init local git and push ──────────────────────────────────
echo ""
echo "📤  Pushing site to $BRANCH branch ..."

TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/fando" "$TMPDIR/tbh-ai-adoption"
cp index.html "$TMPDIR/index.html"
cp slide-template.html "$TMPDIR/slide-template.html"
cp fando/index.html "$TMPDIR/fando/index.html"
cp fando/fando_presentation.html "$TMPDIR/fando/fando_presentation.html"
cp tbh-ai-adoption/TBH_AI_Adoption_Strategy.html "$TMPDIR/tbh-ai-adoption/index.html"
cp tbh-ai-adoption/TBH_AI_Adoption_Strategy.html "$TMPDIR/tbh-ai-adoption/TBH_AI_Adoption_Strategy.html"
cd "$TMPDIR"

git init -q
git checkout -q -b "$BRANCH"
git config user.email "deploy@fando-ai-agent"
git config user.name  "Fando Deploy"
git add index.html slide-template.html fando/index.html fando/fando_presentation.html tbh-ai-adoption/index.html tbh-ai-adoption/TBH_AI_Adoption_Strategy.html
git commit -q -m "chore: deploy hub + Fando + TBH AI adoption decks"

if [ -n "$TOKEN" ]; then
  REMOTE="https://x-access-token:$TOKEN@github.com/$USER/$REPO.git"
else
  REMOTE="https://github.com/$USER/$REPO.git"
fi
git remote add origin "$REMOTE"
git push -q -f origin "$BRANCH"

cd - > /dev/null
rm -rf "$TMPDIR"
echo "✅  Pushed to $BRANCH"

# ── 4. Enable GitHub Pages ──────────────────────────────────────
if [ -n "$TOKEN" ]; then
  echo ""
  echo "🌐  Enabling GitHub Pages ..."
  HTTP=$(curl -s -o /tmp/gh_pages.json -w "%{http_code}" \
    -X POST \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/$USER/$REPO/pages \
    -d "{
      \"source\": {
        \"branch\": \"$BRANCH\",
        \"path\": \"/\"
      }
    }")

  if [ "$HTTP" = "201" ]; then
    echo "✅  GitHub Pages enabled"
  elif [ "$HTTP" = "409" ]; then
    echo "ℹ️   GitHub Pages already enabled"
  else
    echo "⚠️   Pages API returned HTTP $HTTP — check manually:"
    echo "    https://github.com/$USER/$REPO/settings/pages"
    cat /tmp/gh_pages.json 2>/dev/null || true
  fi
else
  echo ""
  echo "ℹ️   Set GITHUB_TOKEN to auto-enable Pages via API, or enable in repo Settings → Pages"
fi

# ── 5. Done ─────────────────────────────────────────────────────
echo ""
echo "──────────────────────────────────────────"
echo "✅  All done!"
echo ""
echo "   Repo   → https://github.com/$USER/$REPO"
echo "   Pages  → https://$USER.github.io/$REPO"
echo ""
echo "   ⏱  GitHub Pages takes ~60s to go live on first deploy."
echo "   🔄  To redeploy after edits: bash deploy_to_github.sh"
echo "──────────────────────────────────────────"
