#!/usr/bin/env bash
# Auto Git Push: initialize if needed, commit & push with nice UX

set -e

# --- Colors ---
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # No Color

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Git Push" "$1"
    fi
}

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; notify "$1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Check Git ---
if ! command -v git >/dev/null 2>&1; then
    error "Git is not installed. Please install git first."
fi

if [ ! -d .git ]; then
    warn "No .git directory found. Initializing repository..."
    git init || error "Failed to initialize git."
    default_branch="main"
    git branch -M "$default_branch"

    info "Enter SSH remote (e.g. git@github.com:user/repo.git):"
    read -r remote
    [ -z "$remote" ] && error "No remote URL provided. Aborting."
    git remote add origin "$remote" || error "Failed to add remote."
    success "Repository initialized with remote $remote"
fi

# --- Ensure remote is set ---
if ! git remote get-url origin >/dev/null 2>&1; then
    info "No remote named 'origin'. Please enter SSH URL:"
    read -r remote
    [ -z "$remote" ] && error "No remote URL provided. Aborting."
    git remote add origin "$remote" || error "Failed to add remote."
    success "Remote 'origin' set to $remote"
fi

# --- Commit & Push ---
msg="${1:-Auto commit on $(date '+%Y-%m-%d %H:%M:%S')}"

info "Staging changes..."
git add . || error "Failed to add files."

if git diff --cached --quiet; then
    warn "No changes to commit."
    exit 0
fi

info "Committing with message: $msg"
git commit -m "$msg" || error "Commit failed."

branch=$(git rev-parse --abbrev-ref HEAD)
info "Pushing to branch $branch..."
git push -u origin "$branch" && success "Pushed successfully!"

