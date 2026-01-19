# Claude Instructions for Unity C# LSP

This plugin provides C# language server support for Unity projects via OmniSharp.

## Available LSP Operations

When working with Unity C# files (`.cs`, `.csx`), use these operations:

| Operation | Use Case |
|-----------|----------|
| `goToDefinition` | Find where a class, method, or variable is defined |
| `findReferences` | Find all usages of a symbol across the project |
| `hover` | Get type information and documentation |
| `documentSymbol` | List all symbols in a file |
| `getDiagnostics` | Get compiler errors and warnings |

## When to Use LSP

- **Always prefer LSP over grep/search** for C# symbol navigation
- Use `goToDefinition` instead of searching for class/method definitions
- Use `findReferences` before refactoring to understand impact
- Use `hover` to understand types without reading documentation

## Unity Project Structure

```
UnityProject/
├── Assets/
│   ├── Scripts/*.cs           # Game scripts (Assembly-CSharp)
│   ├── Editor/*.cs            # Editor scripts (Assembly-CSharp-Editor)
│   └── Plugins/*.cs           # Plugin scripts
├── Packages/
├── ProjectName.sln            # Solution file (required)
├── Assembly-CSharp.csproj     # Main assembly
└── omnisharp.json             # Optional OmniSharp config
```

## Common Unity Types

| Type | Purpose |
|------|---------|
| `MonoBehaviour` | Component base class |
| `ScriptableObject` | Data container asset |
| `GameObject` | Scene entity |
| `Transform` | Position/rotation/scale |
| `SerializeField` | Expose private fields in Inspector |
| `RequireComponent` | Dependency declaration |

## Common Unity Namespaces

- `UnityEngine` - Core runtime (GameObject, MonoBehaviour, etc.)
- `UnityEditor` - Editor-only APIs
- `Unity.Mathematics` - DOTS math library
- `Unity.Collections` - Native collections
- `UnityEngine.UI` - UI components

## Troubleshooting

If LSP returns no results:

1. Check for `.sln` file in project root
2. Verify OmniSharp is running (check `/plugins` errors)
3. For missing Unity types, regenerate project files in Unity Editor
4. Large projects need 30-60 seconds for initial indexing

## File Types

| Extension | LSP Support |
|-----------|-------------|
| `.cs` | Full |
| `.csx` | Full |
| `.shader` | None (use text search) |
| `.asmdef` | None (JSON file) |
