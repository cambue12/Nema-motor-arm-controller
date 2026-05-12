# CAD & 3D-Printed Parts

## Files

- **`RoboticArm.f3d`** — Fusion 360 source assembly (Arm Assembly V4). Open with Fusion 360 to edit components or export new STL files.
- **`stl/`** — exported STL meshes for 3D printing.

## Print order (recommended)

| # | File | Notes |
|---|------|-------|
| 01 | `01_Base.stl` / `02_BaseV2.stl` | Dome/skirt base — needs supports under the flare |
| 03 | `03_BottomPlate.stl` | Bottom mounting plate |
| 04 | `04_TopPlate.stl` | Top of the rotating disc |
| 05 | `05_TopSupport.stl` | Shoulder column / motor housing |
| 06 | `06_FirstLink.stl` | Upper arm |
| 07 | `07_SecondLink.stl` | Forearm horn |
| 08 | `08_LinkToWrist.stl` | Wrist tube + face plate |
| 09 | `09_Gearbox_SunGear.stl` | Planetary sun gear (smaller) |
| 10 | `10_Gearbox_PlanetGear.stl` | Planetary planet gears (×4) |

## Print settings (suggested)

- **Material:** PLA+ for testing, PETG or ABS for final assembly
- **Layer height:** 0.2 mm
- **Infill:** 35% gyroid for structural parts, 100% for gears
- **Walls:** 4 perimeters minimum
- **Supports:** required for the dome base flare and any overhangs > 45°

## Gearbox

5:1 planetary reduction. The shoulder uses one of these driven by a NEMA 23 + DM556 driver; the elbow uses a smaller version driven by a NEMA 17. The web app's joint settings have `gr: 5.0` baked in for both joints.
