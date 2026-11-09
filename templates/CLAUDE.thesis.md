# sub-reranker — master's thesis project

> Template from JaHyunKwak/research-skills. Fill the "Project" section from the actual
> repository layout, delete rows that don't apply, keep the whole file short.
> If this folder (or one above it) has a Codex `AGENTS.md`, add a line containing only
> `@AGENTS.md` here: Claude Code stops reading AGENTS.md once a CLAUDE.md exists.

## Project (fill in)

- Thesis: *A Multi-Criteria Ranking Pipeline for Somatic Variant Candidate Prioritization
  in Cardiac Whole-Exome Sequencing* — tumor-only (no matched normal) cardiac WES; several
  callers (Mutect2, LoFreq, VarDict, VarScan2 + PoN) merged into a learned technical score,
  a Top-K shortlist for expert review, and a separate evidence layer (functional impact,
  cardiac RNA levels, multiome context). An LLM component summarizes/audits evidence
  without changing the ranking.
- Data: `<path to BAM/VCF/caller outputs>`; reference build: `<GRCh38 / hg19>`
- Environment: `conda activate <env>`; GPU: `<yes/no>`
- Outputs go to: `<results dir convention>`; never overwrite a dated results folder.

## Working rules

- Thesis text and figure legends in English; explanations to me in Korean, keeping English
  technical terms (threshold, reranker, calibration, bootstrap …) untranslated.
- Report honestly: mean ± SD over seeds/folds, exact n, both site-level and donor-level
  numbers when aggregation matters. Never say a method "beat" a baseline within noise.
- Check `genomic-coordinates` conventions whenever VCF/BED/BAM or hg19/GRCh38 cross a tool
  boundary. Left-align/normalize before comparing variants across callers.
- Before any heavy job on the shared server, check resources (`get-available-resources`).
- Never delete files; move them to `_trash/` instead. (Deletion is only blocked if a
  `Bash(rm *)` deny rule is set — check with `/permissions` or run the installer with `--deny-rm`.)
- Do not install packages into the conda environment (`uv pip install`, `pip install`,
  `conda install`) without asking first — several skills suggest it.

## Skill routing — invoke these yourself, without being asked

| task | skill(s) |
|---|---|
| merge / normalize / compare caller VCFs | `bio-variant-calling-variant-normalization`, `bio-variant-calling-vcf-manipulation`, `bio-variant-calling-vcf-statistics` |
| caller behaviour, PoN, filtering thresholds, orientation bias | `bio-workflows-somatic-variant-pipeline`, `bio-variant-calling-filtering-best-practices` |
| per-site read counts, pileups, allele fractions | `bio-alignment-files-pileup-generation`, `pysam` |
| evidence layer: VEP, gnomAD, ClinVar, ACMG/AMP tiers, variant-effect scores | `bio-variant-calling-variant-annotation`, `bio-variant-calling-clinical-interpretation`, `database-lookup`, `alphagenome` |
| learned technical score / reranker model | `scikit-learn`, `pytorch-lightning`, `transformers` |
| validating the ranker (nested CV, leakage, calibration, Top-K metrics) | `bio-machine-learning-model-validation`, `bio-machine-learning-omics-classifiers` |
| explaining the score (SHAP, feature attribution) | `shap`, `bio-machine-learning-prediction-explanation` |
| statistics, FDR, power, sample size | `statistical-analysis`, `statsmodels`, `bio-experimental-design-multiple-testing`, `bio-experimental-design-power-analysis` |
| caller-overlap figure | `bio-data-visualization-upset-plots` |
| donor × gene variant matrix | `bio-data-visualization-oncoprint-mutation-matrices` |
| any publication figure | `scientific-visualization`, `bio-data-visualization-multipanel-figures`, `bio-reporting-figure-export`, `bio-data-visualization-color-palettes` |
| Table 1 / result tables / supplementary tables | `bio-reporting-publication-tables` |
| thesis chapters, abstract, methods text, Korean explanations | `writing-conventions` (always), `scientific-writing`, `venue-templates`, `citation-management`, `paper-lookup` |
| before sending a chapter to the advisor | `manuscript-review` |
| defense / lab-seminar slides | `scientific-slides` for the build; styling follows `writing-conventions` (ink-on-white, native equation objects) over its "visually engaging" defaults |
| GPU acceleration of slow pandas/sklearn code | `optimize-for-gpu` |
