# 커스텀 스킬 도움말

현재 사용 가능한 커스텀 스킬 목록을 보여주세요.

## 커스텀 스킬 목록

| 명령어 | 용도 | PDCA | 에이전트 | 설명 |
|--------|------|:----:|:--------:|------|
| `/full-test` | 대규모 통합 테스트 | ✅ | 4팀 | 로컬+프로덕션 API 테스트 |
| `/ux-flow` | UX 시나리오 E2E | ✅ | 2팀 | Playwright 사용자 흐름 검증 |
| `/security-team` | 보안 팀 점검 | ✅ | 3팀 | OWASP Top 10 풀 스캔 |
| `/security-quick` | 빠른 보안 | ✅ | 1인 | 경량 보안 점검 (5분) |
| `/mobile-audit` | 모바일 최적화 | ✅ | 4팀 | 모바일 UI/UX 점검 |
| `/responsive-check` | 반응형 점검 | ✅ | 3해상도 | 멀티 해상도 자동 스크린샷 |
| `/a11y-check` | 접근성 점검 | ✅ | 2팀 | WCAG 2.1 접근성 검증 |
| `/perf-audit` | 성능 점검 | ✅ | 3팀 | Core Web Vitals + 번들 + API |
| `/db-health` | DB 건강 점검 | ✅ | 2팀 | Prisma 스키마 + 쿼리 최적화 |
| `/code-health` | 코드 품질 | ✅ | 3팀 | 중복/복잡도/미사용 코드 관리 |
| `/pre-deploy` | 배포 전 체크 | ✅ | 1인 | 빌드+타입+DB+환경변수 검증 |
| `/quick-fix` | 빠른 버그 수정 | ✅ | 1인 | 원인 추적→수정→검증 자동화 |
| `/check-pos` | POS 점검 | - | 1인 | POS Calculator 앱 전용 |
| `/help` | 도움말 | - | - | 이 목록 표시 |

### PDCA 사이클이란?
Plan(계획) → Do(실행) → Check(분석) → Act(수정) → 90점 이상까지 자동 반복

### 카테고리별 추천
- **기능 검증**: `/full-test` → `/ux-flow`
- **보안**: `/security-quick` → `/security-team`
- **UI/UX**: `/mobile-audit` → `/responsive-check` → `/a11y-check`
- **성능**: `/perf-audit` → `/db-health`
- **코드 관리**: `/code-health`
- **배포**: `/pre-deploy`
- **긴급**: `/quick-fix`

위 목록을 보기 좋게 표시하세요.
