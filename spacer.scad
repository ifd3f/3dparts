height = 25;
inner_diameter = 6.5;
thickness = 4;
$fn = 100;

difference() {
    cylinder(d = inner_diameter + thickness, h = height);
    cylinder(d = inner_diameter, h = height);
}