# Robotic Arm Controller

A 4-axis robotic arm with a parallel-gripper end effector, custom 3D-printed structure with planetary gearboxes, and a browser-based control interface that runs in real time over WebSerial.

![Hero](docs/images/hero.png)

## What's in this project

| Subsystem | Tech | Folder |
|-----------|------|--------|
| **Mechanical** | NEMA 23 (shoulder) + 3× NEMA 17, custom 5:1 planetary gearboxes, 3D-printed structural parts | `cad/` |
| **Electronics** | Arduino UNO + CNC Shield + DM556 stepper driver | _diagrams in `docs/`_ |
| **Web Control App** | Single-file HTML, Three.js, WebSerial | `web/` |
| **iOS Hand-Tracking Bridge** | SwiftUI + ARKit + Vision + LiDAR | `ios-bridge/` |
| **WebSocket Relay** | Python `websockets` library | `server/` |

## Joints

| Joint | Motor | Driver | Microsteps | Gear | Range |
|-------|-------|--------|------------|------|-------|
| **Base (X)** | NEMA 17 | A4988 (CNC shield) | 1/8 (2 jumpers) | 1:1 | ±180° |
| **Shoulder (Y)** | NEMA 23 | DM556 | 1/8 | 5:1 planetary | ±90° |
| **Elbow (Z)** | NEMA 17 | A4988 (CNC shield) | full step (no jumpers) | 5:1 planetary | ±140° |
| **Wrist (A)** | NEMA 17 | A4988 (CNC shield) | full step (no jumpers) | 1:1 | ±720° |
| **Claw** | (geared servo) | — | — | — | 0–100% open |

## Quick start

### 1. Run the web control app

```bash
cd web
python3 -m http.server 8888
```

Open `http://localhost:8888/armctl.html` in Chrome (Chrome only — WebSerial is required).

The simulator runs without any hardware connected. To talk to the real arm, plug the Arduino in via USB and click **CONNECT**.

### 2. (Optional) iPhone hand tracking

Build the `ios-bridge/ARHandBridge.swift` project in Xcode (see [`ios-bridge/README.md`](ios-bridge/README.md)). The phone uses LiDAR + Vision to track your hand and streams 3D coordinates over a Python WebSocket relay (`server/relay.py`) to the web app.

## Documentation

- [`docs/HARDWARE.md`](docs/HARDWARE.md) — physical setup and wiring
- [`docs/SOFTWARE.md`](docs/SOFTWARE.md) — how the control app works
- [`docs/SAFETY.md`](docs/SAFETY.md) — the layered safety system
- [`docs/BOM.csv`](docs/BOM.csv) — bill of materials

## Project status

Active development. Mechanical V4 is the current production assembly.

## License

MIT — see [LICENSE](LICENSE).
