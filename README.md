# tollgate-knowledgebase

Knowledge base for the [TollGate](https://github.com/OpenTollGate/tollgate) project. Currently focused on tracking incidents — recurring failure modes, their mitigations, root causes, and the fixes in flight.

The repo is structured to be agent-friendly: every artifact has machine-readable frontmatter, a fixed set of headings, and a skill that knows how to read or extend it.

## Layout

- [`incidents/`](incidents/) — one Markdown file per incident, named `YYYY-MM-DD_slug.md`.
- [`templates/incident.md`](templates/incident.md) — the template incidents are written from.
- [`skills/`](skills/) — agent skills (see below).
- [`AGENTS.md`](AGENTS.md), [`CLAUDE.md`](CLAUDE.md) — symlinks into the active skill so agents pick up its instructions on load.

## Workflow

Active incidents are tracked via pull request:

1. Open a PR that adds a new file under [`incidents/`](incidents/) following the template.
2. Iterate on the PR as the situation evolves — update mitigation, root cause, and permanent fix as more is learned.
3. Merge the PR once the incident is resolved (permanent fix shipped, or it's confirmed obsolete). The merged file becomes the historical record.

This means open PRs == open incidents. The `main` branch is the post-mortem archive.

## Skills

- [`incident-overview`](skills/incident-overview/SKILL.md) — read or create incidents.
  - Read: `bash skills/incident-overview/scripts/overview.sh [N]` prints the N most recent incidents (newest first) as one concatenated, agent-ready document.
  - Create: follow the template, fill the per-section frontmatter, drop the file into `incidents/`.
