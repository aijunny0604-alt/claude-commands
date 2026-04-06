#!/bin/bash
# Claude Code 커스텀 에이전트 v2.1 + 스킬 설치 스크립트

set -e

REPO="https://github.com/aijunny0604-alt/claude-commands.git"
CMD_TARGET="$HOME/.claude/commands"
SKILL_TARGET="$HOME/.claude/skills"
TMP_DIR="/tmp/claude-commands-install"

echo "================================================"
echo "  Claude Code 커스텀 에이전트 v2.1 설치"
echo "  + 스킬 통합 패키지"
echo "================================================"
echo ""

# 임시 디렉토리 정리
rm -rf "$TMP_DIR" 2>/dev/null

# 클론
echo "[1/4] 최신 에이전트 다운로드 중..."
git clone --quiet "$REPO" "$TMP_DIR"

# 커맨드 설치
echo "[2/4] 커맨드 에이전트 설치 중..."
mkdir -p "$CMD_TARGET"
cmd_count=0
for f in "$TMP_DIR"/*.md; do
  filename=$(basename "$f")
  cp "$f" "$CMD_TARGET/$filename"
  cmd_count=$((cmd_count + 1))
done
echo "     -> ${cmd_count}개 커맨드 설치됨"

# 스킬 설치
echo "[3/4] 스킬 설치 중..."
skill_count=0
if [ -d "$TMP_DIR/skills" ]; then
  for skill_dir in "$TMP_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$SKILL_TARGET/$skill_name"
    cp -r "$skill_dir"* "$SKILL_TARGET/$skill_name/"
    skill_count=$((skill_count + 1))
    echo "     -> 스킬: $skill_name"
  done
fi
echo "     -> ${skill_count}개 스킬 설치됨"

# 정리
echo "[4/4] 정리 중..."
rm -rf "$TMP_DIR"

echo ""
echo "================================================"
echo "  설치 완료!"
echo ""
echo "  커맨드: ${cmd_count}개 -> $CMD_TARGET"
echo "  스킬:   ${skill_count}개 -> $SKILL_TARGET"
echo ""
echo "  커맨드: /help 로 목록 확인"
echo "  스킬:   '앱 기획' 또는 /app-plan 으로 사용"
echo "================================================"
