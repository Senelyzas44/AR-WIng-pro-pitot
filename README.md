# AR Wing Pro PT40 mount

A two-piece glue-on mount for the Holybro PT40 pitot tube and MS5525DSO airspeed sensor on the SonicModell AR Wing Pro.

- [Round pipe holder STL](pitot-vent-bridge.stl) has a 4.8 mm open groove for the measured 4.5 mm PT40 shaft. Two curved glue pads straddle the existing vent. A 2.5 mm cable tie threads through the holder and wraps over the tube.
- [Sensor cradle STL](sensor-cradle.stl) holds the sensor flat on the plywood ahead of the ELRS receiver, with both pressure ports facing up.
- [OpenSCAD source](pt40-mount.scad) contains the part dimensions.

![Three-quarter assembly sketch](assembly-preview.png)

## Fit and assembly

Dry-fit the holder over the nose-side portion of the vent. The glue-pad spacing assumes a 22 mm opening and a 1.2 mm crown across the full 36 mm footprint, both estimated from photos. Adjust the OpenSCAD dimensions if either pad rocks or overlaps the vent. Use foam-safe adhesive on the pads.

Seat the shaft immediately ahead of the black manifold, with the probe pointing straight toward the nose. Thread a narrow cable tie through the crosswise slot and snug it around the shaft. Check that the tube cannot slide and that the static holes are exposed.

Feed a thin strap through the sensor cradle before gluing it to the plywood. With the board lying flat and its barbs up, route the two hoses through the rear of the vent behind the holder. Check for hose pinching with the hatch shut and ground clearance with the wing tilted nose-down.

## Export

```sh
openscad -o pitot-vent-bridge.stl -D 'part="saddle"' pt40-mount.scad
openscad -o sensor-cradle.stl -D 'part="cradle"' pt40-mount.scad
```
