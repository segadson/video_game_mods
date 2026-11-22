# Flight Sim Bindings

Nov 6, 2026 · @Someone

## Hardware and setup

In VR the keyboard is out of reach, so every control you need in flight goes on the HOTAS.

| Device | Role |
| --- | --- |
| Pimax Crystal Super | VR headset (eye tracking) |
| Moza AB6 base + MHG grip | Stick (force feedback) |
| Moza MTQ | Throttle quadrant: 4 levers, button panel, two grips |
| Moza MRP | Rudder pedals + toe brakes |

- **Duplicate axes:** DCS auto-assigns axes to every device. Clear duplicate pitch, roll and throttle bindings in each device column.
- **Curves:** set them in Moza Cockpit or in DCS, not both.
- **VR performance:** use the multithreaded DCS build with the Pimax OpenXR runtime and Quad Views foveated rendering.
- **Pedals:** small deadzone on the toe-brake axes.
- **Verify numbers:** press a control in Moza Cockpit to confirm its number lights up where this doc says.

## F/A-18C Hornet

The layout follows the real Hornet HOTAS, with carrier, comms and start-up controls on the MTQ panel.

### Stick

| Control | Function |
| --- | --- |
| Trigger | Gun / missile fire |
| Top red button | Weapon release (pickle) |
| Hat 1 | Trim |
| Hat 2 | Sensor Control Switch (SCS) |
| Hat 3 | Weapon select: fwd AIM-7, right AIM-9, aft AIM-120, press gun |
| Pinky button | Undesignate / NWS |
| Paddle | Autopilot disengage |

### MTQ

| MTQ # | Function | Group |
| --- | --- | --- |
| RX / RY axes | Left / right throttle | Levers |
| 32 / 34 | Left / right finger lift (OFF to IDLE) | Levers |
| 31 / 43 (Dial lever) | Speedbrake extend / retract | Levers |
| 40 / 38 / 36 | Flaps AUTO / HALF / FULL (set Flaps to button mode) | Levers |
| 62 mini-stick | TDC slew; push = designate | Left grip |
| 63 | RAID / FLIR FOV | Left grip |
| 64 | Cage / Uncage | Left grip |
| 65 | ATC (auto-throttle) | Left grip |
| 56 / 55 | COMM1 / COMM2 (SRS PTT) | Right grip |
| 54 / 53 | A/A / A/G master mode | Right grip |
| 52 | Exterior lights master | Right grip |
| 61 / 60 | Dispense switch FWD (chaff) / AFT (flare) | Right grip |
| 59 / 58 / 57 | VR zoom / active pause / VR recenter | Right grip |
| 50 / 51 | Radar antenna elevation up / down | Right grip |
| 11 / 12 / 13 | COMM1 channel down / up / pull | Panel |
| 14 / 15 / 16 | COMM2 channel down / up / pull | Panel |
| 23 / 22 / 24 | Engine crank LEFT / OFF / RIGHT | Panel |
| 5 | APU on | Panel |
| 6 | Canopy | Panel |
| 8 | Master caution reset | Panel |
| 17 / 18 / 19 / 20 | Radar OFF / STBY / OPR / EMERG | Panel |
| 30 / 29 | Landing gear UP / DOWN | Panel |
| 1 | Launch bar | Panel |
| 2 | Arresting hook | Panel |
| 3 | Wing fold | Panel |
| 4 | Anti-skid | Panel |
| 7 | Parking brake | Panel |
| 9 / 10 | Catapult hook-up / launch | Panel |
| 25 / 26 | Master Arm ARM / SAFE | Panel |
| 27 / 28 | Landing / taxi light ON / OFF | Panel |

Spare: 21, 33, 35, 41, 42, 49.

## F-14 Tomcat (pilot)

The pilot seat has no radar or TDC, since Jester runs those. The layout adds wing sweep, DLC and Jester controls instead.

### Stick

| Control | Function |
| --- | --- |
| Trigger | Gun / fire |
| Bomb button | Weapon release |
| Hat 1 | Trim |
| Hat 2 | Weapon select: SP / PH / SW / GUN |
| Button | DLC engage |
| Button | AP reference / NWS |
| Paddle | AP emergency disengage |

### MTQ

| MTQ # | Function | Group |
| --- | --- | --- |
| RX / RY axes | Left / right throttle | Levers |
| 32 / 34 | Throttle OFF / IDLE | Levers |
| 31 / 43 (Dial lever) | Speedbrake extend / retract | Levers |
| 40 / 36 | Flaps UP / DOWN | Levers |
| 62 push | Jester menu | Left grip |
| 63 | Cage / Seam | Left grip |
| 64 | Exterior lights master | Left grip |
| 65 | APC (approach power compensator) | Left grip |
| 56 / 55 | UHF (ARC-159) / V/UHF (ARC-182) mic | Right grip |
| 54 / 53 | Wing sweep forward / aft | Right grip |
| 52 | Wing sweep AUTO | Right grip |
| 57 to 61 | Jester menu navigation; 57 push = select | Right grip |
| 50 / 51 | DLC thumbwheel up / down | Right grip |
| 11 / 12 / 13 | ARC-159 channel down / up / select | Panel |
| 14 / 15 / 16 | ARC-182 channel down / up / select | Panel |
| 23 / 22 / 24 | Engine crank LEFT / OFF / RIGHT | Panel |
| 5 | Ground power / air request (no APU) | Panel |
| 6 | Canopy | Panel |
| 8 | Master caution reset | Panel |
| 29 / 30 | Landing gear UP / DOWN | Panel |
| 1 | Launch bar | Panel |
| 2 | Hook | Panel |
| 4 | Anti-skid | Panel |
| 7 | Parking brake | Panel |
| 9 / 10 | Catapult hook-up / launch | Panel |
| 25 / 26 | Master Arm | Panel |
| 27 / 28 | Landing / taxi light | Panel |

## F-16C Viper

Single engine, so only the left throttle (RX) is bound. Same panel positions as the other jets for comms, gear, Master Arm, lights and engine start.

### MTQ

| MTQ # | Function | Group |
| --- | --- | --- |
| RX | Throttle (axis). Bind RX only | Throttle levers (RX / RY) |
| 32 | Idle detent / cutoff release | Throttle levers (RX / RY) |
| RY, 34 | Spare (single engine) | Throttle levers (RX / RY) |
| 33 / 35, 41 / 42 | Detent signals, leave unbound | Throttle levers (RX / RY) |
| 31 | Speedbrake OPEN | Speedbrake lever (Dial) |
| 43 | Speedbrake CLOSE | Speedbrake lever (Dial) |
| Slider, 36-40 | Spare (no flap lever in the Viper) | Flap lever (Slider) |
| Mini X / Y | Radar cursor slew (axes) | Left grip + mini-stick |
| 62 push | Cursor enable | Left grip + mini-stick |
| 63 | Dogfight: DOGFIGHT | Left grip + mini-stick |
| 64 | Dogfight: MISSILE OVERRIDE | Left grip + mini-stick |
| 65 | Dogfight: CENTER | Left grip + mini-stick |
| 56 / 55 | Transmit UHF / VHF (SRS PTT) | Right grip: thumb hat 52 |
| 54 / 53 | IFF OUT / IFF IN | Right grip: thumb hat 52 |
| 52 push | Uncage (MAN RNG knob push) | Right grip: thumb hat 52 |
| 61 / 60 | DMS up / down | Right grip: side hat 57 |
| 59 / 58 | DMS left / right | Right grip: side hat 57 |
| 57 push | VR recenter | Right grip: side hat 57 |
| 50 / 51 | Antenna elevation up / down | Right grip: rocker 50 / 51 |
| 49 | Centre position, leave unbound | Right grip: rocker 50 / 51 |
| 1 | Air refuel door | Panel buttons A1-A4 |
| 2 | Hook | Panel buttons A1-A4 |
| 3 | Laser arm | Panel buttons A1-A4 |
| 4 | Parking brake (anti-skid switch) | Panel buttons A1-A4 |
| 5 | Main power BATT / MAIN | Panel buttons 5-10 |
| 6 | Canopy | Panel buttons 5-10 |
| 7 | Autopilot pitch ALT HOLD | Panel buttons 5-10 |
| 8 | Master caution reset | Panel buttons 5-10 |
| 9 / 10 | Fault ack (F-ACK) / VR zoom | Panel buttons 5-10 |
| 11 / 12 | UHF channel down / up | Encoders 11-16 |
| 13 | ICP COM 1 | Encoders 11-16 |
| 14 / 15 | HSI course left / right | Encoders 11-16 |
| 16 | ICP COM 2 | Encoders 11-16 |
| 17 / 18 | CMDS mode OFF / STBY | 5-position rotary 17-21 |
| 19 / 20 | CMDS mode MAN / SEMI | 5-position rotary 17-21 |
| 21 | CMDS mode AUTO | 5-position rotary 17-21 |
| 23 / 22 / 24 | JFS START 1 / OFF / START 2 | 3-way switch 23 / 22 / 24 |
| 25 / 26 | Master Arm ARM / OFF | Toggles 25-30 |
| 27 / 28 | Landing-taxi light ON / OFF | Toggles 25-30 |
| 29 / 30 | Landing gear UP / DOWN | Toggles 25-30 |

## Thrustmaster T.16000M (retired, kept for reference)

Replaced by the MOZA AB6 on Nov 20 2026 (see the AB6 section). The T.16000M has one hat, so the second and third stick hats of each jet move to base buttons. Base 5-10 are the left base cluster, 11-16 the right.

### F/A-18C Hornet

| T.16000M | Function |
| --- | --- |
| Trigger (1) | Gun / missile fire |
| Button 2 | Weapon release (pickle) |
| Button 3 | Undesignate / NWS |
| Button 4 | Autopilot disengage (paddle) |
| Hat | Sensor Control Switch (SCS) |
| Base 5 / 6 / 7 / 8 | Select AIM-7 / AIM-9 / AIM-120 / Gun |
| Base 11-14 | Trim (takeoff only, the FCS auto-trims) |

### F-16C Viper

| T.16000M | Function |
| --- | --- |
| Trigger (1) | Gun |
| Button 2 | Weapon release (pickle) |
| Button 3 | NWS / A/R disconnect / missile step |
| Button 4 | CMS forward (dispense program) |
| Hat | TMS up / down / left / right |
| Base 5 / 6 / 7 | CMS aft (consent) / left / right |
| Base 8 | Autopilot disconnect (paddle) |
| Base 11-14 | Trim |

### F-14B Tomcat (pilot seat)

| T.16000M | Function |
| --- | --- |
| Trigger (1) | Gun / fire |
| Button 2 | Bomb / weapon release |
| Button 3 | DLC engage |
| Button 4 | AP reference / NWS |
| Hat | Trim |
| Base 5 / 6 / 7 / 8 | Weapon select SP / PH / SW / GUN |
| Base 9 | AP emergency disengage (paddle) |

If you fly with pedals, unbind the T.16000M twist axis from rudder in each aircraft.

**F6 / F8 from the stick (all jets):** base buttons **15 = F6** and **16 = F8**. DCS can't bind keyboard keys to a joystick button, so make two VoiceAttack commands: New Command → no spoken phrase needed, tick "When this joystick button is pressed" and pick the T.16000M button → action "Press a key" → F6 (or F8). VoiceAttack must be running while you fly.

Stick pictures: `MTQ key maps/… T16000M stick map.png`. Hornet stick profile: `DCS profiles/FA-18C_hornet/T.16000M (Hornet stick).diff.lua`.

Key map pictures: `MTQ key maps/` (one PNG per jet, plus a printable PDF).

## MOZA AB6 base + MHG grip (stick, replaces the T.16000M)

Numbers are the MOZA Cockpit button numbers (checked from your MOZA Cockpit screenshots, Nov 20 2026). The MHG is an F-16-style grip.

**Grip:** 1 = trigger first detent, 6 = trigger full pull (check in the input test; swap if 6 lights first). 2 = red button top left. 4 = button on the left side of the head. 3 = lower front of the grip (paddle position). 5 = button lower right of the head. 7-11 = 5-way left of the head (7 up, 8 right, 9 down, 10 left, 11 push). 12-16 = 5-way top right (12 up, 13 right, 14 down, 15 left, 16 push). 17-21 = 5-way on the thumb side below the head (17 up, 18 right, 19 down, 20 left, 21 push). 22 / 24 / 23 = 3-way on the left side of the head (22 up, 24 centre push, 23 down). Mini-stick = RX / RY axes. Twist = RZ.
**Base:** 49-52 left column top to bottom, 53-56 right column. Slider 57-59 and Dial 60-62 when set to button mode.

**Setup:** in MOZA Cockpit set the mini-stick to hat (POV) mode, which becomes the trim hat. If it won't, 22 / 23 still trim pitch. Unbind (or screw-lock) the twist axis, since the MRP pedals do rudder.

| AB6 / MHG # | F/A-18C | F-16C | F-14B (pilot) |
| --- | --- | --- | --- |
| 6 (full pull) | Gun / missile fire | Gun | Gun / fire |
| 1 (first detent) | Spare | Camera / laser (first detent) | Spare |
| 2 | Weapon release (pickle) | Weapon release (pickle) | Bomb / weapon release |
| Mini-stick (hat mode) | Trim | Trim | Trim |
| 22 / 23 | Trim nose down / up (backup) | Trim nose down / up (backup) | Trim nose down / up (backup) |
| 12 / 13 / 14 / 15 | AIM-7 / AIM-9 / AIM-120 / spare | TMS up / right / down / left | Weapon select SP / SW / PH / spare |
| 16 | Select Gun | Spare | Weapon select GUN |
| 7 / 8 / 9 / 10 | SCS fwd / right / aft / left | DMS up / right / down / left | Spare |
| 17 / 18 / 19 / 20 | Spare | CMS fwd / right / aft / left | 17 chaff, 19 flare, rest spare |
| 4 | Undesignate / NWS | NWS / A/R disconnect / MSL step | AP reference / NWS |
| 3 | Autopilot disengage (paddle) | Autopilot disconnect (paddle) | AP emergency disengage (paddle) |
| 5 | Spare | Expand / FOV (pinky) | DLC engage |
| 11, 21, 24 | Spare | Spare | Spare |
| 49 / 50 | F6 / F8 (VoiceAttack) | F6 / F8 (VoiceAttack) | F6 / F8 (VoiceAttack) |
| 51-56, sliders | Spare | Spare | Spare |
| RZ twist | Unbound | Unbound | Unbound |

**F6 / F8:** same VoiceAttack setup as before (see the T.16000M section), but pick AB6 buttons 49 and 50.

Stick pictures: `AB6 stick maps/` (one PNG per jet, plus a printable PDF). Hornet stick profile: `DCS profiles/FA-18C_hornet/MOZA AB6 + MHG (Hornet stick).diff.lua` (load it on the AB6 column; it also removes the twist from rudder). F-16 and F-14 profiles need their `joystick\default.lua` command lists, so bind those by hand from the maps for now.

**Import script:** `DCS profiles/DCS-Profiles.ps1` (Windows PowerShell, DCS closed). It zips the F-16C / F-14B / F/A-18C `default.lua` files to your Desktop for upload, then copies every AB6 / MTQ `.diff.lua` from the `DCS profiles\<aircraft>\` folders into `Saved Games\DCS\Config\Input\<aircraft>\joystick`, renamed to your device's name + GUID, backing up anything it replaces. Bind one AB6 button in DCS first so the device file exists.

## MSFS 2024

MSFS has no weapons, radar or countermeasures, so these maps put flying, carrier and view controls on the MTQ instead. Button positions match the DCS maps where the function exists in both (gear, hook, Master/battery, lights, catapult, VR recenter, speedbrake, flaps). Command names are close to the MSFS 2024 Controls Options wording; search a key word and save one profile per aircraft. Add-on specific controls (F-14 wing sweep) may need the add-on's own binding method; check its manual.

### F/A-18E Super Hornet (default jet)

| MTQ # | Function | Group |
| --- | --- | --- |
| RX / RY | Throttle 1 / Throttle 2 axis | Throttle levers (RX / RY) |
| 32 / 34 | Spare (use cockpit or autostart for cutoff) | Throttle levers (RX / RY) |
| 33 / 35, 41 / 42 | Detent signals, leave unbound | Throttle levers (RX / RY) |
| 31 | Spoilers ON (speedbrake out) | Speedbrake lever (Dial) |
| 43 | Spoilers OFF (speedbrake in) | Speedbrake lever (Dial) |
| 40 | Flaps up (AUTO) | Flap lever (Slider) |
| 38 | Flaps 1 (HALF) | Flap lever (Slider) |
| 36 | Flaps down (FULL) | Flap lever (Slider) |
| 39 / 37 | Spare | Flap lever (Slider) |
| Mini X / Y | Cockpit look axes (monitor). Spare in VR | Left grip + mini-stick |
| 62 push | Reset cockpit view | Left grip + mini-stick |
| 63 | Autopilot master on / off | Left grip + mini-stick |
| 64 | Toggle nav lights | Left grip + mini-stick |
| 65 | Autothrottle arm | Left grip + mini-stick |
| 56 | ATC / VATSIM push-to-talk | Right grip: thumb hat 52 |
| 55 | ATC window | Right grip: thumb hat 52 |
| 54 / 53 | Cockpit view previous / next | Right grip: thumb hat 52 |
| 52 push | Toggle strobe lights | Right grip: thumb hat 52 |
| 61 | Active pause | Right grip: side hat 57 |
| 60 | Pause | Right grip: side hat 57 |
| 59 / 58 | Zoom in / out | Right grip: side hat 57 |
| 57 push | VR recenter (reset VR view) | Right grip: side hat 57 |
| 50 / 51 | Autopilot altitude bug up / down | Right grip: rocker 50 / 51 |
| 49 | Centre position, leave unbound | Right grip: rocker 50 / 51 |
| 1 | Spare | Panel buttons A1-A4 |
| 2 | Toggle tail hook | Panel buttons A1-A4 |
| 3 | Toggle wing fold | Panel buttons A1-A4 |
| 4 | Spare | Panel buttons A1-A4 |
| 5 | APU starter | Panel buttons 5-10 |
| 6 | Canopy (toggle aircraft exit) | Panel buttons 5-10 |
| 7 | Parking brake | Panel buttons 5-10 |
| 8 | Master caution acknowledge | Panel buttons 5-10 |
| 9 / 10 | Catapult: takeoff assist arm / fire | Panel buttons 5-10 |
| 11 / 12 | COM1 MHz down / up | Encoders 11-16 |
| 13 | COM1 standby swap | Encoders 11-16 |
| 14 / 15 | COM1 kHz down / up | Encoders 11-16 |
| 16 | Transponder IDENT | Encoders 11-16 |
| 17 | Cockpit camera | 5-position rotary 17-21 |
| 18 | External camera | 5-position rotary 17-21 |
| 19 | Drone camera | 5-position rotary 17-21 |
| 20 / 21 | Spare | 5-position rotary 17-21 |
| 23 / 22 / 24 | Starter 1 / unbound / Starter 2 | 3-way switch 23 / 22 / 24 |
| 25 / 26 | Master battery ON / OFF | Toggles 25-30 |
| 27 / 28 | Landing lights ON / OFF | Toggles 25-30 |
| 29 / 30 | Landing gear UP / DOWN | Toggles 25-30 |

### F-16C/D Fighting Falcon (SC Designs add-on)

| MTQ # | Function | Group |
| --- | --- | --- |
| RX | Throttle axis. Bind RX only | Throttle levers (RX / RY) |
| RY, 32 / 34 | Spare (single engine) | Throttle levers (RX / RY) |
| 33 / 35, 41 / 42 | Detent signals, leave unbound | Throttle levers (RX / RY) |
| 31 | Spoilers ON (speedbrake out) | Speedbrake lever (Dial) |
| 43 | Spoilers OFF (speedbrake in) | Speedbrake lever (Dial) |
| Slider, 36-40 | Spare (no flap lever in the Viper) | Flap lever (Slider) |
| Mini X / Y | Cockpit look axes (monitor). Spare in VR | Left grip + mini-stick |
| 62 push | Reset cockpit view | Left grip + mini-stick |
| 63 | Autopilot master on / off | Left grip + mini-stick |
| 64 | Toggle nav lights | Left grip + mini-stick |
| 65 | Spare (no autothrottle) | Left grip + mini-stick |
| 56 | ATC / VATSIM push-to-talk | Right grip: thumb hat 52 |
| 55 | ATC window | Right grip: thumb hat 52 |
| 54 / 53 | Cockpit view previous / next | Right grip: thumb hat 52 |
| 52 push | Toggle strobe lights | Right grip: thumb hat 52 |
| 61 | Active pause | Right grip: side hat 57 |
| 60 | Pause | Right grip: side hat 57 |
| 59 / 58 | Zoom in / out | Right grip: side hat 57 |
| 57 push | VR recenter (reset VR view) | Right grip: side hat 57 |
| 50 / 51 | Autopilot altitude bug up / down | Right grip: rocker 50 / 51 |
| 49 | Centre position, leave unbound | Right grip: rocker 50 / 51 |
| 1 | Spare | Panel buttons A1-A4 |
| 2 | Toggle tail hook | Panel buttons A1-A4 |
| 3 / 4 | Spare | Panel buttons A1-A4 |
| 5 | Spare (no APU, use JFS in cockpit) | Panel buttons 5-10 |
| 6 | Canopy (toggle aircraft exit) | Panel buttons 5-10 |
| 7 | Parking brake | Panel buttons 5-10 |
| 8 | Master caution acknowledge | Panel buttons 5-10 |
| 9 / 10 | Spare | Panel buttons 5-10 |
| 11 / 12 | COM1 MHz down / up | Encoders 11-16 |
| 13 | COM1 standby swap | Encoders 11-16 |
| 14 / 15 | COM1 kHz down / up | Encoders 11-16 |
| 16 | Transponder IDENT | Encoders 11-16 |
| 17 | Cockpit camera | 5-position rotary 17-21 |
| 18 | External camera | 5-position rotary 17-21 |
| 19 | Drone camera | 5-position rotary 17-21 |
| 20 / 21 | Spare | 5-position rotary 17-21 |
| 23 | Starter 1 | 3-way switch 23 / 22 / 24 |
| 22 / 24 | Spare | 3-way switch 23 / 22 / 24 |
| 25 / 26 | Master battery ON / OFF | Toggles 25-30 |
| 27 / 28 | Landing lights ON / OFF | Toggles 25-30 |
| 29 / 30 | Landing gear UP / DOWN | Toggles 25-30 |

### F-14 Tomcat (DC Designs or IndiaFoxtEcho add-on)

| MTQ # | Function | Group |
| --- | --- | --- |
| RX / RY | Throttle 1 / Throttle 2 axis | Throttle levers (RX / RY) |
| 32 / 34 | Spare (use cockpit or autostart for cutoff) | Throttle levers (RX / RY) |
| 33 / 35, 41 / 42 | Detent signals, leave unbound | Throttle levers (RX / RY) |
| 31 | Spoilers ON (speedbrake out) | Speedbrake lever (Dial) |
| 43 | Spoilers OFF (speedbrake in) | Speedbrake lever (Dial) |
| 40 | Flaps up | Flap lever (Slider) |
| 36 | Flaps down | Flap lever (Slider) |
| 39 / 38 / 37 | Spare | Flap lever (Slider) |
| Mini X / Y | Cockpit look axes (monitor). Spare in VR | Left grip + mini-stick |
| 62 push | Reset cockpit view | Left grip + mini-stick |
| 63 | Autopilot master on / off | Left grip + mini-stick |
| 64 | Toggle nav lights | Left grip + mini-stick |
| 65 | APC (autothrottle arm) | Left grip + mini-stick |
| 56 | ATC / VATSIM push-to-talk | Right grip: thumb hat 52 |
| 55 | ATC window | Right grip: thumb hat 52 |
| 54 / 53 | Wing sweep FORWARD / AFT (add-on binding) | Right grip: thumb hat 52 |
| 52 push | Wing sweep AUTO (add-on) | Right grip: thumb hat 52 |
| 61 | Active pause | Right grip: side hat 57 |
| 60 | Pause | Right grip: side hat 57 |
| 59 / 58 | Zoom in / out | Right grip: side hat 57 |
| 57 push | VR recenter (reset VR view) | Right grip: side hat 57 |
| 50 / 51 | Autopilot altitude bug up / down | Right grip: rocker 50 / 51 |
| 49 | Centre position, leave unbound | Right grip: rocker 50 / 51 |
| 1 | Spare | Panel buttons A1-A4 |
| 2 | Toggle tail hook | Panel buttons A1-A4 |
| 3 / 4 | Spare | Panel buttons A1-A4 |
| 5 | Spare (no APU) | Panel buttons 5-10 |
| 6 | Canopy (toggle aircraft exit) | Panel buttons 5-10 |
| 7 | Parking brake | Panel buttons 5-10 |
| 8 | Master caution acknowledge | Panel buttons 5-10 |
| 9 / 10 | Catapult: takeoff assist arm / fire | Panel buttons 5-10 |
| 11 / 12 | COM1 MHz down / up | Encoders 11-16 |
| 13 | COM1 standby swap | Encoders 11-16 |
| 14 / 15 | COM1 kHz down / up | Encoders 11-16 |
| 16 | Transponder IDENT | Encoders 11-16 |
| 17 | Cockpit camera | 5-position rotary 17-21 |
| 18 | External camera | 5-position rotary 17-21 |
| 19 | Drone camera | 5-position rotary 17-21 |
| 20 / 21 | Spare | 5-position rotary 17-21 |
| 23 / 22 / 24 | Starter 1 / unbound / Starter 2 | 3-way switch 23 / 22 / 24 |
| 25 / 26 | Master battery ON / OFF | Toggles 25-30 |
| 27 / 28 | Landing lights ON / OFF | Toggles 25-30 |
| 29 / 30 | Landing gear UP / DOWN | Toggles 25-30 |

### T.16000M in MSFS (all three jets)

| T.16000M | Function |
| --- | --- |
| Trigger (1) | Autopilot disconnect |
| Button 2 | Brakes (hold) |
| Button 3 | Toggle smoke |
| Button 4 | Toggle VR mode |
| Hat | Elevator trim up / down, aileron trim left / right |
| Base 5 / 6 | Rudder trim left / right |
| Base 7 | Engine autostart (Ctrl+E) |

Key map pictures: `MTQ key maps/MSFS 2024 …` (one PNG per jet, plus a printable PDF).

## IL-2 Great Battles (WWII, all planes)

One general layout for the common WWII fighters (engine, prop pitch, mixture, radiators, flaps, gear, trim, gunsight, views, weapons), so there are no per-plane maps. Positions match the DCS maps where the job is the same: gear 29 / 30, flaps 40 / 36, comms menu 56, VR recenter 57, canopy 6, parking brake 7, engine start 23. Controls a plane doesn't have do nothing in it.

### Stick (AB6 + MHG)

| AB6 / MHG # | Function |
| --- | --- |
| X / Y | Roll / pitch |
| 6 (full pull) | All guns |
| 1 (first detent) | Gun group 1 (machine guns) |
| 5 | Gun group 2 (cannons) |
| 2 | Drop bombs |
| 4 | Fire rockets |
| 3 (paddle) | Wheel brakes (hold), for Spitfire-style hand brakes |
| Mini-stick (hat mode) | Pitch trim fwd / back, rudder trim left / right |
| 22 / 23 | Trim nose down / up (backup) |
| 12 / 14 / 16 | Zoom in / out / reset |
| 13 | Lean to gunsight (Shift+V) |
| 7 / 9 | Wingmen: attack air target / cover me |
| 10 / 8 | Wingmen: resume mission / attack ground target |
| 49 / 50 | Screenshot / pause (bound directly, no VoiceAttack) |
| 11, 15, 17-21, 24, 51-56 | Spare |
| RZ twist | Unbound (pedals) |

### MTQ

| MTQ # | Function | Group |
| --- | --- | --- |
| RX | Throttle (all engines) | Throttle levers (RX / RY) |
| RY | Propeller pitch (all engines) | Throttle levers (RX / RY) |
| 32 | Boost / WEP / MW-50 on / off | Throttle levers (RX / RY) |
| 34 | Supercharger stage | Throttle levers (RX / RY) |
| 33 / 35, 41 / 42 | Detent signals, leave unbound | Throttle levers (RX / RY) |
| 31 / 43 | Dive brakes extend / retract | Speedbrake lever (Dial) |
| 40 / 36 | Flaps up / down (held while the lever sits there) | Flap lever (Slider) |
| 39 / 38 / 37 | Unbound: move the lever here to stop the flaps | Flap lever (Slider) |
| Mini X / Y | Spare | Left grip + mini-stick |
| 62 push | Reset all trims | Left grip + mini-stick |
| 63 | Prop pitch auto / manual | Left grip + mini-stick |
| 64 | Cockpit lights | Left grip + mini-stick |
| 65 | Tailwheel lock | Left grip + mini-stick |
| 56 | Command menu (radio, wingmen) | Right grip: thumb hat 52 |
| 55 | Map | Right grip: thumb hat 52 |
| 53 / 54 | Mixture richer / leaner | Right grip: thumb hat 52 |
| 52 push | Radiator auto / manual | Right grip: thumb hat 52 |
| 61 / 60 | Time faster / slower (offline) | Right grip: side hat 57 |
| 59 | Hide HUD | Right grip: side hat 57 |
| 58 | Spare | Right grip: side hat 57 |
| 57 push | VR recenter | Right grip: side hat 57 |
| 50 / 51 | Water radiator open / close | Right grip: rocker 50 / 51 |
| 49 | Centre position, leave unbound | Right grip: rocker 50 / 51 |
| 1 | Bomb bay doors open / close | Panel buttons A1-A4 |
| 2 | Drop fuel tank | Panel buttons A1-A4 |
| 3 / 4 | Bombs per release / rockets per salvo | Panel buttons A1-A4 |
| 5 | Auto level flight (AI autopilot) | Panel buttons 5-10 |
| 6 | Canopy open / close | Panel buttons 5-10 |
| 7 | Parking brake | Panel buttons 5-10 |
| 8 | Gunsight power | Panel buttons 5-10 |
| 9 / 10 | Oil radiator open / close | Panel buttons 5-10 |
| 11 / 12 | Gyro gunsight range down / up | Encoders 11-16 |
| 13 | Gunsight mode | Encoders 11-16 |
| 14 / 15 | Aileron trim left / right | Encoders 11-16 |
| 16 | Gunsight reset | Encoders 11-16 |
| 17 / 18 / 19 | Cockpit (F1) / external (F2) / fly-by (F3) view | 5-position rotary 17-21 |
| 20 / 21 | Free camera (F11) / bomb sight (V) | 5-position rotary 17-21 |
| 23 | Engine start / stop (E) | 3-way switch 23 / 22 / 24 |
| 22 / 24 | Unbound / spare | 3-way switch 23 / 22 / 24 |
| 25 / 26 | Bombs armed / safe | Toggles 25-30 |
| 27 / 28 | Navigation lights (each flip toggles) | Toggles 25-30 |
| 30 / 29 | Landing gear UP / DOWN (same as your DCS Hornet binding) | Toggles 25-30 |

**Install:** `DCS profiles/DCS-Profiles.ps1 -IL2` (IL-2 closed). IL-2 keeps every device's bindings in one file, `data\input\global.actions`, and refers to devices by number (`joy0`, `joy1` ...). The game ties each number to a device GUID in `data\input\devices.txt`. The script reads `devices.txt` to find the AB6 and MTQ numbers, swaps out only their rows, and backs the old file up to `data\input-backups\`. Layout file: `DCS profiles/IL-2/MOZA AB6 + MTQ (WWII fighters).actions`.

**Once before the first run:** plug in the AB6 and MTQ, start IL-2, open Settings > Key mapping and quit, so the devices are listed in `devices.txt`. Bind the MRP pedals (rudder, left / right wheel brake) in IL-2 yourself.

**Check in-game the first time:** the throttle and prop levers (bound as RX / RY, inverted like DCS), the flaps (if they only move a little, raise Signal Hold Time in MOZA Cockpit), the gunsight range direction, and that the mini-stick shows up as a hat.

Pictures: `IL-2 key maps/` (MTQ and AB6 PNGs plus a printable PDF; the generator script is in `source/`).

## Carrier comms (DCS)

The carrier radio menu is three or more key presses deep, and the F-key numbers shift with which ships are nearest, so it is hard to fly by muscle memory. The easiest fix is to talk to the boat by voice.

### Option A: voice with VoiceAttack + VAICOM PRO (recommended)

1. Install VoiceAttack (paid, about $10) and the free community release of VAICOM PRO (a VoiceAttack plugin). Follow VAICOM's install guide so it finds your DCS install.
2. In VAICOM's config, set its push-to-talk buttons: **TX1 = MTQ 56** (COMM 1) and **TX2 = MTQ 55** (COMM 2). Use the same buttons as your SRS push-to-talk and turn on VAICOM's SRS integration so one press does both.
3. Match VAICOM's Easy Communication setting to DCS (DCS: Options > Gameplay > Easy Communication).
4. Use the Pimax headset microphone. Hold 56, say the call, release.

### Option B: no voice

1. In DCS controls, bind **Communication menu** to a spare MTQ button: **21** in the Hornet, **17** in the Tomcat.
2. The F1-F12 menu choices are keyboard keys. Joystick Gremlin, or a key macro in MOZA Cockpit if it offers one, can put F1 / F2 / F3 on buttons so a call is three throttle taps.
3. Turn on Easy Communication so you don't have to tune the carrier frequency first. With it off, set COMM 1 to the carrier frequency from the mission briefing and open the menu through the radio (Right Alt + \ is COMM 1).

### Calls by phase

| Phase | Call (VAICOM phrase) | Who | When |
| --- | --- | --- | --- |
| Launch | "Request launch" | Ground crew | Hooked up to the catapult, after takeoff checks |
| Recovery, Case I | "Inbound" | Marshal | About 50 nm out. Marshal replies with the carrier heading (BRC) and altimeter |
| Recovery, Case I | "See you at ten" | Marshal | 10 nm from the carrier |
| Recovery, Case I | (none) | Paddles / Tower | Wait for "Signal Charlie", then fly the break |
| Recovery, Case II / III | "Inbound", then "Commencing" | Marshal | Commence at your assigned push time from the stack |
| Final | "Ball" (or "Clara" if you can't see it) | Paddles (LSO) | About 3/4 nm, when the meatball is in sight |

Notes:
- Calls only appear in the menu (and only work by voice) after "Inbound".
- Some players report no Ball option in Case I. It is reliable in Case II and III.
- Alt + F9 jumps to the LSO view if you want to watch others land.

## Importing profiles

DCS stores bindings per device as a `.diff.lua` file. Claude can generate one per aircraft once it has the exact command IDs and device name.

| Aircraft | Command list (DCS install folder) | Your device file (Saved Games\\DCS\\Config\\Input) |
| --- | --- | --- |
| F/A-18C | `Mods\aircraft\FA-18C\Input\FA-18C\joystick\default.lua` | `FA-18C_hornet\joystick\MOZA MTQ {GUID}.diff.lua` |
| F-14 | Pilot folder under `Mods\aircraft\F14\Input\` (not RIO) | The F-14 folder's `joystick\` device file |

1. In DCS, bind any one MTQ button for that aircraft and press OK. This creates the device file.
2. Send Claude both files. Do the same for the stick and pedals if you want those built too.
3. To load the result: Options → Controls → pick the aircraft → click the device column header → Load profile.

- [x] Hornet MTQ profile built: `DCS profiles/FA-18C_hornet/` (bind by hand: 3 wing fold, 5 APU, 7 parking brake, 10 catapult launch, 57-59 VR / pause)
- [ ] Send Tomcat files
