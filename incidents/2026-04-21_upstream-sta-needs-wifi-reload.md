---
date: 21-04-2026
tags: tollgate, openwrt, wifi, upstream
name: upstream STA wifi config does not connect until 'wifi reload'
issue: >-
  Upstream WiFi STA configured via LuCI fails to associate; router stays
  offline with 'Network unreachable' until 'wifi reload' is run.
impact: >-
  Operators bringing TollGate online behind a non-TollGate WiFi uplink may
  give up, since logs misleadingly imply a TollGate-only constraint.
mitigation: >-
  Run 'wifi reload' after applying the LuCI wireless config.
root_cause: >-
  Unknown. LuCI's apply path does not bring up the new STA config; the
  misleading log line is a separate UX defect.
permanent_fix: >-
  None yet. Needs (1) LuCI changes to apply without manual reload and
  (2) reword the misleading 'no TollGate connections' log line.
---


# Upstream STA WiFi config does not connect until `wifi reload`

## Issue

User configured an upstream WiFi STA on the TollGate router via LuCI (`cgi-bin/luci/admin/network/wireless`) to pull internet from a non-TollGate AP. The STA failed to associate; `ping 1.1.1.1` returned `Network unreachable`. Logs surfaced `INTERFACE DOWN: Interface disconnected (no TollGate connections)`, suggesting (incorrectly) that the upstream had to be a TollGate.

## impact

Looks like a fundamental "TollGate only buys from TollGate" limitation, but isn't — it's a config-apply gap. Operators may give up thinking the feature is unsupported.

## mitigation

Run `wifi reload` after applying the LuCI wireless config; the STA then associates and routing works.

## root cause

Unknown. LuCI's apply step on this build does not actually bring up the freshly-configured STA. The misleading log line is a separate UX defect on top of that.

## permanent fix

None yet. Two follow-ups: (1) make LuCI changes apply without a manual reload, (2) reword the misleading log line so it doesn't imply a TollGate-only constraint when the STA fails to associate.
