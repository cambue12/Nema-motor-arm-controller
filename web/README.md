# Web Control App (`armctl.html`)

Single-file browser app — HTML + Three.js + WebSerial. No build step.

## Running

```bash
python3 -m http.server 8888
```

Open `http://localhost:8888/armctl.html` in **Google Chrome** (WebSerial is Chrome-only).

You can also open the file directly with `file://`, but the camera-tracking and MediaPipe features will be blocked by the browser. Use the local server.

## Features

- **Live 3D simulation** of the arm via Three.js
- **WebSerial** to send `MOVE` commands to the Arduino over USB
- **Sliders + presets** for direct joint control
- **Activity macros** — Wave, Dance, Spin, Pick & Place, Sleep, Showcase, EXPO Demo, etc.
- **Hand tracking via webcam** (MediaPipe) — IK and per-finger control modes
- **WebSocket bridge** for receiving 3D coordinates from the iPhone LiDAR app
- **Layered safety system** — speed/accel profiles, per-command step caps, confirmation modals for big moves, panic-stop on spacebar

## Keyboard shortcuts

| Key | Action |
|-----|--------|
| `Space` | EMERGENCY STOP |
| `Esc` | Cancel confirmation modal |

## Settings

Joint microstep / steps-per-rev / gear ratio settings live inside the SETTINGS panel. They default to:

| Joint | μstep | spr | gr |
|-------|-------|-----|----|
| Base (X) | 8 | 200 | 1.0 |
| Shoulder (Y) | 8 | 200 | 5.0 |
| Elbow (Z) | 1 | 200 | 5.0 |
| Wrist (A) | 1 | 200 | 1.0 |
