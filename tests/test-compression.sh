#!/usr/bin/env bash
# Test compression functionality

C2I="$BASEDIR/clipboard-to-imagefile"
OUTPUT_DIR="$TESTDIR/output"

# Check if pngquant is available
if ! command -v pngquant &> /dev/null; then
  skip "pngquant not installed - skipping compression tests"
  ((TESTS_SKIPPED+=5))
else
  # Test: Basic compression with default quality
  test_info "Testing compression with default quality"
  output=$("$C2I" -c "$OUTPUT_DIR" 2>/dev/null)
  exitcode=$?
  assert_exit_code 0 "$exitcode" "Should compress successfully with default quality"
  assert_file_exists "$output" "Compressed file should exist"

  # Get file sizes for comparison
  uncompressed=$("$C2I" "$OUTPUT_DIR" 2>/dev/null)
  size_uncompressed=$(stat -c%s "$uncompressed" 2>/dev/null || stat -f%z "$uncompressed" 2>/dev/null)
  size_compressed=$(stat -c%s "$output" 2>/dev/null || stat -f%z "$output" 2>/dev/null)

  # Usually compressed should be smaller, but not always guaranteed
  test_info "Uncompressed size: $size_uncompressed bytes"
  test_info "Compressed size: $size_compressed bytes"
  assert_true "[[ $size_compressed -gt 0 ]]" "Compressed file should have content"

  # Test: Compression with specific quality (30)
  test_info "Testing compression with quality 30"
  output=$("$C2I" -c 30 "$OUTPUT_DIR" 2>/dev/null)
  exitcode=$?
  assert_exit_code 0 "$exitcode" "Should compress successfully with quality 30"
  assert_file_exists "$output" "Compressed file should exist with quality 30"

  # Test: Compression with high quality (90)
  test_info "Testing compression with quality 90"
  output=$("$C2I" -c 90 "$OUTPUT_DIR" 2>/dev/null)
  exitcode=$?
  assert_exit_code 0 "$exitcode" "Should compress successfully with quality 90"
  assert_file_exists "$output" "Compressed file should exist with quality 90"

  # Test: Compression with minimum quality (20)
  test_info "Testing compression with minimum quality 20"
  output=$("$C2I" -c 20 "$OUTPUT_DIR" 2>/dev/null)
  exitcode=$?
  assert_exit_code 0 "$exitcode" "Should compress successfully with quality 20"
  assert_file_exists "$output" "Compressed file should exist with quality 20"

  # Test: Compression with maximum quality (100)
  test_info "Testing compression with maximum quality 100"
  output=$("$C2I" -c 100 "$OUTPUT_DIR" 2>/dev/null)
  exitcode=$?
  assert_exit_code 0 "$exitcode" "Should compress successfully with quality 100"
  assert_file_exists "$output" "Compressed file should exist with quality 100"
fi

#fin
