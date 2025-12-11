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
    echo "❌ LaTeX not found. Installing basic LaTeX packages..."
    if command -v brew &> /dev/null; then
        # Try to install basictex if not already installed
        if ! brew list basictex &>/dev/null; then
            brew install basictex
        fi
        # Add to PATH if needed
        export PATH="/usr/local/texlive/2024/bin/universal-darwin:$PATH"
        eval "$(brew shellenv)"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get install -y texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra
    else
        echo "❌ Please install LaTeX manually: https://www.tug.org/texlive/"
        echo "   Or use: brew install basictex"
        exit 1
    fi
fi

# Generate PDF
echo "📄 Converting Markdown to PDF..."

# Try LaTeX first, fallback to wkhtmltopdf
if command -v xelatex &> /dev/null || command -v pdflatex &> /dev/null; then
    PDF_ENGINE="pdflatex"
    if command -v xelatex &> /dev/null; then
        PDF_ENGINE="xelatex"
        echo "Using xelatex engine"
    else
        echo "Using pdflatex engine"
    fi

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
else
    echo "LaTeX not available locally, using wkhtmltopdf..."
    # Check if wkhtmltopdf is available
    if ! command -v wkhtmltopdf &> /dev/null; then
        echo "❌ wkhtmltopdf not found. Install with: brew install wkhtmltopdf"
        exit 1
    fi

    # Convert markdown to HTML first, then to PDF
    pandoc Playwright_Guide_Reorganized.md \
      -o temp_guide.html \
      --self-contained \
      --css=https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css \
      --variable title="Playwright Test Framework - Complete Guide"

    wkhtmltopdf \
      --margin-top 20 \
      --margin-bottom 20 \
      --margin-left 20 \
      --margin-right 20 \
      --page-size A4 \
      --enable-local-file-access \
      temp_guide.html \
      Playwright_Complete_Guide.pdf

    rm temp_guide.html
fi

echo "✅ PDF generated successfully: Playwright_Complete_Guide.pdf"
echo "📊 File size: $(du -h Playwright_Complete_Guide.pdf | cut -f1)"
