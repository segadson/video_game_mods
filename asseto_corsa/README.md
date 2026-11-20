# Assetto Corsa manual mod installer

Two PowerShell scripts for mods that have to be copied into the Assetto Corsa folder instead of dragged into Content Manager.

- **Install-ACMod.ps1** unpacks the mod, finds the folder inside it that matches the AC root (the one with `content`, `extension`, `apps`, `system` or `dwrite.dll`), shows you what it will add and overwrite, backs up every file it overwrites, then copies the mod in.
- **Restore-ACMod.ps1** undoes an install: it puts the original files back and deletes the files the mod added.

Backups go to `<AC folder>\_mod_backups\<date-time>_<mod name>\`, each with a `manifest.json` listing what changed.

## Which of your mods need this

| Mod | How to install | Why |
| --- | --- | --- |
| **Pure** | **This script** | Its zip is meant to be copied into the AC root (`extension`, `apps`, sometimes `content`). Afterwards pick Pure Gamma in Content Manager → Settings → Custom Shaders Patch → Weather FX. |
| **Better AI Single Seaters** | **This script** | It overwrites the stock AI line files at Monza, Silverstone, Imola and Red Bull Ring. The backup lets you go back to Kunos AI. |
| **Pyyer's F1 track extensions** | **This script** if the download has `extension` or `content` at the top, otherwise Content Manager | Track config files go into `extension\config\tracks` or the track's own folder. |
| **Traffic plans and track patches** (Shutoko, LA Canyons, Transfăgărășan, Isle of Man patches) | **This script** when the readme says to copy into the AC or track folder | They usually add or overwrite files inside an existing track. |
| **Custom Shaders Patch, manual install** | **This script**, only if CM's own installer fails | The manual package is `dwrite.dll` plus `extension`. Stay on 0.2.11. |
| **Sol** | This script, only if you ever switch from Pure | Don't run Pure and Sol together. |
| Cars, tracks, skins | Drag into Content Manager | CM puts them in the right `content` folder. |
| Sidekick, Helicorsa, Real Head Motion | Drag into Content Manager | CM recognises Python apps. |
| Full Send AI, RARE | Drag into Content Manager (Full Send AI via Settings → Custom Shaders Patch) | The script works too if the zip has `apps` or `extension` at the top. |
| Crew Chief, SimHub, Career Hub, BigLad Career Mode App | Their own installer or app | They run alongside AC and don't go into the game folder. |

These are based on each mod's usual install instructions. If a mod's readme says something different, follow the readme.

## One-time setup

1. Put both `.ps1` files in a folder, for example `Documents\AC-Mod-Installer`.
2. Find your AC folder: in Steam, right-click Assetto Corsa → Manage → Browse local files, then copy the path from the address bar. It's the folder with `acs.exe` in it, usually `C:\Program Files (x86)\Steam\steamapps\common\assettocorsa`.
3. Open PowerShell in the scripts folder (in File Explorer, type `powershell` in the address bar and press Enter).
4. Allow the downloaded scripts to run:

```powershell
Unblock-File .\Install-ACMod.ps1, .\Restore-ACMod.ps1
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

If you'd rather not change the policy, start each command with `powershell -ExecutionPolicy Bypass -File` instead of `.\`.

`.zip` files work out of the box. For `.7z` and `.rar` mods, install [7-Zip](https://www.7-zip.org) and the script will use it, or extract the archive yourself and pass the folder.

## Usage

Close Assetto Corsa first. The script refuses to run while the game is open.

Set your path once per PowerShell window:

```powershell
$AC = "C:\Program Files (x86)\Steam\steamapps\common\assettocorsa"
```

**See what a mod would change, without touching anything:**

```powershell
.\Install-ACMod.ps1 -ZipPath "$env:USERPROFILE\Downloads\Pure_v2.5.zip" -AssettoCorsaPath $AC -DryRun
```

**Install Pure:**

```powershell
.\Install-ACMod.ps1 -ZipPath "$env:USERPROFILE\Downloads\Pure_v2.5.zip" -AssettoCorsaPath $AC
```

**Install Better AI Single Seaters:**

```powershell
.\Install-ACMod.ps1 -ZipPath "$env:USERPROFILE\Downloads\better_ai_single_seaters.zip" -AssettoCorsaPath $AC
```

**A mod you already extracted:**

```powershell
.\Install-ACMod.ps1 -ZipPath "$env:USERPROFILE\Downloads\IOM_patches" -AssettoCorsaPath $AC
```

**A zip with more than one variant inside.** The script stops and lists the candidate folders. Pick one with `-SourceSubfolder`:

```powershell
.\Install-ACMod.ps1 -ZipPath .\some_mod.zip -AssettoCorsaPath $AC -SourceSubfolder "Main\assettocorsa"
```

**List backups, undo the last install, or undo a specific one:**

```powershell
.\Restore-ACMod.ps1 -AssettoCorsaPath $AC -List
.\Restore-ACMod.ps1 -AssettoCorsaPath $AC -Latest
.\Restore-ACMod.ps1 -AssettoCorsaPath $AC -BackupName "20261120-093000_Pure_v2.5"
```

Running `Restore-ACMod.ps1` with only `-AssettoCorsaPath` shows a numbered list to pick from.

## Other options

| Option | Script | What it does |
| --- | --- | --- |
| `-BackupRoot D:\AC-Backups` | both | Keep backups somewhere other than `_mod_backups` in the game folder. Pass the same path to Restore. |
| `-ModName "Pure 2.5"` | Install | Name used for the backup folder. |
| `-IncludeAll` | Install | Also copy loose files that sit next to `content`, `extension` etc. (readmes are skipped by default). |
| `-Force` | both | Skip the Y/N prompt. |
| `-KeepAddedFiles` | Restore | Put the originals back but leave the new files. |

## Good to know

- **Updating a mod:** just install the new version. The backup then holds the old version's files, so a restore takes you back to it.
- **Restore newest first.** If two installs touched the same files, undo the later one first. The restore script warns you when that's the case.
- **Access denied:** right-click PowerShell and choose Run as administrator.
- **Steam's "Verify integrity of game files"** restores Kunos files but won't remove mod files, so these backups are still the cleanest way to undo a mod.
- Mods installed before you started using this script have no backup, so the restore script can't undo them.
- The scripts only write inside the AC folder. If a readme also asks you to copy files into `Documents\Assetto Corsa\cfg`, do that part by hand.
