# Makefile for c2i test suite

.PHONY: all test test-fixtures clean help

# Default target
all: test

# Run all tests
test:
	@echo "Running c2i test suite..."
	@bash run-tests.sh

# Create test fixtures from clipboard
test-fixtures:
	@echo "Creating test fixture from clipboard..."
	@mkdir -p fixtures
	@if xclip -selection clipboard -t TARGETS -o 2>/dev/null | grep -q 'image/png'; then \
		xclip -selection clipboard -t image/png -o > fixtures/test-image.png 2>/dev/null && \
		echo "✓ Saved test image: fixtures/test-image.png" && \
		file fixtures/test-image.png; \
	else \
		echo "✗ No PNG image found in clipboard"; \
		echo "Please copy a PNG image to clipboard and try again"; \
		exit 1; \
	fi

# Clean test outputs
clean:
	@echo "Cleaning test outputs..."
	@rm -rf output/* tmp/*
	@echo "✓ Test outputs cleaned"

# Clean everything including fixtures
clean-all: clean
	@echo "Cleaning all test data..."
	@rm -f fixtures/*.png
	@echo "✓ All test data cleaned"

# Show help
help:
	@echo "c2i Test Suite Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make test          - Run all tests"
	@echo "  make test-fixtures - Create test fixture from clipboard image"
	@echo "  make clean         - Clean test outputs"
	@echo "  make clean-all     - Clean all test data including fixtures"
	@echo "  make help          - Show this help message"
	@echo ""
	@echo "Quick start:"
	@echo "  1. Copy an image to clipboard"
	@echo "  2. Run: make test-fixtures"
	@echo "  3. Run: make test"

#fin