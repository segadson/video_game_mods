# MSFS 2024 VR game plan

Setup: RTX 5080 (16 GB), Pimax Crystal Super, MSFS 2024 (Steam), MOZA AB6 + MTQ.
Written Nov 21, 2026 from Pimax's MSFS 2024 guide and the MSFS forums (sources at the bottom).

## First, about that "GPU" message

The message MSFS 2024 shows is **"Resource usage exceeds GPU memory capacity, lower graphics settings for better performance."** It is a **warning about video memory (VRAM), not a blocking error.** Players report the sim keeps running after it. It fires most at load time, when memory use peaks. On a 16 GB card in VR, high Textures plus a high headset resolution is the usual cause.

So if the sim truly would not go into VR, the warning is probably a symptom, not the cause. The usual real causes are the wrong OpenXR runtime, OpenXR Toolkit or another overlay, or launching in the wrong order. The steps below cover all three.

## Part 1: Get it into VR (about 30 minutes)

Do these in order. Stop as soon as it works and go to Part 2.

1. **Update first.** Update Pimax Play, the NVIDIA driver and MSFS 2024 (let Steam finish any update). Restart the PC.
2. **Close extras.** Quit SteamVR, MSI Afterburner/RivaTuner, ReShade, Discord overlay, and anything that draws on screen.
3. **Turn off OpenXR Toolkit** if it's installed (open its Companion app and disable it, or uninstall it). It's a known cause of MSFS 2024 failing to load in VR, and MSFS 2024 doesn't need it.
4. **Pimax Play, general settings:**
   - OpenXR runtime: **Pimax OpenXR** (set it as the active/default runtime). The Steam copy of MSFS does not need SteamVR.
   - Refresh rate: **72 Hz** to start (easiest to hold steady). Move to 90 Hz later once things are smooth. Pimax's own guide uses 90 Hz.
   - Render quality: **70%** to start.
   - Eye tracking: **On**, and run the calibration.
   - Smart Smoothing / motion reprojection: **Off** to start (Pimax's MSFS guide says to disable it).
5. **Pimax Play, per-game settings for Microsoft Flight Simulator 2024:**
   - Enable per-program settings.
   - Priority/Foveated rendering: **OpenXR Quad Views** (this is the eye-tracked foveated rendering MSFS 2024 supports natively).
6. **Launch in this order:** headset on and showing the Pimax home, then start MSFS 2024 from Steam **on the monitor (2D)**.
7. **Set the VR graphics before going into VR:** Settings > Graphics > **VR** tab, use the table in Part 2.
8. **Load a simple flight in 2D:** Free Flight, Cessna 172, a small airport, clear skies, no add-ons.
9. **Switch to VR:** press **Ctrl+Tab** (the default "Toggle VR mode" binding), then put the headset on.

### If it still won't go into VR

Try one at a time, retesting after each:

- **Lower settings further:** Textures Medium, render quality 60%, DLSS Performance. If it loads now, it was memory.
- **Empty the Community folder** (move its contents somewhere else) and test again. Add-ons are a common cause.
- **Check the runtime again:** if SteamVR opens when you press Ctrl+Tab, Pimax isn't the active OpenXR runtime. Set it again in Pimax Play and restart MSFS.
- **Cable:** headset DisplayPort straight into the 5080, no adapter, with Pimax's cable.
- **Remove overclocks:** GPU overclock off. As a test, turn EXPO off in the BIOS too.
- **Resizable BAR (advanced, optional):** several players found ReBAR uses about 1 GB more VRAM in MSFS 2024. Turning it off in the BIOS freed memory for some, but others saw more scenery pop-in. Try it only if the memory warning keeps coming back.
- **Repair:** Steam > MSFS 2024 > Properties > Installed Files > **Verify integrity**. Don't reinstall yet.
- **Find the crash:** if MSFS closes, open Windows **Reliability Monitor** and read the error for the failing program (it names the module, such as an overlay's DLL).

## Part 2: Starting settings

### NVIDIA App (or Control Panel)

| Setting | Value |
| --- | --- |
| DLSS override, Super Resolution | Latest model, **Preset K** |
| Power management mode | Prefer maximum performance |
| Image sharpening | About 20% (optional) |

### MSFS 2024 > Settings > Graphics > VR tab

These start a notch below Pimax's RTX 4080 settings, so the first session loads cleanly. Raise them later.

| Setting | Start here | Later (Pimax 4080-class) |
| --- | --- | --- |
| Anti-aliasing | DLSS Super Resolution, **Balanced** | DLAA |
| Frame generation | **Off** | Off |
| Foveated rendering | **On** | On |
| Terrain LOD | 100 | 150-200 |
| Objects LOD | 60 | 80 |
| Texture resolution | **Medium** | Medium (High only if no memory warning) |
| Anisotropic filtering | 16x | 16x |
| Volumetric clouds | Medium | Medium |
| Shadow maps | 1024 | 4096 |
| Terrain shadows | 512 | 1024 |
| Contact shadows | Low | High |
| Ambient occlusion | Medium | High-Medium |
| Raymarched reflections | Off | High-Medium |
| Cubemap reflections | 256 | 384 |
| Buildings / Trees | Medium | Medium |
| Grass | Low | Medium-Low |
| Plants / Rocks / Fauna | Low | Low |
| Windshield effects | Medium | High |
| Glass cockpit refresh | High | High |
| Air traffic / Characters / Airport quality | Medium | Medium |
| Road and sea traffic | Low | Low |
| World scale | 100 | 100 |

**How to tune:** aim for a steady frame rate first. Raise one thing at a time, in this order: render quality (to 75%), Terrain LOD, clouds, shadows, then refresh rate to 90 Hz. If the memory warning appears, lower Textures first.

### Corrections to the earlier advice

- **Textures:** start at Medium, not High. Pimax's guide uses Medium for this class of card, and Textures are the main cause of the memory warning.
- **Foveated rendering:** use Pimax Play's "OpenXR Quad Views" with eye tracking on, plus MSFS's own Foveated rendering setting. You don't need OpenXR Toolkit or other add-ons.
- **Smart Smoothing:** start off. The guides disagree on it, and Pimax's MSFS guide disables it.
- **DLSS:** Balanced to start (Performance if needed), with Preset K. Pimax's guide pairs a lower render quality with DLAA, so try that once you're stable.
- **Refresh rate and render quality:** 72 Hz and 70% are fine starting points. Pimax's guide uses 90 Hz and 75% for 4080-class cards, so you can work up to that.

## Part 3: Controls

- Your MSFS 2024 key maps are in `MTQ key maps/MSFS 2024 …` (one per jet). Bind them in Settings > Controls Options, one profile per aircraft.
- For the Cessna, bind at least: pitch/roll on the AB6, throttle on an MTQ lever, mixture on a second lever, flaps up/down, brakes, **Toggle VR mode** and **Reset VR view (recenter)**.
- No rudder pedals: leave **Assisted rudder** on in the assistance settings.

## Part 4: Learning path (coming from DCS)

You already know stick-and-rudder and jets. The new skills here are civilian procedures, ATC, navigation and weather, so start small.

1. **Discovery Flight (10 min):** Activities > Discovery Flights. You start in the air somewhere scenic. Use this as your VR check: comfort, recenter, and whether the frame rate holds.
2. **Flight Training (Cessna 152):** Jess, the instructor, teaches taxi, takeoff, turns, navigation and landing. Do these in order. It's on the main menu or under Activities, depending on version.
3. **Free Flight practice (Cessna 172):** start on the runway at a long, sea-level airport with clear skies. Fly circuits (traffic patterns): takeoff, downwind, base, final, landing. Rough speeds: rotate 55 kt, climb 75 kt, final 60-65 kt.
4. **Career mode:** main menu > Career. Pick a small home airfield, fly the intro flight with the mentor, then earn your **Private Pilot License (PPL)**. After that, CPL, instrument rating and other ratings open up, each with paid training and an exam.
5. **Then the fun stuff:** the default F/A-18E Super Hornet in Free Flight, with your MTQ map. Do a carrier trap once the circuits feel easy.

**Assistance settings while learning:**
- **Keep on:** checklist assistance, taxi guidance, instrument labels, stall warning, landing-path guidance, and assisted rudder (until you have pedals).
- **Turn off:** AI piloting, assisted takeoff, assisted landing (so you actually fly).
- **Add later:** live weather, turbulence, crosswinds, failures.
- Since Sim Update 6 you can also skip the walkaround in the assistance settings.

## Sources

- Pimax: [Crystal Super, the Ultimate MSFS 2024 Set up Guide](https://store.pimax.com/pages/pimax-crystal-super-the-ultimate-msfs-2024-set-up-guide)
- Pimax: [Best MSFS 2024 performance from your Crystal Super](https://store.pimax.com/blogs/highlights/how-to-get-the-best-performance-from-your-pimax-crystal-super)
- Pimax: [MSFS2024 VR setup and settings](https://store.pimax.com/blogs/blogs/msfs2024-virtual-reality-vr-setup-settings)
- MSFS forums: [Anybody rocking the Pimax Crystal Super with 2024?](https://forums.flightsimulator.com/t/anybody-rocking-the-pimax-crystal-super-with-2024/736328?page=4) and [Which OpenXR runtime for Pimax](https://forums.flightsimulator.com/t/which-openxr-runtime-for-pimax/736385)
- MSFS forums: [Resource usage exceeds GPU capacity message](https://forums.flightsimulator.com/t/resource-usage-exceeds-gpu-capacity-message/717064), [Option to remove the message](https://forums.flightsimulator.com/t/option-to-remove-resource-usage-exceeds-gpu-message/721686), [ReBAR and VRAM in MSFS 2024](https://forums.flightsimulator.com/t/rebar-causing-vram-overusage-and-decreases-available-vram-amount-in-msfs-2024/714047?page=11)
- Fly Away Simulation: [Fix MSFS crashing when switching to VR](https://flyawaysimulation.com/ask/answers/fix-msfs-crashing-switching-vr/), [Reduce VRAM use in MSFS 2024](https://flyawaysimulation.com/ask/answers/reduce-vram-usage-msfs-2024/), [Fly MSFS 2024 as a beginner](https://flyawaysimulation.com/ask/answers/fly-msfs-2024-beginner/)
- AVSIM: [MSFS will not load (OpenXR Toolkit)](https://www.avsim.com/forums/topic/646474-help-msfs-will-not-load-solved-unbelievable-reason/)
- Microsoft: [What should I do first in MSFS](https://www.flightsimulator.com/guide/what-should-i-do-first-in-microsoft-flight-simulator/); MSFS Addons: [Career mode FAQ](https://msfsaddons.com/msfs-2024-faq/career-mode/)
