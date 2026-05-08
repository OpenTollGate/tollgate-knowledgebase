---
name: incident-overview
description: Build a concatenated, agent-ready dump of recent incidents from the incidents/ directory. Use when the user asks for an incident overview, briefing, or wants to know what's been breaking lately.
---

# incident-overview

Prints recent incident files (newest first by `date:` frontmatter) as one concatenated document, with a header per incident.

## Usage

```
bash skills/incident-overview/scripts/overview.sh [N]
```

- `N` (optional) limits to the N most recent incidents. Default: all.
- Sorts by the `date:` field (`DD-MM-YYYY`); newest first.
- Emits a header per incident (name, date, tags, file path) followed by the full file body.

Pipe the output into context when answering "what's been breaking lately" or "have we seen this before".

For repo-wide conventions (filename format, frontmatter shape, how to author a new incident), see [`AGENTS.md`](../../AGENTS.md) at the repo root.
