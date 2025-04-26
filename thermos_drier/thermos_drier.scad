$fs = 1;
$fa = 1;

neck_diameter = 90;
thickness = 7.5;
height = 100;
base_diameter = 130;
hole_count = 12;
hole_height = 80;
hole_width = 20;

module main_shape() {
    union() {
        rotate_extrude() {
            translate([neck_diameter / 2, 0, 0]) circle(d = thickness);
        }

        difference() {
            translate([0, 0, -height]) cylinder(h = height, d1 = base_diameter, d2 = neck_diameter + thickness);
            translate([0, 0, -height]) cylinder(h = height + thickness, d1 = base_diameter - thickness, d2 = neck_diameter - thickness);
        }
    }
}

module holes() {
    hw2 = hole_width / 2;
    profile = [
        [-hw2, 0],
        [hw2, 0],
        [hw2, hole_height - hw2],
        [0, hole_height],
        [-hw2, hole_height - hw2],
    ];
    
    for (i = [0:hole_count]) {
        a = i * 360 / hole_count;
        //rotate([0, 0, a]) translate([0, 0, -height / 2]) cube([base_diameter + thickness, hole_width, hole_height], center = true);
        rotate([0, 0, a]) translate([0, 0, -(height + hole_height) / 2]) rotate([90, 0, 0]) linear_extrude(base_diameter / 2) polygon(profile);
    }
}

difference() {
    main_shape();
    holes();
}