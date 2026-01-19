#!/bin/bash

# Unity C# LSP - OmniSharp Installation Check
# Supports macOS (Homebrew) and Linux

set -e

PLUGIN_NAME="unity-csharp-lsp"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[$PLUGIN_NAME]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$PLUGIN_NAME]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[$PLUGIN_NAME]${NC} $1"
}

log_error() {
    echo -e "${RED}[$PLUGIN_NAME]${NC} $1"
}

# Check if OmniSharp is already installed
check_omnisharp() {
    if command -v OmniSharp &> /dev/null; then
        log_success "OmniSharp found: $(which OmniSharp)"
        return 0
    fi

    if command -v omnisharp &> /dev/null; then
        log_success "OmniSharp found: $(which omnisharp)"
        return 0
    fi

    # Check common installation paths
    local common_paths=(
        "$HOME/.omnisharp/OmniSharp"
        "$HOME/omnisharp/OmniSharp"
        "/usr/local/bin/omnisharp"
        "/opt/omnisharp/OmniSharp"
    )

    for path in "${common_paths[@]}"; do
        if [[ -x "$path" ]]; then
            log_success "OmniSharp found: $path"
            return 0
        fi
    done

    return 1
}

# Install OmniSharp via Homebrew (macOS)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        return 1
    fi

    log_info "Installing OmniSharp via Homebrew..."

    # Add the OmniSharp tap if not already added
    if ! brew tap 2>/dev/null | grep -q "omnisharp/omnisharp-roslyn"; then
        brew tap omnisharp/omnisharp-roslyn
    fi

    # Use omnisharp-mono for Unity (Mono runtime compatibility)
    brew install omnisharp-mono

    if check_omnisharp; then
        log_success "OmniSharp installed successfully via Homebrew"
        return 0
    fi

    return 1
}

# Show manual installation instructions
show_manual_instructions() {
    log_error "Automatic installation failed. Please install OmniSharp manually:"
    echo ""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "  macOS (Homebrew - Recommended for Unity):"
        echo "    brew tap omnisharp/omnisharp-roslyn"
        echo "    brew install omnisharp-mono"
        echo ""
    fi
    echo "  Download from GitHub:"
    echo "    https://github.com/OmniSharp/omnisharp-roslyn/releases"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "    Download omnisharp-osx-x64.tar.gz or omnisharp-osx-arm64.tar.gz"
    else
        echo "    Download omnisharp-linux-x64.tar.gz or omnisharp-linux-arm64.tar.gz"
    fi
    echo "    Extract and add to PATH"
    echo ""
    echo "  For Unity projects, ensure you have:"
    echo "    1. A valid .sln file in your project root"
    echo "    2. Generated .csproj files (Unity Editor > Preferences > External Tools > Regenerate)"
    echo ""
}

# Main installation logic
main() {
    log_info "Checking OmniSharp installation for Unity C# development..."

    # Check if already installed
    if check_omnisharp; then
        log_success "OmniSharp is ready for Unity development!"
        exit 0
    fi

    log_warn "OmniSharp not found. Attempting installation..."

    # Try Homebrew first (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if install_homebrew; then
            exit 0
        fi
    fi

    # Show manual installation instructions
    show_manual_instructions

    # Don't fail the hook, just warn - plugin should still load
    exit 0
}

main "$@"
