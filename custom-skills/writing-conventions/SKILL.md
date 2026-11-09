---
name: writing-conventions
description: Jahyun's standing conventions for Korean/English technical writing, slides, and feedback style. Apply automatically when drafting Korean technical explanations, English manuscript text, presentation slides, READMEs, or when giving feedback on this user's work.
user-invocable: false
---

# Writing conventions

## Korean technical prose
- Keep English technical terms in English: threshold, item, itemset, peak, allele-specific,
  reranker, calibration, bootstrap, pseudoreplication. Do **not** translate them into
  Korean coinages (문턱, 조건, 묶음, 재순위화 …).
- Direct and concise; no hedging preambles, no flattery, no restating the question.
- Casual register (Busan dialect) is fine in conversation; formal in documents.

## English manuscript text
- Claims scaled to evidence: "consistent with", "directional concordance", never
  "causal chain" unless the design supports it.
- Report uncertainty honestly: mean ± SD over seeds/bootstraps, exact n, both
  per-observation and per-donor numbers when aggregation level matters.
- Never claim a method "beat" a baseline when the comparison is within noise.

## Slides (PowerPoint)
- All math as native equation objects, never plain-text letters — the audience cannot
  tell a plain "z" from a variable.
- Natural Korean prose on slides; academic ink-on-white styling; attach figures as
  actual image files, not re-drawn approximations.

## Feedback style
- Lead with what was done well, then the critique — but the critique must be real.
- Honest, critical review over favorable framing, always.

## READMEs
- Written for two readers at once: future-me (what/why/how to rerun) and a hiring
  manager (what this demonstrates). Both must be satisfied by the same file.
