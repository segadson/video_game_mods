<#
DCS-Profiles.ps1  -  three jobs for your DCS and IL-2 bindings

  1. Collect: copies the joystick command lists (default.lua) for the F-16C,
     F-14B pilot and F/A-18C out of your DCS install into one zip on your
     Desktop, so you can upload it and get F-16 / F-14 profiles built.
  2. Import: copies the .diff.lua profiles from this "DCS profiles" folder
     into Saved Games\DCS\Config\Input\<aircraft>\joystick, renamed to the
     exact device name + GUID DCS uses for your AB6 and MTQ.
     Any file it replaces is backed up first (.bak-<date>).
  3. IL2: merges the IL-2 Great Battles layout in IL-2\*.actions into the
     game's data\input\global.actions. It reads data\input\devices.txt to
     find the joystick numbers IL-2 gave your AB6 and MTQ, removes the old
     AB6 / MTQ bindings, adds the new ones and leaves keyboard, mouse and
     pedal bindings alone. The old file is backed up first to
     data\input-backups\.

HOW TO RUN (DCS and IL-2 must be closed)
  - Put this script inside the "DCS profiles" folder (next to FA-18C_hornet\ and IL-2\).
  - Right-click it > "Run with PowerShell", or in a PowerShell window:
        powershell -ExecutionPolicy Bypass -File ".\DCS-Profiles.ps1"
  - Only one job:      -Collect   or   -Import   or   -IL2
  - Custom DCS paths:  -DcsInstall "D:\DCS World"  -SavedGames "D:\Saved Games\DCS"
  - Custom IL-2 path:  -Il2Install "D:\IL-2 Sturmovik Great Battles"
  - If the script can't tell which IL-2 device is which:
                       -Il2StickId 3  -Il2ThrottleId 1   (numbers from devices.txt)

BEFORE THE FIRST IMPORT
  DCS only creates the device file (with its GUID) after you bind something.
  In DCS: Options > Controls > F/A-18C, bind any one AB6 button, press OK, quit.
  Do the same once for the MTQ if you haven't. The script then finds the GUIDs.
  IL-2: start IL-2 once with the AB6 and MTQ plugged in and open Settings >
  Key mapping, so the game lists them in devices.txt. Then quit IL-2.
#>
param(
    [switch]$Collect,
    [switch]$Import,
    [switch]$IL2,
    [string]$DcsInstall,
    [string]$SavedGames,
    [string]$Il2Install,
    [int]$Il2StickId = -1,
    [int]$Il2ThrottleId = -1,
    [string]$ProfilesFolder = $PSScriptRoot
)
$ErrorActionPreference = 'Stop'
if (-not $Collect -and -not $Import -and -not $IL2) { $Collect = $true; $Import = $true; $IL2 = $true }

# Which source files go to which device. Pattern = text in the source file name;
# Device = text DCS puts in the device file name (wildcards allowed).
$DeviceRules = @(
    @{ Pattern = 'AB6';  Device = '*AB6*' },
    @{ Pattern = 'MTQ';  Device = '*MTQ*' }
)

function Find-DcsInstall {
    $candidates = @()
    foreach ($k in 'HKCU:\Software\Eagle Dynamics\DCS World',
                   'HKCU:\Software\Eagle Dynamics\DCS World OpenBeta') {
        try { $p = (Get-ItemProperty -Path $k -ErrorAction Stop).Path; if ($p) { $candidates += $p } } catch {}
    }
    # Steam installs
    try {
        $steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction Stop).SteamPath
        if ($steam) {
            $candidates += (Join-Path $steam 'steamapps\common\DCSWorld')
            $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
            if (Test-Path $vdf) {
                Select-String -Path $vdf -Pattern '"path"\s+"([^"]+)"' | ForEach-Object {
                    $lib = $_.Matches[0].Groups[1].Value -replace '\\\\','\'
                    $candidates += "$lib\steamapps\common\DCSWorld"
                }
            }
        }
    } catch {}
    foreach ($d in 'C:','D:','E:','F:') {
        $candidates += "$d\Program Files\Eagle Dynamics\DCS World",
                       "$d\Program Files\Eagle Dynamics\DCS World OpenBeta",
                       "$d\DCS World", "$d\DCS World OpenBeta",
                       "$d\Eagle Dynamics\DCS World", "$d\Eagle Dynamics\DCS World OpenBeta"
    }
    $candidates | Select-Object -Unique | Where-Object { Test-Path -LiteralPath "$_\Mods\aircraft" -ErrorAction SilentlyContinue }
}

function Find-SavedGames {
    $root = $null
    try { $root = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -ErrorAction Stop).'{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}' } catch {}
    if ($root) { $root = [Environment]::ExpandEnvironmentVariables($root) } else { $root = Join-Path $env:USERPROFILE 'Saved Games' }
    'DCS','DCS.openbeta' | ForEach-Object { Join-Path $root $_ } | Where-Object { Test-Path (Join-Path $_ 'Config') }
}

# ---------------------------------------------------------------- 1. Collect
if ($Collect) {
    Write-Host "`n=== Collecting default.lua command lists ===" -ForegroundColor Cyan
    $installs = if ($DcsInstall) { @($DcsInstall) } else { @(Find-DcsInstall) }
    if (-not $installs) {
        Write-Warning "Couldn't find DCS. Run again with -DcsInstall ""<your DCS folder>"" (the one that contains bin\ and Mods\)."
    } else {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmm'
        $out = Join-Path ([Environment]::GetFolderPath('Desktop')) "DCS default.lua $stamp"
        New-Item -ItemType Directory -Path $out -Force | Out-Null
        # module folder under Mods\aircraft, and a filter that skips the RIO seat
        $modules = @(
            @{ Name = 'F-16C';  Folder = 'F-16C'; Skip = $null },
            @{ Name = 'F-14B';  Folder = 'F14';   Skip = 'RIO' },
            @{ Name = 'FA-18C'; Folder = 'FA-18C'; Skip = $null }
        )
        foreach ($inst in $installs) {
            $tag = Split-Path $inst -Leaf
            foreach ($m in $modules) {
                $inputDir = Join-Path $inst "Mods\aircraft\$($m.Folder)\Input"
                if (-not (Test-Path $inputDir)) { Write-Host "  $tag : $($m.Name) not installed here, skipped"; continue }
                Get-ChildItem $inputDir -Recurse -Filter 'default.lua' |
                    Where-Object { $_.FullName -match '\\joystick\\' -and (-not $m.Skip -or $_.FullName -notmatch $m.Skip) } |
                    ForEach-Object {
                        $seat = $_.Directory.Parent.Name   # e.g. F-16C, F-14B-Pilot
                        $dest = Join-Path $out "$tag - $seat - joystick default.lua"
                        Copy-Item $_.FullName $dest -Force
                        Write-Host "  copied $($_.FullName)"
                    }
            }
        }
        $zip = "$out.zip"
        Compress-Archive -Path "$out\*" -DestinationPath $zip -Force
        Remove-Item $out -Recurse -Force
        Write-Host "  Upload this file to Claude: $zip" -ForegroundColor Green
    }
}

# ---------------------------------------------------------------- 2. Import
if ($Import) { & {   # script block, so "return" below only ends this job
    Write-Host "`n=== Importing .diff.lua profiles ===" -ForegroundColor Cyan
    if (Get-Process -Name 'DCS' -ErrorAction SilentlyContinue) {
        Write-Warning "DCS is running. Close it first, or it will overwrite the files on exit."; return
    }
    $targets = if ($SavedGames) { @($SavedGames) } else { @(Find-SavedGames) }
    if (-not $targets) { Write-Warning "Couldn't find Saved Games\DCS. Run again with -SavedGames ""<path to Saved Games\DCS>"""; return }

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    foreach ($sg in $targets) {
        $inputRoot = Join-Path $sg 'Config\Input'
        Write-Host "Target: $inputRoot"
        # Device file names DCS has created anywhere (any aircraft), e.g. "MOZA AB6 Base {GUID}.diff.lua"
        $known = Get-ChildItem $inputRoot -Recurse -Filter '*.diff.lua' -ErrorAction SilentlyContinue |
                 Where-Object { $_.Directory.Name -eq 'joystick' -and $_.Name -match '\{[0-9A-Fa-f-]+\}\.diff\.lua$' } |
                 Select-Object -ExpandProperty Name -Unique

        # Source layout: <ProfilesFolder>\<aircraft folder as DCS names it>\*.diff.lua
        Get-ChildItem $ProfilesFolder -Directory | ForEach-Object {
            $aircraft = $_.Name
            Get-ChildItem $_.FullName -Filter '*.diff.lua' | ForEach-Object {
                $src = $_
                $rule = $DeviceRules | Where-Object { $src.Name -match $_.Pattern } | Select-Object -First 1
                if (-not $rule) { Write-Host "  skip $aircraft\$($src.Name) (not an AB6 / MTQ profile)"; return }
                $match = @($known | Where-Object { $_ -like $rule.Device })
                if ($match.Count -eq 0) {
                    Write-Warning "  No $($rule.Pattern) device file in $inputRoot yet. Bind one $($rule.Pattern) button in DCS, press OK, quit DCS, then run this again."
                    return
                }
                if ($match.Count -gt 1) {
                    Write-Warning "  More than one $($rule.Pattern) device name found: $($match -join ', '). Using the first. Delete stale ones if this is wrong."
                }
                $destDir = Join-Path $inputRoot "$aircraft\joystick"
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                $dest = Join-Path $destDir $match[0]
                if (Test-Path -LiteralPath $dest) {
                    Copy-Item -LiteralPath $dest -Destination "$dest.bak-$stamp" -Force
                    Write-Host "  backed up existing $aircraft\joystick\$($match[0])"
                }
                Copy-Item -LiteralPath $src.FullName -Destination $dest -Force
                Write-Host "  $aircraft : $($src.Name)  ->  $($match[0])" -ForegroundColor Green
            }
        }
    }
    Write-Host "`nDone. Start DCS and check Options > Controls. To undo, delete the new file and remove '.bak-$stamp' from the backup." -ForegroundColor Cyan
} }

# ---------------------------------------------------------------- 3. IL-2 Great Battles
function Find-Il2Install {
    $candidates = @()
    # Installed programs (standalone installer and Steam both register here)
    foreach ($k in 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                   'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                   'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') {
        Get-ItemProperty $k -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like 'IL-2 Sturmovik*' -and $_.InstallLocation } |
            ForEach-Object { $candidates += $_.InstallLocation.TrimEnd('\') }
    }
    # Steam libraries
    try {
        $steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction Stop).SteamPath
        if ($steam) {
            $libs = @($steam)
            $vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'
            if (Test-Path $vdf) {
                Select-String -Path $vdf -Pattern '"path"\s+"([^"]+)"' | ForEach-Object {
                    $libs += ($_.Matches[0].Groups[1].Value -replace '\\\\','\')
                }
            }
            foreach ($lib in $libs) { $candidates += "$lib\steamapps\common\IL-2 Sturmovik Battle of Stalingrad" }
        }
    } catch {}
    foreach ($d in 'C:','D:','E:','F:') {
        $candidates += "$d\Program Files\IL-2 Sturmovik Great Battles",
                       "$d\Program Files (x86)\1C Game Studios\IL-2 Sturmovik Great Battles",
                       "$d\IL-2 Sturmovik Great Battles", "$d\Games\IL-2 Sturmovik Great Battles",
                       "$d\IL-2 Sturmovik Battle of Stalingrad"
    }
    # Steam and the uninstall entry often name the same folder: resolve and de-duplicate (case-insensitive)
    $candidates | Where-Object { $_ -and (Test-Path -LiteralPath "$_\data\input" -ErrorAction SilentlyContinue) } |
        ForEach-Object { (Resolve-Path -LiteralPath $_).Path.TrimEnd('\') } | Sort-Object -Unique
}

# One binding row in IL-2's column layout: "action,<pad>command,<pad>invert|"
function Format-Il2Row([string]$Action, [string]$Command, [string]$Invert, [string]$Tail = '') {
    ('{0,-50}{1,-50}{2}|{3}' -f "$Action,", "$Command,", $Invert, $Tail)
}

if ($IL2) { & {   # script block, so "return" below only ends this job
    Write-Host "`n=== Installing IL-2 Great Battles bindings ===" -ForegroundColor Cyan
    if (Get-Process -Name 'Il-2' -ErrorAction SilentlyContinue) {
        Write-Warning "IL-2 is running. Close it first, or it will overwrite the file on exit."; return
    }
    $template = Get-ChildItem (Join-Path $ProfilesFolder 'IL-2') -Filter '*.actions' -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $template) { Write-Warning "No IL-2\*.actions file next to this script."; return }

    $installs = if ($Il2Install) { @($Il2Install) } else { @(Find-Il2Install) }
    if (-not $installs) {
        Write-Warning "Couldn't find IL-2. Run again with -Il2Install ""<your IL-2 folder>"" (the one that contains bin\ and data\)."; return
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $latin1 = [Text.Encoding]::GetEncoding(28591)   # byte-for-byte round trip, keeps the game's accented comments intact

    foreach ($inst in $installs) {
        $inputDir = Join-Path $inst 'data\input'
        Write-Host "Target: $inputDir"

        # --- which joystick number is the AB6 and which is the MTQ
        $devFile = Join-Path $inputDir 'devices.txt'
        if (-not (Test-Path -LiteralPath $devFile)) {
            Write-Warning "  No devices.txt yet. Start IL-2 with the AB6 and MTQ plugged in, open Settings > Key mapping, quit, then run this again."; continue
        }
        $devices = foreach ($row in ([IO.File]::ReadAllText($devFile, $latin1) -split '\|')) {
            if ($row.Trim() -match '^(\d+),([^,]*),(.*)$') {
                [pscustomobject]@{
                    Id   = [int]$Matches[1]
                    Guid = [uri]::UnescapeDataString($Matches[2]).Trim('"')
                    Name = [uri]::UnescapeDataString($Matches[3]).Trim()
                }
            }
        }
        Write-Host "  Devices IL-2 knows (devices.txt):"
        $devices | ForEach-Object { Write-Host ("    joy{0,-3} {1}  {2}" -f $_.Id, $_.Name, $_.Guid) }

        $pick = {
            param($forced, $primary, $fallback)
            if ($forced -ge 0) { return @($devices | Where-Object Id -eq $forced) }
            $m = @($devices | Where-Object { $_.Name -match $primary })
            if ($m.Count -eq 0 -and $fallback) { $m = @($devices | Where-Object $fallback) }
            $m
        }
        $stick = @(& $pick $Il2StickId 'AB6' { $_.Name -match 'MOZA' -and $_.Name -notmatch 'MTQ|MRP|Pedal|Rudder|Wheel|Shifter|Handbrake|Throttle' })
        $thr   = @(& $pick $Il2ThrottleId 'MTQ' $null)
        $ok = $true
        foreach ($p in @(@('AB6 stick', $stick, '-Il2StickId'), @('MTQ throttle', $thr, '-Il2ThrottleId'))) {
            if ($p[1].Count -ne 1) {
                $why = if ($p[1].Count -eq 0) { 'not found' } else { 'more than one match' }
                Write-Warning "  $($p[0]): $why in devices.txt. Run again with $($p[2]) <number from the list above>."
                $ok = $false
            }
        }
        if (-not $ok) { continue }
        $a = $stick[0].Id; $m = $thr[0].Id
        if ($a -eq $m) { Write-Warning "  Stick and throttle point at the same device (joy$a)."; continue }
        Write-Host "  AB6 = joy$a ($($stick[0].Name)),  MTQ = joy$m ($($thr[0].Name))" -ForegroundColor Green

        # --- the game's bindings file (global.actions since late 2022, current.actions before)
        $actionsFile = @('global.actions', 'current.actions') | ForEach-Object { Join-Path $inputDir $_ } |
                       Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
        if (-not $actionsFile) {
            Write-Warning "  No global.actions in $inputDir. Open Settings > Key mapping in IL-2 once, quit, then run this again."; continue
        }

        # --- new rows from the template, with real joystick numbers
        $newRows = [ordered]@{}
        foreach ($t in [IO.File]::ReadAllLines($template.FullName)) {
            if ($t -notmatch '^\s*([A-Za-z0-9_]+)\s*,\s*([^,]*?)\s*,\s*(\d+)\s*\|') { continue }
            $cmd = $Matches[2].Replace('{AB6}', "$a").Replace('{MTQ}', "$m")
            if (-not $newRows.Contains($Matches[1])) { $newRows[$Matches[1]] = @() }
            $newRows[$Matches[1]] += (Format-Il2Row $Matches[1] $cmd $Matches[3])
        }

        # --- back up, then rewrite
        $backupDir = Join-Path (Split-Path $inputDir) 'input-backups'
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        $leaf = Split-Path $actionsFile -Leaf
        Copy-Item -LiteralPath $actionsFile -Destination (Join-Path $backupDir "$leaf.bak-$stamp") -Force
        Write-Host "  backed up $leaf to $backupDir\$leaf.bak-$stamp"

        $text = [IO.File]::ReadAllText($actionsFile, $latin1)
        $nl = if ($text.Contains("`r`n")) { "`r`n" } else { "`n" }
        $lines = [Collections.Generic.List[string]]::new([string[]]($text -split "\r?\n"))
        $rowRx = '^\s*([A-Za-z0-9_]+)\s*,\s*([^,]*?)\s*,\s*(\d+)\s*\|(.*)$'
        $ourIds = @($a, $m)
        $removed = 0; $mixed = 0

        # 1. drop every existing AB6 / MTQ binding (keyboard, mouse, pedals and other devices stay)
        for ($i = $lines.Count - 1; $i -ge 0; $i--) {
            if ($lines[$i] -notmatch $rowRx) { continue }
            $act = $Matches[1]; $cmd = $Matches[2]; $inv = $Matches[3]; $tail = $Matches[4]
            $ids = @([regex]::Matches($cmd, 'joy(\d+)_') | ForEach-Object { [int]$_.Groups[1].Value })
            if ($ids.Count -eq 0) { continue }
            $mine = @($ids | Where-Object { $ourIds -contains $_ })
            if ($mine.Count -eq 0) { continue }
            if ($mine.Count -lt $ids.Count) { $mixed++; Write-Warning "  left alone (mixes AB6/MTQ with another device): $($lines[$i].Trim())"; continue }
            if ($tail -match '//') { $lines[$i] = Format-Il2Row $act '' $inv $tail }   # first row of an action carries its description: keep it, empty the binding
            else { $lines.RemoveAt($i) }
            $removed++
        }

        # 2. add the new rows after the last row of each action
        $added = 0; $missing = @()
        $last = @{}
        for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match $rowRx) { $last[$Matches[1]] = $i } }
        $order = $newRows.Keys | Sort-Object { if ($last.ContainsKey($_)) { -$last[$_] } else { 1 } }
        foreach ($act in $order) {
            if ($last.ContainsKey($act)) {
                $lines.InsertRange($last[$act] + 1, [string[]]$newRows[$act])
                $added += $newRows[$act].Count
            } else { $missing += $act }
        }
        if ($missing) {
            # actions this game version doesn't list yet: append them at the end
            $at = $lines.Count; if ($lines[$at - 1] -eq '') { $at-- }
            foreach ($act in $missing) { $lines.InsertRange($at, [string[]]$newRows[$act]); $at += $newRows[$act].Count; $added += $newRows[$act].Count }
            Write-Warning "  Not in your $leaf, added at the end (check them in-game): $($missing -join ', ')"
        }
        [IO.File]::WriteAllText($actionsFile, ($lines -join $nl), $latin1)
        Write-Host "  $leaf : removed $removed old AB6/MTQ rows, added $added rows from $($template.Name)" -ForegroundColor Green
    }
    Write-Host "`nDone. Start IL-2 and check Settings > Key mapping. To undo, copy the backup from data\input-backups back over data\input\global.actions." -ForegroundColor Cyan
} }
