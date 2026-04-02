# DB 건강 점검 에이전트 팀 - PDCA 데이터베이스 최적화

당신은 DB 최적화 전문 에이전트 팀 리더입니다. 2개 전문 에이전트 팀을 **동시에** 출동시켜 PDCA 사이클로 DB 점검 → 최적화 → 재점검을 **90점 이상**까지 자동 반복합니다.

인자: $ARGUMENTS (점검 대상: "전체" 또는 특정 모델/테이블)

---

## PDCA 사이클 개요

```
Plan(스키마+쿼리 파악) → Do(2팀 동시 분석) → Check(점수화) → Act(최적화)
    ↑                                                         |
    └──────────── 90점 미만이면 반복 (최대 3회) ──────────────┘
```

---

## Phase 1: PLAN (점검 계획)

### 1-1. DB 구조 파악
```bash
# Prisma 스키마 확인
cat prisma/schema.prisma
# 모델 수, 관계, 인덱스 현황 정리
```

### 1-2. API 엔드포인트 목록
Prisma를 호출하는 모든 API 파일 목록화:
```bash
grep -rn "prisma\." src/app/api/ --include="*.ts"
```

### 1-3. 계획서 저장
파일: `docs/03-analysis/db-plan-{날짜}.md`

---

## Phase 2: DO (2개 에이전트 팀 동시 출동)

### 팀 1: 스키마 아키텍트 (Explore 에이전트)

**Prisma 스키마 + 데이터 모델 분석**

- **인덱스 점검**:
  - WHERE 조건에 자주 사용되는 필드에 @@index 있는지
  - 복합 인덱스 필요한 쿼리 패턴 (예: customerId + date)
  - 유니크 제약 누락 (중복 데이터 가능성)
- **관계 무결성**:
  - onDelete 설정 (Cascade vs SetNull vs Restrict)
  - 고아 레코드 발생 가능성
  - 양방향 관계 일관성
- **타입 최적화**:
  - String vs Int 적절성 (예: 상태값을 String으로?)
  - DateTime 필드 기본값 설정
  - optional(?) vs required 적절성
- **미사용 필드/모델**:
  - 코드에서 참조하지 않는 모델 또는 필드
  - 중복 데이터 (정규화 부족 or 과다)
- **마이그레이션 상태**:
  - 미적용 마이그레이션 확인
  - 스키마-DB 동기화 상태

각 모델별 분석 결과 + 파일:줄번호 포함.

### 팀 2: 쿼리 최적화반 (code-analyzer 에이전트)

**전체 Prisma 쿼리 패턴 분석**

- **N+1 쿼리 탐지**:
  - 루프 안에서 prisma 호출 (for/map 안의 findMany/findUnique)
  - 해결: include 또는 단일 쿼리로 변환
- **과다 include**:
  - 불필요한 관계 로딩 (사용하지 않는 include)
  - 깊은 네스팅 (include > include > include)
  - 해결: 필요한 필드만 select
- **select 미사용**:
  - 전체 필드 조회 후 일부만 사용
  - 해결: select로 필요한 필드만 지정
- **트랜잭션 누락**:
  - 여러 테이블 동시 수정인데 $transaction 미사용
  - 실패 시 데이터 불일치 가능성
- **정렬/필터 최적화**:
  - 인덱스 없는 필드에 orderBy
  - 대량 데이터 테이블에 skip/take 없는 findMany
- **에러 핸들링**:
  - try/catch 없는 Prisma 호출
  - PrismaClientKnownRequestError 미처리
  - unique constraint 위반 미처리

API 파일별 쿼리 목록 + 문제점 + 개선안 포함.

---

## Phase 3: CHECK (점수화)

### 3-1. 2팀 결과 종합 → DB 건강 점수 (100점)
| 감점 기준 | 점수 |
|----------|------|
| ❌ Critical (N+1, 트랜잭션 누락, 인덱스 없는 대량 조회) 1건당 | -15점 |
| ⚠️ High (과다 include, select 미사용, 에러 미처리) 1건당 | -8점 |
| 🔶 Medium (미사용 필드, 타입 비최적) 1건당 | -3점 |
| 💡 Low (개선 제안) 1건당 | -1점 |

### 3-2. 분석 결과 저장
파일: `docs/03-analysis/db-result-{날짜}.md`

```
## DB 건강 점수: XX/100

### 모델별 현황
| 모델 | 인덱스 | 관계 | 쿼리 패턴 | 상태 |
|------|:------:|:----:|:---------:|:----:|
| Customer | ✅ | ✅ | ⚠️ | 보통 |
| Reservation | ⚠️ | ✅ | ❌ | 위험 |

### CRITICAL (즉시 수정)
- ❌ [문제] — 파일:줄 — 수정방안

### HIGH (1일 이내)
- ⚠️ [문제] — 파일:줄 — 수정방안
```

### 3-3. 판정
- **90점 이상**: Phase 5(보고서)
- **90점 미만**: Phase 4(Act)

---

## Phase 4: ACT (최적화 + 재점검)

**최대 3회 반복. 사용자 확인 후 진행.**

### 4-1. 자동 수정 순서
1. **N+1 쿼리** → include 또는 단일 쿼리로 변환
2. **인덱스 추가** → schema.prisma에 @@index 추가
3. **select 적용** → 필요한 필드만 조회
4. **트랜잭션 적용** → $transaction 래핑
5. **에러 핸들링** → try/catch + 적절한 에러 응답

### 4-2. 스키마 변경 시
```bash
npx prisma validate
npx prisma generate
npx prisma db push  # 또는 migrate dev
```

### 4-3. 빌드 확인
```bash
npx next build
```

### 4-4. 커밋
```bash
git commit -m "perf(db): DB 쿼리 최적화 (PDCA Act #{N})"
```

### 4-5. 재점검 → 90점 이상이면 Phase 5

---

## Phase 5: REPORT (최종 보고서)

파일: `docs/04-report/db-report-{날짜}.md`

```markdown
## PDCA DB 건강 점검 보고서

### 점수 변화: XX/100 → YY/100

### PDCA 이력
| 회차 | 점수 | 수정 건수 |
|------|------|----------|
| 1차 | 58 | 10건 |
| 2차 | 92 | 3건 |

### 쿼리 개선 이력
| API | 문제 | Before | After |
|-----|------|--------|-------|
| GET /api/reservations | N+1 | 12쿼리 | 1쿼리 |

### 스키마 변경 이력
| 모델 | 변경 | 이유 |
|------|------|------|
| Reservation | @@index([customerId, date]) 추가 | 목록 조회 성능 |

### 최종 판정: ✅ PASS (XX점)
```

---

## 핵심 규칙

1. **PDCA 자동 반복**: 90점 미만 시 최적화 → 재점검 최대 3회
2. **스키마 변경 주의**: prisma validate 통과 후에만 적용
3. **기존 데이터 보호**: 파괴적 마이그레이션 금지 (컬럼 삭제 등은 사용자 확인)
4. **빌드 테스트** 필수
5. **API 동작 유지**: 쿼리 최적화가 API 응답 구조를 변경하면 안 됨
6. **문서화**: 계획서, 분석, 보고서 모두 docs/ 저장
