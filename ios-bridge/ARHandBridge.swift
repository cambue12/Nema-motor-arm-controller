// ARHandBridge.swift — paste into ContentView.swift, delete ProjectNameApp.swift
// Info.plist needs: NSCameraUsageDescription = "Hand tracking"

import SwiftUI
import Combine
import ARKit
import Vision

@main
struct ARHandBridgeApp: App {
    var body: some Scene { WindowGroup { ContentView() } }
}

class HandServer: NSObject, ObservableObject, ARSessionDelegate {
    let arSession = ARSession()
    private var webSocket: URLSessionWebSocketTask?
    private var lastSendTime = Date.distantPast

    @Published var status = "Enter your Mac's IP, then tap Connect + Start AR"
    @Published var coords  = "— — —"
    @Published var macIP   = "192.168.0."

    override init() { super.init(); arSession.delegate = self }

    func connect() {
        let addr = macIP.trimmingCharacters(in: .whitespaces)
        guard let url = URL(string: "ws://\(addr):8765") else { status = "Invalid IP"; return }
        webSocket?.cancel()
        webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket?.resume()
        status = "Connecting to \(addr):8765 …"
        webSocket?.sendPing { [weak self] err in
            DispatchQueue.main.async {
                self?.status = err == nil
                    ? "● Connected to \(addr):8765"
                    : "✗ Failed: \(err!.localizedDescription)"
            }
        }
    }

    func startAR() {
        let config = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics = .sceneDepth
        }
        arSession.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    func stop() {
        arSession.pause()
        webSocket?.cancel(); webSocket = nil
        status = "Stopped"
    }

    // MARK: ARSessionDelegate

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let now = Date()
        guard now.timeIntervalSince(lastSendTime) >= 1.0 / 30.0 else { return }
        lastSendTime = now

        // 2D hand pose via Vision
        let req = VNDetectHumanHandPoseRequest()
        req.maximumHandCount = 1
        let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .right)
        try? handler.perform([req])
        guard let obs  = req.results?.first,
              let wrist = try? obs.recognizedPoint(.wrist),
              wrist.confidence > 0.35 else { return }

        // Vision → image pixel coords (origin top-left, y-down)
        let iW = Double(CVPixelBufferGetWidth(frame.capturedImage))
        let iH = Double(CVPixelBufferGetHeight(frame.capturedImage))
        let px = wrist.x * iW
        let py = (1.0 - wrist.y) * iH

        // LiDAR depth at that pixel
        var depth: Float = 0.6
        if let sd = frame.sceneDepth {
            depth = sampleDepth(sd.depthMap, px: px, py: py, iW: iW, iH: iH) ?? depth
        }

        // Unproject pixel + depth → camera space → world space (metres)
        let c  = frame.camera.intrinsics
        let xCam =  (Float(px) - c[2][0]) * depth / c[0][0]
        let yCam = -(Float(py) - c[2][1]) * depth / c[1][1]   // flip y
        let zCam = -depth
        let world = frame.camera.transform * SIMD4<Float>(xCam, yCam, zCam, 1)

        // Send mm to relay
        let x = world.x * 1000, y = world.y * 1000, z = world.z * 1000
        let json = String(format: "{\"x\":%.1f,\"y\":%.1f,\"z\":%.1f}", x, y, z)
        webSocket?.send(.string(json)) { _ in }

        DispatchQueue.main.async {
            self.coords = String(format: "X:%+.0f  Y:%+.0f  Z:%+.0f mm", x, y, z)
        }
    }

    private func sampleDepth(_ buf: CVPixelBuffer,
                              px: Double, py: Double, iW: Double, iH: Double) -> Float? {
        let dW = CVPixelBufferGetWidth(buf), dH = CVPixelBufferGetHeight(buf)
        let dx = Int(px / iW * Double(dW)), dy = Int(py / iH * Double(dH))
        guard dx >= 0, dy >= 0, dx < dW, dy < dH else { return nil }
        CVPixelBufferLockBaseAddress(buf, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(buf, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(buf) else { return nil }
        let v = base.assumingMemoryBound(to: Float32.self)[dy * dW + dx]
        return (v.isFinite && v > 0.05 && v < 5.0) ? v : nil
    }
}

// MARK: - Views

struct ContentView: View {
    @StateObject var server = HandServer()

    var body: some View {
        VStack(spacing: 18) {
            Text("ARHand Bridge").font(.largeTitle.bold())

            Text(server.status)
                .font(.callout).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal)

            Text(server.coords)
                .font(.system(.title3, design: .monospaced))
                .padding(8).background(.quaternary)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            ARPreview(session: server.arSession)
                .aspectRatio(4/3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
                TextField("Mac IP  e.g. 192.168.0.5", text: $server.macIP)
                    .textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
                Button("Connect") { server.connect() }
                    .buttonStyle(.borderedProminent)
            }.padding(.horizontal)

            HStack(spacing: 16) {
                Button("Start AR") { server.startAR() }.buttonStyle(.borderedProminent)
                Button("Stop")     { server.stop()    }.buttonStyle(.bordered)
            }

            Text("Run relay.py on your Mac first\nMac IP: System Settings → Wi-Fi → Details")
                .font(.caption).foregroundStyle(.tertiary).multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct ARPreview: UIViewRepresentable {
    let session: ARSession
    func makeUIView(context: Context) -> ARSCNView {
        let v = ARSCNView(frame: .zero)
        v.session = session; v.autoenablesDefaultLighting = true; return v
    }
    func updateUIView(_ v: ARSCNView, context: Context) {}
}
