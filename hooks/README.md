# Claude Code Hooks

Claude Code의 이벤트 기반 자동화 스크립트 모음입니다.

## 포함된 Hook

### 1. pre-deploy-check.sh
**트리거**: `PreToolUse` (Bash)
**작동 조건**: `git push` + 커밋 메시지에 `[deploy]` 태그 포함

**기능**:
- `npx next build` 자동 실행 → 실패 시 push 차단
- `npx tsc --noEmit` 자동 실행 → 타입 에러 시 push 차단
- 통과 시만 push 허용

### 2. post-deploy-check.sh
**트리거**: `PostToolUse` (Bash)
**작동 조건**: `git push` 후 + `[deploy]` 태그 커밋

**기능**:
- push 완료 알림
- "프로덕션 헬스체크 실행하세요" 컨텍스트 추가
- Claude가 자동으로 프로덕션 9페이지 200 체크

### 3. save-conversation.sh
**트리거**: `SessionEnd`
**기능**: 세션 종료 시 대화 내용 저장

## 설치 방법

`install.sh` 스크립트가 자동으로 설치합니다:
```bash
curl -sSL https://raw.githubusercontent.com/aijunny0604-alt/claude-commands/master/install.sh | bash
```

## 수동 설치

1. 스크립트 복사:
```bash
mkdir -p ~/.claude/hooks
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

2. `~/.claude/settings.json`에 `settings-hooks-sample.json`의 `hooks` 섹션 내용 추가

## 동작 예시

```
사장님이 커밋 + push
  ↓
git commit -m "fix: 버그 수정 [deploy]"
git push origin master
  ↓
[PreToolUse hook 자동 실행]
  - npx next build ✅
  - npx tsc --noEmit ✅
  - 통과 → push 허용
  ↓
push 완료
  ↓
[PostToolUse hook 자동 실행]
  - "프로덕션 헬스체크 실행하세요" 알림
  ↓
Claude가 자동으로 9페이지 HTTP 200 체크
```

## 주의사항

- Windows에서 `$CLAUDE_TOOL_INPUT` 환경변수로 명령어 감지
- `[deploy]` 태그 없는 커밋은 hook이 작동하지 않음 (일반 commit 영향 없음)
- 일반 Bash 명령어(npm install, ls 등)는 즉시 통과
