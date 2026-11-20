// AR Wing Pro left-pocket airspeed mount. Units are millimetres.
// Select "saddle" or "cradle" to export an individual part.
part = "both";
$fn = 72;

// Vent bridge. Negative X faces the nose, Y crosses the vent.
vent_span = 22; // Photo estimate with clearance at the sides.
bridge_height = 7;
bridge_thickness = 2.5;
pad_length = 18;
pad_width = 7;
foam_crown = 1.2; // Estimated crosswise rise over the full width of the feet.
foam_lengthwise_crown = 0.35; // Estimated front-to-back rise over one foot.
glue_tab_length = 9;
glue_tab_width = 3.6;
glue_tab_depth = 2; // Depth below each curved shoulder.

// Round PT40 shaft saddle.
tube_diameter = 4.5;
tube_clearance = 0.3; // Diametral clearance.
saddle_length = 12;
saddle_width = 11;
tie_width = 2.5;
tie_thickness = 1.2;

// Shallow support for the black rear manifold.
manifold_diameter = 9.5; // Read from the photo annotation. Confirm with calipers.
manifold_clearance = 0.4;
manifold_seat_length = 8;

// Sensor envelope. X is across the board, Y runs toward the hose exit.
board_width = 20;
board_length = 22;
board_clearance = 0.4;
strap_width = 3;
strap_thickness = 0.8;
strap_offset = -7; // Rear of the board, away from the upward-facing ports.
cradle_floor = 1.8;
connector_slot_width = 10; // Centred on the inboard PCB edge. Check the plug width.

module rounded_plate(length, width, height, radius) {
    linear_extrude(height)
        offset(r = radius)
            square([length - 2 * radius, width - 2 * radius], center = true);
}

module glue_pad() {
    linear_extrude(bridge_height + 0.25)
        hull() {
            translate([-pad_length / 2 + pad_width / 2, 0])
                circle(d = pad_width);
            translate([pad_length / 2 - 1, 0])
                circle(r = 1);
        }
}

module bridge_deck(total_width) {
    // Keep a flat centre for the pipe saddle and round the exposed edges.
    flat_half_length = saddle_length / 2;
    translate([0, 0, bridge_height])
        rotate([90, 0, 0])
            linear_extrude(total_width - 1, center = true)
                hull() {
                    // Small nose radius, flat saddle landing, and a thin tail.
                    translate([-flat_half_length - 0.5, 1])
                        circle(r = 1);
                    for (x = [-flat_half_length + 1.2, flat_half_length - 1.2])
                        translate([x, bridge_thickness / 2])
                            circle(d = bridge_thickness);
                    translate([flat_half_length + 5.5, 0.5])
                        circle(r = 0.5);
                }
}

module pipe_saddle(deck_top, shaft_axis_z) {
    bore = tube_diameter + tube_clearance;
    groove_z = shaft_axis_z + tube_clearance / 2;
    tie_slot_height = tie_thickness + 0.35;

    difference() {
        translate([0, 0, deck_top - 0.15])
            rounded_plate(saddle_length, saddle_width, groove_z - deck_top + 0.15, 1.7);
        translate([0, 0, groove_z])
            rotate([0, 90, 0])
                cylinder(d = bore, h = saddle_length + 2, center = true);
        // Crosswise passage for a tie that wraps over the tube.
        translate([-(tie_width + 0.45) / 2, -saddle_width / 2 - 1, deck_top + 0.45])
            cube([tie_width + 0.45, saddle_width + 2, tie_slot_height]);
    }
}

module manifold_support(shaft_axis_z) {
    seat_diameter = manifold_diameter + manifold_clearance;
    seat_centre_x = saddle_length / 2 + 0.4 + manifold_seat_length / 2;
    support_base = bridge_height + 0.8;
    support_top = shaft_axis_z - seat_diameter / 2 + 0.6;
    front_overlap = 1;
    support_width = 8;

    difference() {
        // Stop below the side tab and ahead of both hose barbs.
        translate([seat_centre_x - front_overlap / 2, 0, support_base])
            rounded_plate(manifold_seat_length + front_overlap, support_width,
                support_top - support_base, 0.8);
        translate([seat_centre_x, 0, shaft_axis_z])
            rotate([0, 90, 0])
                cylinder(d = seat_diameter, h = manifold_seat_length + 4, center = true);
    }
}

function crown_height(position, half_chord, rise) =
    rise == 0 ? 0 :
        let(radius = (half_chord * half_chord + rise * rise) / (2 * rise))
        rise - position * position / (radius + sqrt(radius * radius - position * position));

module foam_clearance(total_width) {
    // Sweep the crosswise arc along the lengthwise arc. The cutter models
    // the foam beside the vent, which is where the two feet make contact.
    x_limit = pad_length / 2 + 0.5;
    y_limit = total_width / 2 + 0.5;
    cross_section = [for (step = [32:-1:0])
        let(y = -y_limit + 2 * y_limit * step / 32)
        [y, crown_height(y, total_width / 2, foam_crown)]];

    hull()
        for (step = [0:12])
            let(x = -x_limit + 2 * x_limit * step / 12,
                rise = crown_height(x, pad_length / 2, foam_lengthwise_crown))
            translate([x, 0, rise])
                multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
                    linear_extrude(0.02, center = true)
                        polygon(concat([[-y_limit, -2], [y_limit, -2]], cross_section));
}

module saddle() {
    deck_top = bridge_height + bridge_thickness;
    shaft_axis_z = deck_top + 3 + tube_diameter / 2;
    total_width = vent_span + 2 * pad_width;
    union() {
        difference() {
            union() {
                for (side = [-1, 1])
                    translate([0, side * (vent_span + pad_width) / 2, 0])
                        glue_pad();

                bridge_deck(total_width);
                pipe_saddle(deck_top, shaft_axis_z);
                manifold_support(shaft_axis_z);
            }

            if (foam_crown > 0 || foam_lengthwise_crown > 0)
                foam_clearance(total_width);
        }

        // The tabs enter shallow pockets. Their ends follow the foam profile
        // at a constant depth, while the shoulders seat on the original skin.
        if (glue_tab_depth > 0)
            difference() {
                for (side = [-1, 1])
                    translate([-2, side * (vent_span + pad_width) / 2, -glue_tab_depth - 0.5])
                        rounded_plate(glue_tab_length, glue_tab_width, glue_tab_depth + 2.8, 0.5);
                translate([0, 0, -glue_tab_depth])
                    foam_clearance(total_width);
            }
    }
}

module cradle() {
    floor_height = cradle_floor;
    rail_height = 1.5;
    opening = board_width + 2 * board_clearance;
    length = board_length + 2 * board_clearance + 2;
    width = opening + 9;
    strap_slot_x = opening / 2 + 2.1;
    rail_x = opening / 2 + 0.65;
    rail_start = connector_slot_width / 2 + 0.4;
    rail_end = board_length / 2 - 1.1;

    difference() {
        union() {
            rounded_plate(width, length, floor_height, 2);
            translate([-rail_x, 0, floor_height - 0.01])
                rounded_plate(1.3, board_length * 0.55, rail_height + 0.01, 0.35);
            // The centred connector exits between the two inboard rails.
            for (end = [-1, 1])
                translate([rail_x, end * (rail_start + rail_end) / 2,
                    floor_height - 0.01])
                    rounded_plate(1.3, rail_end - rail_start, rail_height + 0.01, 0.35);
        }
        translate([board_width / 2 - 0.3, -connector_slot_width / 2, -0.1])
            cube([width / 2 - board_width / 2 + 1, connector_slot_width,
                floor_height + rail_height + 0.2]);
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
