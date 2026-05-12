# Software Architecture

## How a click becomes a motor step

```
User drags slider
   ↓ input event
changeJoint(key, value)        ← updates J[key] (the simulation target)
   ↓ updates 3D model + UI

Slider released (change event)
   ↓
sliderReleased(key)
   ↓
sendJointHW(key)               ← computes integer-step delta from lastSentSteps
                                 → caps to MAX_STEPS_PER_CMD (80)
                                 → "MOVE A 22\r\n" out the WebSerial port
   ↓
Arduino firmware
   ↓
DM556 / A4988
   ↓
Motor turns

(in parallel)
100 ms sync interval ──→ sendAllJointsHW()  ← chunks any remaining delta to hardware
                                              until lastSentSteps == jointTargetSteps
```

## Forward kinematics

`computeFK(j)` uses the same convention as the Three.js scene graph:

- `rotGroup.rotation.y = -j.X`  (base)
- `upperArmGroup.rotation.x = +j.Y`  (shoulder)
- `forearmGroup.rotation.x = +j.Z`  (elbow)
- `wristGroup.rotation.y = +j.A`  (wrist roll)

World direction of the upper arm is:
```
armDir = (-sin(sa)*sin(ba), cos(sa), +sin(sa)*cos(ba))
```

EE position is then `shoulder + L1·armDir + (L2+L3)·foreDir`.

## Inverse kinematics

`solveIK(tx, ty, tz, fallbackBase)` is a 2-link planar IK using the law of cosines:

1. `R = sqrt(tx² + tz²)` — projected distance in the floor plane
2. `Ht = ty - shoulderPivotY`
3. `baseDeg = atan2(-tx, tz)` (matches the FK convention above)
4. Clamp `d = sqrt(R² + Ht²)` to the reachable sphere radius `(L1 + L2 + L3) * 0.97`
5. Elbow: `acos((d² - L1² - L23²) / (2·L1·L23))`
6. Shoulder: `atan2(R, Ht) − atan2(L23·sin(elbow), L1 + L23·cos(elbow))`

A singularity guard kicks in when the target is within 25mm of the vertical axis — it falls back to the previous base angle and blends `R` smoothly to avoid the arm spinning wildly.

## Safety system

Layered defences against the strong NEMA 23 / planetary-geared joints:

1. **`MAX_STEPS_PER_CMD = 80`** — every single MOVE command is capped. Big simulation jumps get chunked across the 100ms sync ticks.
2. **Safety profiles** (`SAFE / NORMAL / FAST`) push conservative `SET SPEED` and `SET ACCEL` to the firmware on connect.
3. **Confirmation modal** for any preset or slider release that would move a joint by more than 35°.
4. **Per-axis motion tracking** — banner appears at top showing which axes are still moving.
5. **`SPACEBAR` panic stop** — sends `STOP ALL`, disables drivers, snaps `lastSentSteps` to current `J` so the queue can't ambush you.
6. **`STOP ALL` resync** — local `lastSentSteps` re-sync prevents the sync loop from re-firing the moves the firmware just discarded.
7. **Slider drag pause** — the 100ms sync interval pauses while any slider is being dragged, preventing command queue buildup.

## Activities

Defined as keyframe arrays in `ACTIVITIES`. Each keyframe is `{X, Y, Z, A, CLAW, d}` where `d` is the duration in seconds for the smooth transition into that pose. `loops:true` activities cycle indefinitely.

```javascript
{name:'wave', label:'Wave', loops:false, kf:[
  {X:40, Y:55, Z:30, A:0,   CLAW:20, d:.7},
  {X:40, Y:55, Z:30, A:70,  CLAW:40, d:.3},
  {X:40, Y:55, Z:30, A:-70, CLAW:20, d:.3},
  ...
]}
```

The interpolation uses a smoothstep curve (`ssf(t) = t*t*(3 - 2*t)`) for natural ease-in/ease-out.
