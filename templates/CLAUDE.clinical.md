# main-임상 — clinical paper project

> Template from JaHyunKwak/research-skills. Fill the "Project" section from the actual
> repository layout, delete the routing rows that don't apply (keep either the
> chromatin/multiome block or the cohort-statistics block, or both), keep the file short.
> If this folder (or one above it) has a Codex `AGENTS.md`, add a line containing only
> `@AGENTS.md` here: Claude Code stops reading AGENTS.md once a CLAUDE.md exists.

## Project (fill in)

- Paper: `<title / one-line question>`; target venue: `<journal>`
- Cohort / data: `<n donors or patients, tissue, assays — snATAC/snRNA multiome, WES, clinical variables>`
- Reference build: `<GRCh38 / hg19>`; environment: `conda activate <env>`
- Current manuscript version: `<path>`; figures: `<path>`; results summary: `<path>`
- Outputs go to: `<results dir convention>`; never overwrite a dated results folder.

## Working rules

- Manuscript text in English; explanations to me in Korean with English technical terms kept.
- Every number in the text must trace to a file in the results folder; when a number changes,
  grep the manuscript, legends, and supplement for the old value before finishing.
- Patient/donor is the unit of independence: use donor-block bootstrap / permutation, never
  treat site × donor × cell-type observations as independent.
- Causal language only when the design supports it; default to "consistent with".
- Never delete files; move them to `_trash/` instead. (Deletion is only blocked if a
  `Bash(rm *)` deny rule is set — check with `/permissions` or run the installer with `--deny-rm`.)
- Do not install packages into the conda environment (`uv pip install`, `pip install`,
  `conda install`) without asking first — several skills suggest it.

## Skill routing — invoke these yourself, without being asked

**Chromatin accessibility / multiome**

| task | skill(s) |
|---|---|
| allele-specific accessibility, WASP, mapping bias, caQTL | `bio-atac-seq-allele-specific-accessibility` |
| chromBPNet / Enformer / Borzoi variant effects, ISM, TF-MoDISco | `bio-atac-seq-deep-learning-atac`, `alphagenome` |
| snATAC processing, peaks, LSI, chromVAR | `bio-atac-seq-single-cell-atac`, `bio-single-cell-scatac-analysis`, `bio-atac-seq-consensus-peakset`, `bio-atac-seq-atac-qc` |
| differential accessibility, footprinting, motif deviation | `bio-atac-seq-differential-accessibility`, `bio-atac-seq-footprinting`, `bio-atac-seq-motif-deviation` |
| peak → gene coupling, snATAC↔snRNA | `bio-atac-seq-enhancer-gene-linking`, `bio-workflows-multiome-pipeline`, `bio-single-cell-multimodal-integration` |
| scRNA/snRNA QC, clustering, pseudobulk, annotation | `scanpy`, `anndata`, `bio-machine-learning-atlas-mapping`, `bio-research:single-cell-rna-qc`, `bio-research:scvi-tools` |
| bigWig tracks, TSS/peak heatmaps, browser-style figures | `deeptools`, `bio-data-visualization-genome-tracks` |
| motif logos | `bio-data-visualization-sequence-logos` |
| pathway / gene-set interpretation | `pathway-enrichment`, `database-lookup` |

**Cohort statistics (if the paper has clinical variables)**

| task | skill(s) |
|---|---|
| group comparisons, regression, assumptions, effect sizes | `statistical-analysis`, `statsmodels` |
| multiple testing, power, sample size, batch confounding | `bio-experimental-design-multiple-testing`, `bio-experimental-design-power-analysis`, `bio-experimental-design-sample-size`, `bio-experimental-design-batch-design` |
| survival / logistic / CONSORT-style reporting | only if the `--extra` tier is installed: `bio-clinical-biostatistics-*`, `bio-machine-learning-survival-analysis`; otherwise `statistical-analysis` + `statsmodels` (delete this row if not installed) |

**Figures, tables, writing (always)**

| task | skill(s) |
|---|---|
| any publication figure | `scientific-visualization`, `bio-data-visualization-multipanel-figures`, `bio-reporting-figure-export`, `bio-data-visualization-color-palettes`, `bio-data-visualization-statistical-annotation` |
| heatmaps, volcano/MA | `bio-data-visualization-heatmaps-clustering`, `bio-data-visualization-volcano-and-ma-plots` |
| Table 1, result tables, supplementary tables | `bio-reporting-publication-tables` |
| manuscript sections, references, cover letter, Korean explanations | `writing-conventions` (always), `scientific-writing`, `citation-management`, `paper-lookup`, `venue-templates` |
| pre-submission audit (claim ledger, figure–text consistency, stats) | `manuscript-review`, `peer-review` |
| seminar / conference slides | `scientific-slides` for the build; styling follows `writing-conventions` (ink-on-white, native equation objects) over its "visually engaging" defaults |
