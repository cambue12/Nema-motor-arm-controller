# Hardware

## Electronics

```
USB ───▶ Arduino UNO ──┬─▶ CNC Shield V3 ──┬─▶ A4988 (Base)     ──▶ NEMA 17
                       │                   ├─▶ A4988 (Elbow)    ──▶ NEMA 17 → 5:1 planetary
                       │                   └─▶ A4988 (Wrist)    ──▶ NEMA 17
                       └─▶ D12/D13 ─────────▶ DM556 ─────────────▶ NEMA 23 → 5:1 planetary
```

### Pin assignments (CNC Shield)

| Joint | Shield axis | Step pin | Dir pin | Microsteps |
|-------|-------------|----------|---------|------------|
| Base | X | D2 | D5 | 1/8 (MS1+MS2 jumpers) |
| Wrist | Y | D3 | D6 | full step (no jumpers) |
| Elbow | Z | D4 | D7 | full step (no jumpers) |
| Shoulder | A (D12/D13) | D12 | D13 | 1/8 (set on DM556) |

### DM556 dip switches (for NEMA 23 shoulder)

`SW1-SW4` set the current; `SW5-SW8` set microsteps.

For 1/8 microstepping (1600 steps/rev): `SW5=ON, SW6=OFF, SW7=ON, SW8=ON`.

## Mechanical

### Joint reductions

| Joint | Motor | Gearbox | Steps per joint degree |
|-------|-------|---------|------------------------|
| Base | NEMA 17 | direct (1:1) | 4.4 |
| Shoulder | NEMA 23 | planetary 5:1 | 22.2 |
| Elbow | NEMA 17 | planetary 5:1 | 2.8 |
| Wrist | NEMA 17 | direct (1:1) | 0.56 |

The high-resolution shoulder (22 steps/°) is what allows the heaviest joint to move smoothly.

The low-resolution wrist and elbow (0.56 / 2.8 steps/°) are acceptable because those joints are downstream — small angle errors there don't accumulate the way they do at the shoulder.

### Arm dimensions (mm)

- `L0 = 48` — base height
- `COL_H = 78` — column / shoulder pivot height above base top
- `L1 = 220` — upper arm length
- `L2 = 60` — forearm length
- `L3 = 140` — wrist horn + face plate length

Total reach (fully extended): `L1 + L2 + L3 = 420 mm`

## Power

- **24V DC** to the DM556 (the NEMA 23 needs the higher voltage)
- **12V DC** to the CNC Shield's Vmot pin (powers the A4988s)
- USB **5V** powers the Arduino logic

⚠️ Never share grounds across power supplies without isolation. The DM556's PUL/DIR/ENA inputs are opto-isolated — wire them with their own + and − pairs from the Arduino.
