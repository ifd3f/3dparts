.PHONY: all
all: white.stl brown.stl orange.stl yellow.stl

white.stl: bottom.scad
	openscad $< -o $@ -D "white=true"

yellow.stl: bottom.scad
	openscad $< -o $@ -D "yellow=true"

brown.stl: bottom.scad
	openscad $< -o $@ -D "brown=true"

orange.stl: bottom.scad
	openscad $< -o $@ -D "orange=true"
