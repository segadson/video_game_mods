from PIL import Image, ImageDraw, ImageFont
import os

FD = '/usr/share/fonts/opentype/inter/'
def F(size, w='Regular'):
    return ImageFont.truetype(FD + f'Inter-{w}.otf', size)

BG = (243, 244, 248)
INK = (24, 28, 38)
SUB = (90, 96, 110)
GREY = (150, 155, 165)
OUT = '/mnt/project-files/'
UP = '/mnt/project-files/uploads/hearth/'

# ------------------------------------------------------------------ MTQ
C = dict(
    speed=(217, 72, 15), thr=(201, 42, 42), flap=(232, 119, 0), a14=(103, 65, 217), p510=(112, 72, 232),
    thumb=(194, 37, 92), side=(166, 30, 77), rocker=(156, 54, 181), left=(25, 113, 194),
    enc=(28, 126, 214), tog=(92, 148, 13), sw3=(43, 138, 62), rot=(12, 133, 153))

GROUPS = {
    'flap': ('Flap lever (Slider)', [('40', 'Flaps up (hold)'), ('36', 'Flaps down (hold)'),
                                     ('39 / 38 / 37', 'Stop flaps where they are', 1)]),
    'speed': ('Speedbrake lever (Dial)', [('31', 'Dive brakes extend (Ju 87 and others)'), ('43', 'Dive brakes retract')]),
    'thr': ('Throttle levers (RX / RY)', [('RX', 'Throttle (all engines)'), ('RY', 'Propeller pitch (all engines)'),
                                          ('32', 'Boost / WEP / MW-50 on / off'), ('34', 'Supercharger stage'),
                                          ('33 / 35, 41 / 42', 'Detent signals, leave unbound', 1)]),
    'a14': ('Panel buttons A1-A4', [('1', 'Bomb bay doors open / close'), ('2', 'Drop fuel tank'),
                                    ('3', 'Bombs per release'), ('4', 'Rockets per salvo')]),
    'p510': ('Panel buttons 5-10', [('5', 'Auto level flight (AI autopilot)'), ('6', 'Canopy open / close'),
                                    ('7', 'Parking brake'), ('8', 'Gunsight power'), ('9 / 10', 'Oil radiator open / close')]),
    'thumb': ('Right grip: thumb hat 52', [('56', 'Command menu (radio, wingmen)'), ('55', 'Map'),
                                          ('53 / 54', 'Mixture richer / leaner'), ('52 push', 'Radiator auto / manual')]),
    'side': ('Right grip: side hat 57', [('61 / 60', 'Time faster / slower (offline)'), ('59', 'Hide HUD'),
                                        ('58', 'Spare', 1), ('57 push', 'VR recenter')]),
    'rocker': ('Right grip: rocker 50 / 51', [('50 / 51', 'Water radiator open / close'), ('49', 'Centre position, leave unbound', 1)]),
    'left': ('Left grip + mini-stick', [('Mini X / Y', 'Spare', 1), ('62 push', 'Reset all trims'),
                                       ('63', 'Prop pitch auto / manual'), ('64', 'Cockpit lights'), ('65', 'Tailwheel lock')]),
    'enc': ('Encoders 11-16', [('11 / 12', 'Gyro gunsight range down / up'), ('13', 'Gunsight mode'),
                               ('14 / 15', 'Aileron trim left / right'), ('16', 'Gunsight reset')]),
    'tog': ('Toggles 25-30', [('25 / 26', 'Bombs armed / safe'), ('27 / 28', 'Navigation lights (each flip toggles)'),
                              ('30 / 29', 'Landing gear UP / DOWN')]),
    'sw3': ('3-way switch 23 / 22 / 24', [('23', 'Engine start / stop (E)'), ('22 / 24', 'Unbound / spare', 1)]),
    'rot': ('5-position rotary 17-21', [('17', 'Cockpit view (F1)'), ('18', 'External view (F2)'), ('19', 'Fly-by view (F3)'),
                                        ('20', 'Free camera (F11)'), ('21', 'Bomb sight (V)')]),
}
# boxes in mtq_crop coords
BOX = dict(speed=(16, 205, 56, 270), thr=(100, 195, 260, 360), flap=(355, 185, 400, 385), a14=(35, 450, 82, 640),
           p510=(108, 450, 215, 632), enc=(232, 438, 306, 562), rot=(408, 428, 508, 490), sw3=(308, 525, 386, 556),
           tog=(244, 610, 380, 662), thumb=(712, 8, 815, 102), side=(832, 100, 936, 194), rocker=(724, 204, 800, 233),
           left=(578, 412, 858, 562))

HDR = 66; ROW = 50; PADT = 16; PADB = 14


def panel(d, x, y, w, key, numw=300):
    title, rows = GROUPS[key]
    col = C[key]
    h = HDR + PADT + ROW * len(rows) + PADB
    d.rounded_rectangle([x, y, x + w, y + h], 14, fill=(255, 255, 255), outline=col, width=5)
    d.rounded_rectangle([x, y, x + w, y + HDR], 14, fill=col)
    d.rectangle([x + 3, y + HDR - 16, x + w - 3, y + HDR], fill=col)
    d.text((x + 22, y + HDR / 2), title, font=F(34, 'SemiBold'), fill='white', anchor='lm')
    for i, r in enumerate(rows):
        spare = len(r) > 2
        cy = y + HDR + PADT + ROW * i + ROW / 2
        d.text((x + 22, cy), r[0], font=F(31, 'SemiBold'), fill=GREY if spare else col, anchor='lm')
        d.text((x + 22 + numw, cy), r[1], font=F(31), fill=GREY if spare else INK, anchor='lm')
    return h


def mtq():
    W = 3600
    crop = Image.open(UP + 'dddd10b9-892d-4f29-8ef1-e7f1f8b2a38a').convert('RGB').crop((810, 170, 1757, 890))
    s = 1.49
    dx, dy = 1094, 470
    diag = crop.resize((int(crop.width * s), int(crop.height * s)), Image.LANCZOS)
    H = 2480
    im = Image.new('RGB', (W, H), BG)
    im.paste(diag, (dx, dy))
    d = ImageDraw.Draw(im)
    d.text((43, 40), 'IL-2 Great Battles: WWII fighters', font=F(80, 'Bold'), fill=INK)
    d.text((45, 145), 'MOZA MTQ key map for IL-2 (one layout for all planes)  ·  numbers match the MOZA Cockpit button diagram',
           font=F(38), fill=SUB)

    def bx(k):
        x0, y0, x1, y1 = BOX[k]
        return (dx + x0 * s, dy + y0 * s, dx + x1 * s, dy + y1 * s)

    for k in BOX:
        d.rounded_rectangle(bx(k), 8, outline=C[k], width=4)

    anchors = {}
    LW, RX0, RW = 1000, 2556, 1000
    PL = []   # panels to draw after the lines
    # left column
    y = 230
    for k in ['speed', 'thr', 'a14', 'p510']:
        h = panel(ImageDraw.Draw(Image.new('RGB', (1, 1))), 43, y, LW, k)
        PL.append((43, y, LW, k, 300))
        anchors[k] = ((43 + LW, y + HDR / 2), 'r')
        y += h + 26
    lbottom = y
    # right column
    y = 230
    for k in ['thumb', 'side', 'rocker', 'left']:
        h = panel(ImageDraw.Draw(Image.new('RGB', (1, 1))), RX0, y, RW, k, numw=260)
        PL.append((RX0, y, RW, k, 260))
        anchors[k] = ((RX0, y + HDR / 2), 'l')
        y += h + 26
    rbottom = y
    # top centre
    fx, fy, fw = 1650, 205, 900
    PL.append((fx, fy, fw, 'flap', 280))
    anchors['flap'] = ((fx + fw / 2, fy + HDR + PADT + ROW * 3 + PADB), 'b')
    assert fy + HDR + PADT + ROW * 3 + PADB < dy
    # bottom row
    by = max(dy + diag.height, lbottom, rbottom) + 70
    bw = (W - 86 - 3 * 30) / 4
    hs = []
    for i, k in enumerate(['enc', 'tog', 'sw3', 'rot']):
        x = 43 + i * (bw + 30)
        hs.append(panel(ImageDraw.Draw(Image.new('RGB', (1, 1))), x, by, bw, k, numw=240))
        PL.append((x, by, bw, k, 240))
        x0, y0, x1, y1 = bx(k)
        anchors[k] = ((min(max((x0 + x1) / 2, x + 40), x + bw - 40), by), 't')
    # leader lines
    for k, (pt, side) in anchors.items():
        x0, y0, x1, y1 = bx(k)
        if side == 'r':
            tgt = (x0, (y0 + y1) / 2)
        elif side == 'l':
            tgt = (x1, (y0 + y1) / 2)
        elif side == 'b':
            tgt = ((x0 + x1) / 2, y0)
        else:
            tgt = ((x0 + x1) / 2, y1)
        d.line([pt, tgt], fill=C[k], width=4)
        for p in (pt, tgt):
            d.ellipse([p[0] - 9, p[1] - 9, p[0] + 9, p[1] + 9], fill=C[k])
    for (x, y, w, k, nw) in PL:
        panel(d, x, y, w, k, numw=nw)
    for k, (pt, side) in anchors.items():
        d.ellipse([pt[0] - 9, pt[1] - 9, pt[0] + 9, pt[1] + 9], fill=C[k])
    fy2 = by + max(hs) + 40
    foot = ('Installed by DCS-Profiles.ps1 -IL2 (merges into data\\input\\global.actions). In MOZA Cockpit set Flaps to button mode, '
            'as for DCS. Bind the MRP pedals (rudder, toe brakes) in IL-2 once.\n'
            'Gear follows your own DCS binding (30 = UP, 29 = DOWN). Press each control in MOZA Cockpit to confirm its number. Grey rows are spare.')
    d.multiline_text((45, fy2), foot, font=F(31), fill=SUB, spacing=14)
    im = im.crop((0, 0, W, fy2 + 120))
    return im


# ------------------------------------------------------------------ AB6
CAT = dict(weap=(214, 40, 40), view=(28, 110, 214), trim=(47, 140, 60), sim=(240, 120, 10),
           other=(112, 72, 232), spare=(160, 165, 175))

AB6_LEFT = [
    ('4', 'Fire rockets', 'weap', 'g', (339, 353)),
    ('22 / 23', 'Trim nose down / up (backup)', 'trim', 'g', (407, 381)),
    ('24', 'Spare', 'spare', 'g', (407, 381)),
    ('6', 'All guns (full pull)', 'weap', 'g', (358, 526)),
    ('1', 'Gun group 1 (first detent)', 'weap', 'g', (435, 526)),
    ('3', 'Wheel brakes, hold (paddle)', 'other', 'g', (213, 689)),
    ('7 / 9', 'Wingmen: attack air / cover me', 'other', 'g', (733, 384)),
    ('10 / 8', 'Wingmen: resume / attack ground', 'other', 'g', (907, 378)),
    ('17-21', 'Spare', 'spare', 'g', (733, 652)),
]
AB6_RIGHT = [
    ('2', 'Drop bombs', 'weap', 'g', (899, 311)),
    ('HAT', 'Trim pitch + rudder (mini-stick)', 'trim', 'g', (977, 319)),
    ('12 / 14', 'Zoom in / out', 'view', 'g', (1227, 268)),
    ('16', 'Reset zoom', 'view', 'g', (1227, 311)),
    ('13', 'Lean to gunsight (Shift+V)', 'view', 'g', (1283, 311)),
    ('5', 'Gun group 2, cannons (pinky)', 'weap', 'g', (1050, 378)),
    ('11, 15', 'Spare (switch push / left)', 'spare', 'g', (1170, 311)),
    ('49 / 50', 'Screenshot / pause', 'sim', 'b', (445, 567)),
    ('RZ', 'Twist: unbound (pedals)', 'spare', 'g', (974, 995)),
]


def pill(d, x, y, w, h, num, text, col, right=False):
    r = h / 2
    d.rounded_rectangle([x, y, x + w, y + h], r, fill=(255, 255, 255), outline=col, width=5)
    f = F(36, 'SemiBold')
    nw = max(115, d.textlength(num, font=f) + 50)
    d.rounded_rectangle([x + 10, y + 10, x + 10 + nw, y + h - 10], (h - 20) / 2, fill=col)
    d.text((x + 10 + nw / 2, y + h / 2), num, font=f, fill='white', anchor='mm')
    d.text((x + 10 + nw + 26, y + h / 2), text, font=F(38), fill=GREY if col == CAT['spare'] else INK, anchor='lm')


def ab6():
    W, H = 3000, 1900
    im = Image.new('RGB', (W, H), BG)
    d = ImageDraw.Draw(im)
    d.text((40, 40), 'IL-2 Great Battles: WWII fighters', font=F(72, 'Bold'), fill=INK)
    d.text((44, 130), 'MOZA AB6 base + MHG grip stick map for IL-2  ·  numbers match MOZA Cockpit button numbers',
           font=F(36), fill=SUB)
    grip = Image.open(UP + '0e7c0959-d1ca-4414-9300-277889c9c3c1').convert('RGB').crop((20, 330, 1420, 1400))
    gs = 0.914
    gx, gy = 860, 205
    im.paste(grip.resize((int(grip.width * gs), int(grip.height * gs)), Image.LANCZOS), (gx, gy))
    base = Image.open(UP + '9e8ac39d-17d3-4ed5-b931-f6b83c727d30').convert('RGB').crop((250, 780, 1760, 2080))
    bs = 0.30
    bxp, byp = 1640, 1200
    im.paste(base.resize((int(base.width * bs), int(base.height * bs)), Image.LANCZOS), (bxp, byp))

    def P(src, pt):
        if src == 'g':
            return (gx + pt[0] * gs, gy + pt[1] * gs)
        return (bxp + pt[0] * bs, byp + (pt[1] - 200) * bs)

    ph, pw = 72, 800
    ys = [210 + i * 135 for i in range(9)]
    for side, items in (('L', AB6_LEFT), ('R', AB6_RIGHT)):
        for (num, text, cat, src, pt), y in zip(items, ys):
            col = CAT[cat]
            x = 40 if side == 'L' else W - 40 - pw
            pill(d, x, y, pw, ph, num, text, col)
            a = (x + pw, y + ph / 2) if side == 'L' else (x, y + ph / 2)
            t = P(src, pt)
            d.line([a, t], fill=col, width=3)
            d.ellipse([t[0] - 16, t[1] - 16, t[0] + 16, t[1] + 16], outline=col, width=5)
    # legend
    ly = 1640
    x = 44
    for cat, name in (('weap', 'Weapons'), ('view', 'Views / zoom'), ('trim', 'Trim'), ('other', 'Brakes / wingmen'),
                      ('sim', 'Sim controls'), ('spare', 'Spare')):
        d.ellipse([x, ly, x + 30, ly + 30], fill=CAT[cat])
        d.text((x + 44, ly + 15), name, font=F(36), fill=INK, anchor='lm')
        x += 44 + d.textlength(name, font=F(36)) + 70
    foot = ('Pitch / roll = stick X / Y. Set the mini-stick to hat (POV) mode in MOZA Cockpit for trim; 22 / 23 trim pitch either way. '
            'Trigger: 1 = first detent, 6 = full pull.\n'
            'Base buttons: 49-52 left column top to bottom, 53-56 right column. IL-2 binds keyboard functions directly, so no VoiceAttack is needed.')
    d.multiline_text((44, 1710), foot, font=F(30), fill=SUB, spacing=12)
    return im.crop((0, 0, W, 1830))


if __name__ == '__main__':
    import sys
    os.makedirs(OUT + 'IL-2 key maps', exist_ok=True)
    m = mtq(); m.save(OUT + 'IL-2 key maps/IL-2 MTQ key map.png', optimize=True)
    a = ab6(); a.save(OUT + 'IL-2 key maps/IL-2 AB6 stick map.png', optimize=True)
    pdf = [m.convert('RGB'), a.convert('RGB')]
    pdf[0].save(OUT + 'IL-2 key maps/IL-2 key maps (MTQ + AB6).pdf', save_all=True, append_images=pdf[1:], resolution=300)
    print(m.size, a.size)
