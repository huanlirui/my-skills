#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/huanlirui/my-skills.git"
INSTALL_BASE="${HOME}/.local/share"
INSTALL_DIR="${INSTALL_BASE}/my-skills"
TARGET="cursor"

usage() {
  cat <<'EOF'
Install my-skills to Cursor, Codex, or Claude by symlinking all skills.

Usage:
  install.sh [--target cursor|codex|claude] [--dir INSTALL_DIR]

Options:
  --target  Install target. Default: cursor
  --dir     Local repo install dir. Default: ~/.local/share/my-skills
  -h, --help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --)
      shift
      ;;
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --dir)
      INSTALL_DIR="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

case "$TARGET" in
  cursor)
    SKILL_HOME="${HOME}/.cursor/skills"
    ;;
  codex)
    if [[ -z "${CODEX_HOME:-}" ]]; then
      SKILL_HOME="${HOME}/.codex/skills"
    else
      SKILL_HOME="${CODEX_HOME}/skills"
    fi
    ;;
  claude)
    SKILL_HOME="${HOME}/.claude/skills"
    ;;
  *)
    echo "Invalid --target: ${TARGET}. Expected cursor|codex|claude" >&2
    exit 1
    ;;
esac

if ! command -v git >/dev/null 2>&1; then
  echo "git is required but not found." >&2
  exit 1
fi

mkdir -p "${INSTALL_BASE}" "${SKILL_HOME}"

if [[ -d "${INSTALL_DIR}/.git" ]]; then
  echo "Updating existing repo: ${INSTALL_DIR}"
  git -C "${INSTALL_DIR}" pull --ff-only
else
  echo "Cloning repo to: ${INSTALL_DIR}"
  rm -rf "${INSTALL_DIR}"
  git clone "${REPO_URL}" "${INSTALL_DIR}"
fi

shopt -s nullglob
count=0
for d in "${INSTALL_DIR}"/skills/*/; do
  [[ -f "${d}/SKILL.md" ]] || continue
  name="$(basename "${d}")"
  ln -sfn "${d}" "${SKILL_HOME}/${name}"
  count=$((count + 1))
done
shopt -u nullglob

echo "Installed ${count} skills to ${SKILL_HOME} (target=${TARGET})."
echo "Done."
