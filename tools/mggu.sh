#!/usr/bin/env bash
set -euo pipefail

[[ -t 1 ]] && BOLD=$'\033[1m' GREEN=$'\033[32m' CYAN=$'\033[36m' RED=$'\033[31m' RESET=$'\033[0m' \
            || BOLD=''         GREEN=''           CYAN=''           RED=''           RESET=''

info()  { printf "  ${CYAN}›${RESET} %s\n" "$*"; }
error() { printf "  ${RED}✗${RESET} ${BOLD}%s${RESET}\n" "$*" >&2; }

[[ $# -lt 1 ]] && { error "Usage: $0 [workspace-root]"; exit 1; }

URL="https://raw.githubusercontent.com/transicle/MGGU-LLM-NoCode-Prompt/refs/heads/main/SKILL.md"
SKILLS_DIR="${1:-$PWD}/.github/skills"

printf "\n${BOLD}Installing Copilot skill${RESET}\n\n"
info "Getting skill from repo..."
CONTENT="$(curl -fsSL "$URL")"

SKILL_NAME="$(printf '%s\n' "$CONTENT" | awk '
  /^---/ { h++; next } h==1 && /^name:/ { gsub(/^name:[[:space:]]*/, ""); print; exit }
')"

[[ -z "$SKILL_NAME" ]] && { error "Could not find 'name:' in skill frontmatter."; exit 1; }

TARGET="$SKILLS_DIR/$SKILL_NAME/SKILL.md"
[[ -e "$TARGET" ]] && { error "Skill '${SKILL_NAME}' already exists."; exit 1; }

info "Saving as a new Copilot skill..."
mkdir -p "$(dirname "$TARGET")"
printf '%s\n' "$CONTENT" > "$TARGET"

printf "\n${GREEN}${BOLD}Done!${RESET} New Copilot skill ${BOLD}${CYAN}${SKILL_NAME}${RESET} installed.\n\n"
