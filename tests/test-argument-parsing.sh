#!/usr/bin/env bash
# Test argument parsing

C2I="$BASEDIR/clipboard-to-imagefile"
OUTPUT_DIR="$TESTDIR/output"

# Test: Long options
test_info "Testing long option --compress"
output=$("$C2I" --compress "$OUTPUT_DIR" 2>/dev/null)
exitcode=$?
if command -v pngquant &> /dev/null; then
  assert_exit_code 0 "$exitcode" "Should accept --compress long option"
else
  skip "pngquant not installed"
  ((TESTS_SKIPPED+=1))
fi

test_info "Testing long option --copy-path"
output=$("$C2I" --copy-path "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should accept --copy-path long option"
assert_contains "$output" "File path copied" "Should copy path with long option"

test_info "Testing long option --verbose"
output=$("$C2I" --verbose "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should accept --verbose long option"

test_info "Testing long option --quiet"
output=$("$C2I" --quiet "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should accept --quiet long option"
assert_equals "" "$output" "Should be quiet with long option"

# Test: Combined short options
test_info "Testing combined short options -vp"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output=$("$C2I" -vp "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should accept combined options -vp"
assert_contains "$output" "File path copied" "Should be verbose and copy path"

test_info "Testing combined short options -pc"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
if command -v pngquant &> /dev/null; then
  output=$("$C2I" -pc "$OUTPUT_DIR" 2>&1)
  exitcode=$?
  assert_exit_code 0 "$exitcode" "Should accept combined options -pc"
  assert_contains "$output" "File path copied" "Should compress and copy path"
else
  skip "pngquant not installed"
  ((TESTS_SKIPPED+=2))
fi

# Test: Option order independence
test_info "Testing option order independence"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output1=$("$C2I" -v "$OUTPUT_DIR" 2>/dev/null)
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output2=$("$C2I" "$OUTPUT_DIR" -v 2>/dev/null)
# Both should succeed
assert_true "[[ -f '$output1' && -f '$output2' ]]" "Options should work regardless of position"

# Test: Multiple verbose flags
test_info "Testing multiple verbose flags"
output=$("$C2I" -vv "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should accept multiple verbose flags"

# Test: Compression with explicit value after equals (not supported, but test behavior)
test_info "Testing compression value formats"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output=$("$C2I" -c50 "$OUTPUT_DIR" 2>&1)
exitcode=$?
# This format is not supported - -c50 will be treated as -c -5 -0
assert_exit_code 22 "$exitcode" "Should fail for -c50 format (not supported)"

#fin
