# Safety

These motors are strong — especially the NEMA 23 with the 5:1 planetary gearbox at the shoulder. A runaway move can break printed parts, snap fingers, or rip cables out. The safety system is designed to fail closed.

## Hard limits (hardcoded — no UI override)

- **80 steps per single MOVE command** — the firmware can't be told to do more in one shot.
- **Joint angle clamps** — `Math.max(min, Math.min(max, val))` on every `setJoint` call.
- **Sync interval pauses while sliders are being dragged** — prevents buffer flooding.

## Soft limits (UI-controllable)

- **Safety profile selector** in the bottom bar:
  - `SAFE` (default) — speed 60, accel 30
  - `NORMAL` — speed 140, accel 80
  - `FAST` — speed 240, accel 160
- The selected profile is sent to the firmware via `SET SPEED` / `SET ACCEL` on every connect and re-applied after E-Stop is cleared.

## Confirmation gates

The big modal asks "Are you sure?" before:

- Applying any **preset** that moves a joint by more than 35°
- Releasing any **slider** more than 35° away from the current position

## Panic stops

| Trigger | Effect |
|---------|--------|
| `SPACEBAR` | `STOP ALL` + `DISABLE ALL`, drivers off, `lastSentSteps` resync, motion banner cleared |
| Red **STOP** button | Same as spacebar |
| **STOP ALL** in the bottom bar | Sends `STOP ALL` and resyncs the step tracking |
| Disconnecting USB | Drivers de-energise, arm holds via gear friction |

## What happens during E-Stop

1. All running activities/test moves/camera modes are stopped immediately
2. `lastSentSteps[]` is snapped to the current target so when E-Stop clears, the system doesn't re-send a queue of buffered moves
3. `STOP ALL` and `DISABLE ALL` go to the firmware
4. Toast notification appears
5. UI reflects E-Stop state until manually cleared

## After clearing E-Stop

Drivers stay OFF until you click **ENABLE** again. The safety profile is re-pushed to the firmware. You'll need to manually re-enable drivers before any movement.
