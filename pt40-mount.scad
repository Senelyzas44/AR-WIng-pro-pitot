// AR Wing Pro left-pocket airspeed mount. Units are millimetres.
// Select "saddle" or "cradle" to export an individual part.
part = "both";
$fn = 72;

// Vent bridge. X follows the probe, Y crosses the vent.
vent_span = 22; // Estimate from the 20 mm photo annotation, plus side clearance.
hose_clearance = 10; // Extra room for the hoses to descend into the vent.
pad_length = 18;
pad_width = 7;
bridge_thickness = 3;
tab_length = 11; // Prototype estimate. Measure the flat factory ear.
tab_width = 8;
tab_clearance = 0.35;
probe_axis_offset = 5; // Lateral distance from the probe axis to the tab centre.
mirror_tab = false;

// Sensor envelope. X is across the board, Y runs toward the hose exit.
board_width = 20;
board_length = 22;
board_clearance = 0.4;
strap_width = 3;
strap_thickness = 0.8;
strap_offset = -7; // Rear of the board, away from the upward-facing ports.
cradle_floor = 1.8;

module rounded_plate(length, width, height, radius) {
    linear_extrude(height)
        offset(r = radius)
            square([length - 2 * radius, width - 2 * radius], center = true);
}

module tab_seat(z) {
    difference() {
        translate([0, 0, z - 0.1])
            rounded_plate(tab_length + 2, tab_width + 2, 1.1, 1);
        // The probe body overhangs the open side of the ear seat.
        translate([-tab_length / 2 - tab_clearance, -tab_width / 2 - 2, z])
            cube([tab_length + 2 * tab_clearance,
                tab_width + tab_clearance + 2, 1.2]);
    }
}

module saddle() {
    deck_top = hose_clearance + bridge_thickness;
    union() {
        for (side = [-1, 1])
            translate([0, side * (vent_span + pad_width) / 2, 0])
                rounded_plate(pad_length, pad_width, hose_clearance + 0.1, 1.5);

        translate([0, 0, hose_clearance])
            rounded_plate(tab_length + 3, vent_span + 2 * pad_width,
                bridge_thickness, 1.5);

        if (mirror_tab)
            mirror([0, 1, 0])
                translate([0, probe_axis_offset, 0]) tab_seat(deck_top);
        else
            translate([0, probe_axis_offset, 0]) tab_seat(deck_top);
    }
}

module cradle() {
    floor_height = cradle_floor;
    rail_height = 1.5;
    opening = board_width + 2 * board_clearance;
    length = board_length + 2 * board_clearance + 2;
    width = opening + 9;
    strap_slot_x = opening / 2 + 2.1;

    difference() {
        union() {
            rounded_plate(width, length, floor_height, 2);
            // Short rails leave the board ends accessible.
            for (side = [-1, 1])
                translate([side * (opening / 2 + 0.65), 0,
                    floor_height - 0.01])
                    rounded_plate(1.3, board_length * 0.55,
                        rail_height + 0.01, 0.35);
        }
        // Feed the strap through the under-floor tunnel before gluing.
        translate([-strap_slot_x - 0.8, strap_offset - strap_width / 2, -0.01])
            cube([2 * strap_slot_x + 1.6, strap_width, strap_thickness + 0.01]);
        for (side = [-1, 1])
            translate([side * strap_slot_x - 0.8, strap_offset - strap_width / 2, -0.1])
                cube([1.6, strap_width, floor_height + 0.2]);
    }
}

if (part == "saddle") saddle();
if (part == "cradle") cradle();
if (part == "both") {
    saddle();
    translate([36, 0, 0]) cradle();
}
