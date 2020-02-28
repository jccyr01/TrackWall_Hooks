/* [Hook base] */
// Tickness of the main body
hook_tickness = 3.0;

// Width of the hook
hook_width = 15.0;

// Distance between top and bottom hook attachment 
base_height = 67.0;

/* [Top attachment] */
// 
top_hook_depth = 10.5;

// 
top_hook_height = 17.5;

// Tickness of the top attachment
top_hook_tickness = 2.5;

top_hook_bottom_angle = 90; // [90:90]
top_hook_back_angle = 90; // [30:180]

/* [Bottom attachment] */
// Generate bottom attachment
bottom_hook = true;
bottom_hook_tickness = 2.0;
bottom_hook_depth = 9.0;
// Generate a tab to make it easier to remove the hook
bottom_hook_pull_tab = true;

/* [Accessory Type] */
accessory_type = "None"; // [None, Cleat, J-Hook, Single, Level]

/* [Cleat Options] */
cleat_height = 15.0;
cleat_depth = 10.0;
cleat_position = 40.0;

/* [J-Hook Options] */
jhook_tickness = 3.0; //
jhook_inner_diameter = 10.0; //
jhook_angle = 180; // [100:200]
// J-hook position on the base. At 0, the bottom of the j-hook will be at the same height as the bottom of the hook.
jhook_position = 0.0; //

/* [Level Hook Options] */
level_bevel = 144; // [90:180]
level_height = 10;
level_depth = 15;
level_lip_height = 2.5;
level_position = 50.0; //

/* [Single Hook Options] */
single_tickness = 4.0;
single_position = 50.0;
single_length = 30;

/* [Hidden] */
$fn = 60;

has_cleat = accessory_type == "Cleat";
has_jhook = accessory_type == "J-Hook";
has_level = accessory_type == "Level";
has_single = accessory_type == "Single";

hook_base();

module hook_base() {
    
    top_hook_depth = top_hook_depth - (top_hook_tickness);
    top_hook_height = top_hook_height - (top_hook_tickness*2);
	base_height_original = base_height;
	base_height = hook_tickness > top_hook_tickness ? base_height - abs(hook_tickness - top_hook_tickness) : base_height + abs(hook_tickness - top_hook_tickness);
	
    base(width = hook_width, height = base_height);

    translate([0,base_height_original,0]) {
        top_attachment();
    }
    
    if (bottom_hook) {
        bottom_attachment();
    }
    
    if (has_cleat) {
        translate([0,cleat_position,0]) {
            cleat();
        }
    } else if (has_jhook) {
        translate([0,jhook_position - (bottom_hook ? bottom_hook_tickness: 0) ,0]) {
            j_hook();
        }
    } else if (has_level) {
		translate([hook_tickness,level_position,0]) {
			level(depth = level_depth, height = level_height, width = hook_width, lip_height = level_lip_height, bevel = level_bevel);
		}
	} else if (has_single) {
		translate([hook_tickness,single_position,0]) {
			singleHook(tickness = single_tickness, length = single_length, width = hook_width);
		}
	}
    
    module base(tickness = hook_tickness, height = 50, width = 15) {
        bottom_attachment_height = bottom_hook ? 0 : tickness;
        union() {
            translate([0, bottom_attachment_height, 0]) {
                cube([tickness, height - bottom_attachment_height, width ]);
            }
            translate([tickness,tickness,0]) {
                rotate([0,0,180]) {
                   slice(r = tickness, h = width, a = 90);
                }
            }
        }
    }
    
    module top_attachment() {
        union() {
            translate([0,top_hook_tickness - hook_tickness,0]) {
                slice(r = hook_tickness, h = hook_width , a = top_hook_bottom_angle);
            }
            
            rotate([0,0,top_hook_bottom_angle - 90]) {
				translate([-top_hook_depth,0, 0]) {
                    cube([top_hook_depth, top_hook_tickness, hook_width]);
                    translate([0,top_hook_tickness,0]) {
                        rotate([0,0,top_hook_back_angle + 90]) {
                            slice(r = top_hook_tickness, h = hook_width, a = 180 - top_hook_back_angle);
                        }
                        rotate([0,0,top_hook_back_angle - 90]) {
                            translate([-top_hook_tickness,0,0]) {
                                cube([top_hook_tickness,top_hook_height,hook_width]);
                            }
                            translate([0,top_hook_height,0]) {
                                rotate([0,0,90])
                                slice(r = top_hook_tickness, h = hook_width, a = 90);
                            }
                        }
                        
                    }
                }
            }            
        }
    }
    
    module bottom_attachment() {
        translate([0,-2,0]) {
            if (bottom_hook_pull_tab || has_jhook) {
				cube([hook_tickness,2,hook_width]);
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
                cube([bottom_hook_tickness, bottom_hook_depth, hook_width]);
                rotate([0,0,90]) {
                    translate([2,-1,0]) {
                        difference() {
                            slice(r = 2, h = hook_width, a = 180);
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

/* Accessories */
module cleat(width = 15, hole = false) {
    tolerance = hole ? 0 : 0;
    cleat_height = cleat_height + tolerance + 0.8 + (hole ? 3 : 0);
    cleat_depth = cleat_depth + tolerance;
    hook_tickness = hook_tickness + tolerance;
    width = width;// + tolerance;
    translate([0,hole?-3:0,0]) {
    difference() {
        union() {
            cube([cleat_depth, cleat_height, width]);
//            if (hole) {
//                translate([0,-(cleat_height/4),0]) {
//                    cube([cleat_depth, cleat_height, width ]);
//                }
//            }
                
        }
        translate([-1,cleat_height - cleat_depth,0]) {
            rotate([0,0,45]) {
                cube([cleat_depth * 2,cleat_depth,width]);
            }
        }
//        if (!hole) {
            translate([cleat_depth,-cleat_depth,0]) {
                rotate([0,0,45]) {
                    translate([-cleat_depth,0,0])
                        cube([cleat_depth * 2,cleat_depth,width]);
                }
            }
//        }
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
}

module j_hook() {
	jhook_inner_radius = jhook_inner_diameter / 2;
	jhook_center = jhook_inner_radius + jhook_tickness;
	
	translate([jhook_tickness,0,0]) {
		difference() {
			union() {
				cube([jhook_center - hook_tickness,jhook_center,hook_width]);
				translate([jhook_center - hook_tickness,jhook_center,0]) {	
					rotate ([0,0,-90]) {
							slice(r = jhook_center, h = hook_width, a = jhook_angle - 90);
					}
	
					rotate([0,0,jhook_angle - 180]) {
                        translate([jhook_tickness/2 + jhook_inner_radius ,0,0]) {
                            slice(r = jhook_tickness/2, h=hook_width);
                        }
                    }
				}
			}
			translate([jhook_center - hook_tickness,jhook_center,0]) {
				cylinder(r = jhook_inner_radius, h = hook_width);
			}
		}
	}
}

module level(depth = 15, height = 10, width = hook_width, lip_height = 2.5, bevel = 140) {	
	slope_length = calculateTriangleSide(bevel, width, (180 - bevel) / 2);
	
	// Make sure bevel height is a number > 0
	bevel_height = bevel % 180 != 0 ? pythagoras(width/2,slope_length) : 0.1;
	
	difference() {
		union() {
			translate([0,height - bevel_height,width / 2]) {
				resize([depth,bevel_height,width + 2]) {
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
		
		stopper_side_width = ((width + 2) - hook_width) / 2;
		
		translate([0, height - bevel_height,-stopper_side_width])
			cube([depth, bevel_height + lip_height,stopper_side_width]);
		
		translate([0, height - bevel_height,width])
			cube([depth,bevel_height + lip_height,stopper_side_width]);
	}
}

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
