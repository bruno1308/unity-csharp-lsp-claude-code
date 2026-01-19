# Unity C# LSP Plugin for Claude Code

A Language Server Protocol (LSP) plugin for Claude Code, optimized for Unity game development with C#.

## Features

- **Go to Definition** - Jump to symbol definitions across your Unity project
- **Find References** - Locate all usages of classes, methods, and variables
- **Hover Information** - View type signatures and documentation
- **Document Symbols** - Navigate file structure quickly
- **Diagnostics** - Real-time error and warning detection
- **Unity-Optimized** - Configured for Unity's Mono runtime and project structure
- **Cross-Platform** - Works on Windows, macOS, and Linux
- **Auto-Installation** - Automatically detects and installs OmniSharp if missing

## Requirements

- **Claude Code** v2.0.74 or later
- **.NET SDK 6.0+** - [Download here](https://dotnet.microsoft.com/download)
- **Unity Project** with generated `.sln` and `.csproj` files
- **Windows**: Visual Studio 2022 (any edition) - required for MSBuild

## Installation

### Step 1: Clone this repository

```bash
git clone https://github.com/bruno1308/unity-csharp-lsp-claude-code.git
cd unity-csharp-lsp-claude-code
```

### Step 2: Install the plugin

Choose ONE of the following methods:

#### Method A: User-level installation (Recommended)

This installs the plugin globally for all your projects.

**Windows (PowerShell):**
```powershell
# Create plugins directory if it doesn't exist
$pluginDir = Join-Path $env:USERPROFILE ".claude\plugins"
New-Item -ItemType Directory -Force -Path $pluginDir

# Copy the plugin (excludes .claude directory and temp files)
$dest = Join-Path $env:USERPROFILE ".claude\plugins\unity-csharp-lsp"
Get-ChildItem -Path "." -Exclude ".claude","tmpclaude-*" | Copy-Item -Destination $dest -Recurse -Force
```

**macOS / Linux:**
```bash
# Create plugins directory if it doesn't exist
mkdir -p ~/.claude/plugins

# Copy the plugin (excludes .claude directory and temp files)
rsync -av --exclude='.claude' --exclude='tmpclaude-*' ./ ~/.claude/plugins/unity-csharp-lsp/
```

#### Method B: Project-level installation

This installs the plugin only for a specific Unity project. Good for team sharing.

**Windows (PowerShell):**
```powershell
# Navigate to your Unity project root
cd "C:\Path\To\Your\UnityProject"

# Create plugins directory
New-Item -ItemType Directory -Force -Path ".\.claude\plugins"

# Copy the plugin (adjust source path to where you cloned the repo)
$source = "C:\Path\To\unity-csharp-lsp-claude-code"
$dest = ".\.claude\plugins\unity-csharp-lsp"
Get-ChildItem -Path $source -Exclude ".claude","tmpclaude-*" | Copy-Item -Destination $dest -Recurse -Force
```

**macOS / Linux:**
```bash
# Navigate to your Unity project root
cd /path/to/your/unity-project

# Create plugins directory and copy (excludes .claude directory and temp files)
mkdir -p .claude/plugins
rsync -av --exclude='.claude' --exclude='tmpclaude-*' /path/to/unity-csharp-lsp-claude-code/ .claude/plugins/unity-csharp-lsp/
```

#### Method C: Direct plugin install command

```bash
# From within Claude Code
/plugin install /full/path/to/unity-csharp-lsp-claude-code
```

> **Note:** This method may have issues persisting across sessions on some systems. If the plugin doesn't load after restart, use Method A or B instead.

### Step 3: Restart Claude Code

Close and reopen Claude Code for the plugin to load.

### Step 4: Verify installation

Run `/plugins` in Claude Code and check that `unity-csharp-lsp` appears in the list.

---

## OmniSharp Setup

The plugin requires OmniSharp to be installed on your system. The plugin will attempt to auto-install on first run, but you can also install manually:

### Windows

```powershell
# Option 1: Install via Scoop (Recommended)
scoop install omnisharp

# Option 2: Install via winget
winget install OmniSharp.OmniSharp

# Option 3: Download from GitHub releases
# https://github.com/OmniSharp/omnisharp-roslyn/releases
# Extract and add to PATH
```

### macOS

```bash
# Install OmniSharp with Mono support (Required for Unity)
brew tap omnisharp/omnisharp-roslyn
brew install omnisharp-mono
```

> **Important:** Use `omnisharp-mono` (not just `omnisharp`) for Unity projects to ensure Mono runtime compatibility.

### Linux

```bash
# Option 1: Download from GitHub releases
# https://github.com/OmniSharp/omnisharp-roslyn/releases
# Download the linux-x64 or linux-arm64 version, extract, and add to PATH

# Option 2: Build from source
# See: https://github.com/OmniSharp/omnisharp-roslyn#building
```

---

## Unity Project Setup

For the LSP to work, your Unity project needs valid solution and project files.

### Generate project files

1. Open your Unity project in the Unity Editor
2. Go to **Edit > Preferences > External Tools**
3. Under "Generate .csproj files for:", check the boxes for your needs
4. Click **Regenerate project files**
5. Verify that `.sln` and `Assembly-CSharp.csproj` files exist in your project root

### Optional: Add OmniSharp configuration

Create an `omnisharp.json` file in your Unity project root for custom settings:

```json
{
  "msbuild": {
    "enabled": true,
    "UseLegacySdkResolver": true
  },
  "formattingOptions": {
    "enableEditorConfigSupport": true,
    "useTabs": false,
    "tabSize": 4
  },
  "roslynExtensionsOptions": {
    "enableAnalyzersSupport": true,
    "enableImportCompletion": true
  }
}
```

> **Important:** The `UseLegacySdkResolver: true` setting helps with SDK resolution on systems with multiple .NET SDK versions.

A sample configuration file is included: `omnisharp.json.sample`

---

## Supported File Types

| Extension | Language | LSP Support |
|-----------|----------|-------------|
| `.cs` | C# | Full |
| `.csx` | C# Script | Full |

---

## Troubleshooting

### "No LSP server available for file type"

1. Verify OmniSharp is installed and in your PATH:
   ```bash
   omnisharp --version
   # or
   OmniSharp --version
   ```
2. Restart Claude Code after installing OmniSharp
3. Check `/plugins` > Errors tab for details

### Plugin not loading after restart

If using Method C (`/plugin install`), try Method A (copy to `~/.claude/plugins/`) instead.

### LSP not finding Unity types

1. Ensure your Unity project has a valid `.sln` file
2. Regenerate project files in Unity Editor
3. Check that `Assembly-CSharp.csproj` exists

### macOS: OmniSharp crashes with Unity projects

Use the Mono version instead of the .NET version:
```bash
brew install omnisharp-mono  # NOT just 'omnisharp'
```

### Large projects: Slow initial load

OmniSharp needs to index your project on first load. This can take 60-90 seconds for large Unity projects with many assemblies. Subsequent loads will be faster.

### Windows: "SDK WorkloadAutoImportPropsLocator could not be found"

This error occurs when there's a mismatch between your .NET SDK version and Visual Studio's MSBuild. The plugin includes a workaround (`MSBuildEnableWorkloadResolver=false`) that should handle this automatically.

If you still see this error:
1. Ensure you have .NET SDK 6.0+ installed: `dotnet --list-sdks`
2. Verify Visual Studio 2022 is installed (provides MSBuild)
3. Check that `omnisharp.json` in your Unity project has `"UseLegacySdkResolver": true`

### LSP returns empty results (0 symbols, 0 references)

This usually means projects failed to load. Check:
1. Wait 60-90 seconds after starting Claude Code for indexing
2. Verify your Unity project has a valid `.sln` file
3. Check `/plugins` > Errors for SDK-related errors
4. Try regenerating project files in Unity Editor

---

## How it works

This plugin configures Claude Code to use OmniSharp as the Language Server for C# files. When you open a Unity project:

1. Claude Code detects `.cs` files
2. The plugin starts OmniSharp with Unity-optimized settings
3. OmniSharp indexes your project using the `.sln` file
4. Claude gains access to semantic code intelligence

### LSP Operations Available

| Operation | Status | What Claude can do |
|-----------|--------|-------------------|
| `documentSymbol` | ✅ Works | List all symbols (classes, methods, fields) in a file |
| `workspaceSymbol` | ✅ Works | Search for symbols across the entire workspace |
| `hover` | ✅ Works | Get type information and documentation |
| `goToDefinition` | ✅ Works | Navigate to where symbols are defined |
| `findReferences` | ✅ Works | Find all usages of a class, method, or variable |
| `goToImplementation` | ✅ Works | Find implementations of interfaces/abstract classes |
| `getDiagnostics` | ✅ Works | See compiler errors and warnings |
| `prepareCallHierarchy` | ❌ N/A | Not supported by OmniSharp |
| `incomingCalls` | ❌ N/A | Not supported by OmniSharp |
| `outgoingCalls` | ❌ N/A | Not supported by OmniSharp |

### Performance

- Navigation queries: ~50ms (vs ~45 seconds with text search)
- Reference lookups: Near-instant across entire codebase
- Real-time diagnostics: Errors shown as you discuss code

---

## Plugin Structure

```
unity-csharp-lsp/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── .lsp.json                 # OmniSharp configuration
├── hooks/
│   ├── hooks.json            # Auto-install hooks
│   ├── check-omnisharp.sh    # macOS/Linux installer
│   └── check-omnisharp.ps1   # Windows installer
├── omnisharp.json.sample     # Sample project config
├── CLAUDE.md                 # Instructions for Claude
├── README.md                 # This file
└── LICENSE                   # MIT License
```

---

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Test with a Unity project
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [OmniSharp](https://github.com/OmniSharp/omnisharp-roslyn) - The C# language server
- [Claude Code](https://claude.ai/code) - Anthropic's CLI coding assistant
- [Piebald-AI/claude-code-lsps](https://github.com/Piebald-AI/claude-code-lsps) - LSP plugin reference
