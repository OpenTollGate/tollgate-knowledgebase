# Agent guide — tollgate-knowledgebase

This repo is a knowledge base for the [TollGate](https://github.com/OpenTollGate/tollgate) project. Today it tracks incidents — recurring failure modes with their mitigations, root causes, and fixes in flight.

It is structured to be agent-friendly: every artifact has machine-readable frontmatter, a fixed set of headings, and a skill that knows how to operate on it.

## Layout

- [`incidents/`](incidents/) — one Markdown file per incident.
- [`templates/incident.md`](templates/incident.md) — the template incidents are written from.
- [`skills/`](skills/) — agent skills (see [Skills](#skills)).

## Workflow

Active incidents are tracked via pull request:

1. Open a PR adding a new file under [`incidents/`](incidents/) following the template.
2. Iterate as the situation evolves — update mitigation, root cause, and permanent fix as more is learned.
3. Merge the PR once the incident is resolved (permanent fix shipped, or confirmed obsolete).

Open PRs == open incidents. `main` is the post-mortem archive.

## Incident file convention

### Filename

`YYYY-MM-DD_short-slug.md`. Date prefix matches the `date:` frontmatter field (frontmatter is `DD-MM-YYYY`, filename is `YYYY-MM-DD` so files sort chronologically). Slug is short, lowercase, hyphenated.

### Frontmatter

The frontmatter mirrors the body — one short line per body section, written so an agent skimming only the frontmatter can decide whether the incident is relevant to its current task. Use `>-` (folded block scalar) so multiline prose stays valid YAML.

```yaml
---
date: DD-MM-YYYY
tags: comma, separated, tags
name: one-line title
issue: >-
  one-line symptom
impact: >-
  one-line description of who/what is affected
mitigation: >-
  one-line workaround, or "none"
root_cause: >-
  one-line cause, or "unknown"
permanent_fix: >-
  one-line fix with PR/issue ref, or "none yet"
---
```

### Body

Sections appear in this order, headings exactly as shown:

```
# Title

## Issue
What went wrong, what was observed.

## impact
Who/what was affected and how badly.

## mitigation
The workaround in place today. "None." if there isn't one.

## root cause
The underlying cause. "Unknown." if not yet diagnosed.

## permanent fix
The real fix — links to PRs/issues, status. "None yet." if open.
```

Strip personal names. Refer to people by role ("user", "operator", "maintainer").

## Creating an incident

1. Pick a date and a short slug. Compose `YYYY-MM-DD_slug.md` under `incidents/`.
2. Copy [`templates/incident.md`](templates/incident.md) and fill frontmatter + all five body sections.
3. The frontmatter one-liners must match what's in the body — they are the agent-skim summary.
4. Verify it shows up: `bash skills/incident-overview/scripts/overview.sh 1`.
5. Open a PR.

## Skills

- [`incident-overview`](skills/incident-overview/SKILL.md) — print recent incidents as one concatenated, agent-ready document. Use when answering "what's been breaking lately" or "have we seen this before".
