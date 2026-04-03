#!/bin/bash
# Claude Code 커스텀 에이전트 v2.0 설치 스크립트

set -e

REPO="https://github.com/aijunny0604-alt/claude-commands.git"
TARGET="$HOME/.claude/commands"
TMP_DIR="/tmp/claude-commands-install"

echo "================================================"
echo "  Claude Code 커스텀 에이전트 v2.0 설치"
echo "================================================"
echo ""

# 임시 디렉토리 정리
rm -rf "$TMP_DIR" 2>/dev/null

# 클론
echo "[1/3] 최신 에이전트 다운로드 중..."
git clone --quiet "$REPO" "$TMP_DIR"

# 설치 디렉토리 생성
echo "[2/3] 설치 중..."
mkdir -p "$TARGET"

# .md 파일만 복사 (install.sh, README 등 제외)
count=0
for f in "$TMP_DIR"/*.md; do
  filename=$(basename "$f")
  if [ "$filename" != "README.md" ]; then
    cp "$f" "$TARGET/$filename"
    count=$((count + 1))
  fi
done

# README도 복사 (참고용)
cp "$TMP_DIR/README.md" "$TARGET/README.md"
count=$((count + 1))

# 정리
echo "[3/3] 정리 중..."
rm -rf "$TMP_DIR"

echo ""
echo "================================================"
echo "  설치 완료!"
echo "  ${count}개 에이전트가 $TARGET 에 설치되었습니다."
echo ""
echo "  Claude Code에서 /help 로 목록을 확인하세요!"
echo "================================================"
