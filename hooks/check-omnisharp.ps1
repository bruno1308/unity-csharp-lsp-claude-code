# Unity C# LSP - OmniSharp Installation Check (Windows)
# PowerShell script for automatic OmniSharp detection and installation

$ErrorActionPreference = "SilentlyContinue"
$PluginName = "unity-csharp-lsp"

function Write-PluginLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $color = switch ($Level) {
        "SUCCESS" { "Green" }
        "WARN"    { "Yellow" }
        "ERROR"   { "Red" }
        default   { "Cyan" }
    }
    Write-Host "[$PluginName] " -ForegroundColor $color -NoNewline
    Write-Host $Message
}

function Test-OmniSharpInstalled {
    # Check for OmniSharp in PATH (case variations)
    $omnisharp = Get-Command "OmniSharp" -ErrorAction SilentlyContinue
    if ($omnisharp) {
        Write-PluginLog "OmniSharp found: $($omnisharp.Source)" "SUCCESS"
        return $true
    }

    $omnisharp = Get-Command "omnisharp" -ErrorAction SilentlyContinue
    if ($omnisharp) {
        Write-PluginLog "OmniSharp found: $($omnisharp.Source)" "SUCCESS"
        return $true
    }

    # Check for OmniSharp.exe in common locations
    $commonPaths = @(
        "$env:USERPROFILE\omnisharp\OmniSharp.exe",
        "$env:USERPROFILE\.omnisharp\OmniSharp.exe",
        "$env:LOCALAPPDATA\omnisharp\OmniSharp.exe",
        "$env:USERPROFILE\scoop\apps\omnisharp\current\OmniSharp.exe",
        "$env:ProgramFiles\OmniSharp\OmniSharp.exe",
        "${env:ProgramFiles(x86)}\OmniSharp\OmniSharp.exe"
    )

    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            Write-PluginLog "OmniSharp found: $path" "SUCCESS"
            return $true
        }
    }

    return $false
}

function Install-OmniSharpViaScoop {
    $scoop = Get-Command "scoop" -ErrorAction SilentlyContinue
    if (-not $scoop) {
        return $false
    }

    Write-PluginLog "Attempting OmniSharp installation via Scoop..." "INFO"

    try {
        & scoop install omnisharp 2>$null

        if (Test-OmniSharpInstalled) {
            Write-PluginLog "OmniSharp installed successfully via Scoop" "SUCCESS"
            return $true
        }
    }
    catch {
        # Scoop installation failed
    }

    return $false
}

function Install-OmniSharpViaWinget {
    $winget = Get-Command "winget" -ErrorAction SilentlyContinue
    if (-not $winget) {
        return $false
    }

    Write-PluginLog "Attempting OmniSharp installation via winget..." "INFO"

    try {
        & winget install OmniSharp.OmniSharp --silent 2>$null

        # Refresh PATH
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

        if (Test-OmniSharpInstalled) {
            Write-PluginLog "OmniSharp installed successfully via winget" "SUCCESS"
            return $true
        }
    }
    catch {
        # Winget installation failed
    }

    return $false
}

function Show-ManualInstructions {
    Write-PluginLog "Automatic installation failed. Please install OmniSharp manually:" "WARN"
    Write-Host ""
    Write-Host "  Option 1: Install via Scoop (Recommended)"
    Write-Host "    scoop install omnisharp"
    Write-Host ""
    Write-Host "  Option 2: Install via winget"
    Write-Host "    winget install OmniSharp.OmniSharp"
    Write-Host ""
    Write-Host "  Option 3: Download from GitHub"
    Write-Host "    https://github.com/OmniSharp/omnisharp-roslyn/releases"
    Write-Host "    Download omnisharp-win-x64.zip, extract, and add to PATH"
    Write-Host ""
    Write-Host "  Prerequisites:"
    Write-Host "    - .NET SDK 6.0+: https://dotnet.microsoft.com/download"
    Write-Host ""
    Write-Host "  For Unity projects, ensure you have:"
    Write-Host "    1. A valid .sln file in your project root"
    Write-Host "    2. Generated .csproj files (Unity > Preferences > External Tools > Regenerate)"
    Write-Host ""
}

# Main execution
function Main {
    Write-PluginLog "Checking OmniSharp installation for Unity C# development..." "INFO"

    if (Test-OmniSharpInstalled) {
        Write-PluginLog "OmniSharp is ready for Unity development!" "SUCCESS"
        exit 0
    }

    Write-PluginLog "OmniSharp not found. Attempting installation..." "WARN"

    # Try Scoop first (most common on Windows dev machines)
    if (Install-OmniSharpViaScoop) {
        exit 0
    }

    # Try winget if available
    if (Install-OmniSharpViaWinget) {
        exit 0
    }

    # Show manual instructions
    Show-ManualInstructions

    # Don't fail the hook - plugin should still load
    exit 0
}

Main
