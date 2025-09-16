#!/usr/bin/env bash
# Simple test to verify framework

C2I="$BASEDIR/clipboard-to-imagefile"

# Test: Version check
test_info "Testing version check"
output=$("$C2I" --version 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Version check should succeed"
assert_contains "$output" "1.0.1" "Should contain version number"

#fin