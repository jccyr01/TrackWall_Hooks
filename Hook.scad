$fn = 60;
//difference() {
//    cylinder(h = 10, r = 5, center = true);
//    translate([2.5, 2.5, 0])
//        cylinder(h = 10, r = 5, center = true);
//}

//peg_board_hole_diameter = 6.35;
//peg_board_hole_distance = 25.4;

//peg_board_base();


//cleat();
/*----- Variable -------*/
hook_tickness = 3;
hook_width = 15;

/*----- Cleat params ---*/
cleat_height = 15;
cleat_depth = 10;

/* ---- Versa Trac ---- */
top_hook_height = 18;
top_hook_depth = 13;
top_hook_tickness = 2;

//hook_cleat();
//husky();
versa_trac();

//slice(r = 2, d = 270);

module husky() {
    base_height = 50;
    base(width = hook_width, height = base_height - hook_tickness);
    
    translate([0,base_height - hook_tickness,0]) {
        top_attachment();
    }
    bottom_attachment();
        
    
    module top_attachment() {
        union() {
            slice(r = hook_tickness, h = hook_width , d = 90);
            translate([-10,hook_tickness - 2 ,0]) {
                cube([10, 2, hook_width]);
                translate([0,2,0]) {
                    rotate([0,0,150]) {
                        slice(r = 2, h = hook_width, d = 120);
                    }
                    rotate([0,0,-30]) {
                        translate([-2,0,0]) {
                            cube([2,10,hook_width]);
                        }
                        translate([0,10,0]) {
                            rotate([0,0,90])
                            slice(r=2, h = hook_width, d = 90);
                        }
                    }
                    
                }
            }
            
        }
    }
    
    module bottom_attachment() {
        rotate([0,0,-90]) {
            slice(r = hook_tickness, h = hook_width, d = 90);
            translate([1,-8,0]) {
                cube([2, 8, hook_width]);
                rotate([0,0,90]) {
                    translate([2,-1,0]) {
                        difference() {
                            slice(r = 2, h = hook_width, d = 180);
                            translate([-2,0,0]) {
                                cube([4,1,hook_width]);
                            }
                        }
                    }
                }
            }
        }
    }
}

module versa_trac() {
    base_height = 50;
    top_hook_depth = top_hook_depth -top_hook_tickness - hook_tickness;
    top_hook_height = top_hook_height - top_hook_tickness;
    base(width = hook_width, height = base_height - hook_tickness);
    
    translate([0,base_height - hook_tickness,0]) {
        top_attachment();
    }
//    bottom_attachment();
    
    module top_attachment() {
        union() {
            slice(r = hook_tickness, h = hook_width , d = 90);
            translate([-top_hook_depth,hook_tickness - 2 ,0]) {
                cube([top_hook_depth, top_hook_tickness, hook_width]);
                translate([0,2,0]) {
                    rotate([0,0,180]) {
                        slice(r = 2, h = hook_width, d = 90);
                    }
                    rotate([0,0,0]) {
                        translate([-2,0,0]) {
                            cube([2,top_hook_height,hook_width]);
                        }
                        translate([0,top_hook_height,0]) {
                            rotate([0,0,90])
                            slice(r=2, h = hook_width, d = 90);
                        }
                    }
                    
                }
            }
            
        }
    }
}

module hook_cleat() {
    base(width = hook_width) {
        translate([hook_tickness,10,0]) {
            cleat(width = hook_width, hole=true);
        }
    }
}

//base(width = hook_width + 0.3) {
//    translate([hook_tickness,10,0]) {
//        cleat(width = hook_width + 0.3);
//    }
//}

module base(tickness = hook_tickness, height = 50, width = 15) {
    union() {
        cube([tickness, height, width ]);
        children();
    }
}

module cleat(width = 15, hole = false) {
    tolerance = hole ? 0.5 : 0;
    cleat_height = cleat_height  + tolerance + 0.8;
    cleat_depth = cleat_depth + tolerance;
    hook_tickness = hook_tickness + tolerance;
    width = width + tolerance;
    
    difference() {
        union() {
            cube([cleat_depth, cleat_height, width ]);
            if (hole) {
                translate([0,-(cleat_height/2),0]) {
                    cube([cleat_depth, cleat_height, width ]);
                }
            }
                
        }
        translate([-1,cleat_height - cleat_depth,0]) {
            rotate([0,0,45]) {
                cube([cleat_depth * 2,cleat_depth,width]);
            }
        }
        if (!hole) {
            translate([cleat_depth,-cleat_depth,0]) {
                rotate([0,0,45]) {
                    translate([-cleat_depth,0,0])
                        cube([cleat_depth * 2,cleat_depth,width]);
                }
            }
        }
    }
    
    translate([1,-1,0]) {
        rotate([0,0,90]) {
            difference() {
                cube([1,1, width]);
                cylinder(r = 1, h = width);
            }
        }
    }
}

module peg_board_base(tickness = 3, height = 50, width = 15) {
    peg_board_spacing = 6;
    peg_board_tickness = 2.5;
    
    
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
            z_offset = center ? 0 : h/2;
            translate([0,-r/2,z_offset]) {
                cube([r*2, r, h], center = true);
            }
        }
    }
}
