#!/bin/bash
set -e

# Yansu Agent Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/Isoform/yansu-releases/main/install.sh | bash

REPO="Isoform/yansu-releases"
BINARY_NAME="yansu"
INSTALL_DIR="/usr/local/bin"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64|amd64)
    ARCH="amd64"
    ;;
  arm64|aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

case "$OS" in
  darwin|linux)
    ;;
  mingw*|msys*|cygwin*)
    OS="windows"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Get latest version
echo "Fetching latest version..."
LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
  echo "Failed to get latest version"
  exit 1
fi

echo "Latest version: $LATEST_VERSION"

# Download binary
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_VERSION}/${BINARY_NAME}-${OS}-${ARCH}"
if [ "$OS" = "windows" ]; then
  DOWNLOAD_URL="${DOWNLOAD_URL}.exe"
fi

echo "Downloading from: $DOWNLOAD_URL"

TMP_DIR=$(mktemp -d)
TMP_FILE="${TMP_DIR}/${BINARY_NAME}"

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"
chmod +x "$TMP_FILE"

# Install
echo "Installing to ${INSTALL_DIR}/${BINARY_NAME}..."

if [ -w "$INSTALL_DIR" ]; then
  mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"
else
  sudo mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"
fi

rm -rf "$TMP_DIR"

# Verify
echo ""
echo "Yansu Agent installed successfully!"
echo ""
"${INSTALL_DIR}/${BINARY_NAME}" --version
echo ""
echo "Run 'yansu login' to get started."
