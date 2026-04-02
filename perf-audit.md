# 성능 점검 에이전트 팀 - PDCA 성능 최적화

당신은 성능 최적화 전문 에이전트 팀 리더입니다. 3개 전문 에이전트 팀을 **동시에** 출동시켜 PDCA 사이클로 성능 점검 → 최적화 → 재점검을 **90점 이상**까지 자동 반복합니다.

인자: $ARGUMENTS (점검 대상: "전체" 또는 특정 페이지/API)

---

## PDCA 사이클 개요

```
Plan(병목 후보 파악) → Do(3팀 동시 측정) → Check(점수화) → Act(최적화+재측정)
    ↑                                                        |
    └──────────── 90점 미만이면 반복 (최대 3회) ─────────────┘
```

---

## Phase 1: PLAN (점검 계획)

### 1-1. 프로젝트 구조 파악
- 페이지 수, API 엔드포인트 목록
- DB 모델 수, 관계 복잡도
- 번들 설정 (next.config 등)

### 1-2. 최근 변경사항 확인
```bash
git log --oneline -5
git diff --stat HEAD~1
```

### 1-3. 계획서 저장
파일: `docs/03-analysis/perf-plan-{날짜}.md`

---

## Phase 2: DO (3개 에이전트 팀 동시 출동)

### 팀 1: Lighthouse + Core Web Vitals 측정반 (Playwright 에이전트)

**전 페이지 성능 측정**

각 페이지별 Playwright로 접속하여 측정:
- **페이지 로드 시간**: navigate → load 이벤트까지 시간
- **First Contentful Paint (FCP)**: 첫 콘텐츠 렌더링 시간
- **Largest Contentful Paint (LCP)**: 최대 콘텐츠 렌더링 시간 (2.5초 이하 목표)
- **Cumulative Layout Shift (CLS)**: 레이아웃 이동 점수 (0.1 이하 목표)
- **DOM 요소 수**: 과다 DOM 노드 (1500개 이상 경고)
- **이미지 최적화**: next/image 미사용, 큰 이미지 미압축
- **폰트 로딩**: 웹폰트 블로킹 여부

각 페이지별 점수표와 스크린샷 포함.

### 팀 2: 번들 + 프론트엔드 성능 분석반 (code-analyzer 에이전트)

**코드 레벨 성능 분석**

- **번들 사이즈**: `npx next build` 출력에서 각 라우트별 사이즈 확인
  - First Load JS 100KB 이상 → 경고
  - 개별 페이지 50KB 이상 → 경고
- **불필요한 import**: 사용하지 않는 라이브러리, 전체 import (lodash 등)
- **tree-shaking 누락**: barrel export, re-export 패턴
- **리렌더링**: 불필요한 state 변경, 메모이제이션 누락
  - useMemo/useCallback 미사용으로 비용 큰 연산 반복
  - 부모 리렌더링에 의한 자식 리렌더링
- **동적 import 미활용**: 모달, 차트 등 lazy load 가능 컴포넌트
- **이미지/에셋**: public 폴더 대용량 파일, 미사용 에셋

파일:줄번호와 예상 개선 효과 포함.

### 팀 3: API + DB 응답 시간 측정반 (general-purpose 에이전트)

**전 API 엔드포인트 응답 시간 측정**

프로덕션 또는 로컬 서버에서 curl로 전 API 호출:
```bash
# 응답 시간 측정
curl -s -o /dev/null -w "%{time_total}" -b /tmp/cookies.txt {URL}
```

- **각 API 응답 시간**: 200ms 이하 목표
  - 200ms 이하: ✅ 정상
  - 200-500ms: ⚠️ 느림
  - 500ms 이상: ❌ 심각
- **느린 API 원인 분석**:
  - Prisma include 과다 (불필요한 관계 로딩)
  - N+1 쿼리 패턴
  - 인덱스 미적용 필드에 where 조건
  - 불필요한 데이터 전체 조회 (select 미사용)
- **캐싱 기회**: 자주 호출되지만 변경 적은 데이터
- **동시 요청**: Promise.all 가능한데 순차 호출하는 패턴

API별 응답시간 표와 개선안 포함.

---

## Phase 3: CHECK (점수화)

### 3-1. 3팀 결과 종합 → 성능 점수 (100점)
| 감점 기준 | 점수 |
|----------|------|
| ❌ Critical (500ms+ API, LCP 4초+) 1건당 | -15점 |
| ⚠️ High (200-500ms API, 번들 100KB+) 1건당 | -8점 |
| 🔶 Medium (리렌더링, 캐싱 누락) 1건당 | -3점 |
| 💡 Low (개선 제안) 1건당 | -1점 |

### 3-2. 분석 결과 저장
파일: `docs/03-analysis/perf-result-{날짜}.md`

### 3-3. 판정
- **90점 이상**: Phase 5(보고서)
- **90점 미만**: Phase 4(Act)

---

## Phase 4: ACT (최적화 + 재측정)

**최대 3회 반복. 사용자 확인 후 진행.**

### 4-1. 자동 최적화 순서
1. **Critical**: 느린 API → Prisma select/include 최적화, 인덱스 추가
2. **High**: 번들 → dynamic import, 불필요한 import 제거
3. **Medium**: 리렌더링 → useMemo/useCallback 적용

### 4-2. 빌드 확인
```bash
npx next build
```

### 4-3. 커밋
```bash
git commit -m "perf: 성능 최적화 (PDCA Act #{N})"
```

### 4-4. 재측정 → 90점 이상이면 Phase 5

---

## Phase 5: REPORT (최종 보고서)

파일: `docs/04-report/perf-report-{날짜}.md`

```markdown
## PDCA 성능 최적화 보고서

### 점수 변화: XX/100 → YY/100

### PDCA 이력
| 회차 | 점수 | 최적화 건수 |
|------|------|-----------|
| 1차 | 65 | 8건 |
| 2차 | 93 | 3건 |

### API 응답 시간 개선
| API | Before | After | 개선율 |
|-----|--------|-------|--------|
| GET /api/xxx | 450ms | 120ms | -73% |

### 번들 사이즈 개선
| 라우트 | Before | After |
|--------|--------|-------|
| / | 150KB | 95KB |

### 최종 판정: ✅ PASS (XX점)
```

---

## 핵심 규칙

1. **PDCA 자동 반복**: 90점 미만 시 최적화 → 재측정 최대 3회
2. **측정 먼저**: 추측 금지, 반드시 측정 후 최적화
3. **최소 변경**: 성능 개선에 필요한 코드만 수정
4. **빌드 테스트** 필수
5. **기존 기능 유지**: 성능 개선이 기능을 깨뜨리면 안 됨
6. **문서화**: 계획서, 분석, 보고서 모두 docs/ 저장
