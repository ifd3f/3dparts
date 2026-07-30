thickness = 1.5;
inset = 10;
curve_inner_radius = 5;
height = 15;
length = 145;

module side_profile() {
    translate([0, -thickness]) square([inset, thickness]);
    translate([0, curve_inner_radius]) rotate([0, 0, 180]) union() {
        intersection() {
            difference() {
                circle(r = curve_inner_radius + thickness);
                circle(r = curve_inner_radius);
            }
            square([curve_inner_radius + thickness, curve_inner_radius + thickness]);
        }
        translate([curve_inner_radius, -height]) square([thickness, height]);
    }
}

linear_extrude(length) side_profile();