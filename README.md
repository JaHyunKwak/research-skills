# research-skills

Reproducible [Claude Code](https://code.claude.com/docs/en/skills) skill setup for my
research work — single-nucleus multiome / allele-specific chromatin accessibility
(ASCA) in failing human heart, somatic variant prioritization in cardiac WES
(master's thesis), and the manuscript / figure / statistics work around them.

One command turns a fresh Linux account into a Claude Code environment that knows
scanpy, WASP/chromBPNet ATAC conventions, Mutect2 pipelines, publication figure and
table rules, and my own review and writing protocols.

```bash
curl -fsSL https://raw.githubusercontent.com/JaHyunKwak/research-skills/main/setup_research_skills.sh \
  | bash -s -- --no-plugins
```

## What it does

`setup_research_skills.sh` sparse-clones three upstream skill libraries into
`~/.claude/skill-sources/` and symlinks a **curated subset** into `~/.claude/skills/`,
where Claude Code loads them in every project on that machine. Nothing is vendored;
`--update` pulls upstream changes. Re-running is idempotent; skills removed from the
lists are pruned, your own non-symlink skills are never touched.

| source | license | picked |
|---|---|---|
| [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | MIT | 27 (core) + 9 (`--extra`) |
| [GPTomics/bioSkills](https://github.com/GPTomics/bioSkills) (archived 2026-08, still correct) | MIT | 42 (core) + 24 (`--extra`) |
| [anthropics/skills](https://github.com/anthropics/skills) docx/pptx/xlsx/pdf | source-available | only with `--with-anthropic-docs` (not needed when signed in with a claude.ai account — they sync) |
| this repo `custom-skills/` | — | all |

Why a subset and not everything: every installed skill's description sits in Claude's
context on **every** turn (~9k tokens for the core set). Install what you use, check
`/skill-doctor` after a couple of weeks, prune.

### Core tier (69 skills) by job

| job | skills |
|---|---|
| ASCA / chromatin accessibility | allele-specific-accessibility (WASP · ASEReadCounter · RASQUAL), deep-learning-atac (chromBPNet · Enformer · TF-MoDISco), single-cell-atac, footprinting, motif-deviation, peak-calling, QC, consensus-peakset, differential-accessibility, enhancer-gene-linking |
| somatic / germline variants (thesis) | variant-calling, filtering-best-practices, variant-annotation (VEP), variant-normalization, vcf-manipulation, vcf-statistics, clinical-interpretation (ACMG/AMP), somatic-variant-pipeline (Mutect2 · PoN · orientation bias), pileup-generation |
| single-cell / multiome | scanpy, anndata, multiome-pipeline (WNN/MultiVI), multimodal-integration, scatac-analysis (Signac · ArchR · SnapATAC2), atlas-mapping |
| statistics & design | statistical-analysis, statsmodels, batch-design, multiple-testing, power-analysis, randomization-blocking, sample-size |
| ML (learned technical score, reranker) | scikit-learn, shap, pytorch-lightning, transformers, model-validation, omics-classifiers, prediction-explanation, optimize-for-gpu |
| publication figures & tables | scientific-visualization, matplotlib, seaborn, multipanel-figures, figure-export, color-palettes, statistical-annotation, volcano-and-ma-plots, heatmaps-clustering, genome-tracks, sequence-logos, upset-plots, oncoprint-mutation-matrices, publication-tables |
| literature & writing | paper-lookup (18 scholarly APIs), citation-management, scientific-writing, peer-review, venue-templates, scientific-slides, markdown-mermaid-writing |
| genomics utilities | pysam, deeptools, genomic-coordinates (0/1-based · hg19/GRCh38 · chr-prefix), alphagenome, pathway-enrichment, database-lookup, nextflow, get-available-resources |

`--extra` adds clinical-biostatistics (logistic regression, Cox/RMST, effect measures,
CONSORT trial reporting, missing data, subgroup), survival models, more plots, Quarto /
Jupyter reports, scvi-tools, pydeseq2, literature-review.

Plugins (`skill-creator`, Anthropic's `bio-research` with PubMed / bioRxiv / ChEMBL /
Open Targets MCP connectors) are installed with `claude plugin install` when the CLI is on
PATH. When Claude Code is signed in with a claude.ai account — including Claude Desktop SSH
sessions — both already arrive through claude.ai sync, so pass `--no-plugins`.

## Usage

```bash
bash setup_research_skills.sh --dry-run        # show what would change
bash setup_research_skills.sh                  # core tier
bash setup_research_skills.sh --extra          # core + extra
bash setup_research_skills.sh --update         # git pull all sources, re-link
bash setup_research_skills.sh --list           # print the lists
bash setup_research_skills.sh --uninstall      # remove our symlinks only
bash setup_research_skills.sh --deny-rm        # deny Bash(rm *)/Bash(rmdir *) in settings.json (direct rm/rmdir incl. chains and /bin/rm; not find -delete)
bash setup_research_skills.sh --budget 0.02    # raise the skill-listing budget (see below)
```

Then inside Claude Code: `/reload-skills` (first time), `/skills` to verify,
`/skill-doctor` later to prune. The skills are instructions, not software — scanpy,
GATK, samtools etc. must exist in the conda environment; each `SKILL.md` lists its
prerequisites. Several K-Dense helper scripts use [`uv`](https://docs.astral.sh/uv/).

## The skill-listing budget (read this once)

Claude Code shows Claude a listing of every skill's name + description on every turn, capped at
**1% of the context window**. Characters per token are model-specific (3 for Opus 5.x, 4 for the
Claude 3/4 families), so on a 1M-context Opus 5.x session 1% ≈ **30k characters** and
`--budget 0.02` ≈ 60k. Past the cap the listing keeps every name but **drops descriptions**:
built-in skills always keep theirs, the rest are ranked by a usage score (invocations × recency,
7-day half-life), ties — i.e. everything you have never used — fall back to listing order, where
`~/.claude/skills/` entries come before plugin skills. A skill with no description does not
auto-trigger; it only works when named (by you, or by a `CLAUDE.md` routing table).

Every plugin enabled on your claude.ai account syncs its skills into the same listing. Measured on
this server (Claude Code 2.1.317, from the listing actually sent to the model): full text would be
~166k characters, of which the 72 installed research skills are ~37k; at the default 1% only 26 of
them kept a description, at 2% all 72 did.

What to do, in order:
1. On claude.ai (Settings → Customize → Plugins, "⋯ → Remove") drop plugins unrelated to
   research. Restart the Desktop app afterwards so SSH sessions receive the new plugin set.
2. `bash setup_research_skills.sh --budget 0.02` (writes `skillListingBudgetFraction` to
   `~/.claude/settings.json`, with a backup). The research skills fit at 2%.
3. `/context` shows the Skills row as the model receives it (`/doctor` only estimates from disk);
   `/skill-doctor` after a couple of weeks lists skills never invoked — prune those.

## AGENTS.md (Codex) next to CLAUDE.md

Claude Code reads a folder's `AGENTS.md` only while no `CLAUDE.md` exists in that folder or
above it. If a project already has a Codex `AGENTS.md`, put a line containing only `@AGENTS.md`
in the new `CLAUDE.md` so both agents keep the same rules. The templates say so in their header.

## Layout

```
setup_research_skills.sh      installer (edit the arrays at the top to change the set)
custom-skills/<name>/SKILL.md my own skills — see custom-skills/README.md
templates/CLAUDE.*.md         per-project / user-level CLAUDE.md starting points
```

## Design notes

- **Symlinks, not copies**: `~/.claude/skills/<name>` → `~/.claude/skill-sources/<repo>/…`,
  so `git pull` updates everything and nothing is duplicated on disk (~15 MB total).
- **Sparse clones**: only the selected skill directories are checked out
  (`git sparse-checkout`, cone mode); falls back to a full shallow clone on git < 2.25.
- **bioSkills names** follow the upstream installer convention `bio-<category>-<skill>`; a few
  upstream `SKILL.md` files carry a shorter `name:` (`bio-vcf-manipulation`) — both names resolve.
- **Safety**: skills can run code. Upstream libraries are security-scanned
  (K-Dense: Cisco skill-scanner weekly), but bioSkills is archived and unpatched — read a
  `SKILL.md` before relying on it, and keep `/skill-doctor` honest.

## Per-project `CLAUDE.md` templates

Skills load automatically, but with ~70 of them the match is only as good as the request.
A short project `CLAUDE.md` with a *task → skill* routing table makes Claude reach for the
right one unprompted. Two templates live in `templates/`; in a project session on the server:

```
Read https://raw.githubusercontent.com/JaHyunKwak/research-skills/main/templates/CLAUDE.thesis.md
and write this repository's CLAUDE.md from it: fill the Project section from the actual layout,
drop routing rows that don't apply, keep it under 80 lines.
```

(`CLAUDE.clinical.md` for the clinical paper.) When both projects live in one workspace, put each
file in its project subfolder — subfolder `CLAUDE.md` files load on demand when Claude touches a
file there — and keep only shared rules at the root (or in `~/.claude/CLAUDE.md`, see
`templates/CLAUDE.user.md`). `/context` shows which memory files are loaded.
