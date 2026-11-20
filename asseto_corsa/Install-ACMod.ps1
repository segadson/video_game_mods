<#
.SYNOPSIS
    Installs an Assetto Corsa mod that has to be copied into the game folder
    (Pure, Better AI Single Seaters, track extensions, traffic plans, manual CSP...)
    and backs up every file it overwrites first.

.DESCRIPTION
    1. Extracts the archive (.zip natively, .7z/.rar if 7-Zip is installed) to a temp folder,
       or uses a folder you already extracted.
    2. Finds the folder inside the archive that mirrors the Assetto Corsa root, i.e. the one
       holding content\, extension\, apps\, system\, launcher\, sdk\ or dwrite.dll. This handles
       zips that wrap everything in an extra folder such as "Pure_v2.x\assettocorsa\".
    3. Shows what will be added and what will be overwritten, and asks you to confirm.
    4. Copies every file that will be overwritten into a timestamped backup folder, with a
       manifest.json that also lists the new files, so Restore-ACMod.ps1 can undo the install.
    5. Copies the mod in.

.PARAMETER ZipPath
    The mod archive (.zip, .7z, .rar) or an already extracted folder.

.PARAMETER AssettoCorsaPath
    The Assetto Corsa install root, the folder that contains acs.exe, e.g.
    "C:\Program Files (x86)\Steam\steamapps\common\assettocorsa".

.PARAMETER BackupRoot
    Where backups go. Default: <AssettoCorsaPath>\_mod_backups

.PARAMETER ModName
    Label used in the backup folder name. Default: the archive's file name.

.PARAMETER SourceSubfolder
    Use this folder inside the archive as the AC root instead of auto-detecting it.
    Needed only when the archive holds more than one candidate (for example a main and an
    "optional" variant). The script lists the candidates when that happens.

.PARAMETER IncludeAll
    Also copy loose top-level files next to content\, extension\ etc. (readmes, images).
    By default only known AC root folders and dwrite.dll are copied.

.PARAMETER DryRun
    Show what would happen without changing anything.

.PARAMETER Force
    Skip the confirmation prompt.

.EXAMPLE
    .\Install-ACMod.ps1 -ZipPath "$env:USERPROFILE\Downloads\Pure_v2.5.zip" `
        -AssettoCorsaPath "C:\Program Files (x86)\Steam\steamapps\common\assettocorsa"

.EXAMPLE
    .\Install-ACMod.ps1 -ZipPath .\better_ai_single_seaters.zip -AssettoCorsaPath D:\SteamLibrary\steamapps\common\assettocorsa -DryRun
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ZipPath,
    [Parameter(Mandatory = $true)][string]$AssettoCorsaPath,
    [string]$BackupRoot,
    [string]$ModName,
    [string]$SourceSubfolder,
    [switch]$IncludeAll,
    [switch]$DryRun,
    [switch]$Force
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

# Folders and files that live directly in the Assetto Corsa root.
$RootMarkers = @('content', 'extension', 'apps', 'system', 'launcher', 'sdk', 'server', 'dwrite.dll')

function Write-Step([string]$Text) { Write-Host "`n== $Text" -ForegroundColor Cyan }

function Get-SevenZip {
    $cmd = Get-Command '7z.exe' -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Path }
    foreach ($p in @("$env:ProgramFiles\7-Zip\7z.exe", "${env:ProgramFiles(x86)}\7-Zip\7z.exe")) {
        if ($p -and (Test-Path -LiteralPath $p)) { return $p }
    }
    return $null
}

function Expand-ModArchive([string]$Archive, [string]$Destination) {
    $ext = [IO.Path]::GetExtension($Archive).ToLowerInvariant()
    $sevenZip = Get-SevenZip
    if ($ext -eq '.zip') {
        try {
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [IO.Compression.ZipFile]::ExtractToDirectory($Archive, $Destination)
            return
        } catch {
            if (-not $sevenZip) { throw "Could not extract the zip: $($_.Exception.Message)" }
            Write-Host "Built-in unzip failed ($($_.Exception.Message)); retrying with 7-Zip." -ForegroundColor Yellow
            Remove-Item -LiteralPath $Destination -Recurse -Force -ErrorAction SilentlyContinue
            [void][IO.Directory]::CreateDirectory($Destination)
        }
    } elseif (-not $sevenZip) {
        throw "'$ext' archives need 7-Zip (https://www.7-zip.org). Install it, or extract the archive yourself and pass the folder as -ZipPath."
    }
    & $sevenZip x $Archive "-o$Destination" -y | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "7-Zip failed to extract '$Archive' (exit code $LASTEXITCODE)." }
}

function Get-MarkerNames([string]$Dir) {
    $names = @(Get-ChildItem -LiteralPath $Dir -Force | ForEach-Object { $_.Name.ToLowerInvariant() })
    return @($names | Where-Object { $RootMarkers -contains $_ })
}

function Find-ContentRoots([string]$Start, [int]$MaxDepth = 6) {
    # Breadth-first: return every folder at the shallowest depth that contains root markers.
    $level = @($Start)
    for ($depth = 0; $depth -le $MaxDepth -and $level.Count -gt 0; $depth++) {
        $found = @($level | Where-Object { (Get-MarkerNames $_).Count -gt 0 })
        if ($found.Count -gt 0) { return $found }
        $next = @()
        foreach ($d in $level) {
            $next += @(Get-ChildItem -LiteralPath $d -Directory -Force |
                Where-Object { $_.Name -ne '__MACOSX' } | ForEach-Object { $_.FullName })
        }
        $level = $next
    }
    return @()
}

function Get-RelativePath([string]$Base, [string]$Full) {
    $b = $Base.TrimEnd('\', '/')
    return $Full.Substring($b.Length).TrimStart('\', '/')
}

# ---------------------------------------------------------------- validate inputs
if (-not (Test-Path -LiteralPath $ZipPath)) { throw "Mod archive not found: $ZipPath" }
$ZipPath = (Get-Item -LiteralPath $ZipPath).FullName

if (-not (Test-Path -LiteralPath $AssettoCorsaPath -PathType Container)) { throw "Assetto Corsa folder not found: $AssettoCorsaPath" }
$AcRoot = (Get-Item -LiteralPath $AssettoCorsaPath).FullName.TrimEnd('\')
if ((Split-Path $AcRoot -Leaf) -ieq 'content' -and (Test-Path -LiteralPath (Join-Path (Split-Path $AcRoot -Parent) 'acs.exe'))) {
    $AcRoot = Split-Path $AcRoot -Parent
    Write-Host "You pointed at the content folder; using the game root instead: $AcRoot" -ForegroundColor Yellow
}
if (-not (Test-Path -LiteralPath (Join-Path $AcRoot 'acs.exe'))) {
    throw "acs.exe not found in '$AcRoot'. Pass the Assetto Corsa root folder (the one with acs.exe, content and system in it)."
}
if (Get-Process -Name 'acs', 'acs_x86' -ErrorAction SilentlyContinue) {
    throw 'Assetto Corsa is running. Close the game first, then run this again.'
}

if (-not $ModName) { $ModName = [IO.Path]::GetFileNameWithoutExtension($ZipPath) }
if (-not $BackupRoot) { $BackupRoot = Join-Path $AcRoot '_mod_backups' }

$tempDir = $null
try {
    # ------------------------------------------------------------ extract
    if (Test-Path -LiteralPath $ZipPath -PathType Container) {
        $extracted = $ZipPath
    } else {
        Write-Step "Extracting $(Split-Path $ZipPath -Leaf)"
        $tempDir = Join-Path ([IO.Path]::GetTempPath()) ('ACMod_' + [guid]::NewGuid().ToString('N'))
        [void][IO.Directory]::CreateDirectory($tempDir)
        Expand-ModArchive $ZipPath $tempDir
        $extracted = $tempDir
    }
    $extracted = (Get-Item -LiteralPath $extracted).FullName

    # ------------------------------------------------------------ find the AC-root folder in the archive
    if ($SourceSubfolder) {
        $sourceRoot = Join-Path $extracted $SourceSubfolder
        if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) { throw "-SourceSubfolder '$SourceSubfolder' not found in the archive." }
    } else {
        $roots = @(Find-ContentRoots $extracted)
        if ($roots.Count -eq 0) {
            Write-Host "`nTop of the archive:" -ForegroundColor Yellow
            Get-ChildItem -LiteralPath $extracted -Force | ForEach-Object { Write-Host "  $($_.Name)" }
            throw ("No content\, extension\, apps\, system\ or dwrite.dll found in the archive. " +
                   "If it is a plain car or track folder, drag it into Content Manager instead. " +
                   "Otherwise pass -SourceSubfolder with the folder that should land in the AC root.")
        }
        if ($roots.Count -gt 1) {
            Write-Host "`nThe archive has more than one folder that looks like an AC root:" -ForegroundColor Yellow
            $roots | ForEach-Object { Write-Host "  $(Get-RelativePath $extracted $_)" }
            throw 'Check the mod readme for which one you want, then run again with -SourceSubfolder "<one of the above>".'
        }
        $sourceRoot = $roots[0]
    }
    $sourceRoot = (Get-Item -LiteralPath $sourceRoot).FullName
    $relRoot = Get-RelativePath $extracted $sourceRoot
    if (-not $relRoot) { $relRoot = '(archive root)' }
    Write-Host "Installing from: $relRoot"

    # Anything in the archive outside the chosen folder is reported, not installed.
    $outside = @(Get-ChildItem -LiteralPath $extracted -Recurse -File -Force |
        Where-Object { -not $_.FullName.StartsWith($sourceRoot + '\', [StringComparison]::OrdinalIgnoreCase) -and
                       -not $_.FullName.StartsWith($sourceRoot + '/', [StringComparison]::OrdinalIgnoreCase) })
    if ($outside.Count -gt 0) {
        Write-Host "Not installed (outside that folder, usually readmes or optional extras):" -ForegroundColor DarkYellow
        $outside | Select-Object -First 15 | ForEach-Object { Write-Host "  $(Get-RelativePath $extracted $_.FullName)" -ForegroundColor DarkYellow }
        if ($outside.Count -gt 15) { Write-Host "  ... and $($outside.Count - 15) more" -ForegroundColor DarkYellow }
    }

    # ------------------------------------------------------------ build the file plan
    $topItems = @(Get-ChildItem -LiteralPath $sourceRoot -Force)
    $copyItems = @(); $skippedTop = @()
    foreach ($item in $topItems) {
        if ($IncludeAll -or ($RootMarkers -contains $item.Name.ToLowerInvariant())) { $copyItems += $item }
        else { $skippedTop += $item.Name }
    }
    if ($skippedTop.Count -gt 0) {
        Write-Host ("Skipped loose top-level items (use -IncludeAll to copy them): " + ($skippedTop -join ', ')) -ForegroundColor DarkYellow
    }

    $plan = New-Object System.Collections.Generic.List[object]
    foreach ($item in $copyItems) {
        $files = if ($item.PSIsContainer) { @(Get-ChildItem -LiteralPath $item.FullName -Recurse -File -Force) } else { @($item) }
        foreach ($f in $files) {
            $rel = Get-RelativePath $sourceRoot $f.FullName
            $dest = Join-Path $AcRoot $rel
            if (Test-Path -LiteralPath $dest -PathType Container) { throw "Archive file '$rel' would replace a folder of the same name in the game. Stopping." }
            $action = 'Add'
            if (Test-Path -LiteralPath $dest -PathType Leaf) {
                $action = 'Overwrite'
                $existing = Get-Item -LiteralPath $dest -Force
                if ($existing.Length -eq $f.Length -and
                    (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash -eq (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash) {
                    $action = 'Same'
                }
            }
            $plan.Add([pscustomobject]@{ Rel = $rel; Source = $f.FullName; Dest = $dest; Action = $action })
        }
    }
    if ($plan.Count -eq 0) { throw 'Nothing to install: the selected folder has no files.' }

    $toAdd = @($plan | Where-Object Action -eq 'Add')
    $toOverwrite = @($plan | Where-Object Action -eq 'Overwrite')
    $same = @($plan | Where-Object Action -eq 'Same')

    # Folders this install creates, so a restore can remove them again.
    $createdDirs = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    foreach ($p in $toAdd) {
        $relDir = Split-Path $p.Rel -Parent
        while ($relDir) {
            if (Test-Path -LiteralPath (Join-Path $AcRoot $relDir)) { break }
            [void]$createdDirs.Add($relDir)
            $relDir = Split-Path $relDir -Parent
        }
    }

    Write-Step "Plan for '$ModName' -> $AcRoot"
    Write-Host ("  New files:          {0}" -f $toAdd.Count) -ForegroundColor Green
    Write-Host ("  Files to overwrite: {0} (backed up first)" -f $toOverwrite.Count) -ForegroundColor Yellow
    Write-Host ("  Already identical:  {0} (left alone)" -f $same.Count)
    if ($toOverwrite.Count -gt 0) {
        Write-Host '  Overwrites:' -ForegroundColor Yellow
        $toOverwrite | Select-Object -First 25 | ForEach-Object { Write-Host "    $($_.Rel)" -ForegroundColor Yellow }
        if ($toOverwrite.Count -gt 25) { Write-Host "    ... and $($toOverwrite.Count - 25) more" -ForegroundColor Yellow }
    }

    if ($DryRun) {
        Write-Host "`nDry run: nothing was changed." -ForegroundColor Cyan
        return
    }
    if ($toAdd.Count -eq 0 -and $toOverwrite.Count -eq 0) {
        Write-Host "`nEverything in this mod is already installed. Nothing to do." -ForegroundColor Green
        return
    }
    if (-not $Force) {
        $answer = Read-Host "`nBack up and install now? (Y/N)"
        if ($answer -notmatch '^(y|yes)$') { Write-Host 'Cancelled. Nothing was changed.'; return }
    }

    # ------------------------------------------------------------ backup
    $safeName = ($ModName -replace '[^\w\.\- ]', '_').Trim()
    $backupDir = Join-Path $BackupRoot ('{0}_{1}' -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $safeName)
    $backupFiles = Join-Path $backupDir 'files'
    [void][IO.Directory]::CreateDirectory($backupFiles)
    $manifestPath = Join-Path $backupDir 'manifest.json'

    $manifest = [ordered]@{
        ModName          = $ModName
        Source           = $ZipPath
        SourceSubfolder  = $relRoot
        AssettoCorsaPath = $AcRoot
        Created          = (Get-Date).ToString('s')
        Status           = 'InProgress'
        Overwritten      = @($toOverwrite | ForEach-Object { $_.Rel })
        Added            = @($toAdd | ForEach-Object { $_.Rel })
        CreatedDirs      = @($createdDirs | Sort-Object)
    }
    # Written before anything changes, so even a failed install can be rolled back.
    $manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    Write-Step "Backing up $($toOverwrite.Count) file(s) to $backupDir"
    foreach ($p in $toOverwrite) {
        $b = Join-Path $backupFiles $p.Rel
        [void][IO.Directory]::CreateDirectory((Split-Path $b -Parent))
        Copy-Item -LiteralPath $p.Dest -Destination $b -Force
    }

    # ------------------------------------------------------------ install
    Write-Step 'Copying mod files'
    $done = 0
    try {
        foreach ($p in @($toAdd + $toOverwrite)) {
            [void][IO.Directory]::CreateDirectory((Split-Path $p.Dest -Parent))
            Copy-Item -LiteralPath $p.Source -Destination $p.Dest -Force
            $done++
        }
    } catch {
        $manifest.Status = 'Failed'
        $manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
        Write-Host "`nInstall stopped after $done file(s): $($_.Exception.Message)" -ForegroundColor Red
        Write-Host 'If it says access is denied, run PowerShell as Administrator.' -ForegroundColor Red
        Write-Host "To undo the partial install:" -ForegroundColor Red
        Write-Host "  .\Restore-ACMod.ps1 -AssettoCorsaPath `"$AcRoot`" -BackupName `"$(Split-Path $backupDir -Leaf)`"" -ForegroundColor Red
        exit 1
    }

    $manifest.Status = 'Installed'
    $manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    Write-Host "`nDone. Installed $done file(s) from '$ModName'." -ForegroundColor Green
    Write-Host "Backup: $backupDir"
    Write-Host 'To undo:'
    Write-Host "  .\Restore-ACMod.ps1 -AssettoCorsaPath `"$AcRoot`" -BackupName `"$(Split-Path $backupDir -Leaf)`""
}
finally {
    if ($tempDir -and (Test-Path -LiteralPath $tempDir)) {
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
