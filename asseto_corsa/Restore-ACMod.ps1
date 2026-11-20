<#
.SYNOPSIS
    Undoes an install made by Install-ACMod.ps1: puts the original files back and removes
    the files the mod added.

.PARAMETER AssettoCorsaPath
    The Assetto Corsa root (the folder with acs.exe).

.PARAMETER BackupRoot
    Where the backups are. Default: <AssettoCorsaPath>\_mod_backups

.PARAMETER BackupName
    The backup folder to restore (e.g. 20261120-093000_Pure_v2.5), or its full path.

.PARAMETER Latest
    Restore the most recent backup that hasn't been restored yet.

.PARAMETER List
    Just list the backups.

.PARAMETER KeepAddedFiles
    Put overwritten files back but leave the files the mod added.

.PARAMETER DryRun
    Show what would happen without changing anything.

.PARAMETER Force
    Skip the confirmation prompt.

.EXAMPLE
    .\Restore-ACMod.ps1 -AssettoCorsaPath "C:\Program Files (x86)\Steam\steamapps\common\assettocorsa" -List

.EXAMPLE
    .\Restore-ACMod.ps1 -AssettoCorsaPath "C:\Program Files (x86)\Steam\steamapps\common\assettocorsa" -Latest
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$AssettoCorsaPath,
    [string]$BackupRoot,
    [string]$BackupName,
    [switch]$Latest,
    [switch]$List,
    [switch]$KeepAddedFiles,
    [switch]$DryRun,
    [switch]$Force
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $AssettoCorsaPath -PathType Container)) { throw "Assetto Corsa folder not found: $AssettoCorsaPath" }
$AcRoot = (Get-Item -LiteralPath $AssettoCorsaPath).FullName.TrimEnd('\')
if ((Split-Path $AcRoot -Leaf) -ieq 'content' -and (Test-Path -LiteralPath (Join-Path (Split-Path $AcRoot -Parent) 'acs.exe'))) {
    $AcRoot = Split-Path $AcRoot -Parent
}
if (-not $BackupRoot) { $BackupRoot = Join-Path $AcRoot '_mod_backups' }

function Read-Manifest([string]$Dir) {
    $m = Get-Content -LiteralPath (Join-Path $Dir 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    return $m
}
function Get-List($m, [string]$Name) {
    $prop = $m.PSObject.Properties[$Name]
    if ($null -eq $prop -or $null -eq $prop.Value) { return @() }
    return @($prop.Value)
}

$backups = @()
if (Test-Path -LiteralPath $BackupRoot) {
    $backups = @(Get-ChildItem -LiteralPath $BackupRoot -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'manifest.json') } |
        Sort-Object Name |
        ForEach-Object {
            $m = Read-Manifest $_.FullName
            [pscustomobject]@{
                Name        = $_.Name
                Path        = $_.FullName
                Mod         = $m.ModName
                Created     = $m.Created
                Status      = $m.Status
                Overwritten = (Get-List $m 'Overwritten').Count
                Added       = (Get-List $m 'Added').Count
            }
        })
}
if ($backups.Count -eq 0 -and -not $BackupName) { Write-Host "No backups found in $BackupRoot"; return }

if ($List) {
    $backups | Format-Table Name, Mod, Created, Status, Overwritten, Added -AutoSize
    return
}

# ---------------------------------------------------------------- pick a backup
$selectedPath = $null
if ($BackupName) {
    if (Test-Path -LiteralPath (Join-Path $BackupName 'manifest.json')) { $selectedPath = (Get-Item -LiteralPath $BackupName).FullName }
    elseif (Test-Path -LiteralPath (Join-Path (Join-Path $BackupRoot $BackupName) 'manifest.json')) { $selectedPath = (Get-Item -LiteralPath (Join-Path $BackupRoot $BackupName)).FullName }
    else { throw "Backup '$BackupName' not found (looked in $BackupRoot)." }
} elseif ($Latest) {
    $candidate = @($backups | Where-Object { $_.Status -ne 'Restored' }) | Select-Object -Last 1
    if (-not $candidate) { Write-Host 'Every backup has already been restored.'; return }
    $selectedPath = $candidate.Path
} else {
    Write-Host ''
    for ($i = 0; $i -lt $backups.Count; $i++) {
        $b = $backups[$i]
        Write-Host ("  [{0}] {1}  ({2}, {3})" -f ($i + 1), $b.Name, $b.Status, $b.Created)
    }
    $pick = Read-Host "`nNumber of the backup to restore"
    $n = 0
    if (-not [int]::TryParse($pick, [ref]$n) -or $n -lt 1 -or $n -gt $backups.Count) { Write-Host 'Cancelled.'; return }
    $selectedPath = $backups[$n - 1].Path
}

if (Get-Process -Name 'acs', 'acs_x86' -ErrorAction SilentlyContinue) {
    throw 'Assetto Corsa is running. Close the game first, then run this again.'
}

$manifest = Read-Manifest $selectedPath
$selectedName = Split-Path $selectedPath -Leaf
$overwritten = @(Get-List $manifest 'Overwritten')
$added = @(Get-List $manifest 'Added')
$createdDirs = @(Get-List $manifest 'CreatedDirs')
$backupFiles = Join-Path $selectedPath 'files'

if ($manifest.AssettoCorsaPath -and ($manifest.AssettoCorsaPath.TrimEnd('\') -ne $AcRoot)) {
    Write-Host "Note: this backup was made for $($manifest.AssettoCorsaPath); restoring into $AcRoot." -ForegroundColor Yellow
}
if ($manifest.Status -eq 'Restored') {
    Write-Host 'This backup has already been restored once.' -ForegroundColor Yellow
}

# Warn when a later install touched the same files: undo the newer one first.
$mine = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($r in @($overwritten + $added)) { [void]$mine.Add($r) }
$conflicts = @()
foreach ($b in @($backups | Where-Object { $_.Name -gt $selectedName -and $_.Status -ne 'Restored' })) {
    $other = Read-Manifest $b.Path
    $hits = @(@((Get-List $other 'Overwritten') + (Get-List $other 'Added')) | Where-Object { $mine.Contains($_) })
    if ($hits.Count -gt 0) { $conflicts += "$($b.Name) ($($hits.Count) shared files)" }
}
if ($conflicts.Count -gt 0) {
    Write-Host "`nThese later installs changed some of the same files. Restore them first (newest first), or the result will be mixed:" -ForegroundColor Yellow
    $conflicts | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
}

Write-Host "`n== Restore '$($manifest.ModName)' from $selectedName" -ForegroundColor Cyan
Write-Host ("  Original files to put back: {0}" -f $overwritten.Count)
if ($KeepAddedFiles) { Write-Host ("  Files the mod added:        {0} (kept)" -f $added.Count) }
else { Write-Host ("  Files the mod added:        {0} (deleted)" -f $added.Count) }

if ($DryRun) { Write-Host "`nDry run: nothing was changed." -ForegroundColor Cyan; return }
if (-not $Force) {
    $answer = Read-Host "`nRestore now? (Y/N)"
    if ($answer -notmatch '^(y|yes)$') { Write-Host 'Cancelled. Nothing was changed.'; return }
}

$errors = 0
if (-not $KeepAddedFiles) {
    foreach ($rel in $added) {
        $p = Join-Path $AcRoot $rel
        if (Test-Path -LiteralPath $p -PathType Leaf) {
            try { Remove-Item -LiteralPath $p -Force } catch { $errors++; Write-Host "Could not delete $rel : $($_.Exception.Message)" -ForegroundColor Red }
        }
    }
    # Remove folders the install created, deepest first, only if they're now empty.
    foreach ($rel in @($createdDirs | Sort-Object { $_.Length } -Descending)) {
        $d = Join-Path $AcRoot $rel
        if ((Test-Path -LiteralPath $d -PathType Container) -and -not (Get-ChildItem -LiteralPath $d -Force | Select-Object -First 1)) {
            Remove-Item -LiteralPath $d -Force -ErrorAction SilentlyContinue
        }
    }
}

foreach ($rel in $overwritten) {
    $src = Join-Path $backupFiles $rel
    $dst = Join-Path $AcRoot $rel
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) {
        # A failed install can stop before every backup copy was made; those originals were never touched.
        if (@('Failed', 'InProgress') -notcontains $manifest.Status) { $errors++; Write-Host "Missing from backup: $rel" -ForegroundColor Red }
        continue
    }
    try {
        [void][IO.Directory]::CreateDirectory((Split-Path $dst -Parent))
        Copy-Item -LiteralPath $src -Destination $dst -Force
    } catch { $errors++; Write-Host "Could not restore $rel : $($_.Exception.Message)" -ForegroundColor Red }
}

$manifest | Add-Member -NotePropertyName RestoredAt -NotePropertyValue (Get-Date).ToString('s') -Force
$manifest.Status = if ($errors -eq 0) { 'Restored' } else { 'RestoreIncomplete' }
$manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $selectedPath 'manifest.json') -Encoding UTF8

if ($errors -eq 0) {
    Write-Host "`nDone. '$($manifest.ModName)' has been rolled back. The backup folder is kept; delete it when you no longer need it." -ForegroundColor Green
} else {
    Write-Host "`nFinished with $errors problem(s) listed above. If it says access is denied, run PowerShell as Administrator and try again." -ForegroundColor Yellow
}
