$fn = 60;
//difference() {
//    cylinder(h = 10, r = 5, center = true);
//    translate([2.5, 2.5, 0])
//        cylinder(h = 10, r = 5, center = true);
//}

peg_board_hole_diameter = 6.35;
peg_board_hole_distance = 25.4;

peg_board_base();

module base(tickness = 3, height = 50, width = 15) {
    cube([tickness, height, width ]);
}

module peg_board_base(tickness = 3, height = 50, width = 15) {
    peg_board_spacing = 5;
    peg_board_tickness = 6.35;
    
    
    difference() {
        difference() {
            union() {
                base(tickness, height, width);
                translate([tickness, 0, 0]) {
                    base(peg_board_tickness + peg_board_spacing - tickness, height, width);
                }
            }
            translate([0, 3, 3]) {
                cube([tickness, height - 6, width - 6]);
            }
        }
        translate([2, 10, width/2]) {
            rotate([0, 90, 0]) {
                for (y=[0:1]) {
                    translate([0, y * peg_board_hole_distance, 0]) {
                        hole();
                    }
                }
            }
        }
    }
    module hole() {
        cylinder(h = 3, d = peg_board_hole_diameter);
    }
}

//slice(r = 2, d = 270, center = true);
module slice(r = 10, h = 10, d = 180, center = false) {
    
    
    if (d < 180) {
        intersection() {
            half_cylinder(r = r, h = h, center = center);
            rotate([0, 0, d - 180]) {
                half_cylinder(r = r, h = h, center = center);
            }
        }
    } else if (d > 180) {
        union() {
            half_cylinder(r = r, h = h, center = center);
            rotate([0, 0, d - 180]) {
                half_cylinder(r = r, h = h, center = center);
            }
        }
    } else {
        half_cylinder(r = r, h = h, center = center);
    }


    module half_cylinder(r, h, center) {
        difference() {
            cylinder(r = r, h = h, center = center);
            translate([0,-r/2,0]) {
                cube([r*2, r, h], center = center);
            }
        }
    }
}
