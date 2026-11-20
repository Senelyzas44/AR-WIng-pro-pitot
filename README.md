# AR Wing Pro PT40 mount

A two-piece glue-on mount for the Holybro PT40 pitot tube and MS5525DSO airspeed sensor on the SonicModell AR Wing Pro.

- [Round pipe holder STL](pitot-vent-bridge.stl) is exported nose-down for printing. It has a 4.8 mm open groove for the measured 4.5 mm PT40 shaft. The low bridge has a rounded leading edge and a longer, thinner tail taper. Two curved shoulders straddle the existing vent, with shallow glue tabs that recess into the foam. A 2.5 mm cable tie wraps over the tube. An integral rear cradle supports the black plastic manifold.
- [Sensor cradle STL](sensor-cradle.stl) holds the sensor flat on the plywood ahead of the ELRS receiver, with both pressure ports facing up. The inboard edge and both ends have centred 10 mm plug openings.
- [OpenSCAD source](pt40-mount.scad) contains the part dimensions.

![Three-quarter assembly sketch](assembly-preview.png)

## Printing the bridge

Keep the STL in its supplied orientation, with the flat nose face on the bed. The vent passage builds sideways in this orientation, and the shaft saddle and glue tabs have ramps to reduce overhangs. The tie tunnel has a pointed end in the build direction so it closes gradually. Start with 0.2 mm layers and check the tie tunnel in the slicer preview before adding supports.

## Fit and assembly

Dry-fit the holder over the nose-side portion of the vent. The bridge spans 22 mm between its feet and has a nominal 5.5 mm opening above the glue-pad datum. Dry-fit both hoses through the vent before gluing, since their clearance depends on the foam profile and hose diameter. Both glue pads sit on solid foam beside the recess. The starting profiles assume a 1.2 mm rise across the full 36 mm footprint and a 0.35 mm rise front to back over 18 mm. These are estimates. Use a straightedge across and along the mounting spot to check the profiles, and adjust the two crown settings and vent span in OpenSCAD if either pad rocks or overlaps the lip. Mark the actual tab positions from the print before cutting. Each tab is 9 × 3.6 mm in plan and extends 2 mm below the curved shoulder. Check the available foam thickness before making the shallow pockets, then use foam-safe adhesive inside them. Keep the rounded edge toward the nose and seat the shoulders flush with the skin.

Seat the shaft immediately ahead of the black manifold, with the probe pointing straight toward the nose. Thread a narrow cable tie through the crosswise slot and snug it around the shaft. The 9.5 mm long rear cradle is sized for an estimated 9.5 mm manifold diameter and includes about 0.2 mm of radial fit clearance. Check that the body sits in the cradle without contacting its factory tab or either hose barb. If there is a small gap, use a thin compliant shim under the body. Check that the tube cannot slide and that the static holes are exposed.

Feed a thin strap through the sensor cradle before gluing it to the plywood. Lay the sensor flat with the pressure ports up and align its centred edge connector with the opening that gives the cable a clear route toward the main electronics bay. Check the opening against the actual plug and keep the retaining strap behind it. Once the connector is seated, route the two pressure hoses through the rear of the vent behind the holder. Check for hose pinching with the hatch shut and ground clearance with the wing tilted nose-down.

## Export

```sh
openscad -o pitot-vent-bridge.stl -D 'part="print_saddle"' pt40-mount.scad
openscad -o sensor-cradle.stl -D 'part="cradle"' pt40-mount.scad
```
