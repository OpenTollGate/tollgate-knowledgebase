---
date: 22-04-2026
tags: tollgate, wallet, mint, merchant
name: merchant fails to initialize when configured mint returns 502
issue: >-
  Merchant wallet init fails with 'error code: 502' from the first listed
  mint; tollgate service never starts and CLI calls hit 'connection refused'.
impact: >-
  A single unreachable mint takes down the whole gateway — no payments,
  no CLI, no service.
mitigation: >-
  Remove the unresponsive mint from /etc/tollgate/config.json and restart
  tollgate-wrt.
root_cause: >-
  Gateway hard-fails wallet init on the first listed mint instead of
  falling back to other configured mints. Triggered here by a DDoS on
  mint.coinos.io.
permanent_fix: >-
  PR #99 — auto de-list unreachable mints; gated on test-tooling PR #109.
---


# Merchant fails to initialize when configured mint returns 502

## Issue

On startup the merchant tried to open a wallet against the first mint in `/etc/tollgate/config.json` (`https://mint.coinos.io`). The mint returned HTTP 502 and wallet creation aborted with `failed to create wallet: error code: 502`. The mint was unreachable due to a DDoS event.

## impact

The tollgate service never started, so the unix socket at `/var/run/tollgate.sock` was never opened. `tollgate status` and every other CLI call failed with `connection refused`. A single bad mint took down the whole happy path instead of falling back to other configured mints.

## mitigation

Remove the unresponsive mint from `/etc/tollgate/config.json` and restart `tollgate-wrt`.

## root cause

The gateway treats wallet init as all-or-nothing on the first listed mint and does not fall back to other configured mints. A transient outage on the first mint (here, a DDoS against `mint.coinos.io`) is sufficient to keep the entire service from starting.

## permanent fix

PR #99 — temporarily de-list unreachable mints rather than failing init. Gated on test-tooling PR #109. Spillman channels are expected to reduce DDoS exposure later.
