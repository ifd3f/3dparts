$fs = 0.05;

diameter = 95;
leg_diameter = 10;
clearance = 30;
thickness = 2;
legs = 6;
mesh_void_diameter = 10;
mesh_fill_thickness = 2;
outer_thickness = 4;

module base() {
    union() {
        difference() {
            cylinder(d = diameter, h = thickness);
            mesh_holes();
        }
        difference() {
            cylinder(d = diameter, h = thickness);
            cylinder(d = diameter - outer_thickness, h = thickness);
        }
    }
}

module legs() {
    for (i = [1:legs]) {
        rotate([0, 0, 360 * i / legs])
            translate([diameter / 2 - leg_diameter / 2, 0, 0])
                cylinder(h = clearance + thickness, d = leg_diameter);
    }
}

module mesh_holes() {
    // hexagonal tiling
    mesh_pitch = mesh_void_diameter + mesh_fill_thickness / 2;
    mesh_radial_count = ceil(diameter / 2 / mesh_pitch);
    for (x = [-mesh_radial_count:mesh_radial_count]) {
        for (y = [-mesh_radial_count:mesh_radial_count]) {
            tx = x + y / 2;
            ty = y;
            translate(mesh_pitch * [tx, ty, 0])
                cylinder(h = thickness, d = mesh_void_diameter);
        }
    }
}

union() {
    translate([0, 0, clearance]) base();
    legs();
}

//mesh_holes();
