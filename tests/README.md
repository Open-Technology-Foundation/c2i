# c2i Test Suite

Comprehensive test suite for the clipboard-to-imagefile (c2i) utility.

## Structure

```
tests/
├── run-tests.sh              # Main test runner
├── test-basic-functionality.sh   # Basic operations tests
├── test-compression.sh       # Image compression tests
├── test-clipboard-path.sh    # Clipboard path copy tests
├── test-error-handling.sh    # Error handling tests
├── test-argument-parsing.sh  # Argument parsing tests
├── test-file-naming.sh       # File naming and timestamp tests
├── fixtures/
│   └── test-image.png       # Test image fixture
├── output/                   # Test output directory
├── tmp/                      # Temporary test files
├── Makefile                  # Test automation
└── README.md                 # This file
```

## Quick Start

1. **Create test fixture from clipboard:**
   ```bash
   # Copy an image to clipboard first, then:
   make test-fixtures
   ```

2. **Run all tests:**
   ```bash
   make test
   ```

3. **Clean test outputs:**
   ```bash
   make clean
   ```

## Test Coverage

### Basic Functionality (`test-basic-functionality.sh`)
- Default save to /tmp
- Save to specified directory
- Quiet mode (-q)
- Verbose mode (-v)
- Version output (--version)
- Help output (--help)

### Compression (`test-compression.sh`)
- Default compression quality
- Custom compression quality values (20-100)
- File size comparison
- pngquant dependency handling

### Clipboard Path (`test-clipboard-path.sh`)
- Copy file path to clipboard (-p)
- Path copy in quiet mode
- Path copy with compression
- Clipboard content verification

### Error Handling (`test-error-handling.sh`)
- Invalid options
- Non-existent directories
- No image in clipboard
- Invalid compression values
- Permission errors
- Combined options with errors

### Argument Parsing (`test-argument-parsing.sh`)
- Long options (--compress, --copy-path, etc.)
- Short options (-c, -p, -v, -q)
- Combined short options (-vp, -pc)
- Option order independence
- Multiple verbose flags

### File Naming (`test-file-naming.sh`)
- Filename format (image-YYYYMMDD-HHMMSS.png)
- Timestamp accuracy
- Multiple files don't overwrite
- PNG extension verification
- Valid PNG file creation

## Test Statistics

The test runner provides detailed statistics:
- Total tests run
- Tests passed ✓
- Tests failed ✗
- Tests skipped ⊘

## Dependencies

- `bash` >= 4.0
- `xclip` (required)
- `pngquant` (optional, for compression tests)
- Standard Unix utilities: `stat`, `file`, `grep`, etc.

## Writing New Tests

To add a new test:

1. Create a new file `test-feature-name.sh` in the tests directory
2. Use the assertion functions from `run-tests.sh`:
   - `assert_equals expected actual [message]`
   - `assert_true condition [message]`
   - `assert_false condition [message]`
   - `assert_file_exists filepath [message]`
   - `assert_file_not_exists filepath [message]`
   - `assert_contains haystack needle [message]`
   - `assert_exit_code expected actual [message]`

3. Example test:
   ```bash
   #!/usr/bin/env bash
   # Test description

   C2I="$BASEDIR/clipboard-to-imagefile"
   OUTPUT_DIR="$TESTDIR/output"

   info "Testing new feature"
   output=$("$C2I" --new-option "$OUTPUT_DIR" 2>&1)
   exitcode=$?
   assert_exit_code 0 "$exitcode" "Should succeed with new option"
   assert_contains "$output" "expected" "Should contain expected output"
   #fin
   ```

## Continuous Integration

The test suite can be integrated into CI/CD pipelines:

```bash
# Install dependencies
sudo apt update && sudo apt install -y xclip pngquant

# Create test fixture (or use pre-existing)
cp sample-image.png tests/fixtures/test-image.png

# Run tests
cd tests && bash run-tests.sh
```

Exit codes:
- 0: All tests passed
- 1: One or more tests failed

#fin