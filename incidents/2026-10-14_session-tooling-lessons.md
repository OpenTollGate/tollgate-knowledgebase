# 2026-10-13/14 — consolidation session: tooling lessons (no product impact)

Four sharp tooling failures from the governance/consolidation session, all
caught by fail-closed checks before damage; recorded so the checks get
reused, not just the scars.

## 1. Stale remote-tracking ref → silent no-op edits

`git worktree add … origin/main` without a preceding `git fetch` happily
builds on a weeks-old ref; `str.replace`-style scripted edits then match
nothing and "succeed" silently. Cost: two no-op map edits. Guard: **fetch
before every worktree branch-off, and assert anchor-in-content before any
scripted doc edit** (`assert anchor in s`). The assertion is what made this
a lesson instead of an incident.

## 2. `gh api -w '%{http_code}'` measures nothing

gh's `-w` write-out flag is not curl's; status probes built on it return
empty strings that read as "not 200" → a fork-exposure sweep reported
"all clean" while `main` tips were exposed. Guard: **always run a positive
control** (a ref where the condition is known-true) before trusting a
negative sweep. Working method for tip checks, now in the #206 comment:
`gh api repos/<fork>/git/trees/<branch> -q '[.tree[] | select(.path=="X")] | length'`.

## 3. Chained `sed` self-overlap

Sequential `sed` expressions over the same file double-substitute
overlapping patterns (`LOCAL-VM-TESTING.md` → `docs/LOCAL-VM-docs/TESTING.md`,
`docs/docs/TESTING.md`). Guard: after any scripted reference rewrite,
grep for the broken shapes (`docs/docs`, doubled prefixes) — they are
cheap to catch and embarrassing to merge.

## 4. `git bundle` prerequisites + fork-headed PRs

A bundle created from `origin/main..branch` cannot be fetched into a repo
missing its base commits (the shared ai-legion checkout was pre-rc3), and
PR branches from forks do not exist on `origin` at all — fetch by the PR's
`headRepositoryOwner` + refspec (`+refs/heads/<ref>:refs/pr/<N>`), which
also gives every queue PR a stable local ref for review tooling.

Session-context: these surfaced during PRTA #216–#245 and module #892–#925;
the meta-lesson — assertions on every scripted mutation — is already the
house style in the fences (`tests/contract/`), this extends it to session
tooling.
