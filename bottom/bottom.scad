white = false;
brown = false;
yellow = false;
orange = false;
height = 5;
diameter = 25;
dpi = 96;
// it's .375in diameter at 96dpi
scaling = diameter / (.375 * 25.4);
$fn = 200;

module white_raw() {
    color("white") import(file = "pleading-face.svg", id = "layer1", dpi = dpi, $fn = $fn);
}

module brown_raw() {
    color("brown") import(file = "pleading-face.svg", id = "layer2", dpi = dpi, $fn = $fn);
}

module yellow_raw() {
    color("yellow") import(file = "pleading-face.svg", id = "circle1", dpi = dpi, $fn = $fn);
}

module orange_raw() {
    color("orange") import(file = "pleading-face.svg", id = "layer3", dpi = dpi, $fn = $fn);
}

module white_subtracted() {
    difference() {
        white_raw();
    }
}

module brown_subtracted() {
    difference() {
        brown_raw();
        white_raw();
    }
}

module orange_subtracted() {
    difference() {
        orange_raw();
        brown_raw();
    }
}

module yellow_subtracted() {
    difference() {
        yellow_raw();
        brown_raw();
        orange_raw();
        white_raw();
    }
}

scale([scaling, scaling, 1]) {
    if (yellow) {
        color("yellow") linear_extrude(height = height) yellow_subtracted();
    }
    if (orange) {
        color("orange") linear_extrude(height = height) orange_subtracted();
    }
    if (brown) {
        color("brown") linear_extrude(height = height) brown_subtracted();
    }
    if (white) {
        color("white") linear_extrude(height = height) white_subtracted();
    }
}
