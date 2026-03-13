#!/usr/bin/env bash
set -euo pipefail

# Test runner for clipboard-to-imagefile (c2i)
VERSION='1.0.0'
PRG0=$(readlink -en -- "$0")
PRG=${PRG0##*/}
TESTDIR=${PRG0%/*}
BASEDIR=$(dirname "$TESTDIR")
readonly -- VERSION PRG0 PRG TESTDIR BASEDIR

# Test counters
declare -i TESTS_TOTAL=0
declare -i TESTS_PASSED=0
declare -i TESTS_FAILED=0
declare -i TESTS_SKIPPED=0

# Color definitions
if [[ -t 2 ]]; then
  declare -- RED=$'\033[0;31m' GREEN=$'\033[0;32m' YELLOW=$'\033[0;33m' CYAN=$'\033[0;36m' NC=$'\033[0m'
else
  declare -- RED='' GREEN='' YELLOW='' CYAN='' NC=''
fi
readonly -- RED GREEN YELLOW CYAN NC

# --------------------------------------------------------------------------------
# Utility functions
# --------------------------------------------------------------------------------

# Core message function
_msg() {
  local -- status="${FUNCNAME[1]}" prefix="$PRG" msg
  case "$status" in
    pass)      prefix+=": ${GREEN}✓${NC}" ;;
    fail)      prefix+=": ${RED}✗${NC}" ;;
    skip)      prefix+=": ${YELLOW}⊘${NC}" ;;
    test_info) prefix+=": ${CYAN}ℹ${NC}" ;;
    error)     prefix+=": ${RED}error${NC}" ;;
    section)   prefix=""; status="${CYAN}===${NC}" ;;
  esac
  for msg in "$@"; do
    if [[ $status == "${CYAN}===${NC}" ]]; then
      printf '\n%s %s %s\n' "$status" "$msg" "$status"
    else
      printf '%s %s\n' "$prefix" "$msg"
    fi
  done
}

pass() { >&2 _msg "$@"; }
fail() { >&2 _msg "$@"; }
skip() { >&2 _msg "$@"; }
test_info() { >&2 _msg "$@"; }
error() { >&2 _msg "$@"; }
section() { >&2 _msg "$@"; }

# Test assertion functions
assert_equals() {
  local -- expected="$1" actual="$2" message="${3:-}"
  ((TESTS_TOTAL+=1))
  if [[ "$expected" == "$actual" ]]; then
    ((TESTS_PASSED+=1))
    pass "$message"
    return 0
  else
    ((TESTS_FAILED+=1))
    fail "$message"
    error "  Expected: '$expected'"
    error "  Got:      '$actual'"
    return 1
  fi
}

assert_true() {
  local -- condition="$1" message="${2:-}"
  ((TESTS_TOTAL+=1))
  if eval "$condition"; then
    ((TESTS_PASSED+=1))
    pass "$message"
    return 0
  else
    ((TESTS_FAILED+=1))
    fail "$message"
    error "  Condition failed: $condition"
    return 1
  fi
}

assert_false() {
  local -- condition="$1" message="${2:-}"
  ((TESTS_TOTAL+=1))
  if ! eval "$condition"; then
    ((TESTS_PASSED+=1))
    pass "$message"
    return 0
  else
    ((TESTS_FAILED+=1))
    fail "$message"
    error "  Condition should have failed: $condition"
    return 1
  fi
}

assert_file_exists() {
  local -- filepath="$1" message="${2:-File should exist}"
  assert_true "[[ -f '$filepath' ]]" "$message: $filepath"
}

assert_file_not_exists() {
  local -- filepath="$1" message="${2:-File should not exist}"
  assert_false "[[ -f '$filepath' ]]" "$message: $filepath"
}

assert_contains() {
  local -- haystack="$1" needle="$2" message="${3:-}"
  ((TESTS_TOTAL+=1))
  if [[ "$haystack" == *"$needle"* ]]; then
    ((TESTS_PASSED+=1))
    pass "$message"
    return 0
  else
    ((TESTS_FAILED+=1))
    fail "$message"
    error "  String '$needle' not found in output"
    return 1
  fi
}

assert_exit_code() {
  local -i expected="$1" actual="$2"
  local -- message="${3:-Exit code check}"
  assert_equals "$expected" "$actual" "$message (exit code)"
}

# Test setup/teardown
setup_test() {
  # Clean test output directory
  rm -rf "$TESTDIR/output"/*
  rm -rf "$TESTDIR/tmp"/*
  mkdir -p "$TESTDIR/output" "$TESTDIR/tmp"

  # Load test image to clipboard if available
  if [[ -f "$TESTDIR/fixtures/test-image.png" ]]; then
    xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null || true
  fi
}

teardown_test() {
  # Cleanup can be added here if needed
  true
}

# --------------------------------------------------------------------------------
# Test execution
# --------------------------------------------------------------------------------

run_test() {
  local -- test_name="$1"
  local -- test_file="$2"

  section "Running: $test_name"
  setup_test

  # Source and run the test
  # shellcheck source=/dev/null
  source "$test_file"

  teardown_test
}

# Main test runner
main() {
  section "Clipboard to Image (c2i) Test Suite v$VERSION"

  # Check if c2i script exists
  if [[ ! -f "$BASEDIR/clipboard-to-imagefile" ]]; then
    error "clipboard-to-imagefile script not found in $BASEDIR"
    exit 1
  fi

  # Check if test fixture exists
  if [[ ! -f "$TESTDIR/fixtures/test-image.png" ]]; then
    error "Test fixture not found: $TESTDIR/fixtures/test-image.png"
    test_info "Copy a screen region to clipboard, then run: make -C tests test-fixtures"
    exit 1
  fi

  test_info "Ensure a screen region has been copied to the clipboard before running tests"
  test_info "Running tests from: $TESTDIR"
  test_info "Testing script: $BASEDIR/clipboard-to-imagefile"

  # Run all test files
  for test_file in "$TESTDIR"/test-*.sh; do
    if [[ -f "$test_file" ]]; then
      test_name=$(basename "$test_file" .sh)
      run_test "$test_name" "$test_file"
    fi
  done

  # Summary
  section "Test Summary"
  test_info "Total tests: $TESTS_TOTAL"
  pass "Passed: $TESTS_PASSED"
  ((TESTS_FAILED)) && fail "Failed: $TESTS_FAILED"
  ((TESTS_SKIPPED)) && skip "Skipped: $TESTS_SKIPPED"

  if ((TESTS_FAILED)); then
    error "Test suite failed!"
    exit 1
  else
    pass "All tests passed!"
    exit 0
  fi
}

# Run tests if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
#fin