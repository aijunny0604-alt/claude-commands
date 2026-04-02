# Claude Code 커스텀 명령 모음

Claude Code에서 사용할 수 있는 PDCA 기반 커스텀 슬래시 명령 모음입니다.

## 설치 방법

```bash
git clone https://github.com/aijunny0604-alt/claude-commands.git
cp claude-commands/*.md ~/.claude/commands/
```

## 명령 목록

### 테스트 & QA

| 명령 | PDCA | 에이전트 | 설명 |
|------|:----:|:--------:|------|
| `/full-test` | ✅ | 4팀 | 대규모 통합 테스트 (로컬+프로덕션 API) |
| `/ux-flow` | ✅ | 2팀 | 사용자 시나리오 E2E Playwright 검증 |

### 보안

| 명령 | PDCA | 에이전트 | 설명 |
|------|:----:|:--------:|------|
| `/security-team` | ✅ | 3팀 | OWASP Top 10 보안 풀 스캔 |
| `/security-quick` | ✅ | 1인 | 경량 보안 점검 (5분) |

### UI/UX

| 명령 | PDCA | 에이전트 | 설명 |
|------|:----:|:--------:|------|
| `/mobile-audit` | ✅ | 4팀 | 모바일 UI/UX 최적화 점검 |
| `/responsive-check` | ✅ | 3해상도 | 멀티 해상도 반응형 점검 |
| `/a11y-check` | ✅ | 2팀 | WCAG 2.1 접근성 점검 |

### 성능 & DB

| 명령 | PDCA | 에이전트 | 설명 |
|------|:----:|:--------:|------|
| `/perf-audit` | ✅ | 3팀 | Core Web Vitals + 번들 + API 성능 |
| `/db-health` | ✅ | 2팀 | Prisma 스키마 + 쿼리 최적화 |

### 코드 품질

| 명령 | PDCA | 에이전트 | 설명 |
|------|:----:|:--------:|------|
| `/code-health` | ✅ | 3팀 | 중복/복잡도/미사용 코드 기술 부채 관리 |

### 배포 & 버그

| 명령 | PDCA | 에이전트 | 설명 |
|------|:----:|:--------:|------|
| `/pre-deploy` | ✅ | 1인 | 배포 전 자동 체크리스트 (빌드+타입+DB) |
| `/quick-fix` | ✅ | 1인 | 빠른 버그 수정 (원인 추적→수정→검증) |

### 기타

| 명령 | PDCA | 설명 |
|------|:----:|------|
| `/check-pos` | - | POS Calculator 앱 점검 |
| `/help` | - | 명령 목록 표시 |

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
/a11y-check                # 접근성 점검
/perf-audit                # 성능 점검
/db-health                 # DB 건강 점검
/code-health               # 코드 품질 점검
/ux-flow                   # UX 시나리오 E2E
/pre-deploy production     # 배포 전 체크리스트
/quick-fix 로그인 안됨     # 빠른 버그 수정
```

## 파일 위치

- **모든 프로젝트에서 사용**: `~/.claude/commands/` 에 복사
- **특정 프로젝트에서만 사용**: `프로젝트/.claude/commands/` 에 복사
