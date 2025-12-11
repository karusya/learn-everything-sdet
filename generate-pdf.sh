#!/bin/bash

# Script to generate PDF from Markdown locally
# This mirrors the GitHub Actions workflow for testing

set -e

echo "🚀 Generating PDF from Markdown..."

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "❌ Pandoc not found. Installing..."
    # On macOS with Homebrew
    if command -v brew &> /dev/null; then
        brew install pandoc
    # On Ubuntu/Debian
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y pandoc texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra
    else
        echo "❌ Please install pandoc manually: https://pandoc.org/installing.html"
        exit 1
    fi
fi

# Check if LaTeX is available
if ! command -v xelatex &> /dev/null && ! command -v pdflatex &> /dev/null; then
    echo "❌ LaTeX not found. Please install LaTeX:"
    echo "   macOS: brew install --cask mactex"
    echo "   Ubuntu: sudo apt-get install texlive-latex-extra"
    echo "   Or download from: https://www.tug.org/texlive/"
    exit 1
fi

# Generate PDF
echo "📄 Converting Markdown to PDF..."

# Check LaTeX availability
if ! command -v pdflatex &> /dev/null && ! command -v xelatex &> /dev/null; then
  echo "❌ No LaTeX engine found"
  exit 1
fi

# Prefer xelatex if available, fallback to pdflatex
PDF_ENGINE="pdflatex"
if command -v xelatex &> /dev/null; then
  PDF_ENGINE="xelatex"
  echo "Using xelatex engine"
else
  echo "Using pdflatex engine"
fi

# Generate PDF with error handling
set -e
pandoc Playwright_Guide_Reorganized.md \
  -o Playwright_Complete_Guide.pdf \
  --pdf-engine=$PDF_ENGINE \
  --variable geometry:margin=1in \
  --variable fontsize=11pt \
  --variable colorlinks=true \
  --variable linkcolor=blue \
  --variable urlcolor=blue \
  --variable toc \
  --variable toc-depth=2 \
  --variable title="Playwright Test Framework - Complete Guide" \
  --variable author="Generated from GitHub Actions"

echo "✅ PDF generated successfully"

echo "✅ PDF generated successfully: Playwright_Complete_Guide.pdf"
echo "📊 File size: $(du -h Playwright_Complete_Guide.pdf | cut -f1)"
