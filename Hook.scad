$fn = 60;

/*----- Variable -------*/
hook_tickness = 3;
hook_width = 15;

/*----- Cleat params ---*/
cleat_height = 15;
cleat_depth = 10;

/* ---- Versa Trac ---- */
top_hook_height = 17.5;
top_hook_depth = 13;
top_hook_tickness = 2;

//hook_cleat();
husky(){
    
};
//versa_trac();

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
    top_hook_tickness = 2.5;
    base_height = 67.2;
    top_hook_depth = top_hook_depth - (top_hook_tickness + hook_tickness);
    top_hook_height = top_hook_height - (top_hook_tickness*2);
    base(width = hook_width, height = base_height);
    
    top_hook_bottom_angle = 90;
    top_hook_back_angle = 90;
    
    translate([0,base_height - max(hook_tickness, top_hook_tickness),0]) {
        top_attachment();
    }
    
    bottom_attachment();
    
    translate([0,40,0]) {
        cleat();
    }
    
    module top_attachment() {
        union() {
            translate([0,hook_tickness,0]) {
                slice(r = hook_tickness, h = hook_width , d = top_hook_bottom_angle);
            }
            rotate([0,0,top_hook_bottom_angle - 90]) {
                translate([-top_hook_depth,hook_tickness + 0.5, 0]) {
                    cube([top_hook_depth, top_hook_tickness, hook_width]);
                    translate([0,top_hook_tickness,0]) {
                        rotate([0,0,top_hook_back_angle + 90]) {
                            slice(r = top_hook_tickness, h = hook_width, d = 180 - top_hook_back_angle);
                        }
                        rotate([0,0,top_hook_back_angle - 90]) {
                            translate([-top_hook_tickness,0,0]) {
                                cube([top_hook_tickness,top_hook_height,hook_width]);
                            }
                            translate([0,top_hook_height,0]) {
                                rotate([0,0,90])
                                slice(r = top_hook_tickness, h = hook_width, d = 90);
                            }
                        }
                        
                    }
                }
            }            
        }
    }
    
    module bottom_attachment() {
        translate([0,-2,0]) {
            cube([hook_tickness,2,hook_width]);
            translate([hook_tickness,0,0])
            rotate([0,0,-180]) {
                slice(r = hook_tickness/2, h = hook_width, d = 90);
            }
        }
        rotate([0,0,-90]) {
            translate([0,-9,0]) {
                cube([2, 9, hook_width]);
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

module hook_cleat() {
    base(width = hook_width) {
        translate([hook_tickness,10,0]) {
            cleat(width = hook_width, hole=true);
        }
    }
}

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

module slice(r = 10, h = 10, d = 180, center = false) {
    translate([0,0,(center ? -h/2 : 0)]) {
        rotate_extrude(angle = d, $fn=100) {
            square([r,h]);
        }
    }
}