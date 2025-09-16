#!/usr/bin/env bash
# Test file naming and timestamps

C2I="$BASEDIR/clipboard-to-imagefile"
OUTPUT_DIR="$TESTDIR/output"

# Test: Filename format
test_info "Testing filename format"
output=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
exitcode=$?
assert_exit_code 0 "$exitcode" "Should create file successfully"
basename=$(basename "$output")
assert_true "[[ '$basename' =~ ^image-[0-9]{8}-[0-9]{6}\.png$ ]]" "Filename should match pattern: image-YYYYMMDD-HHMMSS.png"

# Test: Timestamp accuracy
test_info "Testing timestamp accuracy"
before=$(date +'%Y%m%d-%H%M%S')
sleep 1
output=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
sleep 1
after=$(date +'%Y%m%d-%H%M%S')
basename=$(basename "$output")
timestamp=${basename#image-}
timestamp=${timestamp%.png}

test_info "Before: $before"
test_info "File:   $timestamp"
test_info "After:  $after"
assert_true "[[ '$timestamp' > '$before' || '$timestamp' == '$before' ]]" "Timestamp should be >= start time"
assert_true "[[ '$timestamp' < '$after' || '$timestamp' == '$after' ]]" "Timestamp should be <= end time"

# Test: Multiple files don't overwrite
test_info "Testing multiple files don't overwrite"
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
file1=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
sleep 1  # Ensure different timestamp
# Reload image to clipboard
xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
file2=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
assert_true "[[ '$file1' != '$file2' ]]" "Multiple saves should create different files"
assert_file_exists "$file1" "First file should still exist"
assert_file_exists "$file2" "Second file should exist"

# Test: PNG extension
test_info "Testing PNG extension"
output=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
assert_true "[[ '$output' == *.png ]]" "Output file should have .png extension"

# Test: File is valid PNG
test_info "Testing file is valid PNG"
output=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
file_type=$(file "$output")
assert_contains "$file_type" "PNG image data" "File should be valid PNG image"

#fin
