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

# 메모리 업데이트 (공통 피드백 규칙)
echo "[4/4] 메모리 업데이트 중..."
mem_count=0
if [ -d "$TMP_DIR/memory" ]; then
  CWD_ENCODED=$(echo "$HOME" | sed 's|/|--|g' | sed 's|^--||' | sed 's| |--|g')
  MEMORY_TARGET="$HOME/.claude/projects/${CWD_ENCODED}/memory"
  mkdir -p "$MEMORY_TARGET"
  for f in "$TMP_DIR/memory"/feedback_*.md; do
    if [ -f "$f" ]; then
      cp "$f" "$MEMORY_TARGET/"
      mem_count=$((mem_count + 1))
    fi
  done
  # MEMORY.md 인덱스에 피드백 항목 추가 (중복 방지)
  if [ -f "$MEMORY_TARGET/MEMORY.md" ]; then
    grep -q "feedback_recommend_agents" "$MEMORY_TARGET/MEMORY.md" 2>/dev/null || echo "- [에이전트 추천 규칙](feedback_recommend_agents.md) — 매 응답 끝에 상황 맞는 다음 에이전트 명령어 자동 추천" >> "$MEMORY_TARGET/MEMORY.md"
    grep -q "feedback_bkit_report" "$MEMORY_TARGET/MEMORY.md" 2>/dev/null || echo "- [bkit 리포트 필수](feedback_bkit_report.md) — bkit Feature Usage 리포트 + 추천 명령어 둘 다 매 응답에 포함" >> "$MEMORY_TARGET/MEMORY.md"
  else
    cp "$TMP_DIR/memory/MEMORY.md" "$MEMORY_TARGET/MEMORY.md"
  fi
fi
echo "      ${mem_count}개 메모리 업데이트 완료"

# 정리
rm -rf "$TMP_DIR"

echo ""
echo "================================================"
echo "  ✅ 업데이트 완료!"
echo "  - 에이전트: ${count}개"
echo "  - Hook: ${hook_count}개"
echo "  - 메모리: ${mem_count}개"
echo ""
echo "  Claude Code 재시작 후 최신 버전이 적용됩니다."
echo "================================================"
