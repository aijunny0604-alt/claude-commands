#!/bin/bash
# Claude Code 커스텀 에이전트 + Hook 설치 스크립트 v2.1

set -e

REPO="https://github.com/aijunny0604-alt/claude-commands.git"
COMMANDS_TARGET="$HOME/.claude/commands"
HOOKS_TARGET="$HOME/.claude/hooks"
SETTINGS_FILE="$HOME/.claude/settings.json"
TMP_DIR="/tmp/claude-commands-install"

echo "================================================"
echo "  Claude Code 커스텀 에이전트 v2.1 설치"
echo "  (에이전트 + Hook + Settings 통합)"
echo "================================================"
echo ""

# 임시 디렉토리 정리
rm -rf "$TMP_DIR" 2>/dev/null

# 클론
echo "[1/4] 최신 파일 다운로드 중..."
git clone --quiet "$REPO" "$TMP_DIR"

# 에이전트 설치
echo "[2/4] 에이전트(.md) 설치 중..."
mkdir -p "$COMMANDS_TARGET"
count=0
for f in "$TMP_DIR"/*.md; do
  filename=$(basename "$f")
  cp "$f" "$COMMANDS_TARGET/$filename"
  count=$((count + 1))
done
echo "      ${count}개 에이전트 설치 완료"

# Hook 스크립트 설치
echo "[3/4] Hook 스크립트 설치 중..."
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
echo "      ${hook_count}개 hook 스크립트 설치 완료"

# settings.json 안내
echo "[4/4] Settings 구성..."
if [ -f "$SETTINGS_FILE" ]; then
  if grep -q "pre-deploy-check.sh" "$SETTINGS_FILE" 2>/dev/null; then
    echo "      ✅ settings.json에 hook이 이미 등록되어 있습니다"
  else
    echo "      ⚠️  settings.json에 hook을 수동으로 추가해야 합니다"
    echo ""
    echo "      $HOME/.claude/settings.json 파일의 hooks 섹션에 다음을 추가:"
    echo ""
    cat "$TMP_DIR/hooks/settings-hooks-sample.json" 2>/dev/null || cat <<'EOF'
      "PreToolUse": [
        {
          "matcher": "Bash",
          "hooks": [
            { "type": "command", "command": "bash ~/.claude/hooks/pre-deploy-check.sh" }
          ]
        }
      ],
      "PostToolUse": [
        {
          "matcher": "Bash",
          "hooks": [
            { "type": "command", "command": "bash ~/.claude/hooks/post-deploy-check.sh" }
          ]
        }
      ]
EOF
  fi
else
  echo "      ⚠️  $SETTINGS_FILE 파일이 없습니다. Claude Code 실행 후 다시 시도하세요."
fi

# 정리
rm -rf "$TMP_DIR"

echo ""
echo "================================================"
echo "  설치 완료!"
echo "  - 에이전트: $COMMANDS_TARGET (${count}개)"
echo "  - Hook 스크립트: $HOOKS_TARGET (${hook_count}개)"
echo ""
echo "  사용법:"
echo "  - /help            에이전트 목록 확인"
echo "  - /pre-deploy      배포 전 체크리스트"
echo "  - /change-verify   변경사항 정밀 검증"
echo ""
echo "  Hook (자동): git push 시 [deploy] 태그면 빌드 체크"
echo "================================================"
