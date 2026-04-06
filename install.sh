#!/bin/bash
# Claude Code 커스텀 에이전트 v2.1 + 스킬 + Hooks 통합 설치

set -e

REPO="https://github.com/aijunny0604-alt/claude-commands.git"
CMD_TARGET="$HOME/.claude/commands"
SKILL_TARGET="$HOME/.claude/skills"
SETTINGS="$HOME/.claude/settings.json"
TMP_DIR="/tmp/claude-commands-install"

echo "================================================"
echo "  Claude Code 커스텀 에이전트 v2.1 통합 설치"
echo "  커맨드 + 스킬 + 자동 추천 Hooks"
echo "================================================"
echo ""

# 임시 디렉토리 정리
rm -rf "$TMP_DIR" 2>/dev/null

# 클론
echo "[1/5] 최신 에이전트 다운로드 중..."
git clone --quiet "$REPO" "$TMP_DIR"

# 커맨드 설치
echo "[2/5] 커맨드 에이전트 설치 중..."
mkdir -p "$CMD_TARGET"
cmd_count=0
for f in "$TMP_DIR"/*.md; do
  filename=$(basename "$f")
  cp "$f" "$CMD_TARGET/$filename"
  cmd_count=$((cmd_count + 1))
done
echo "     -> ${cmd_count}개 커맨드 설치됨"

# 스킬 설치
echo "[3/5] 스킬 설치 중..."
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

# Hooks 설치 (settings.json에 병합)
echo "[4/5] 자동 추천 Hooks 설치 중..."
HOOKS_FILE="$TMP_DIR/hooks/auto-recommend.json"
if [ -f "$HOOKS_FILE" ]; then
  if [ -f "$SETTINGS" ]; then
    # settings.json이 이미 있으면 hooks가 있는지 확인
    if grep -q '"hooks"' "$SETTINGS" 2>/dev/null; then
      echo "     -> settings.json에 이미 hooks 있음 (덮어쓰지 않음)"
      echo "     -> 최신 hooks: $TMP_DIR/hooks/auto-recommend.json 참고"
    else
      # hooks가 없으면 마지막 } 앞에 추가
      HOOKS_CONTENT=$(cat "$HOOKS_FILE" | sed '1d' | sed '$d')
      # 마지막 } 앞에 콤마 + hooks 삽입
      sed -i '$ d' "$SETTINGS"
      echo "  ," >> "$SETTINGS"
      echo "$HOOKS_CONTENT" >> "$SETTINGS"
      echo "}" >> "$SETTINGS"
      echo "     -> settings.json에 자동 추천 hooks 추가됨"
    fi
  else
    # settings.json이 없으면 새로 생성
    mkdir -p "$(dirname "$SETTINGS")"
    echo '{' > "$SETTINGS"
    cat "$HOOKS_FILE" | sed '1d' | sed '$d' >> "$SETTINGS"
    echo '}' >> "$SETTINGS"
    echo "     -> settings.json 생성 + hooks 추가됨"
  fi
else
  echo "     -> hooks 파일 없음 (스킵)"
fi

# 정리
echo "[5/5] 정리 중..."
rm -rf "$TMP_DIR"

echo ""
echo "================================================"
echo "  설치 완료!"
echo ""
echo "  커맨드: ${cmd_count}개 -> $CMD_TARGET"
echo "  스킬:   ${skill_count}개 -> $SKILL_TARGET"
echo "  Hooks:  자동 추천 설정됨"
echo ""
echo "  /help          전체 에이전트 목록"
echo "  /app-plan      앱 기획 인터뷰 스킬"
echo ""
echo "  자동 추천 Hook 동작:"
echo "  코드 수정 시 -> /change-verify /quick-fix /doc-sync"
echo "  git commit 시 -> /pre-deploy /doc-sync"
echo "  빌드 시      -> /pre-deploy /security-quick"
echo "  DB 작업 시   -> /db-health"
echo "================================================"
