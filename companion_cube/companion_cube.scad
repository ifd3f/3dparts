// Modified from https://www.thingiverse.com/thing:2550501 to have a hole to put a ball bearing in.

$fs = .5;
$fa = .5;

size = 50;

ball_bearing_diam = 19.05;
ball_bearing_spacing = 0.05;

gray = false;
white = false;
pink = false;

scalloped_edge_width = .0629 * size;

face_divot_depth = .0633 * size;
face_divot_outer_radius = .4118 * size;
face_divot_inner_radius = .3249 * size;

face_button_outer_radius = (.3870 / 2) * size;
face_button_height = .0423 * size;

edge_divot_lower_width = .2874 * size;
edge_divot_upper_width = .4118 * size;

edge_bump_height = .0192 * size;
edge_bump_width = .2246 * size;
edge_bump_outer_scalloped_edge_width = .0293 * size;
edge_bump_scallop_rotation = 48.23566717;
edge_bump_scallop_inclination = 31.17288265;
edge_bump_length_to_scallop = 0.0900267225 * size;

channel_lower_width = .0127 * size;
channel_upper_width = .0256 * size;
channel_depth = .0126 * size;

module mirror_duplicate(plane) {
    children();
    mirror(plane) children();
}

module rotate_duplicate(rotation) {
    children();
    rotate(rotation) children();
}

function vector(direction, magnitude) = magnitude * direction / norm(direction);

module centered_cube(dimensions, centered_x, centered_y, centered_z) {
    translate([centered_x?-dimensions[0]/2:0, centered_y?-dimensions[1]/2:0, centered_z?-dimensions[2]/2:0]) cube(dimensions);
}

module orient_to(origin, normal) {   
      translate(origin)
      rotate([0, 0, atan2(normal.y, normal.x)]) //rotation
      rotate([0, atan2(sqrt(pow(normal.x, 2)+pow(normal.y, 2)),normal.z), 0])
      children();
}

module oriented_cube(center_face_point, orientation, size) {
    translate(center_face_point) orient_to([0, 0, 0], orientation) centered_cube(size, true, true);
}

module full_box() {
    centered_cube([size, size, size], true, true, true);
}

module all_axes() {
    children();
    rotate([0, 90, 0]) children();
    rotate([90, 0, 0]) children();
}

module all_faces() {
    children();
    rotate([90, 0, 0]) children();
    rotate([180, 0, 0]) children();
    rotate([270, 0, 0]) children();
    rotate([180, 90, 0]) children();
    rotate([0, 90, 0]) children();
}

module all_edges() {
    mirror_duplicate([0, 0, 1]) {
        children();
        rotate([0, 0, 90]) children();
        rotate([0, 0, 180]) children();
        rotate([0, 0, 270]) children();
    }
    rotate([0, 90, 0]) children();
    rotate([0, 90, 90]) children();
    rotate([0, 90, 180]) children();
    rotate([0, 90, 270]) children();
}

module all_corners() {
    mirror_duplicate([0, 0, 1]) {
        children();
        rotate([0, 0, 90]) children();
        rotate([0, 0, 180]) children();
        rotate([0, 0, 270]) children();
    }
}

module scalloped_edge() {
    edge_dist = sqrt(2 * pow(size/2, 2));
    scalloping_cube_dist = edge_dist - scalloped_edge_width * tan(45) / 2;
    translate(vector([0, -1, 1], scalloping_cube_dist)) rotate([45, 0, 0])
        centered_cube([100, 100, 100], true, true, false);
}

module scalloped_corner() {
    corner_dist = sqrt(3 * pow(size/2, 2));
    scalloped_face_size = size - (2 * scalloped_edge_width) / (sqrt(2));
    scalloped_corner_points = [
        [-size / 2, -scalloped_face_size / 2, scalloped_face_size / 2],
        [-scalloped_face_size / 2, -size / 2, scalloped_face_size / 2],
        [-scalloped_face_size / 2, -scalloped_face_size / 2, size / 2]
    ];
    
    normal = cross(scalloped_corner_points[0] - scalloped_corner_points[1],
        scalloped_corner_points[0] - scalloped_corner_points[2]);
    
    oriented_cube(scalloped_corner_points[0], normal, [100, 100, 100]);
}

module face_divot() {
    slope = (face_divot_outer_radius - face_divot_inner_radius)/face_divot_depth;
    
    translate([0, 0, -size / 2 - 1]) 
        cylinder(face_divot_depth + 1,
            (face_divot_inner_radius) + (face_divot_depth + 1) * slope,
            face_divot_inner_radius);
}

module edge_divot() {
    slope = (edge_divot_upper_width/2 - edge_divot_lower_width/2)/face_divot_depth;
    
    height = face_divot_depth + 1;
    
    rotate_duplicate([0, 0, 90]) {
        translate([0, 0, -(size / 2) + face_divot_depth])
            rotate([-90, 0, 0]) translate([0, 0, -50]) linear_extrude(100) polygon([
                [-edge_divot_lower_width/2, 0],
                [edge_divot_lower_width/2, 0],
                [edge_divot_lower_width/2 + slope * height, height],
                [-edge_divot_lower_width/2 - slope * height, height]
            ]);
    
        // TODO: find/calculate the coordinates of corners and get rid of the magic constants, similar to scalloped_corner
        mirror_duplicate([0, 1, 0]) translate([0, -(size / 2) + face_divot_depth, -(size / 2) + face_divot_depth])
            rotate([-135, 0, 0]) translate([0, 0, -50]) linear_extrude(100) polygon([
                [-edge_divot_lower_width/2, 0],
                [edge_divot_lower_width/2, 0],
                [edge_divot_lower_width/2 + (slope + .08825) * height, height],
                [-edge_divot_lower_width/2 - (slope + .08825) * height, height]
            ]);
    }
}

module edge_bump() {
    total_width = (size / 2 - face_divot_depth + edge_bump_height) * 2;
    
    rotate_duplicate([0, 0, 90]) translate([0, 0, -(size / 2) + face_divot_depth - edge_bump_height]) difference() {
        centered_cube([edge_bump_width, total_width, edge_bump_height], true, true, false);
        edge_bump_scallop();
        edge_bump_inner_scallop();
        
        face_divot_column();
    }
}

module edge_bump_scallop() {
    total_width = (size / 2 - face_divot_depth + edge_bump_height) * 2;
    
    edge_dist = sqrt(pow(total_width/2, 2) + pow(edge_bump_height/2, 2));
    scalloping_cube_dist = edge_dist - edge_bump_outer_scalloped_edge_width * tan(45) / 2;
    
    mirror_duplicate([0, 1, 0]) translate([0, -scalloping_cube_dist, 0]) rotate([-45, 0, 0]) translate([0, 0, -size * 2])
        centered_cube([size * 2, size * 2, size * 2], true, true, false);
}

module edge_bump_inner_scallop() {
    mirror_duplicate([0, 1, 0]) mirror_duplicate([1, 0, 0]) translate([
            edge_bump_width / 2,
            (size / 2) - face_divot_depth - edge_bump_length_to_scallop,
            0])
        translate([0, 0, edge_bump_height]) rotate([0, 90 + edge_bump_scallop_inclination, -90+edge_bump_scallop_rotation])
            translate([-size / 10, 0, 0])
            centered_cube([size / 5, size / 5, size / 5], false, true, false);
}

module face_divot_column() {
    translate([0, 0, -(size + 1)/2]) cylinder(size + 1, face_divot_inner_radius, face_divot_inner_radius);
}

module edge_bump_surrounding_slits() {
    rotate_duplicate([0, 90, 0]) rotate_duplicate([0, 0, 90]) {
        slit_width = (edge_divot_lower_width - edge_bump_width) / 2;
        mirror_duplicate([1, 0, 0]) mirror([0, 0, 1]) rotate([0, 0, 90])
            translate([0, (edge_divot_lower_width - slit_width) / 2, 0])
                centered_cube([size, slit_width, size], true, true, true);
    }
}

module edge_bump_inner_scallop_hole() {
    rotate_duplicate([0, 0, 90]) translate([0, 0, -(size / 2) + face_divot_depth - edge_bump_height]) difference() {
        
        mirror_duplicate([0, 1, 0]) mirror_duplicate([1, 0, 0]) translate([
                edge_bump_width / 2,
                (size / 2) - face_divot_depth - edge_bump_length_to_scallop,
                0])
            translate([0, 0, edge_bump_height])
                rotate([0, 90, -90+edge_bump_scallop_rotation])
                translate([-size / 5 + .0001, -size * .02, 0])
                centered_cube([size / 5, size / 15, size / 35], false, true, false);
    }
}

module face_button() {
    translate([0, 0, -face_button_height/2 + -(size / 2) + face_divot_depth]) {
        
        cylinder(face_button_height/2,
            face_button_outer_radius,
            face_button_outer_radius);    
        
        rotate_extrude() translate([face_button_outer_radius - face_button_height/2, 0, 0])
            circle(face_button_height/2);
        translate([0, 0, -face_button_height/2]) {
            cylinder(face_button_height/2,
                face_button_outer_radius - face_button_height/2,
                face_button_outer_radius - face_button_height/2);
        }
    }
}

module channel() {
    rotate_duplicate([0, 0, 90]) translate([0, 0, -(size/2) + face_divot_depth + channel_depth]) {
        rotate([-90, 0, 0]) translate([0, 0, -size]) linear_extrude(size * 2) polygon([
            [-channel_lower_width / 2, 0],
            [channel_lower_width / 2, 0],
            [channel_upper_width, channel_depth * 2],
            [-channel_upper_width, channel_depth * 2]
        ]);
    }
}

module button_column() {
    translate([0, 0, -(size - face_divot_depth * 2 + .0001)/2]) cylinder(size - face_divot_depth * 2 + .0001, face_button_outer_radius, face_button_outer_radius);
    mirror_duplicate([0, 0, 1]) face_button();
}

module heart_column() {
    translate([0, 0, -(size - face_divot_depth * 2 + face_button_height * 2 + .0001) / 2]) linear_extrude(size - face_divot_depth * 2 + face_button_height * 2 + .0001) translate([0, -.75, 0]) scale([.7, .7]) polygon(
        points=
            [[-0.0, 4.483], [-1.221, 6.145], [-2.536, 7.132], [-4.605, 7.552], [-5.655, 7.416], [-6.585, 7.0], [-7.607, 6.133], [-8.349, 5.104], [-8.813, 3.91], [-9.006, 2.546], [-8.537, 0.279], [-7.896, -0.885], [-6.983, -1.8], [-4.727, -3.198], [-2.649, -4.676], [-0.0, -7.553], [-0.0, 4.483], [1.221, 6.145], [2.536, 7.132], [4.605, 7.552], [5.655, 7.416], [6.585, 7.0], [7.607, 6.133], [8.349, 5.104], [8.813, 3.91], [9.006, 2.546], [8.537, 0.279], [7.896, -0.885], [6.983, -1.8], [4.727, -3.198], [2.649, -4.676], [-0.0, -7.553]],
        paths=
            [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]]
    );
}

module inner_solid_cube() {    
    // leave only 7 .15 layers of white/pink of the top/bottom face, to minimize
    // the number of material changes in those areas
    
    vertical_size = size - face_divot_depth * 2 - (7*.15*2);
    centered_cube([size * .7, size * .7, vertical_size], true, true, true);
}

module white_parts() {    
    difference() {
        union() {
            difference() {
                full_box();
                
                all_axes() face_divot_column();
                all_edges() scalloped_edge();        
                all_corners() scalloped_corner();
                all_faces() face_divot();
                all_faces() edge_divot();
                
                edge_bump_surrounding_slits();
                all_faces() edge_bump_inner_scallop_hole();
            }
            
            all_axes() difference() {
                button_column();
            }
        
            all_faces() difference() {
                translate([0, 0, .0001]) edge_bump();
                face_divot();
            }
        }
        hearts();
        inner_solid_cube();
        ball_bearing_hole();
    }
}

module hearts() {
        heart_column();
        rotate([0, 90, 0]) heart_column();

        // the hearts on these two faces are oriented in opposite directions
        // so we split the heart column in half and rotate each half independently
        intersection() {
            rotate([90, 0, 0]) heart_column();
            centered_cube([size, size, size], true, false, true);
        }

        intersection() {
            rotate([90, 180, 0]) heart_column();
            translate([0, -size, 0]) centered_cube([size, size, size], true, false, true);
        } 
}

module pink_parts() {
    difference() {
        union() {            
            hearts();
            
            all_axes() intersection() {
                rotate_duplicate([0, 0, 90]) centered_cube([channel_lower_width, size, size - face_divot_depth * 2 - channel_depth * 2 + .0001], true, true, true);
                difference() {
                    face_divot_column();
                    button_column();            
                }
            }
        }
        inner_solid_cube();
        ball_bearing_hole();
    }
}

module gray_parts() {
    cube_size = size - face_divot_depth * 2 - .0001;
    difference() {
        union() {
            difference() {
                centered_cube([cube_size, cube_size, cube_size], true, true, true);
                white_parts();
                
                // pink slits
                all_axes() rotate_duplicate([0, 0, 90]) centered_cube([channel_lower_width, size, size - face_divot_depth * 2 - channel_depth * 2 + .0001], true, true, true);
                all_faces() channel();
                all_axes() button_column();
            }
            inner_solid_cube();
        }
        ball_bearing_hole();
    }
}

module ball_bearing_hole() {
    pill_length_factor = 0.45;
    pill_length = pill_length_factor * size;
    diam = ball_bearing_diam + ball_bearing_spacing;
    union() {
        sphere(d = diam);
        cylinder(h = diam / 2, r = diam / 2);
        translate([0, 0, diam / 2]) cylinder(h = pill_length - diam / 2, r1 = diam / 2, r2 = 0);
    }
}

if (white) {
    white_parts();
}

if (pink) {
    pink_parts();
}

if (gray) {
    gray_parts();
}