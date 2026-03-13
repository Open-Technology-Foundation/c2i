# Clipboard to Image (c2i)

A lightweight, robust utility for saving PNG images from clipboard to timestamped files.

```bash
git clone https://github.com/Open-Technology-Foundation/c2i.git && cd c2i && sudo make install
```

## Version 1.2.0

### What's New in v1.2.0
- **Simplified Message System**: Replaced text-based status prefixes with icons (◉, ✓, ✗)
- **Cleaner Variable Declarations**: Switched to `declare -r` for constants
- **Improved Option Bundling**: Rewritten combined short option handling
- **Better Error Formatting**: Error messages use `${var@Q}` for quoted output

## Features

- Save PNG images from clipboard with automatic timestamps
- Optional image compression using pngquant (20-100 quality range)
- Configurable output directory (defaults to `/tmp`)
- Copy saved file path to clipboard for easy sharing (`-p` flag)
- Quiet mode for scripting (`-q` flag)
- Verbose mode for detailed output (`-v` flag)
- Simple, focused command-line interface

## Installation

### Dependencies

**Required:**
- `xclip` - Clipboard access

**Optional:**
- `pngquant` - Image compression (only needed with `-c` flag)

#### Install on Debian/Ubuntu:
```bash
sudo apt update && sudo apt install xclip pngquant
```

### Setup

```bash
git clone <repository-url>
cd c2i
sudo make install
```

This installs the script, symlink, manpage, and bash completion to `/usr/local`.
To customise the prefix: `sudo make PREFIX=/opt/local install`

## Usage

```
c2i [OPTIONS] [output_dir]
```

### Options

| Option | Description |
|--------|-------------|
| `-c, --compress [INT]` | Compress image using pngquant. INT range: 20-100 (lower = higher compression). Default: 50 |
| `-p, --copy-path` | Copy the saved file path to clipboard (replaces image) |
| `-v, --verbose` | Verbose output (default) |
| `-q, --quiet` | Suppress output |
| `-V, --version` | Show version |
| `-h, --help` | Display help |

### Examples

```bash
# Take a screenshot with your system tool, then:

# Save to /tmp (default)
c2i
# Output: /tmp/image-20250316-143022.png

# Save to current directory
c2i .

# Save to specific folder with compression
c2i -c ~/Pictures
# Compresses with default quality (50)

# Save with high compression (quality 30)
c2i -c 30 ~/Pictures

# Save and copy path to clipboard for sharing
c2i -p ~/Documents
# The file path replaces the image in clipboard

# Capture filepath in a variable (verbose mode outputs to stdout)
imgpath=$(c2i ~/Pictures)
echo "Saved to: $imgpath"

# Combine options
c2i -pc 70 ~/Pictures
# Compress at quality 70 and copy path to clipboard
```

## Output Format

Files are saved with the pattern:
```
{output_dir}/image-{YYYYMMDD-HHMMSS}.png
```

Example: `image-20250316-143022.png`

This timestamp format ensures:
- Files sort chronologically
- No naming conflicts
- Easy identification of when the image was captured

## Testing

The project includes a comprehensive test suite:

```bash
# Run all tests
make test

# Create test fixture from clipboard image
make -C tests test-fixtures

# Run specific test file
bash tests/test-basic-functionality.sh
```

Test coverage includes:
- Basic functionality (save, quiet, verbose modes)
- Compression with various quality levels
- Clipboard path copying
- Error handling and edge cases
- Argument parsing
- File naming and timestamps

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error (no image, directory issues, etc.) |
| 2 | Too many arguments |
| 22 | Invalid command-line option |

## Project Structure

```
c2i/
├── clipboard-to-imagefile    # Main script
├── c2i                       # Symlink to main script
├── Makefile                  # Install/uninstall/test targets
├── c2i.1                     # Man page
├── c2i.bash_completion       # Tab completion support
├── README.md                 # This file
├── LICENSE                   # GPL-3 License
└── tests/                    # Test suite
    ├── run-tests.sh          # Test runner
    ├── test-*.sh             # Individual test files
    ├── fixtures/             # Test images
    └── Makefile              # Test automation
```

## Code Quality

This project follows strict Bash coding standards:
- `set -euo pipefail` for safety
- Proper variable scoping with `local` and `declare`
- Consistent error handling with meaningful exit codes
- Shellcheck validated (no warnings)
- Comprehensive input validation
- Clear separation of stdout/stderr output

## Contributing

Contributions are welcome! Please ensure:
1. All tests pass: `make test`
2. Shellcheck reports no issues: `shellcheck -x clipboard-to-imagefile`
3. New features include corresponding tests

## License

GPL-3

## Troubleshooting

**No image in clipboard:**
- Ensure you've copied a PNG image (screenshots work)
- Some applications may not copy images in PNG format

**Permission denied:**
- Check output directory permissions
- Ensure the script is executable: `chmod +x clipboard-to-imagefile`

**xclip not found:**
- Install with: `sudo apt install xclip`
- Required for clipboard access

**Compression not working:**
- Install pngquant: `sudo apt install pngquant`
- Only needed when using `-c` flag

