#!/bin/bash
# Claude Code 커스텀 에이전트 업데이트 스크립트
# 기존 설치를 최신 버전으로 덮어쓰기

set -e

REPO="https://github.com/aijunny0604-alt/claude-commands.git"
COMMANDS_TARGET="$HOME/.claude/commands"
HOOKS_TARGET="$HOME/.claude/hooks"
TMP_DIR="/tmp/claude-commands-update"

echo "================================================"
echo "  Claude Code 에이전트 업데이트"
echo "================================================"
echo ""

# 임시 디렉토리 정리
rm -rf "$TMP_DIR" 2>/dev/null

# 최신 클론
echo "[1/3] 최신 버전 다운로드 중..."
git clone --quiet "$REPO" "$TMP_DIR"

# 에이전트 업데이트
echo "[2/3] 에이전트 업데이트 중..."
mkdir -p "$COMMANDS_TARGET"
count=0
for f in "$TMP_DIR"/*.md; do
  filename=$(basename "$f")
  cp "$f" "$COMMANDS_TARGET/$filename"
  count=$((count + 1))
done
echo "      ${count}개 에이전트 업데이트 완료"

# Hook 업데이트
echo "[3/3] Hook 스크립트 업데이트 중..."
mkdir -p "$HOOKS_TARGET"
hook_count=0
if [ -d "$TMP_DIR/hooks" ]; then
  for f in "$TMP_DIR/hooks"/*.sh; do
    if [ -f "$f" ]; then
      filename=$(basename "$f")
      cp "$f" "$HOOKS_TARGET/$filename"
      chmod +x "$HOOKS_TARGET/$filename"
      hook_count=$((hook_count + 1))
    fi
  done
fi
echo "      ${hook_count}개 hook 업데이트 완료"

# 정리
rm -rf "$TMP_DIR"

echo ""
echo "================================================"
echo "  ✅ 업데이트 완료!"
echo "  - 에이전트: ${count}개"
echo "  - Hook: ${hook_count}개"
echo ""
echo "  Claude Code 재시작 후 최신 버전이 적용됩니다."
echo "================================================"
