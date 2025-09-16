#!/usr/bin/env bash
# Test error handling

C2I="$BASEDIR/clipboard-to-imagefile"
OUTPUT_DIR="$TESTDIR/output"

# Test: Invalid option
test_info "Testing invalid option handling"
output=$("$C2I" --invalid-option 2>&1)
exitcode=$?
assert_exit_code 22 "$exitcode" "Should fail with exit code 22 for invalid option"
assert_contains "$output" "Invalid option" "Should report invalid option"

# Test: Non-existent directory
test_info "Testing non-existent directory"
output=$("$C2I" "/non/existent/directory" 2>&1)
exitcode=$?
assert_exit_code 1 "$exitcode" "Should fail for non-existent directory"
assert_contains "$output" "does not exist" "Should report directory doesn't exist"

# Test: No image in clipboard
test_info "Testing no image in clipboard"
# Clear clipboard or put text in it
echo "This is text, not an image" | xclip -selection clipboard
output=$("$C2I" "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 1 "$exitcode" "Should fail when no image in clipboard"
assert_contains "$output" "No image found in clipboard" "Should report no image found"

# Test: Invalid compression value (too low)
test_info "Testing invalid compression value (too low)"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output=$("$C2I" -c 10 "$OUTPUT_DIR" 2>&1)
exitcode=$?
# Script auto-corrects to 20, so should succeed
assert_exit_code 0 "$exitcode" "Should auto-correct low compression value"

# Test: Invalid compression value (non-numeric)
test_info "Testing invalid compression value (non-numeric)"
output=$("$C2I" -c abc "$OUTPUT_DIR" 2>&1)
exitcode=$?
# Bash will interpret non-numeric as 0, which gets corrected to 20
assert_exit_code 0 "$exitcode" "Should handle non-numeric compression value"

# Test: File permissions (if possible to test)
test_info "Testing directory without write permissions"
READONLY_DIR="$TESTDIR/tmp/readonly"
mkdir -p "$READONLY_DIR"
chmod 555 "$READONLY_DIR"
output=$("$C2I" "$READONLY_DIR" 2>&1)
exitcode=$?
if [[ $(id -u) -eq 0 ]]; then
  skip "Running as root - permission test skipped"
  ((TESTS_SKIPPED+=1))
else
  assert_exit_code 1 "$exitcode" "Should fail for directory without write permissions"
fi
chmod 755 "$READONLY_DIR"
rm -rf "$READONLY_DIR"

# Test: Combined short options with invalid option
test_info "Testing combined short options with invalid"
output=$("$C2I" -vqz 2>&1)
exitcode=$?
assert_exit_code 22 "$exitcode" "Should fail with invalid option in combined short options"

#fin
