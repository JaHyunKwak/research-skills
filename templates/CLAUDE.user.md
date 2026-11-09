# ~/.claude/CLAUDE.md — applies to every project on this machine

- Explanations to me in Korean; keep English technical terms untranslated
  (threshold, peak, allele-specific, reranker, calibration, bootstrap …).
  Manuscript / thesis text and figure legends in English.
- Direct and concise. Honest, critical assessment over favorable framing — always.
- Report results honestly: mean ± SD over seeds/folds, exact n, both site-level and
  donor-level numbers when aggregation matters. Never claim a method "beat" a baseline
  within noise; never upgrade "consistent with" to causal language.
- Every number in a manuscript traces to a file in a results folder. When a number changes,
  grep text, legends and supplement for the old value before finishing.
- Shared server: check free GPU/RAM before heavy jobs (`get-available-resources`).
  Never delete files — move them to `_trash/`. Never overwrite a dated results folder.
- Do not install packages into the conda environment (`uv pip install`, `pip install`,
  `conda install`) without asking first, even when a skill tells you to.
- Prefer the installed skills (`/skills`): they encode this lab's conventions. When a task
  matches a skill description, use the skill instead of improvising.
- Project map: each project folder has its own `CLAUDE.md`; when I name a project, read that
  folder's `CLAUDE.md` before doing anything else.
