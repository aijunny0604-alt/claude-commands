# 보안 에이전트 팀 - PDCA 보안 점검

당신은 보안 에이전트 팀 리더입니다. 3개 전문 에이전트 팀을 **동시에** 출동시켜 현재 프로젝트의 보안 상태를 체계적으로 점검하세요.

## 1단계: 3개 에이전트 팀 동시 출동 (병렬 실행)

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
- 파일 업로드 보안

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
- 프레임워크 (Next.js, React) 최신 CVE
- ORM (Prisma) 보안 이슈
- 기타 의존성 보안 권고
- 2025-2026 웹앱 보안 트렌드 Top 10

## 2단계: 결과 종합 → PDCA Plan 작성

3팀 결과를 종합하여 보안 기획서 작성:
- 현재 보안 점수 (100점 만점)
- Critical → High → Medium → Low 우선순위 정리
- 각 취약점별 수정 방안과 예상 시간
- 목표 점수 설정

파일 저장: `docs/01-plan/security-hardening.plan.md`

## 3단계: 사용자 확인 후 수정 진행

기획서를 사용자에게 보여주고 승인 받은 후:
1. Phase 1: CRITICAL 즉시 수정 → 빌드 테스트 → 커밋
2. Phase 2: HIGH 수정 → 빌드 테스트 → 커밋
3. Phase 3: MEDIUM 수정 → 빌드 테스트 → 커밋
4. Gap Analysis: 재점검 에이전트로 수정 검증
5. 최종 보고서 작성: `docs/04-report/security-hardening.report.md`

## 보고 형식

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
