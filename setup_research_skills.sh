#!/usr/bin/env bash
# =============================================================================
#  setup_research_skills.sh  —  Claude Code research skill installer (user scope)
#
#  What it does
#    1. Sparse-clones skill repositories into  ~/.claude/skill-sources/
#    2. Symlinks the selected skills into      ~/.claude/skills/<skill>/
#       (Claude Code loads every ~/.claude/skills/*/SKILL.md in every project)
#    3. Installs a few official plugins with the `claude plugin` CLI
#
#  Usage
#    bash setup_research_skills.sh               # install CORE tier
#    bash setup_research_skills.sh --extra       # CORE + EXTRA tier
#    bash setup_research_skills.sh --dry-run     # show what would happen
#    bash setup_research_skills.sh --update      # git pull sources, re-link
#    bash setup_research_skills.sh --with-anthropic-docs   # also docx/pptx/xlsx/pdf
#    bash setup_research_skills.sh --no-plugins  # skip `claude plugin` steps
#    bash setup_research_skills.sh --no-custom   # skip the custom-skills repo
#    bash setup_research_skills.sh --list        # print the skill lists and exit
#    bash setup_research_skills.sh --uninstall   # remove our symlinks only
#    bash setup_research_skills.sh --deny-rm     # add Bash(rm *)/Bash(rmdir *) deny rules to ~/.claude/settings.json
#    bash setup_research_skills.sh --budget 0.02 # set skillListingBudgetFraction (see README: listing budget)
#
#  Re-running is safe (idempotent). To add/remove a skill, edit the arrays
#  below and run again: symlinks not in the list are pruned, new ones added.
#
#  Claude Desktop "SSH" sessions: Claude Code runs ON the server and reads the
#  server's ~/.claude/skills/, so run this script on the server (the session's
#  integrated terminal, Ctrl+`, is fine). When the session is signed in with a
#  claude.ai account, skill-creator, bio-research and docx/pptx/xlsx/pdf already
#  arrive through claude.ai sync — pass --no-plugins there.
#
#  Sources
#    K-Dense-AI/scientific-agent-skills  (MIT)        177 skills
#    GPTomics/bioSkills                  (MIT, archived 2026-08) 561 skills
#    anthropics/skills                   (docx/pptx/xlsx/pdf: source-available)
# =============================================================================
set -euo pipefail

# ----------------------------------------------------------------------------
# K-Dense scientific-agent-skills  →  ~/.claude/skills/<name>
# ----------------------------------------------------------------------------
KDENSE_CORE=(
  # single-cell / multiome / genomics  (scvi-tools comes from the bio-research plugin)
  scanpy anndata pysam deeptools genomic-coordinates alphagenome
  pathway-enrichment database-lookup
  # literature & writing
  paper-lookup citation-management scientific-writing peer-review venue-templates
  # figures / slides / diagrams
  scientific-visualization matplotlib seaborn scientific-slides markdown-mermaid-writing
  # statistics & ML (thesis: learned technical score, reranker, SHAP)
  statistical-analysis statsmodels scikit-learn shap pytorch-lightning transformers
  # infra on a shared GPU server
  optimize-for-gpu get-available-resources nextflow
)
KDENSE_EXTRA=(
  scvi-tools pydeseq2 literature-review exploratory-data-analysis pacsomatic
  latex-posters pymc umap-learn statistical-power experimental-design
)

# ----------------------------------------------------------------------------
# GPTomics bioSkills  "<category>/<skill>"  →  ~/.claude/skills/bio-<category>-<skill>
# ----------------------------------------------------------------------------
BIOSKILLS_CORE=(
  # ASCA / chromatin accessibility (WASP, chromBPNet, Signac/ArchR, footprinting, ...)
  atac-seq/allele-specific-accessibility atac-seq/deep-learning-atac
  atac-seq/single-cell-atac atac-seq/atac-peak-calling atac-seq/atac-qc
  atac-seq/consensus-peakset atac-seq/differential-accessibility
  atac-seq/footprinting atac-seq/motif-deviation atac-seq/enhancer-gene-linking
  # somatic / germline variants (thesis: multi-caller WES prioritization)
  variant-calling/variant-calling variant-calling/filtering-best-practices
  variant-calling/variant-annotation variant-calling/variant-normalization
  variant-calling/vcf-manipulation variant-calling/vcf-statistics
  variant-calling/clinical-interpretation
  workflows/somatic-variant-pipeline alignment-files/pileup-generation
  # multiome
  workflows/multiome-pipeline single-cell/multimodal-integration single-cell/scatac-analysis
  # experimental design & statistics reviewers ask about
  experimental-design/batch-design experimental-design/multiple-testing
  experimental-design/power-analysis experimental-design/randomization-blocking
  experimental-design/sample-size
  # publication figures & tables
  reporting/publication-tables reporting/figure-export
  data-visualization/multipanel-figures data-visualization/volcano-and-ma-plots
  data-visualization/heatmaps-clustering data-visualization/genome-tracks
  data-visualization/sequence-logos data-visualization/color-palettes
  data-visualization/statistical-annotation data-visualization/upset-plots
  data-visualization/oncoprint-mutation-matrices
  # ML on omics (validation, leakage, calibration, explanation)
  machine-learning/model-validation machine-learning/omics-classifiers
  machine-learning/prediction-explanation machine-learning/atlas-mapping
)
BIOSKILLS_EXTRA=(
  atac-seq/nucleosome-positioning atac-seq/co-accessibility
  variant-calling/vcf-basics variant-calling/gatk-variant-calling
  variant-calling/structural-variant-calling
  data-visualization/lollipop-protein-maps data-visualization/dimensionality-reduction-plots
  data-visualization/forest-funnel-plots data-visualization/ggplot2-fundamentals
  reporting/quarto-reports reporting/jupyter-reports reporting/automated-qc-reports
  machine-learning/survival-analysis machine-learning/biomarker-discovery
  single-cell/cell-annotation single-cell/differential-abundance
  # clinical paper statistics
  clinical-biostatistics/logistic-regression clinical-biostatistics/survival-analysis
  clinical-biostatistics/effect-measures clinical-biostatistics/categorical-tests
  clinical-biostatistics/subgroup-analysis clinical-biostatistics/trial-reporting
  clinical-biostatistics/missing-data-sensitivity
)

# ----------------------------------------------------------------------------
# anthropics/skills document skills (only with --with-anthropic-docs).
# If `claude` is signed in with a claude.ai account these already sync to
# ~/.claude/skills/synced/ automatically, so this is only for API-key logins.
# ----------------------------------------------------------------------------
ANTHROPIC_DOC_SKILLS=( docx pptx xlsx pdf )

# ----------------------------------------------------------------------------
# Official plugins:  "<marketplace repo>|<marketplace name>|<plugin name>"
#   skill-creator : author/evaluate your own skills (manuscript-review, research-ppt, ...)
#   bio-research  : Anthropic's life-sciences bundle — skills (single-cell-rna-qc,
#                   scvi-tools, nextflow-development, scientific-problem-selection)
#                   + MCP connectors (PubMed, bioRxiv, ChEMBL, Open Targets,
#                   ClinicalTrials.gov need no login; BioRender/Consensus/Synapse/
#                   Wiley/Benchling need an account and can be left unauthenticated)
#   NOTE: anthropics/life-sciences README still lists pubmed@life-sciences etc.,
#   but its marketplace.json no longer contains them (checked 2026-11-09).
# ----------------------------------------------------------------------------
PLUGINS=(
  "anthropics/claude-plugins-official|claude-plugins-official|skill-creator"
  "anthropics/knowledge-work-plugins|knowledge-work-plugins|bio-research"
)

# ----------------------------------------------------------------------------
# Your own skills: every  custom-skills/<name>/SKILL.md  in this repository is
# linked too, so authoring a skill = commit + `--update` on each machine.
# ----------------------------------------------------------------------------
CUSTOM_REPO="${CUSTOM_REPO:-https://github.com/JaHyunKwak/research-skills.git}"
CUSTOM_SUBDIR="custom-skills"

# ----------------------------------------------------------------------------
REPO_KDENSE="https://github.com/K-Dense-AI/scientific-agent-skills.git"
REPO_BIOSKILLS="https://github.com/GPTomics/bioSkills.git"
REPO_ANTHROPIC="https://github.com/anthropics/skills.git"

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
SRC_ROOT="${CLAUDE_SKILL_SOURCES:-$CLAUDE_HOME/skill-sources}"
SKILLS_DIR="$CLAUDE_HOME/skills"
MANIFEST="$SRC_ROOT/installed-skills.txt"

usage() {
  cat <<'USAGE'
setup_research_skills.sh — curated Claude Code skills for research (user scope)

  --dry-run              show what would change, write nothing
  --extra                also install the EXTRA tier
  --update               git pull every source, re-link
  --with-anthropic-docs  link docx/pptx/xlsx/pdf from anthropics/skills (API-key logins only)
  --no-plugins           skip `claude plugin` steps (Desktop SSH sessions, claude.ai sync)
  --no-custom            skip the custom-skills repo
  --deny-rm              add Bash(rm *) and Bash(rmdir *) to permissions.deny in ~/.claude/settings.json
  --budget <fraction>    set skillListingBudgetFraction in ~/.claude/settings.json (e.g. 0.02)
  --list                 print the skill lists and exit
  --uninstall            remove the symlinks this script created (sources and plugins stay)
USAGE
}

DRY_RUN=false; EXTRA=false; WITH_DOCS=false; DO_PLUGINS=true; DO_CUSTOM=true
UPDATE=false; UNINSTALL=false; LIST_ONLY=false; DENY_RM=false; BUDGET=""

while [ $# -gt 0 ]; do
  arg="$1"; shift
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --deny-rm) DENY_RM=true ;;
    --budget) BUDGET="${1:-}"; shift || true
              [[ "$BUDGET" =~ ^0?\.[0-9]+$|^1$|^0$ ]] || { echo "--budget needs a fraction like 0.02"; exit 2; } ;;
    --extra) EXTRA=true ;;
    --with-anthropic-docs) WITH_DOCS=true ;;
    --no-plugins) DO_PLUGINS=false ;;
    --no-custom) DO_CUSTOM=false ;;
    --update) UPDATE=true ;;
    --uninstall) UNINSTALL=true ;;
    --list) LIST_ONLY=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $arg (see --help)"; exit 2 ;;
  esac
done

c_ok()   { printf '\033[32m%s\033[0m\n' "$*"; }
c_warn() { printf '\033[33m%s\033[0m\n' "$*"; }
c_err()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }
run()    { if $DRY_RUN; then echo "  [dry-run] $*"; else "$@"; fi; }

# ---- build the final selection ---------------------------------------------
KDENSE_SEL=("${KDENSE_CORE[@]}"); BIO_SEL=("${BIOSKILLS_CORE[@]}")
if $EXTRA; then
  KDENSE_SEL+=("${KDENSE_EXTRA[@]}"); BIO_SEL+=("${BIOSKILLS_EXTRA[@]}")
fi

if $LIST_ONLY; then
  echo "K-Dense ($( $EXTRA && echo core+extra || echo core ), ${#KDENSE_SEL[@]}):"; printf '  %s\n' "${KDENSE_SEL[@]}"
  echo "bioSkills (${#BIO_SEL[@]}):"; printf '  %s\n' "${BIO_SEL[@]}"
  $WITH_DOCS && { echo "anthropics/skills:"; printf '  %s\n' "${ANTHROPIC_DOC_SKILLS[@]}"; }
  echo "plugins:"; printf '  %s\n' "${PLUGINS[@]}"
  exit 0
fi

# ---- uninstall ---------------------------------------------------------------
if $UNINSTALL; then
  echo "Removing symlinks in $SKILLS_DIR that point into $SRC_ROOT ..."
  n=0
  if [ -d "$SKILLS_DIR" ]; then
    for link in "$SKILLS_DIR"/*; do
      [ -L "$link" ] || continue
      case "$(readlink "$link")" in
        "$SRC_ROOT"/*) run rm -f "$link"; n=$((n+1)); echo "  removed $(basename "$link")" ;;
      esac
    done
  fi
  $DRY_RUN || rm -f "$MANIFEST"
  c_ok "Removed $n symlink(s). Sources kept at $SRC_ROOT (delete manually if unwanted)."
  echo "Plugins are not touched. To remove them:"
  for spec in "${PLUGINS[@]}"; do IFS='|' read -r _ mkt plug <<<"$spec"; echo "  claude plugin uninstall ${plug}@${mkt}"; done
  exit 0
fi

# ---- preflight ---------------------------------------------------------------
command -v git >/dev/null || { c_err "git is required"; exit 1; }
GIT_VER=$(git --version | awk '{print $3}')
git_ge() { [ "$(printf '%s\n%s\n' "$1" "$GIT_VER" | sort -V | head -1)" = "$1" ]; }
SPARSE_OK=false; git_ge 2.25.0 && SPARSE_OK=true
$SPARSE_OK || c_warn "git $GIT_VER < 2.25: sparse checkout unavailable, doing full shallow clones (bigger, still fine)."

echo "Claude home : $CLAUDE_HOME"
echo "Sources     : $SRC_ROOT"
echo "Skills dir  : $SKILLS_DIR"
echo "Tier        : $( $EXTRA && echo 'core + extra' || echo core )"
$DRY_RUN && c_warn "DRY RUN — nothing will be written."
run mkdir -p "$SRC_ROOT" "$SKILLS_DIR"

# ---- clone / update a repo with a sparse path list ---------------------------
# sync_repo <url> <dir> <path>...
sync_repo() {
  local url="$1" dir="$2"; shift 2
  if [ -d "$dir/.git" ]; then
    if $UPDATE; then
      echo "Updating $(basename "$dir") ..."
      if ! run git -C "$dir" pull --ff-only --quiet; then
        if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
          c_warn "  pull failed: $(basename "$dir") has local edits (git -C $dir status). Keep them in custom-skills/ instead, or run: git -C $dir stash && re-run --update"
        else
          c_warn "  pull failed for $(basename "$dir") (network, or upstream history rewritten) — using the existing checkout"
        fi
      fi
    fi
  else
    echo "Cloning $(basename "$dir") ..."
    if $SPARSE_OK; then
      run git clone --quiet --depth 1 --filter=blob:none --sparse "$url" "$dir"
    else
      run git clone --quiet --depth 1 "$url" "$dir"
    fi
  fi
  if $SPARSE_OK && [ -d "$dir/.git" ]; then
    # (re)apply the path list — picks up additions to the arrays above
    run git -C "$dir" sparse-checkout set "$@" \
      || c_warn "  sparse-checkout failed for $(basename "$dir") (offline?) — new skills may be missing"
  fi
}

# ---- symlink management -------------------------------------------------------
declare -a WANTED=()      # link names this run wants
declare -a LINKED=()      # link names actually (re)linked
link_skill() {            # link_skill <link-name> <target-dir>
  local name="$1" target="$2" link="$SKILLS_DIR/$1"
  WANTED+=("$name")
  if ! $DRY_RUN && [ ! -f "$target/SKILL.md" ]; then
    c_warn "  skip $name: no SKILL.md at $target (renamed upstream?)"; return
  fi
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    c_warn "  skip $name: $link exists and is not a symlink (your own skill?) — left untouched"; return
  fi
  run ln -sfn "$target" "$link"
  LINKED+=("$name")
}

# K-Dense
KD_DIR="$SRC_ROOT/scientific-agent-skills"
kd_paths=(); for s in "${KDENSE_SEL[@]}"; do kd_paths+=("skills/$s"); done
sync_repo "$REPO_KDENSE" "$KD_DIR" "${kd_paths[@]}"
echo "Linking K-Dense skills ..."
for s in "${KDENSE_SEL[@]}"; do link_skill "$s" "$KD_DIR/skills/$s"; done

# bioSkills
BIO_DIR="$SRC_ROOT/bioSkills"
sync_repo "$REPO_BIOSKILLS" "$BIO_DIR" "${BIO_SEL[@]}"
echo "Linking bioSkills ..."
for cs in "${BIO_SEL[@]}"; do
  cat="${cs%%/*}"; sk="${cs##*/}"
  link_skill "bio-${cat}-${sk}" "$BIO_DIR/$cs"     # upstream installer naming; a few SKILL.md `name:` fields differ (bio-<skill>) — both names work
done

# anthropics/skills document skills (optional)
if $WITH_DOCS; then
  AN_DIR="$SRC_ROOT/anthropic-skills"
  an_paths=(); for s in "${ANTHROPIC_DOC_SKILLS[@]}"; do an_paths+=("skills/$s"); done
  sync_repo "$REPO_ANTHROPIC" "$AN_DIR" "${an_paths[@]}"
  echo "Linking anthropics/skills document skills ..."
  for s in "${ANTHROPIC_DOC_SKILLS[@]}"; do link_skill "$s" "$AN_DIR/skills/$s"; done
fi

# your own skills from the research-skills repository (optional, never fatal)
if $DO_CUSTOM && [ -n "$CUSTOM_REPO" ]; then
  CU_DIR="$SRC_ROOT/research-skills"
  if [ -d "$CU_DIR/.git" ] || $DRY_RUN; then
    $UPDATE && { echo "Updating research-skills ..."; run git -C "$CU_DIR" pull --ff-only --quiet || c_warn "  pull failed for research-skills (local edits? network?) — using the existing checkout"; }
    $DRY_RUN && [ ! -d "$CU_DIR/.git" ] && echo "  [dry-run] git clone --depth 1 $CUSTOM_REPO $CU_DIR"
  else
    echo "Cloning research-skills (your custom skills) ..."
    git clone --quiet --depth 1 "$CUSTOM_REPO" "$CU_DIR" 2>/dev/null \
      || c_warn "  could not clone $CUSTOM_REPO (private repo without credentials, or not created yet) — skipped"
  fi
  if [ -d "$CU_DIR/$CUSTOM_SUBDIR" ]; then
    echo "Linking custom skills ..."
    for d in "$CU_DIR/$CUSTOM_SUBDIR"/*/; do
      [ -f "$d/SKILL.md" ] || continue
      link_skill "$(basename "$d")" "${d%/}"
    done
  fi
fi

# prune: symlinks into SRC_ROOT that are no longer wanted
pruned=0
if [ -d "$SKILLS_DIR" ]; then
  for link in "$SKILLS_DIR"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in "$SRC_ROOT"/*) ;; *) continue ;; esac
    name=$(basename "$link"); keep=false
    for w in ${WANTED[@]+"${WANTED[@]}"}; do [ "$w" = "$name" ] && { keep=true; break; }; done
    $keep || { run rm -f "$link"; pruned=$((pruned+1)); echo "  pruned $name (not in list anymore)"; }
  done
fi

# verify + manifest
broken=0
if ! $DRY_RUN; then
  : > "$MANIFEST"
  for name in ${LINKED[@]+"${LINKED[@]}"}; do
    if [ -f "$SKILLS_DIR/$name/SKILL.md" ]; then echo "$name" >> "$MANIFEST"
    else c_err "  BROKEN: $SKILLS_DIR/$name"; broken=$((broken+1)); fi
  done
fi

# ---- optional settings.json edits (--deny-rm / --budget) -----------------------
# Merges keys into ~/.claude/settings.json with python3; keeps a timestamped backup.
settings_merge() {   # settings_merge <python-expr applied to dict `d`>
  local f="$CLAUDE_HOME/settings.json"
  if $DRY_RUN; then echo "  [dry-run] edit $f: $1"; return; fi
  command -v python3 >/dev/null || { c_warn "python3 missing — edit $f by hand: $1"; return; }
  [ -f "$f" ] && cp "$f" "$f.bak.$(date +%Y%m%d%H%M%S)"
  python3 - "$f" "$1" <<'PY' || c_warn "  could not update $f (invalid JSON?) — backup kept"
import json, sys, os
f, expr = sys.argv[1], sys.argv[2]
d = json.load(open(f)) if os.path.exists(f) and os.path.getsize(f) else {}
exec(expr)
json.dump(d, open(f, "w"), indent=2, ensure_ascii=False); open(f, "a").write("\n")
print("  updated", f)
PY
}
if $DENY_RM; then
  echo "Adding rm/rmdir deny rules ..."
  settings_merge 'p=d.setdefault("permissions",{}); L=p.setdefault("deny",[]); [L.append(r) for r in ("Bash(rm *)","Bash(rmdir *)") if r not in L]'
fi
if [ -n "$BUDGET" ]; then
  echo "Setting skillListingBudgetFraction=$BUDGET ..."
  settings_merge "d['skillListingBudgetFraction']=float('$BUDGET')"
fi

# ---- plugins -------------------------------------------------------------------
if $DO_PLUGINS; then
  [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"   # native-installer location
  if command -v claude >/dev/null 2>&1; then
    echo "Claude Code : $(claude --version 2>/dev/null | head -1)"
    mkts=$(claude plugin marketplace list 2>/dev/null || true)
    plist=$(claude plugin list 2>/dev/null || true)
    for spec in "${PLUGINS[@]}"; do
      IFS='|' read -r repo mkt plug <<<"$spec"
      if ! grep -q "$mkt" <<<"$mkts"; then
        echo "Adding marketplace $mkt ($repo) ..."
        run claude plugin marketplace add "$repo" || c_warn "  marketplace add failed: $repo"
        mkts="$mkts $mkt"
      fi
      if grep -q "${plug}@${mkt}" <<<"$plist"; then
        echo "  plugin ${plug}@${mkt} already installed"
      else
        echo "Installing plugin ${plug}@${mkt} ..."
        run claude plugin install "${plug}@${mkt}" || c_warn "  install failed: ${plug}@${mkt} (try inside a session: /plugin install ${plug}@${mkt})"
      fi
    done
  else
    c_warn "claude CLI not on PATH — skipped plugins. Inside Claude Code run:"
    for spec in "${PLUGINS[@]}"; do IFS='|' read -r repo mkt plug <<<"$spec"; echo "  /plugin marketplace add $repo ; /plugin install ${plug}@${mkt}"; done
  fi
fi

# ---- summary -------------------------------------------------------------------
echo
c_ok "Done. ${#LINKED[@]} skill(s) linked, $pruned pruned, $broken broken."
$DRY_RUN || { echo "Manifest: $MANIFEST"; }
command -v uv >/dev/null 2>&1 || echo "Note: some K-Dense skills call 'uv' for helper scripts and may suggest 'uv pip install'. Optional — in a fixed conda environment prefer NOT to install it; the CLAUDE.md templates tell Claude to ask before installing packages."
cat <<'EOF'

Next steps (inside Claude Code on this machine):
  /reload-skills      pick up the new skills without restarting (or just start a new session)
  /skills             check the list; synced claude.ai skills show under "claude.ai sync"
  /skill-doctor       after a week or two: per-skill context cost + usage → prune unused ones
  /doctor             check the skill LISTING budget (1% of context): if it overflows, descriptions
                      are dropped (least-used first = your new skills) and auto-use stops working.
                      Fix: turn off unrelated claude.ai plugins (sales, marketing, …) and/or
                      re-run with --budget 0.02
  /plugin             confirm skill-creator and bio-research are enabled (claude.ai sync or CLI)
  /mcp                PubMed / bioRxiv / ChEMBL / Open Targets connect without login;
                      ignore (or /mcp disable) the ones that ask for an account

The skill files are instructions, not software: scanpy, GATK, samtools etc. still
have to exist in your conda env. Each SKILL.md lists its own prerequisites.
EOF
