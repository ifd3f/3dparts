thickness = 1.5;
mount_inset = 10;
curve_inner_radius = 5;
bumper_rise_height = 15;
instrument_length = 145;
corner_fillet_radius = 5;

/**
    A rectangle where only two of the corners are rounded.
    The rounded corners are at (w, 0) and (w, h).
*/
module semirounded_rect(w, h, r) {
    square([w, h - r]);
    translate([r, 0]) square([w - 2 * r, h]);
    translate([r, h - r]) circle(r = r);
    translate([w - r, h - r]) circle(r = r);
}

module quarter_donut(r1, r2) {
    rads = r1 < r2
        ? [r1, r2]
        : [r2, r1];
    
    ri = rads[0];
    ro = rads[1];
        
    intersection() {
        difference() {
            circle(r = ro);
            circle(r = ri);
        }
        square([ro, ro]);
    }
}

linear_extrude(instrument_length, center = true) quarter_donut(corner_fillet_radius, corner_fillet_radius + thickness);
translate([0, corner_fillet_radius + thickness / 2, 0]) rotate([90, 90, 180]) linear_extrude(thickness, center = true) translate([-instrument_length / 2, 0]) semirounded_rect(instrument_length, bumper_rise_height, corner_fillet_radius);
translate([corner_fillet_radius + thickness / 2, 0, 0]) rotate([0, 90, 180]) linear_extrude(thickness, center = true) translate([-instrument_length / 2, 0]) semirounded_rect(instrument_length, mount_inset, corner_fillet_radius);
