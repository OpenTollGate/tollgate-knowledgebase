---
date: 24-04-2026
tags: tollgate, wallet, cashu, mint, coinos, minibits
name: ecash receive fails when configured mint is flaky
issue: >-
  Gateway rejects incoming tokens with 'outputs are pending' (minibits) or
  'proofs already spent' (coinos), even when the sender wallet reports
  success.
impact: >-
  Pay flow looks successful client-side but the TollGate refuses the token,
  internet is never granted, funds appear stuck mid-flight.
mitigation: >-
  Remove the flaky mint(s) from /etc/tollgate/config.json and restart;
  the token can typically be retried on a different gateway.
root_cause: >-
  Gateway hard-fails wallet.Receive when a configured mint misbehaves
  instead of skipping it. Same class of problem as the merchant-init
  incident.
permanent_fix: >-
  PR #99 — auto de-list misbehaving mints; gated on test-tooling PR #109.
  Duplicate-swap and ISP-blocking edges still need investigation.
---


# Ecash receive fails when configured mint is flaky

## Issue

On the gateway, `TollWallet.Receive` failed mid-payment in two distinct error variants, both tied to the configured mint misbehaving:

- Against `https://mint.minibits.cash/Bitcoin`: `wallet.Receive failed: could not swap proofs: outputs are pending`. Reported from a Starlink uplink at sea — possibly proofs partially swapped on a different gateway, or ISP-level interference with mint traffic.
- Against `https://mint.coinos.io`: `wallet.Receive failed: could not swap proofs: proofs already spent`. Reproduced by multiple operators with both minibits-originated and self-hosted-mint tokens. Sender wallet reported the send as successful in every case.

## impact

Pay flow appears successful on the client but the TollGate refuses the token, so internet is never granted and the user's funds are stuck mid-flight. Erodes trust in the payment path; users initially blamed their own setup before realizing it was mint-side. Especially painful on constrained / monitored uplinks like Starlink.

## mitigation

Remove the flaky mint(s) from `/etc/tollgate/config.json` and restart the service. Token reportedly remains good and can be retried elsewhere.

## root cause

Same class of problem as the merchant-init incident: the gateway hard-fails when a configured mint misbehaves rather than skipping it. The two error strings reflect different upstream conditions (pending swaps vs already-spent proofs) but the gateway's response — abort the receive — is the same.

## permanent fix

PR #99 — auto de-list unreachable / misbehaving mints. Gated on test-tooling PR #109. Also needs investigation into duplicate-swap scenarios across multiple gateways and ISP-level mint blocking.
