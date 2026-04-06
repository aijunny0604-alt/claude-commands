# DOCS_PRINCIPLES

앱 프로젝트 문서를 효율적으로 운영하기 위한 원칙. 어떤 앱을 만들어도 재사용 가능한 기준이다.

## The 5-Layer Model

| Layer | Role | 위치 |
| --- | --- | --- |
| Entry | 저장소 첫 진입점 | `README.md` |
| Global Rules | 항상 적용되는 규칙 | `CLAUDE.md`, `PROJECT_GUIDE.md` |
| Navigation | 문서 지도 | `docs/INDEX.md` |
| Active Docs | 현재 운영 기준 | `docs/*.md` |
| Reference | 과거 기록, 실험, 폐기안 | `docs/ref/**` |

이 5계층을 섞지 않는 것이 핵심이다.

## Core Rules

1. **문서마다 계층을 먼저 정한다** — Entry / Global / Active / Reference 중 하나.
2. **한 문서는 한 질문에 답한다** — 제목만 보고 역할이 분명해야 한다.
3. **Active 문서는 현재 사실만 다룬다** — 시행착오 로그, 폐기안은 `docs/ref/`로.
4. **계획 / 사실 / 기록을 분리한다** — 같은 문서에 섞지 않는다.
5. **입구는 얇게, 본문은 책임별로** — README와 INDEX는 짧게, 상세 내용은 각 주제 문서로.
6. **중복보다 링크** — source of truth 문서를 하나 정하고, 나머지는 링크만 둔다.
7. **코드 변경과 문서 변경은 같은 작업에서** — 아키텍처, API, 환경변수, 정책이 바뀌면 문서도 같이 바뀐다.

## Recommended Structure

```
README.md
CLAUDE.md                  # AI 에이전트용 규칙
docs/
  INDEX.md                 # 문서 지도 (링크 + 한 줄 설명)
  QUICK_REF.md             # 커맨드·환경변수·엔드포인트 치트시트
  DEPLOY.md
  TEST.md
  ROADMAP.md               # 계획 문서 — "확정된 것"과 "미결 사항" 섹션 구분 필수
  API.md                   # 필요 시
  DB.md                    # 필요 시
  AUTH.md                  # 필요 시
  ARCHITECTURE.md          # 필요 시
  AI_SYSTEMS.md            # AI 기능이 있으면
  BILLING.md               # 필요 시
  ref/
    README.md
    sessions/
    prompts/
    archive/
```

새 문서를 만드는 기준: 독립된 운영 규칙이 생겼거나, 반복 실행 절차가 생겼을 때. "있으면 좋아서"는 이유가 되지 않는다.

## Document Sections Template

주제 문서의 권장 섹션 순서:

```
## Purpose
## Current State
## Current Rules
## Commands / Checklist / Contract
## Related Docs
```

필요에 따라 `Source of Truth`, `Required Env`, `Implementation Plan`, `Common Failure Modes` 추가.

## Naming Rules

- Active 문서: 주제 중심 대문자 — `API.md`, `DEPLOY.md`
- 절차 문서: `*_RUNBOOK.md`, `*_GUIDE.md`
- 세션/회의 기록: 날짜 기반 — `SESSION-SUMMARY-2026-04-05.md`
- 언어: 파일명은 항상 영어, 섹션 헤더는 영어, 본문은 팀 주언어

## When to Archive

아래 조건이면 `docs/ref/archive/`로 내린다:

- 더 이상 현재 기준이 아니다
- 새 active 문서가 그 책임을 대신한다

절차: active 문서에 새 기준을 먼저 쓴다 → archive로 내린다 → archive 문서는 더 이상 수정하지 않는다.  
의사결정 맥락 추적이나 진행 중인 마이그레이션이 필요한 경우에만 active 문서에 archive 링크를 남긴다.

## Anti-Patterns

- `README.md`가 거대한 위키가 되는 것
- Active 문서에 세션 로그를 계속 추가하는 것
- 현재 규칙과 폐기된 안을 같은 문서에 쌓는 것
- Source of truth가 둘 이상 생기는 것
- INDEX에 없는 active 문서를 만드는 것
- "임시 메모"가 영구 운영 문서가 되는 것

## Maintenance Checklist

문서 수정 시 확인:

1. 이 문서의 계층(Entry / Global / Active / Reference)이 맞는가?
2. 현재 사실 / 계획 / 기록이 섞여 있지 않은가?
3. 다른 문서가 source of truth인 내용을 중복 작성하고 있지 않은가?
4. 새 active 문서라면 `docs/INDEX.md`에 등록했는가?
5. 코드 변경과 문서 변경이 같은 작업에서 끝났는가?

---

**One-sentence principle**: 현재 기준 문서는 얇고 명확하게, 과거 기록은 reference로, 모든 active 문서는 INDEX에서 발견 가능하게.
