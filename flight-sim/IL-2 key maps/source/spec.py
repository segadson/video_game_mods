# Single source of truth for the IL-2 AB6 + MTQ layout.
# Each binding: (device, input, action, label, category)
#   input: int button (MOZA number, 1-based), 'axis_x' etc, 'pov0_0', or ('pair', a, b) for axis actions on two buttons (a = increase)
AB6 = [
    ('axis_x', 'rpc_roll', 0),
    ('axis_y', 'rpc_pitch', 0),
]
MTQ_AXES = [
    ('axis_w', 'rpc_all_engines_throttles', 1),     # RX lever
    ('axis_s', 'rpc_all_engines_props_pitch', 1),   # RY lever
]

AB6_BTN = [
    (6, 'all_guns_fire'),
    (1, 'weapon_group_1_fire'),
    (5, 'weapon_group_2_fire'),
    (2, 'throw_bombs_command'),
    (4, 'launch_rockets_command'),
    (3, 'rpc_wheel_brakes'),
    ('pov0_0', 'pitch_trim_switch_dn'),
    ('pov0_180', 'pitch_trim_switch_up'),
    ('pov0_270', 'yaw_trim_switch_left'),
    ('pov0_90', 'yaw_trim_switch_right'),
    (22, 'pitch_trim_switch_dn'),
    (23, 'pitch_trim_switch_up'),
    (12, 'bc_head_cfovi'),
    (14, 'bc_head_cfovo'),
    (16, 'bc_head_cfovr'),
    (13, 'cam_switch_visor'),
    (7, 'bc_signal_attack_nearest_air_target'),
    (8, 'bc_signal_attack_nearest_ground_target'),
    (9, 'bc_signal_hold_formation'),
    (10, 'bc_signal_back_to_mission'),
    (49, 'screenshot'),
    (50, 'timepause'),
]

MTQ_BTN = [
    (32, 'all_engines_boost'),
    (34, 'all_engines_superchargers'),
    (31, 'airbrakes_on'),
    (43, 'airbrakes_off'),
    (40, 'flaps_up'),
    (36, 'flaps_dn'),
    (62, 'trims_reset'),
    (63, 'all_engines_props_pitch_control_mode'),
    (64, 'cockpit_lights'),
    (65, 'tailwheel_lock'),
    (56, 'commandmenu'),
    (55, 'switchmap'),
    (('pair', 53, 54), 'rpc_all_engines_mixtures'),
    (52, 'all_engines_water_radiators_control_mode'),
    (61, 'timefaster'),
    (60, 'timeslower'),
    (59, 'hidehud'),
    (57, 'resethmd'),
    (('pair', 50, 51), 'rpc_all_engines_water_radiators_shutters'),
    (1, 'bombdoors_toggle'),
    (2, 'jettison_fueltank'),
    (3, 'throw_bombs_mode'),
    (4, 'launch_rockets_mode'),
    (5, 'autolevelflight'),
    (6, 'canopy_open_close'),
    (7, 'parking_brakes'),
    (8, 'gunsight_power'),
    (('pair', 9, 10), 'rpc_all_engines_oil_radiators_shutters'),
    (('pair', 12, 11), 'gs_distance'),
    (13, 'gunsight_mode'),
    (14, 'roll_trim_switch_left'),
    (15, 'roll_trim_switch_right'),
    (16, 'gs_reset'),
    (17, 'cam_switch_cockpitview_self'),
    (18, 'cam_switch_ext_free_self'),
    (19, 'cam_switch_flyby_target'),
    (20, 'cam_switch_free'),
    (21, 'cam_switch_bombaim'),
    (23, 'all_engines_switch'),
    (25, 'bombsafety_on'),
    (26, 'bombsafety_off'),
    (27, 'navigation_lights'),
    (28, 'navigation_lights'),
    (29, 'gear_dn'),
    (30, 'gear_up'),
]


def ref(dev, inp):
    if isinstance(inp, tuple):
        _, a, b = inp
        return f'joy{{{dev}}}_b{a-1}/joy{{{dev}}}_b{b-1}'
    if isinstance(inp, int):
        return f'joy{{{dev}}}_b{inp-1}'
    return f'joy{{{dev}}}_{inp}'


def line(action, cmd, inv=0):
    return f'{action + ",":<50}{cmd + ",":<50}{inv}|'


def template():
    out = [
        '// IL-2 Great Battles: MOZA AB6 + MHG stick and MOZA MTQ throttle, general WWII layout.',
        '// Installed by DCS-Profiles.ps1 -IL2, which swaps {AB6} / {MTQ} for the joystick numbers',
        '// the game gave those devices in data\\input\\devices.txt and merges these lines into',
        '// data\\input\\global.actions. Button numbers here are 0-based (joyN_b0 = MOZA button 1).',
        '// Format: action, command, invert|',
    ]
    for inp, act, inv in AB6:
        out.append(line(act, ref('AB6', inp), inv))
    for inp, act in AB6_BTN:
        out.append(line(act, ref('AB6', inp)))
    for inp, act, inv in MTQ_AXES:
        out.append(line(act, ref('MTQ', inp), inv))
    for inp, act in MTQ_BTN:
        out.append(line(act, ref('MTQ', inp)))
    return '\n'.join(out) + '\n'


if __name__ == '__main__':
    import sys
    sys.stdout.write(template())
