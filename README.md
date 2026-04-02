# Claude Code 커스텀 명령 모음

Claude Code에서 사용할 수 있는 PDCA 기반 커스텀 슬래시 명령 모음입니다.

## 설치 방법

```bash
git clone https://github.com/aijunny0604-alt/claude-commands.git
cp claude-commands/*.md ~/.claude/commands/
```

## 명령 목록

| 명령 | PDCA | 설명 |
|------|:----:|------|
| `/full-test` | ✅ | 4개 에이전트 팀 대규모 통합 테스트 (로컬+프로덕션) |
| `/security-team` | ✅ | 3개 에이전트 팀 OWASP Top 10 보안 점검 |
| `/security-quick` | ✅ | 1인 경량 보안 점검 (5분) |
| `/mobile-audit` | ✅ | 4개 에이전트 팀 모바일 UI/UX 최적화 |
| `/responsive-check` | ✅ | 3개 해상도 반응형 자동 점검 |
| `/pre-deploy` | ✅ | 배포 전 자동 체크리스트 (빌드+타입+DB) |
| `/quick-fix` | ✅ | 빠른 버그 수정 (원인 추적→수정→검증) |
| `/check-pos` | - | POS Calculator 앱 점검 |

## PDCA 사이클

모든 스킬은 PDCA(Plan-Do-Check-Act) 방식으로 작동합니다:
1. **Plan**: 점검 계획 수립 + 대상 파악
2. **Do**: 에이전트 팀 동시 투입 실행
3. **Check**: 결과 분석 + 점수화 (90점 기준)
4. **Act**: 90점 미만 시 자동 수정 → 재점검 (최대 3회 반복)

## 사용법

```
/full-test 예약 mileage   # 특정 기능 대규모 테스트
/full-test 전체            # 전체 기능 테스트
/security-team             # 전체 보안 점검
/security-quick            # 빠른 보안 점검
/mobile-audit              # 모바일 최적화 점검
/responsive-check          # 반응형 점검
/pre-deploy production     # 배포 전 체크리스트
/quick-fix 로그인 안됨     # 빠른 버그 수정
```

## 파일 위치

- **모든 프로젝트에서 사용**: `~/.claude/commands/` 에 복사
- **특정 프로젝트에서만 사용**: `프로젝트/.claude/commands/` 에 복사
