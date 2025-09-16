#!/usr/bin/env bash
# Test basic functionality of clipboard-to-imagefile

# Test variables
C2I="$BASEDIR/clipboard-to-imagefile"
OUTPUT_DIR="$TESTDIR/output"

# Test: Default save to /tmp
test_info "Testing default save to /tmp"
output=$("$C2I" 2>/dev/null)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should save successfully to /tmp"
assert_true "[[ -f '$output' ]]" "Output file should exist: $output"
assert_contains "$output" "/tmp/image-" "Output path should be in /tmp"
assert_contains "$output" ".png" "Output should be a PNG file"
rm -f "$output" 2>/dev/null

# Test: Save to current directory
test_info "Testing save to specified directory"
output=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should save successfully to specified dir"
assert_true "[[ -f '$output' ]]" "Output file should exist"
assert_contains "$output" "$OUTPUT_DIR/image-" "Output should be in specified directory"

# Test: Quiet mode
test_info "Testing quiet mode"
output=$("$C2I" -q "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should save successfully in quiet mode"
assert_equals "" "$output" "Should produce no output in quiet mode"

# Test: Verbose mode
test_info "Testing verbose mode"
output=$("$C2I" -v "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should save successfully in verbose mode"
assert_true "[[ -n '$output' ]]" "Should produce output in verbose mode"

# Test: Version output
test_info "Testing version output"
output=$("$C2I" --version 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should show version successfully"
assert_contains "$output" "1.1.0" "Should show correct version"

# Test: Help output
test_info "Testing help output"
output=$("$C2I" --help 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should show help successfully"
assert_contains "$output" "Usage:" "Should show usage information"
assert_contains "$output" "Options:" "Should show options"
assert_contains "$output" "Examples:" "Should show examples"

#fin
