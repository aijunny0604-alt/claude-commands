#!/bin/bash
# Pre-deploy hook: git push 전 빌드+타입 자동 체크
# [deploy] 커밋의 git push만 체크, 그 외는 모두 통과

# git push가 아니면 즉시 통과
if [[ "$CLAUDE_TOOL_INPUT" != *"git push"* ]]; then
  echo '{"decision":"approve"}'
  exit 0
fi

# 최신 커밋 메시지 확인
COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null)

# [deploy] 태그가 없으면 스킵
if [[ "$COMMIT_MSG" != *"[deploy]"* ]]; then
  echo '{"decision":"approve"}'
  exit 0
fi

# 빌드 체크
npx next build > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo '{"decision":"block","reason":"BUILD FAILED - push 차단. 빌드 에러를 수정하세요."}'
  exit 0
fi

# 타입 체크
npx tsc --noEmit > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo '{"decision":"block","reason":"TYPE ERROR - push 차단. TypeScript 에러를 수정하세요."}'
  exit 0
fi

echo '{"decision":"approve","reason":"Pre-deploy PASSED (build + type)"}'
