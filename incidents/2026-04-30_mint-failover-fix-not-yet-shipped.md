---
date: 30-04-2026
tags: tollgate, release, build, dev-channel, mint
name: mint-failover fix exists but is not reachable by users
issue: >-
  Fix for the mint-related failures sits on a branch — dev-channel build
  URL 404s and stable v0.4.0 predates PR #99.
impact: >-
  Operators in the field have no path to the fix and keep hitting mint
  failures despite upgrading.
mitigation: >-
  Drop misbehaving mints from /etc/tollgate/config.json (see related
  ecash-receive and merchant-init incidents).
root_cause: >-
  Build for the fix commit was never published to the dev channel, and no
  new stable release has been cut since v0.4.0. PR #99 is also gated on
  test-tooling PR #109.
permanent_fix: >-
  Republish the dev build and/or cut a new stable release containing PR #99
  once PR #109 lands.
---


# Mint-failover fix exists but is not reachable by users

## Issue

The mint-failover fix is implemented in PR #99 but operators in the field cannot get it:

- The dev-channel build link shared for testing — `https://releases.tollgate.me/os/689300eb…?channel=dev` — returns `The requested OS release could not be found.` for everyone who tries it.
- The current stable release, v0.4.0, predates the fix. Operators upgrading from v0.3.2 → v0.4.0 see no improvement and continue to hit the mint-related failures.

## impact

Affected operators have no good path to the fix. They either keep hitting mint failures or maintain ad-hoc config edits indefinitely. Reinforces the "TollGate doesn't work with my mint" perception even though a fix exists.

## mitigation

Drop misbehaving mints from `/etc/tollgate/config.json` (see the related ecash-receive and merchant-init incidents).

## root cause

This is a fix-delivery problem rather than a code defect. Two contributing causes: the dev-channel build for the fix commit was never (re)published to a working URL, and no new stable release has been cut since v0.4.0. PR #99 is also gated on test-tooling PR #109, which has slowed the merge.

## permanent fix

Republish the dev build and/or fast-track a new stable release that includes PR #99 once PR #109 is reviewed and merged.
