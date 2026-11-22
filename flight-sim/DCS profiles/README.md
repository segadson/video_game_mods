# DCS profiles

DCS World control profiles (`.diff.lua`) and an IL-2 Great Battles layout for a MOZA AB6 stick (MHG grip) and a MOZA MTQ throttle, plus a PowerShell script that installs them.

## What `DCS-Profiles.ps1` does

The script has three jobs. By default it runs all three.

1. **Collect** (`-Collect`): copies the joystick command lists (`default.lua`) for the F-16C, the F-14B pilot seat and the F/A-18C out of your DCS install. It zips them to your Desktop as `DCS default.lua <date>.zip`. New profiles are built from these lists.
2. **Import** (`-Import`): copies every AB6 and MTQ `.diff.lua` in this folder into `Saved Games\DCS\Config\Input\<aircraft>\joystick`. Each file is renamed to the exact device name and GUID that DCS uses on your PC, for example `MOZA AB6 ... {GUID}.diff.lua`. Any file it replaces is backed up first as `.bak-<date>`.
3. **IL-2** (`-IL2`): merges `IL-2\MOZA AB6 + MTQ (WWII fighters).actions` into IL-2's `data\input\global.actions`. See [IL-2 Great Battles](#il-2-great-battles) below.

## Folder layout

Each subfolder is named exactly like the aircraft folder DCS uses under `Saved Games\DCS\Config\Input\`:

```
DCS profiles/
├── DCS-Profiles.ps1
├── README.md
└── FA-18C_hornet/
    ├── MOZA AB6 + MHG (Hornet stick).diff.lua
    ├── MOZA MTQ Throttle Panel {GUID}.diff.lua
    └── T.16000M (Hornet stick).diff.lua      (ignored by the script)
└── IL-2/
    └── MOZA AB6 + MTQ (WWII fighters).actions
```

The script picks a device by matching text in the file name:

| File name contains | Installed as the device whose DCS file name matches |
| --- | --- |
| `AB6` | `*AB6*` |
| `MTQ` | `*MTQ*` |

Other files, such as the old T.16000M profile, are skipped. To add another device, add a line to `$DeviceRules` at the top of the script.

To add a new aircraft, create a folder with its DCS input folder name and put the profiles in it. Common names are `FA-18C_hornet`, `F-16C_50` and `F-14B`. To check a name, look in `Saved Games\DCS\Config\Input\` after binding something in that jet.

## Before the first import

DCS only creates a device's file, with its GUID, after you bind something on that device.

1. Start DCS, open Options > Controls and pick the aircraft (for example F/A-18C).
2. Bind any one AB6 button, and one MTQ button if you haven't before. Press OK.
3. Quit DCS.

## How to run

DCS must be closed. If it's running, it overwrites the files when it exits.

Right-click `DCS-Profiles.ps1` and choose **Run with PowerShell**. Or, from a PowerShell window in this folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\DCS-Profiles.ps1            # collect + import + IL-2
powershell -ExecutionPolicy Bypass -File .\DCS-Profiles.ps1 -Collect   # only zip the default.lua files
powershell -ExecutionPolicy Bypass -File .\DCS-Profiles.ps1 -Import    # only install DCS profiles
powershell -ExecutionPolicy Bypass -File .\DCS-Profiles.ps1 -IL2       # only install the IL-2 layout
```

Then start DCS and check Options > Controls for that aircraft.

### Options

| Option | Use it when |
| --- | --- |
| `-DcsInstall "D:\DCS World"` | The script can't find your DCS install. Point it at the folder that holds `bin\` and `Mods\`. |
| `-SavedGames "D:\Saved Games\DCS"` | Your Saved Games folder is somewhere unusual. Point it at the folder that holds `Config\`. |
| `-ProfilesFolder "C:\path\to\DCS profiles"` | You run the script from somewhere other than this folder. |
| `-Il2Install "D:\IL-2 Sturmovik Great Battles"` | The script can't find IL-2. Point it at the folder that holds `bin\` and `data\`. |
| `-Il2StickId 3 -Il2ThrottleId 1` | The script can't tell which IL-2 device is the AB6 or the MTQ. Use the `joy` numbers it prints from `devices.txt`. |

### Where it looks automatically

- **DCS install:** the Eagle Dynamics registry keys (release and OpenBeta), Steam libraries (`steamapps\common\DCSWorld`), and `Program Files\Eagle Dynamics\DCS World[ OpenBeta]`, `\DCS World` and `\Eagle Dynamics\...` on drives C to F.
- **Saved Games:** your Windows Saved Games folder, even if it was moved, under both `DCS` and `DCS.openbeta`. Profiles are installed into every one it finds.
- **IL-2:** installed-programs entries named `IL-2 Sturmovik*`, Steam libraries (`steamapps\common\IL-2 Sturmovik Battle of Stalingrad`), and `Program Files\IL-2 Sturmovik Great Battles`, `Program Files (x86)\1C Game Studios\...`, `\IL-2 Sturmovik Great Battles` and `\Games\...` on drives C to F.

## IL-2 Great Battles

IL-2 doesn't use one file per device like DCS. All bindings for every device live in one file, `data\input\global.actions` (older versions used `current.actions`). Each row names a device by number, for example `gear_up, joy1_b29, 0|`. The numbers come from `data\input\devices.txt`, which the game writes and which ties each number to the device's GUID. So no GUID needs typing in. The script reads `devices.txt`, works out which number is the AB6 and which is the MTQ, and fills them in.

What the script changes:

- Every existing row bound to the AB6 or the MTQ is removed. Keyboard, mouse, the MRP pedals and any other device keep their bindings.
- The rows from `IL-2\*.actions` are added, with the real joystick numbers.
- `devices.txt`, `current.map`, `current.responses` and per-aircraft presets in `data\input\custom\` are not touched.
- The old `global.actions` is copied to `data\input-backups\global.actions.bak-<date>` first.

Running it twice gives the same result, so it's safe to run again after changing the layout.

### Before the first IL-2 run

1. Plug in the AB6 and MTQ and start MOZA Cockpit. Set the AB6 mini-stick to hat (POV) mode and the MTQ Flaps lever to button mode, the same as for DCS.
2. Start IL-2, open **Settings > Key mapping**, then quit. This makes the game list the devices in `devices.txt` and create `global.actions`.
3. Close IL-2 and run the script.
4. In IL-2, open **Settings > Key mapping** and check the AB6 and MTQ rows. Bind the MRP pedals here too if you haven't (Rudder, Left / Right wheel brake).

The script prints the devices it found, for example `joy2  MOZA MTQ Throttle Panel`. It picks the device whose name contains `MTQ` for the throttle and the one containing `AB6` (or the only other `MOZA` device that isn't pedals) for the stick. If it guesses wrong or finds none, run it again with `-Il2StickId` and `-Il2ThrottleId`.

### Check these in-game the first time

- **Throttle and prop pitch levers** are bound as `axis_w` (RX) and `axis_s` (RY), inverted like the DCS profile. If a lever doesn't move or moves backwards, rebind it in Key mapping (or flip **Invert**).
- **Flaps:** lever position 40 is bound to flaps up and 36 to flaps down, and IL-2 moves the flaps while the button is held. If the flaps move only a little per lever move, MOZA is sending a short pulse. Raise **Signal Hold Time** in MOZA Cockpit, or use the lever in steps.
- **Gunsight range (MTQ 11 / 12)**: if the direction is backwards, swap the two button numbers in that row.
- **Trim hat**: the AB6 mini-stick must be in hat mode. If IL-2 doesn't see a POV, 22 / 23 still trim pitch.

### If IL-2 renumbers the devices

IL-2 can change the numbers when a USB device is added or moved, and then every binding points at the wrong device. Either put the old numbers back as the first column of `devices.txt` (change only that number), or run the script again so it uses the new numbers.

## Undo

DCS: delete the new `.diff.lua` in `Saved Games\DCS\Config\Input\<aircraft>\joystick`, then remove the `.bak-<date>` ending from the backup.

IL-2: copy `data\input-backups\global.actions.bak-<date>` back to `data\input\global.actions` and remove the `.bak-<date>` ending.

## Troubleshooting

| Message or problem | Fix |
| --- | --- |
| "running scripts is disabled on this system" | Use the `powershell -ExecutionPolicy Bypass -File ...` command above. It only affects this one run. |
| "Couldn't find DCS" | Run with `-DcsInstall "<your DCS folder>"`. |
| "Couldn't find Saved Games\DCS" | Start DCS once so it creates the folder, or run with `-SavedGames`. |
| "No AB6 device file ... yet" | Do the "Before the first import" steps, then run again. |
| "More than one AB6 device name found" | DCS has old device files, for example after a USB port or firmware change. In `Config\Input\*\joystick`, delete the stale `*AB6*` files (check which GUID DCS shows today), then run again. |
| "DCS is running" | Close DCS completely, including the launcher, and run again. |
| "IL-2 is running" | Close IL-2 and run again. |
| "Couldn't find IL-2" | Run with `-Il2Install "<your IL-2 folder>"`. |
| "No devices.txt yet" or "No global.actions" | Do the "Before the first IL-2 run" steps. |
| "AB6 stick: not found" or "more than one match" | Run with `-Il2StickId` / `-Il2ThrottleId` and the numbers from the device list it printed. |
| IL-2 bindings land on the wrong device | IL-2 renumbered the devices. Run the script again. |
| Bindings don't appear in DCS | Check that the aircraft folder name matches the one in `Saved Games\DCS\Config\Input\`, and that you looked at the right device column. |
| Buttons do the wrong thing | Check the numbers in MOZA Cockpit's input test. Hats must be set to discrete buttons, and the mini-stick to hat mode for trim. |

## Notes

- The script hasn't been run on Windows yet, so read the output of the first run. The IL-2 merge was tested against a real `global.actions` from another setup, not yours.
- Windows PowerShell 5.1 (built into Windows 10 and 11) and PowerShell 7 both work.
- The `default.lua` files belong to Eagle Dynamics and the module makers. Don't commit them to a public repo.
