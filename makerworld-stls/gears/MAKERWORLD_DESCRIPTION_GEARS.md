5:1 Planetary Gearbox — Sun & Planet Gears (NEMA 17 / NEMA 23)


A printable 5:1 reduction planetary gear set designed for high-torque robotic and mechanical applications. Includes the sun gear (driven by the motor) and the planet gears (4 needed for one gearbox stage). Pair with a printed ring gear and your own housing to build a complete planetary reduction.

These are the gears that drive the shoulder and elbow joints of my 4-axis robot arm — the shoulder runs a NEMA 23 through this reduction and is strong enough to lift several hundred grams at full extension.


Suggested model name

5:1 Planetary Gearbox Gears — Sun & Planet (NEMA 17 / 23 Compatible)

Or if you want something punchier, you could try:
Printable 5:1 Planetary Gear Set — Robot Arm Gearbox
High-Torque 5:1 Planetary Reduction (Sun + Planet Gears)
5:1 Planetary Gears for NEMA Stepper Motors


What's included

Sun_Gear (STL and F3D) — Centre driver gear that mounts on the motor shaft. Print 1 per gearbox.
Planet_Gear (STL and F3D) — Outer planet gear that rides between the sun and ring. Print 4 per gearbox.

Not included yet: the ring gear and housing. Those come with my full robot arm upload, or you can design your own to match.


Specs

Reduction ratio: 5 to 1
Module (gear tooth size): 1.25 mm
Sun gear: small centre gear, mounts to motor shaft
Planet gears: 4 needed, ride between sun and ring
Centre bore: 5.0 mm (suits common NEMA shaft adapters; adjustable in the customiser)


Customisation

The F3D files have these parameters exposed to the MakerWorld customiser, so you can tweak them before downloading:

Scale (default 1.0) — uniform scale multiplier
Tolerance (default 0.2 mm) — print clearance between meshing teeth; bump up if your printer is tight
BoreDiameter (default 5.0 mm) — centre bore diameter for motor shaft fit
modulus (default 1.25 mm) — gear module; change at your own risk since it must match the ring gear


Print settings

Material: PETG strongly recommended. PLA wears out fast under load. ABS works if you've got the chamber for it.
Layer height: 0.16 mm (finer is better for tooth surface finish)
Walls: 4 perimeters
Infill: 100 percent — these gears take real load
Supports: none needed if printed flat


What you'll need to assemble a complete gearbox

1 printed sun gear (this upload)
4 printed planet gears (this upload)
1 ring gear (printed; use your own or wait for my full release)
1 housing with planet carrier (printed)
5 M3 shoulder bolts or 5mm dowel pins for planet axles
1 thrust washer or bearing on the output shaft


Application

Designed for the shoulder and elbow joints of a 4-axis robot arm I'm building. The full project (browser control app, CAD, Arduino firmware, full BOM) is open-source on GitHub:

github.com/cambue12/Nema-motor-arm-controller

Also good for:
3D-printer extruder reductions
Telescope drive trains
Camera slider gearboxes
Any project where you want significant torque multiplication out of a NEMA stepper


Notes

The 5 to 1 ratio is the standard single-stage planetary output. If you want higher reduction (25 to 1, 125 to 1) you can stack stages — same gears, just chain the carrier output of one stage into the sun input of the next.

These print best in PETG with 100 percent infill. I tried PLA first and they wore out within a few hours of testing under load. PETG has held up indefinitely so far.

Tooth face finish matters. Print at 0.16 mm or thinner if you can. Sanding the teeth lightly with 400-grit afterward dramatically reduces noise.


Credits and License

Designed in Fusion 360. MIT licensed.

If you build a gearbox with these, drop a print log photo or tag me — would love to see other applications.
