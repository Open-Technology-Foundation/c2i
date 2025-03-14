# Clipboard to Image (c2i)

A lightweight utility for saving clipboard PNG images to files with timestamp.

## Features

- Save PNG images from clipboard to files with automatic timestamps
- Optional image compression using pngquant
- Configurable output directory
- Copy file path to clipboard for easy sharing
- Simple command-line interface

## Installation

### Dependencies

- `xclip` - Required for clipboard access
- `pngquant` - Optional, for image compression

On Debian/Ubuntu systems:

```bash
sudo apt update && sudo apt install xclip pngquant
```

### Setup

1. Clone this repository or download the script
2. Make the script executable:
   ```bash
   chmod +x clipboard-to-imagefile
   ```
3. Create symlinks or add the script to your PATH:
   ```bash
   # Create symlink in a directory that's in your PATH (e.g., ~/.local/bin)
   ln -s /path/to/clipboard-to-imagefile ~/.local/bin/c2i
   ```

## Usage

```
c2i [OPTIONS] [output_dir]
```

### Options

- `-c, --compress [INT]`: Compress image using pngquant. Valid range for INT is 20-100 (lower values = higher compression). Defaults to 55 if INT is omitted.
- `-p, --copy-path`: Copy the file path to clipboard after saving
- `-v, --verbose`: Print output filename on completion (default)
- `-q, --quiet`: Do not print output filename
- `-V, --version`: Print version and exit
- `-h, --help`: Display help

### Examples

Create a screenshot (using your system's screenshot tool), then run:

```bash
# Save to /tmp (default)
c2i

# Save to current directory
c2i .

# Save to Downloads folder with compression
c2i -c ~/Downloads

# Save with high compression level (30) and store path in a variable
imgfile=$(c2i -c 30)

# Save to Pictures folder and copy the path to clipboard for easy sharing
c2i -p ~/Pictures
```

## File Structure

- `clipboard-to-imagefile` - Main script
- `c2i` - Symlink to the main script
- `clipboard-to-imagefile.sh` - Symlink to the main script

## License

MIT