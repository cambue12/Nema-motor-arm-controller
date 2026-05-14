# 4-Axis Robotic Arm with Browser Control

A fully working 4-axis robotic arm with a parallel-gripper end effector — driven by a NEMA 23 with a custom 5:1 planetary gearbox at the shoulder, three NEMA 17s for the base, elbow and wrist, and controlled live in a browser over USB through a custom Three.js + WebSerial app.

This upload is the **mechanical structure** — the printable parts of the arm. Wiring, firmware and the browser control app are all open-source and linked below.

> ⚠️ **Build status note** — the **Second Link** and **Link to Wrist** parts in this upload are the latest design revisions and have **not yet been printed and assembled** at the time of this post. All other parts are printed and in active use. I'm uploading the design as-is so others can start their own builds; printability has been validated in the slicer for both unprinted parts.

---

## What's printable

| Part | Notes |
|------|-------|
| **BASE REMAKE** | Dome / skirt base with bolt circle. Mounts to a flat surface with M5 bolts. |
| **BOTTOM PLATE** | Lower plate of the planetary gearbox housing. ×2 needed (one per gearbox: shoulder + elbow). |
| **TOP PLATE** | Upper plate of the planetary gearbox housing. ×2 needed. |
| **First Length** | Upper arm — from shoulder pivot to elbow. |
| **Second Link** ⚠️ | Forearm transition piece. *Not yet print-validated.* |
| **SECOND LENGTH (V2)** | Forearm horn — the long tapered cone. |
| **Link to Wrist** ⚠️ | Wrist tube + face plate where the gripper bolts on. *Not yet print-validated.* |

The **planetary gears** themselves (sun + planets) are deliberately **not in this upload** — they'll be in a separate gearbox post so people can mix-and-match gear ratios.

## Print settings (recommended)

- **Material:** PETG or ABS for structural rigidity. PLA+ works for testing but the shoulder yoke takes real load.
- **Layer height:** 0.2 mm
- **Walls:** 4 perimeters minimum
- **Infill:** 35–40% gyroid for structural parts, 100% for the gearbox plates
- **Supports:** required under the dome flare on `BASE REMAKE` and overhangs > 45°
- **Orientation:** print everything with the smallest face down except the dome — flip that so the bolt rim is up

## Hardware bill of materials

### Motors & drivers
- 1× **NEMA 23** stepper (shoulder)
- 3× **NEMA 17** stepper (base, elbow, wrist)
- 1× **DM556** standalone stepper driver (drives the NEMA 23)
- 1× **Arduino UNO + CNC Shield V3** (3× onboard A4988 drivers for the NEMA 17s)
- 1× 24V DC power supply (for the DM556)
- 1× 12V DC power supply (for the CNC shield)

### Mechanical
- 8× planetary planet gears + 2× sun gears (printed — separate upload)
- M3 bolts, nuts, washers throughout
- 608 bearings for the rotating disc
- M5 bolts for floor mounting

### Optional
- iPhone 12 Pro or newer (for LiDAR hand-tracking control)

## Joint specs

| Joint | Motor | Gearbox | Range | Microsteps |
|-------|-------|---------|-------|------------|
| Base | NEMA 17 | direct (1:1) | ±180° | 1/8 |
| Shoulder | NEMA 23 | 5:1 planetary | ±90° | 1/8 (DM556) |
| Elbow | NEMA 17 | 5:1 planetary | ±140° | full step |
| Wrist | NEMA 17 | direct (1:1) | ±720° | full step |

Total reach: ~420 mm fully extended.

## Software

The browser-based control app, iPhone LiDAR hand-tracking bridge, WebSocket relay, and full source for the Arduino firmware are all open-source on GitHub:

🔗 **[github.com/cambue12/Nema-motor-arm-controller](https://github.com/cambue12/Nema-motor-arm-controller)**

Features include:
- Live 3D simulation in the browser (Three.js)
- Real-time WebSerial control over USB
- Webcam hand-tracking (MediaPipe) — IK and per-finger control modes
- iPhone LiDAR hand-tracking (ARKit + Vision)
- Activity macros: Wave, Dance, Pick & Place, Showcase, EXPO Demo, etc.
- Layered safety system with confirmation modals and panic-stop

## Customisable parameters

Each `.f3d` file has a `Scale` parameter exposed to MakerWorld's customiser — bump it up or down to print the arm at a different size. (Note: hardware will need to be matched accordingly.)

## Print order recommendation

1. `BASE REMAKE`
2. `BOTTOM PLATE` (×2)
3. `TOP PLATE` (×2)
4. `First Length`
5. `SECOND LENGTH (V2)`
6. `Second Link` ⚠️ unprinted reference
7. `Link to Wrist` ⚠️ unprinted reference

## Credits & License

Designed in Fusion 360. MIT-licensed source on GitHub.

If you build one, please share photos in the print log or tag me — I'd love to see other people's takes on it. Pull requests welcome on the GitHub repo too if you find improvements.
