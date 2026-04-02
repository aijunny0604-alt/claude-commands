# 보안 에이전트 팀 - PDCA 보안 점검

당신은 보안 에이전트 팀 리더입니다. 3개 전문 에이전트 팀을 **동시에** 출동시켜 PDCA 사이클로 보안 점검 → 수정 → 재점검을 **90점 이상**이 될 때까지 자동 반복합니다.

인자: $ARGUMENTS (점검 범위: "전체" 또는 특정 영역)

---

## PDCA 사이클 개요

```
Plan(점검계획) → Do(3팀 동시 점검) → Check(점수화+분석) → Act(수정) → 재점검...
    ↑                                                          |
    └──────────── 90점 미만이면 반복 (최대 3회) ───────────────┘
```

---

## Phase 1: PLAN (점검 계획)

### 1-1. 프로젝트 기술 스택 파악
- 프레임워크, ORM, 인증 방식, 미들웨어 확인
- package.json 의존성 확인

### 1-2. 점검 계획서 저장
파일: `docs/03-analysis/security-plan-{날짜}.md`

---

## Phase 2: DO (3개 에이전트 팀 동시 출동)

### 팀 1: 보안 아키텍트 (security-architect 에이전트)
OWASP Top 10 기준 전체 취약점 스캔:
- Injection (SQL, NoSQL, Command)
- Broken Authentication (세션, 비밀번호, OAuth)
- Sensitive Data Exposure (환경변수, 토큰, 키)
- Broken Access Control (미들웨어, API 보호)
- Security Misconfiguration (CORS, 헤더, 에러 노출)
- XSS (사용자 입력 검증)
- CSRF 보호
- 레이트리밋 효과
- 쿠키 보안 (httpOnly, secure, sameSite)
- 입력 검증 커버리지 (Zod 적용 여부)

심각도 등급 (Critical/High/Medium/Low)과 파일:줄번호 포함 보고.

### 팀 2: 코드 분석반 (code-analyzer 에이전트)
전체 API 보안 코드 리뷰:
- 하드코딩된 시크릿/비밀번호
- eval(), dangerouslySetInnerHTML 등 위험 패턴
- 에러 메시지 내부 정보 노출
- SSRF 위험 (서버사이드 fetch)
- DELETE/PUT 권한 검증
- npm audit 실행
- 입력 검증 없는 API 목록화

### 팀 3: 트렌드 조사반 (general-purpose 에이전트, 웹 검색)
현재 사용 중인 패키지의 CVE 조사:
- 프레임워크 최신 CVE
- ORM 보안 이슈
- 기타 의존성 보안 권고
- 최신 웹앱 보안 트렌드

---

## Phase 3: CHECK (점수화 + 분석)

### 3-1. 3팀 결과 종합 → 보안 점수 산출 (100점 만점)
| 감점 기준 | 점수 |
|----------|------|
| Critical 1건당 | -15점 |
| High 1건당 | -8점 |
| Medium 1건당 | -3점 |
| Low 1건당 | -1점 |

### 3-2. 분석 결과 저장
파일: `docs/03-analysis/security-result-{날짜}.md`

```
## 보안 점수: XX/100

### CRITICAL (즉시 수정)
- ❌ [문제] — 파일:줄 — 수정방안

### HIGH (1일 이내)
- ⚠️ [문제] — 파일:줄 — 수정방안

### MEDIUM (1주 이내)
- 🔶 [문제] — 수정방안

### LOW
- 💡 [문제] — 수정방안

### 긍정적 발견
- ✅ [잘 되어있는 것]
```

### 3-3. 판정
- **90점 이상 + Critical 0건**: Phase 5(보고서)로
- **90점 미만 또는 Critical 있음**: Phase 4(Act)로

---

## Phase 4: ACT (자동 수정 + 재점검)

**최대 3회 반복. 사용자 확인 후 진행.**

### 4-1. Critical/High 자동 수정
- Critical → 즉시 수정
- High → 즉시 수정
- Medium → 사용자 확인 후 수정

### 4-2. 빌드 확인 + 커밋
```bash
npx next build
git commit -m "fix: 보안 취약점 수정 (PDCA Act #{반복횟수})"
```

### 4-3. 재점검 (에이전트 재투입)
수정된 항목만 재스캔 → 점수 재산출

### 4-4. 재판정
- 90점 이상 + Critical 0건 → Phase 5
- 미달 + 반복 < 3 → Phase 4 반복
- 반복 >= 3 → 강제 Phase 5 (미해결 포함)

---

## Phase 5: REPORT (최종 보고서)

파일: `docs/04-report/security-report-{날짜}.md`

```markdown
## PDCA 보안 점검 보고서

### 점수 변화
| 회차 | 점수 | Critical | High | Medium | Low |
|------|------|----------|------|--------|-----|
| 1차 | 65/100 | 2 | 3 | 5 | 4 |
| 2차 | 92/100 | 0 | 0 | 3 | 4 |

### 수정 이력
- ✅ [취약점] — 수정 방법 — 커밋 해시

### 미해결 (있을 경우)
- ⚠️ [취약점] — 사유 — 권장 조치

### 최종 판정: ✅ 보안 점수 XX/100
```

---

## 핵심 규칙

1. **PDCA 자동 반복**: 90점 미만 시 수정 → 재점검 최대 3회
2. **Critical은 반드시 0건**: Critical이 남아있으면 PASS 불가
3. **문서화 필수**: 계획서, 분석 결과, 보고서 모두 docs/ 저장
4. **수정 후 빌드 필수**: `npx next build` 통과 확인
5. **Phase별 커밋**: 수정 단위로 커밋
