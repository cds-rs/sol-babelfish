.ONESHELL:
SHELL := /bin/bash

# Source repos are private and their names stay out of this file: paths
# arrive only via the environment, per invocation:
#
#   AMM_PATH=/path/to/the/amm/example            make amm
#   RECORD_PATH=/path/to/the/record/member       make record
#   SUBSCRIPTIONS_PATH=/path/to/the/subs/member  make subscriptions

.PHONY: amm record subscriptions

amm:
	set -e
	: "$${AMM_PATH:?set AMM_PATH to the AMM example directory}"
	scripts/add-book.sh amm "$$AMM_PATH" \
	  "AMM" \
	  "A constant-product AMM: initialize a pool, add liquidity, and the atomic sandwich that proves a locked pool is no boundary against the authority who holds the key."

record:
	set -e
	: "$${RECORD_PATH:?set RECORD_PATH to the record member directory}"
	scripts/add-book.sh record "$$RECORD_PATH" \
	  "Record" \
	  "The SPL Record program: store bytes behind an authority you can hand off. Small and complete, a good first read."

subscriptions:
	set -e
	: "$${SUBSCRIPTIONS_PATH:?set SUBSCRIPTIONS_PATH to the subscriptions member directory}"
	scripts/add-book.sh subscriptions "$$SUBSCRIPTIONS_PATH" \
	  "Subscriptions" \
	  "A recurring-payment program: a usage guide by journey (authorities, plans, subscribing, collecting, delegations), every page an executed story with the integration code to match, and the audit findings that now hold as enforcement exhibits."
