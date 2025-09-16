#!/usr/bin/env bash
set -euo pipefail

# Simple test runner to debug issues
echo "Starting simple test..."

TESTDIR="$(cd "$(dirname "$0")" && pwd)"
BASEDIR="$(dirname "$TESTDIR")"
C2I="$BASEDIR/clipboard-to-imagefile"

echo "Test directory: $TESTDIR"
echo "Base directory: $BASEDIR"
echo "Script: $C2I"

# Test version
echo "Testing version..."
output=$("$C2I" --version 2>&1)
exitcode=$?
echo "Output: $output"
echo "Exit code: $exitcode"

if [[ $exitcode -eq 0 ]] && [[ "$output" == *"1.0.1"* ]]; then
  echo "✓ Version test passed"
else
  echo "✗ Version test failed"
fi

# Test help
echo "Testing help..."
output=$("$C2I" --help 2>&1)
exitcode=$?
if [[ $exitcode -eq 0 ]] && [[ "$output" == *"Usage:"* ]]; then
  echo "✓ Help test passed"
else
  echo "✗ Help test failed"
fi

# Test with image in clipboard
echo "Loading test image to clipboard..."
if [[ -f "$TESTDIR/fixtures/test-image.png" ]]; then
  xclip -selection clipboard -t image/png -i < "$TESTDIR/fixtures/test-image.png" 2>/dev/null
  echo "Testing save to output directory..."

  mkdir -p "$TESTDIR/output"
  output=$("$C2I" "$TESTDIR/output" 2>&1)
  exitcode=$?

  if [[ $exitcode -eq 0 ]] && [[ -f "$output" ]]; then
    echo "✓ Save test passed: $output"
    file_info=$(file "$output")
    echo "  File info: $file_info"
  else
    echo "✗ Save test failed"
    echo "  Exit code: $exitcode"
    echo "  Output: $output"
  fi
else
  echo "⊘ Test fixture not found"
fi

echo "Simple test complete"
#fin