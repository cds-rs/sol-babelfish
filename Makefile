.ONESHELL:
SHELL := /bin/bash

# Source repos are private and their names stay out of this file: paths
# arrive only via the environment, per invocation:
#
#   AMM_PATH=/path/to/the/amm/example make amm

amm:
	set -e
	: "$${AMM_PATH:?set AMM_PATH to the AMM example directory}"
	scripts/add-book.sh amm "$$AMM_PATH" \
	  "AMM" \
	  "A constant-product AMM: initialize a pool, add liquidity, and the atomic sandwich that proves a locked pool is no boundary against the authority who holds the key."
