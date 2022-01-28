/* [Hook base] */
// Tickness of the main body
hook_tickness = 4.0;

// Width of the hook
hook_width = 15.0;

// Distance between top and bottom hook attachment 
base_height = 67.01;

/* [Top attachment] */
// 
top_hook_depth = 10.5;

// 
top_hook_height = 17.5;

// Tickness of the top attachment
top_hook_tickness = 3.0; // [4:7]

top_hook_bottom_angle = 90; // [60:120]
top_hook_back_angle = 90; // [30:180]

/* [Bottom attachment] */
// Generate bottom attachment
bottom_hook = true;
bottom_hook_tickness = 2.0;
bottom_hook_depth = 9.0;
// Generate a tab to make it easier to remove the hook
bottom_hook_pull_tab = true;

/* [Accessory Type] */
accessory_type = "None"; // [None, Cleat, J-Hook, Level, Single]

/* [Cleat Options] */
cleat_height = 15.0;
cleat_depth = 10.0;
// Position from the top attachment
cleat_position = 27;

/* [J-Hook Options] */
jhook_tickness = 3.0; //
jhook_inner_diameter = 60; //
jhook_angle = 180; // [100:200]
// J-hook position on the base. At 0, the bottom of the j-hook will be at the same height as the bottom of the hook.
jhook_position = 0.0; //

/* [Level Hook Options] */
level_bevel = 144; // [90:180]
level_height = 10;
level_depth = 15;
level_lip_height = 2.5;
// Position from the top attachment
level_position = 17; //

/* [Single Hook Options] */
single_tickness = 4.0;
single_length = 30;
// Position from the top attachment
single_position = 17;

/* [Hidden] */
$fn = 60;

has_cleat = accessory_type == "Cleat";
has_jhook = accessory_type == "J-Hook";
has_level = accessory_type == "Level";
has_single = accessory_type == "Single";

cleat_modifier = false; //
modifier_tolerance = 0.8; //

modifier_extra_height = 30;

/* --- */

hook() {
    accessory();
}

// Base hook
module hook() {
	hook_width = hook_width + (has_cleat && cleat_modifier ? modifier_tolerance : 0);
	top_hook_depth = top_hook_depth - (top_hook_tickness);
    top_hook_height = top_hook_height - (top_hook_tickness*2);
	base_height_original = base_height;
	base_height = (hook_tickness > top_hook_tickness ? base_height - abs(hook_tickness - top_hook_tickness) : base_height + abs(hook_tickness - top_hook_tickness)) + (cleat_modifier ? modifier_extra_height : 0);
	
    union() {
        translate([0,cleat_modifier ? - (modifier_extra_height/2):0,0]) {
            base(width = hook_width, height = base_height);
        }
        
        if (!cleat_modifier) {
            translate([0,base_height_original,0]) {
                top_attachment();
            }
            if (bottom_hook) {
                bottom_attachment();
            }
        }
        children();
    }
    
    module base(tickness = hook_tickness, height = 50, width = 15) {
        bottom_attachment_height = bottom_hook ? 0 : tickness;
        union() {
            translate([0, bottom_attachment_height, 0]) {
                cube([tickness, height - bottom_attachment_height, width ]);
            }
            if (!bottom_hook) {
                if (!has_jhook) {
                    translate([tickness/2,tickness,0]) {
                        cylinder(r = tickness/2, h = width);
                    }
                } else {
                    translate([tickness,tickness,0]) {
                        rotate([0,0,180]) {
                            slice(r = tickness, h=width, a = 90);
                        }
                    }
                }
            }
        }
    }
    
    module top_attachment() {
        union() {
            translate([0,top_hook_tickness - hook_tickness,0]) {
                slice(r = hook_tickness, h = hook_width , a = top_hook_bottom_angle+0.0001);
            }
            
            rotate([0,0,top_hook_bottom_angle - 90]) {
				translate([-top_hook_depth,0, 0]) {
                    cube([top_hook_depth, top_hook_tickness, hook_width]);
					translate([0,top_hook_tickness,0]) {
                        rotate([0,0,top_hook_back_angle + (90 - 0.0001)]) {
                            slice(r = top_hook_tickness, h = hook_width, a = 180.0001 - top_hook_back_angle);
                        }
                        rotate([0,0,top_hook_back_angle - 90]) {
                            translate([-top_hook_tickness,0,0]) {
                                cube([top_hook_tickness,top_hook_height,hook_width]);
                            }
                            translate([0,top_hook_height,0]) {
                                rotate([0,0,90]) {
                                    slice(r = top_hook_tickness, h = hook_width, a = 90);
                                }
                            }
                        }
                        
                    }
                }
            }        
        }
    }
    
    module bottom_attachment() {
        union() {
            translate([0,-bottom_hook_tickness,0]) {
                if (bottom_hook_pull_tab || has_jhook) {
                    cube([hook_tickness,bottom_hook_tickness,hook_width]);
                }
                if (bottom_hook_pull_tab) {
                    translate([hook_tickness,0,0]) {
                        rotate([0,0,-180]) {
                            slice(r = hook_tickness/2, h = hook_width, a = 90);
                        }
                    }
                } else if (!has_jhook) {
                    translate([hook_tickness - bottom_hook_tickness,bottom_hook_tickness,0]) {
                        slice(r = bottom_hook_tickness, h = hook_width, a = -90);
                    }
                    cube([hook_tickness - bottom_hook_tickness, bottom_hook_tickness, hook_width]);
                }
            }
            rotate([0,0,-90]) {
                translate([0,-bottom_hook_depth,0]) {
                    translate([0,0.3,0]) cube([bottom_hook_tickness, bottom_hook_depth, hook_width]);
                    rotate([0,0,90]) {
                        translate([2,-1,0]) {
                            difference() {
                                cylinder(r = 2, h = hook_width);
                                translate([-2,-bottom_hook_tickness,0]) {
                                    cube([4,1,hook_width]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/* Accessories */
module accessory() {
    if (has_cleat) {
        cleat_position = cleat_position - (cleat_modifier ? 4 : 0);
        translate([hook_tickness,base_height-cleat_position,0]) {
            cleat(width = hook_width, height = cleat_height, depth = cleat_depth);
        }
    } else if (has_jhook) {
        translate([hook_tickness,jhook_position - (bottom_hook ? bottom_hook_tickness: 0) ,0]) {
            j_hook(tickness = jhook_tickness, inner_diameter = jhook_inner_diameter, angle = jhook_angle, width = hook_width);
        }
    } else if (has_level) {
        translate([hook_tickness,base_height-level_position,0]) {
            level(depth = level_depth, height = level_height, width = hook_width, lip_height = level_lip_height, bevel = level_bevel);
        }
    } else if (has_single) {
        translate([hook_tickness,base_height-single_position,0]) {
            singleHook(tickness = single_tickness, length = single_length, width = hook_width);
        }
    }

    module cleat(width = 15, height = 15, depth = 10) {
        tolerance = cleat_modifier ? modifier_tolerance : 0;
        depth = depth + tolerance;
        height = height + tolerance + (cleat_modifier ? 4 : 0);
        difference() {
            union() {
                cube([depth, height, width]);
            }
            translate([-1,height - depth,0]) {
                rotate([0,0,45]) {
                    cube([depth * 2, depth, width]);
                }
            }
            translate([depth, -depth,0]) {
                rotate([0,0,45]) {
                    translate([-depth,0,0])
                        cube([depth * 2, depth, width]);
                }
            }
        }
        
        translate([1,-1,0]) {
            rotate([0,0,90]) {
                difference() {
                    cube([1, 1, width]);
                    cylinder(r = 1, h = width);
                }
            }
        }
    }

    module j_hook(tickness = 4, inner_diameter = 40, angle = 180, width) {
        inner_radius = inner_diameter / 2;
        center_position = inner_radius + tickness;
        
        difference() {
            union() {
                cube([center_position - tickness, center_position,width]);
                translate([center_position - tickness, center_position,0]) {	
                    rotate ([0,0,-90]) {
                        slice(r = center_position, h = width, a = angle - 90);
                    }

                    rotate([0,0, angle - 180]) {
                        translate([jhook_tickness/2 + inner_radius ,0,0]) {
                            slice(r = tickness/2, h=width);
                        }
                    }
                }
            }
            translate([center_position - tickness, center_position,0]) {
                cylinder(r = inner_radius, h = width);
            }
        }
    }

    module level(depth = 15, height = 10, width = hook_width, lip_height = 2.5, bevel = 140) {	
        slope_length = calculateTriangleSide(bevel, width, (180 - bevel) / 2);
        
        // Make sure bevel height is a number > 0
        bevel_height = bevel % 180 != 0 ? pythagoras(width/2,slope_length) : 0.1;
        
        difference() {
            union() {
                translate([0,height - bevel_height, width / 2]) {
                    resize([depth, bevel_height, width + 2]) {
                        rotate([0,90,0])
                            slice(d1 = width, d2 = width + 2, $fn = 4);
                    }
                }
                    
                cube([depth, height - bevel_height, width]);
                
                
                translate([depth - 2,height - bevel_height,width / 2]) {
                    resize([0,bevel_height+lip_height,0]) {
                        rotate([0,90,0]) {
                            slice(d1 = width-1, d2 = width + 2 , h = 2);
                        }
                    }
                }
            }	
            
            stopper_side_width = ((width + 2) - width) / 2;
            
            translate([0, height - bevel_height, -stopper_side_width])
                cube([depth, bevel_height + lip_height,stopper_side_width]);
            
            translate([0, height - bevel_height,width])
                cube([depth,bevel_height + lip_height,stopper_side_width]);
        }
    }

    // Work in progress
    module singleHook(tickness = 4, length = 50, width = hook_width) {
        rotate([0,0,7]) {
            union() {
                cube([length,tickness, width]);
                translate([length, 0, 0]) {
                    rotate([0,0,10]){
                        cube([10,tickness, width]);
                        translate([10,tickness/2,0]) {
                            rotate([0,0,-90]) {
                                slice(d = tickness, h = width);
                            }
                        }
                    }
                }
            }
        }
        translate([0,-1.5,0]) {
            difference() {
                cube([2,4,width]);
                translate([2,-0.25,0]) {
                    cylinder(r = 2, h = width);
                }
            }
        }
        
        translate([0,3,0]) {
            difference() {
                cube([2,3,width]);
                translate([2,3.25,0]) {
                    cylinder(r = 2, h = width);
                }
            }
        }
    }
}

/* Helpers */

// Generates a slice of a cylinder with an angle
module slice(r, r1, r2, d, d1, d2, h = 10, a = 180, center = false, $fn = 100) {
	_r = r ? r : 1;
	_r1 = r1 ? r1 : _r;
	_r2 = r2 ? r2 : _r;
	_d = d ? d : _r * 2;
	_d1 = d1 ? d1 : d ? d : (_r1 ? _r1 * 2 : _d);
	_d2 = d2 ? d2 : d ? d : (_r2 ? _r2 * 2 : _d);
	
	rotate_extrude(angle = a, $fn=$fn) {
		polygon([[0,0],[_d1/2,0],[_d2/2,h],[0,h]]);
	}
}


function calculateTriangleSide(C, c, A) =
	c * sin(A)/sin(C);

function pythagoras(a, c) =
	sqrt(pow(c, 2) - pow(a, 2));
