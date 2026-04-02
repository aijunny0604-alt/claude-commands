# 빠른 보안 점검 - PDCA 경량 사이클

현재 프로젝트의 보안 상태를 **1인 에이전트**로 빠르게 점검합니다. Critical/High 발견 시 즉시 수정하는 경량 PDCA.

인자: $ARGUMENTS (점검 범위: "전체" 또는 특정 영역)

---

## PDCA 경량 사이클

```
Plan(5초) → Do(점검) → Check(점수) → Act(Critical만 수정) → 완료
```

## Phase 1: PLAN
프로젝트 기술 스택과 최근 변경 파일 빠르게 파악.

## Phase 2: DO (1인 점검)
아래 항목을 순서대로 빠르게 점검:

1. **인증/세션**: 하드코딩 비밀번호, 세션 토큰 안전성, 인증 체크 방식
2. **API 보호**: 미들웨어 인증, 레이트리밋, 공개 경로
3. **입력 검증**: Zod/validation 적용 여부 (적용 O/X 목록)
4. **보안 헤더**: HSTS, CSP, X-Frame-Options 등
5. **민감 데이터**: .env 파일, 하드코딩 키/시크릿
6. **위험 패턴**: eval, dangerouslySetInnerHTML, 에러 메시지 노출

## Phase 3: CHECK (점수화)
100점 만점. 발견된 문제를 심각도순으로 5개 이내 요약.

```
## 보안 빠른 점검: XX/100
- ❌ Critical: [N건]
- ⚠️ High: [N건]
- 🔶 Medium: [N건]
```

## Phase 4: ACT (Critical만 즉시 수정)
- Critical 발견 시 → 즉시 코드 수정 → 빌드 확인
- High 이하 → 보고만 (`/security-team`으로 전체 점검 권장)

## 보고 형식
```
보안 점수: XX/100
Critical: N건 (수정됨/미수정)
High: N건
권장: [전체 점검 필요 여부]
```

## 규칙
1. **5분 이내** 완료 목표
2. Critical 발견 시만 코드 수정
3. 전체 점검이 필요하면 `/security-team` 안내
