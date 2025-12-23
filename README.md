# Yansu Agent Releases

Binary releases for [Yansu Agent](https://yansu.ai) - Local development companion that syncs your project's knowledge base with the Yansu cloud.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/Isoform/yansu-releases/main/install.sh | bash
```

## Manual Download

### macOS (Apple Silicon)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-darwin-arm64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

### macOS (Intel)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-darwin-amd64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

### Linux (x86_64)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-linux-amd64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

### Linux (ARM64)
```bash
curl -L https://github.com/Isoform/yansu-releases/releases/latest/download/yansu-linux-arm64 -o yansu
chmod +x yansu
sudo mv yansu /usr/local/bin/
```

### Windows (x86_64)
Download from the [latest release](https://github.com/Isoform/yansu-releases/releases/latest).

## Verify Installation

```bash
yansu --version
```

## Getting Started

```bash
yansu login
yansu clone <org/product/project>
```

## Documentation

Visit [dashboard.yansu.ai](https://dashboard.yansu.ai) for full documentation.
