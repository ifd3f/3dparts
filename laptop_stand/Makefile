PHONY: all
all: macbook_segment.stl thinkpad_segment.stl surface_pro_segment.stl left_cap.stl right_cap.stl right_fit_test.stl left_fit_test.stl

macbook_segment.stl: stand.scad
	openscad $< -o $@ -D "laptop_thickness=20"

thinkpad_segment.stl: stand.scad
	openscad $< -o $@ -D "laptop_thickness=22"

surface_pro_segment.stl: stand.scad
	openscad $< -o $@ -D "laptop_thickness=17"

left_cap.stl: stand.scad
	openscad $< -o $@ -D "make_laptop_walls=false" -D "make_left_tabs=false" -D "base_width=30"

right_cap.stl: stand.scad
	openscad $< -o $@ -D "make_laptop_walls=false" -D "make_right_tabs=false" -D "base_width=30"

left_fit_test.stl: stand.scad
	openscad $< -o $@ -D "make_laptop_walls=false" -D "make_left_tabs=false" -D "base_width=15" -D "base_rounding=1" -D "base_depth=50"

right_fit_test.stl: stand.scad
	openscad $< -o $@ -D "make_laptop_walls=false" -D "make_right_tabs=false" -D "base_width=15" -D "base_rounding=1" -D "base_depth=50"

