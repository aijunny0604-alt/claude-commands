#!/bin/bash
# Post-deploy hook: git push 후 프로덕션 헬스체크 알림

# git push가 아니면 스킵
if [[ "$CLAUDE_TOOL_INPUT" != *"git push"* ]]; then
  exit 0
fi

# [deploy] 태그가 없으면 스킵
COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null)
if [[ "$COMMIT_MSG" != *"[deploy]"* ]]; then
  exit 0
fi

echo '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"[AUTO] [deploy] push 완료. 45초 후 프로덕션 헬스체크 실행: 9페이지 HTTP 200 확인"}}'
