# Claude Code 커스텀 명령 모음

Claude Code에서 사용할 수 있는 커스텀 슬래시 명령 모음입니다.

## 설치 방법

```bash
git clone https://github.com/aijunny0604-alt/claude-commands.git
cp claude-commands/*.md ~/.claude/commands/
```

## 명령 목록

| 명령 | 설명 |
|------|------|
| `/full-test` | 4개 에이전트 팀 대규모 통합 테스트 (로컬+프로덕션) |
| `/security-team` | 3개 에이전트 팀 동시 출동 PDCA 보안 점검 |
| `/security-quick` | 빠른 1인 보안 점검 (5분) |
| `/mobile-audit` | 4개 에이전트 팀 모바일 UI/UX 최적화 |
| `/responsive-check` | 3개 해상도 반응형 자동 점검 |
| `/check-pos` | POS 앱 오류 점검 |

## 사용법

Claude Code에서 슬래시(/)를 입력하면 명령 목록이 나타납니다.

```
/full-test 예약 mileage   # 특정 기능 대규모 테스트
/full-test 전체            # 전체 기능 테스트
/security-team             # 전체 보안 점검
/security-quick            # 빠른 보안 점검
/mobile-audit              # 모바일 최적화 점검
/responsive-check          # 반응형 점검
/check-pos                 # POS 앱 점검
```

## 파일 위치

- **모든 프로젝트에서 사용**: `~/.claude/commands/` 에 복사
- **특정 프로젝트에서만 사용**: `프로젝트/.claude/commands/` 에 복사
