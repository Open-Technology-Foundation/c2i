#!/usr/bin/env bash
# Test clipboard path copy functionality

C2I="$BASEDIR/clipboard-to-imagefile"
OUTPUT_DIR="$TESTDIR/output"

# Test: Copy path to clipboard
test_info "Testing copy path to clipboard"
output=$("$C2I" -p "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should save and copy path successfully"
assert_contains "$output" "File path copied to clipboard" "Should confirm path was copied"

# Verify clipboard contains the path
clipboard_content=$(xclip -selection clipboard -o 2>/dev/null)
# The output includes both the path and the info message, extract just the path
actual_path=$(echo "$output" | grep -v "File path copied" | grep -E "^/.+\.png$")
assert_equals "$actual_path" "$clipboard_content" "Clipboard should contain the file path"

# Test: Copy path in quiet mode
test_info "Testing copy path in quiet mode"
# Reload image to clipboard first
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output=$("$C2I" -p -q "$OUTPUT_DIR" 2>&1)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should save and copy path in quiet mode"
assert_equals "" "$output" "Should produce no output in quiet mode"

# But clipboard should still have the path
clipboard_content=$(xclip -selection clipboard -o 2>/dev/null)
assert_contains "$clipboard_content" "$OUTPUT_DIR/image-" "Clipboard should contain file path even in quiet mode"

# Test: Copy path with compression
test_info "Testing copy path with compression"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
output=$("$C2I" -p -c "$OUTPUT_DIR" 2>&1)
exitcode=$?
if command -v pngquant &> /dev/null; then
  assert_exit_code 0 "$exitcode" "Should compress and copy path successfully"
  assert_contains "$output" "File path copied to clipboard" "Should confirm path was copied"
else
  skip "pngquant not installed - skipping compression with path copy test"
  ((TESTS_SKIPPED+=2))
fi

#fin
