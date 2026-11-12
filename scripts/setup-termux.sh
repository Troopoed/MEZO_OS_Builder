#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
pkg update -y
pkg install -y git gh
if ! gh auth status >/dev/null 2>&1; then gh auth login; fi
read -r -p "Имя GitHub-репозитория [mezo-os-builder]: " REPO
REPO="${REPO:-mezo-os-builder}"
read -r -p "Доступ private/public [private]: " VIS
VIS="${VIS:-private}"
[[ "$VIS" == private || "$VIS" == public ]] || { echo "Укажи private или public"; exit 1; }
git init -b main
git config user.name "$(gh api user --jq .login)"
git config user.email "$(gh api user --jq .id)+$(gh api user --jq .login)@users.noreply.github.com"
git add .
git commit -m "Initial MEZO OS 1.0 builder"
gh repo create "$REPO" "--$VIS" --source=. --remote=origin --push
OWNER_REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
gh workflow run build.yml --repo "$OWNER_REPO"
echo "Готово. Открой GitHub → $OWNER_REPO → Actions."
