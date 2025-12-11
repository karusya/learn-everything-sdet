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
if ! command -v pdflatex &> /dev/null; then
    echo "❌ pdflatex not found. Installing LaTeX..."
    if command -v brew &> /dev/null; then
        brew install --cask mactex
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra
    else
        echo "❌ Please install LaTeX manually"
        exit 1
    fi
fi

# Generate PDF
echo "📄 Converting Markdown to PDF..."
pandoc Playwright_Guide_Reorganized.md \
  -o Playwright_Complete_Guide.pdf \
  --pdf-engine=pdflatex \
  --variable geometry:margin=1in \
  --variable fontsize=11pt \
  --variable colorlinks=true \
  --variable linkcolor=blue \
  --variable urlcolor=blue \
  --variable toc \
  --variable toc-depth=2 \
  --variable title="Playwright Test Framework - Complete Guide" \
  --variable author="Generated from GitHub Actions"

echo "✅ PDF generated successfully: Playwright_Complete_Guide.pdf"
echo "📊 File size: $(du -h Playwright_Complete_Guide.pdf | cut -f1)"
