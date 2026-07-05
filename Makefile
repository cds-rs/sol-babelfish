.ONESHELL:
SHELL := /bin/bash

# The vogon-registry corpus is public, so its members default to the
# sibling checkout (override per invocation if yours lives elsewhere).
# The AMM example lives in a private repo whose location stays out of
# this file: its path arrives only via the environment.
#
#   AMM_PATH=/path/to/the/amm/example  make amm
#   make record
#   make subscriptions

RECORD_PATH        ?= ../vogon-registry/record
SUBSCRIPTIONS_PATH ?= ../vogon-registry/subscriptions

.PHONY: amm record subscriptions

amm:
	set -e
	: "$${AMM_PATH:?set AMM_PATH to the AMM example directory}"
	scripts/add-book.sh amm "$$AMM_PATH" \
	  "AMM" \
	  "A constant-product AMM: initialize a pool, add liquidity, and the atomic sandwich that proves a locked pool is no boundary against the authority who holds the key."

record:
	set -e
	scripts/add-book.sh record "$(RECORD_PATH)" \
	  "Record" \
	  "The SPL Record program: store bytes behind an authority you can hand off. Small and complete, a good first read."

subscriptions:
	set -e
	scripts/add-book.sh subscriptions "$(SUBSCRIPTIONS_PATH)" \
	  "Subscriptions" \
	  "A recurring-payment program: a usage guide by journey (authorities, plans, subscribing, collecting, delegations), every page an executed story with the integration code to match, and the audit findings that now hold as enforcement exhibits."

all: amm record subscriptionS

