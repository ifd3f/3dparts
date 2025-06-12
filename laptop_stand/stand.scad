make_left_tabs = true;
make_right_tabs = true;
make_laptop_walls = true;

base_height = 15;
base_width = 80;
base_depth = 150;
base_rounding = 10;

tab_outer_width = 20;
tab_inner_width = 15;
tab_length = 7.5;

laptop_wall_thickness = 20;
laptop_wall_height = 50;
laptop_thickness = 20;
laptop_inset = 20;
laptop_wall_rounding = 2;

tab_outside_offset = 10;
tab_mating_tolerance = 0.1;

$fs = 0.1;

module tab(expand = 0) {
    points = [
        [0, tab_inner_width / 2],
        [tab_length, tab_outer_width / 2],
        [tab_length, -tab_outer_width / 2],
        [0, -tab_inner_width / 2]
    ];
    
    mirror([0, 0, 1]) linear_extrude(height=base_height) 
        if (expand == 0) {
            polygon(points);
        } else {
            hull() {
                for (p = points) {
                    translate(p) circle(r = expand);
                }
            }
        }
}

module wall_profile() {
    module triangle() {
        top_point = [laptop_wall_rounding, laptop_wall_height - laptop_wall_rounding];
        translate([laptop_thickness / 2, 0]) hull() {
            translate(top_point) circle(r = laptop_wall_rounding);
            polygon([
                top_point,
                [laptop_wall_thickness, 0],
                [0, 0]
            ]);
        }
    }
    union() {
        triangle();
        mirror([1, 0]) triangle();
    }
}

module base_body() {
    x = base_width / 2 - base_rounding;
    y1 = base_rounding;
    y2 = base_depth - base_rounding;
    right_points = [
        [x, y1],
        [x, y2],
    ];

    module right_side(has_tabs) {
        if (has_tabs) {
            cube([base_width / 2, base_depth, base_height]);
        } else {
            for (p = right_points) {
                translate(p) cylinder(h = base_height, r = base_rounding);
            }
        }
    }

    mirror([0, 0, 1]) hull() {
        right_side(make_right_tabs);
        mirror([1, 0, 0]) right_side(make_left_tabs);
    }
}

module main_body() {
    base_body();
    if (make_laptop_walls) {
        mirror([0, 1, 0]) rotate(90, [1, 0, 0]) linear_extrude(base_depth) wall_profile();
    }
}

outsidemost_tab_y = tab_length + tab_outside_offset;

module right_tabs() {
    translate([base_width/2, outsidemost_tab_y, 0]) tab();
    translate([base_width/2, base_depth - outsidemost_tab_y, 0]) tab();
}

module left_tab_negatives() {
    translate([-base_width/2, outsidemost_tab_y, 0]) tab(tab_mating_tolerance);
    translate([-base_width/2, base_depth - outsidemost_tab_y, 0]) tab(tab_mating_tolerance);
}

difference(){
    union() {
        main_body();
        if (make_right_tabs) {
            right_tabs();
        }
    }
    if (make_left_tabs) {
        left_tab_negatives();
    }
}
