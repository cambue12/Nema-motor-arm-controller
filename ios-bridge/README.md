# iPhone LiDAR Hand-Tracking Bridge

A SwiftUI app that uses ARKit + Vision + LiDAR to detect the user's hand in 3D space and stream wrist coordinates over a WebSocket to the web control app.

## Requirements

- iPhone with LiDAR (iPhone 12 Pro or newer Pro models)
- Xcode 15+
- iOS 16+ deployment target

## Setup

1. Open Xcode → **Create New Project** → **iOS App** (SwiftUI lifecycle)
2. Name it `ARHandBridge`
3. Replace `ContentView.swift` with the contents of `ARHandBridge.swift` from this folder
4. Delete the auto-generated `ARHandBridgeApp.swift` (the Swift file in this repo provides the `@main` struct)
5. In the project's **Info** tab, add `Privacy - Camera Usage Description` = "Hand tracking"
6. Plug your iPhone in, select it as the run target, hit ▶
7. Trust the developer certificate on the phone: **Settings → General → VPN & Device Management**

## Usage

1. Run `python3 server/relay.py` on your Mac
2. Find your Mac's local IP (System Settings → Wi-Fi → Details)
3. In the iPhone app, type the Mac's IP and tap **Connect**, then **Start AR**
4. In `armctl.html`, connect to `ws://localhost:8765` from the LiDAR section

## How it works

```
iPhone (ARKit + Vision)
   ↓ {x, y, z} JSON @ 30fps
WebSocket ws://MAC_IP:8765
   ↓ relay.py forwards to all clients
   ↓
armctl.html (browser, ws://localhost:8765)
   → solveIK(x, y, z)
   → MOVE commands over WebSerial
   → Arduino → DM556 / A4988 → motors
```

The phone reads the 2D wrist position via Vision's `VNDetectHumanHandPoseRequest`, samples the LiDAR depth at that pixel, and unprojects to 3D world coordinates using the camera intrinsics.
