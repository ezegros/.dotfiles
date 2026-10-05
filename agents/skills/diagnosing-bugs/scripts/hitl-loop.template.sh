#!/usr/bin/env bash
# Human-in-the-loop reproduction loop.
# Copy this file, edit the steps below, and run it.
# The agent runs the script; the user follows prompts in their terminal.
#
# Last resort only. Before reaching for this, check the loop really needs a
# human: the admin UI can usually be driven with browser-use against
# the already-logged-in Chrome (see the browser-use skill), and most BFF
# questions are answered faster by curl or grpcurl.
#
# Usage:
#   bash hitl-loop.template.sh
#
# Two helpers:
#   step "<instruction>"          -> show instruction, wait for Enter
#   capture VAR "<question>"      -> show question, read response into VAR
#
# At the end, captured values are printed as KEY=VALUE for the agent to parse.
#
# `capture` prints its value back to the terminal, where the agent reads it,
# so capture observations, and leave signing in to the user as a `step`.
#
# Never ask the human to paste a JWT, a signing key id or any other secret
# into a capture: those belong in the environment, not in what the agent reads.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter when done] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- edit below ---------------------------------------------------------

step "Open the admin console in the logged-in Chrome profile and go to Control Tower."

step "Open DevTools -> Network, and filter on the BFF route under test."

capture SYMPTOM "Trigger the action. Did the symptom appear? (y/n)"

capture STATUS "What HTTP status did the BFF request return (or 'none')?"

capture DETAIL "Paste the error text or the wrong value you see (or 'none'):"

# --- edit above ---------------------------------------------------------

printf '\n--- Captured ---\n'
printf 'SYMPTOM=%s\n' "$SYMPTOM"
printf 'STATUS=%s\n' "$STATUS"
printf 'DETAIL=%s\n' "$DETAIL"
