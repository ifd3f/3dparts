.PHONY: all
all: gray.stl pink.stl white.stl

gray.stl: companion_cube.scad
	openscad $< -o $@ -D "gray=true"

pink.stl: companion_cube.scad
	openscad $< -o $@ -D "pink=true"

white.stl: companion_cube.scad
	openscad $< -o $@ -D "white=true"
