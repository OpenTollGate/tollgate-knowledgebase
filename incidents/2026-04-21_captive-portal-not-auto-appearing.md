---
date: 21-04-2026
tags: tollgate, captive-portal, client, upstream
name: captive portal does not auto-appear on phone
issue: >-
  Phone joins the TollGate AP but no captive portal pops up; user has to
  browse to 192.168.1.1 manually.
impact: >-
  First-time users hit a dead end on join with no obvious next step;
  high onboarding friction.
mitigation: >-
  Make sure the TollGate has upstream internet before clients connect, then
  rejoin. As a fallback, open http://192.168.1.1 manually.
root_cause: >-
  Most often: the TollGate has no upstream connectivity, so the client's
  captive-portal probe never returns the redirect that triggers the OS
  popup. Client-side connectivity-check / DNS quirks on hardened OSes are
  a secondary contributor.
permanent_fix: >-
  None yet. Needs the gateway to serve a portal-trigger response even
  before upstream is up, plus investigation into the probe/DNS path.
---


# Captive portal does not auto-appear on phone

## Issue

After joining the TollGate SSID from a phone, the OS did not trigger the captive-portal flow. Reaching the portal required manually navigating to `http://192.168.1.1`.

## impact

First-time users hit a dead end on join: no portal prompt, no obvious next step, no payment flow. High onboarding-friction bug, especially on hardened OSes where the OS is stricter about its connectivity-check probes.

## mitigation

Confirm the TollGate router itself has working upstream internet before clients connect; the captive portal won't trigger reliably without it. If a client has already joined while upstream was down, disconnect/rejoin once upstream is back. As a fallback, manually open `http://192.168.1.1`.

## root cause

The dominant cause is the TollGate having no upstream internet at the moment the client connects. Phones decide whether to show the captive-portal popup based on a connectivity-check probe; without upstream, the gateway can't return the redirect the client expects, so the OS never prompts. A secondary contributor on hardened OSes (e.g. GrapheneOS) is stricter handling of the connectivity-check / DNS lookups against unknown APs, which can suppress the popup even when upstream is healthy.

## permanent fix

None yet. The gateway should serve a portal-trigger response (intercepting the connectivity-check endpoints) regardless of upstream state, so the popup fires even before internet is bought. Also needs investigation into how the captive-portal probe is intercepted on the DNS path for the hardened-OS edge case.
