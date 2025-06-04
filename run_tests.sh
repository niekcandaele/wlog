#!/bin/bash

# Simple test runner for wlog project

set -euo pipefail

echo "Running wlog tests..."
./bats/bin/bats tests/

echo "All tests completed!"