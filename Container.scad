// This file is still a work in progress

width = 100;
bottom_depth = 50;
top_depth = 100;
height = 60;
wall_tickness = 2; // [2:5]
bottom_tickness = 3; // [2:5]
front_opening_angle = 30; // [0:60]
cleat_insert_box_width = 18;
cleat_insert_box_depth = 16;

/* [Hidden] */
minkowski_radius = 1;
wall_tickness2 = wall_tickness - (minkowski_radius * 2);
actual_wall_tickness = wall_tickness2 > 0 ? wall_tickness2 : 0.01;
actual_bottom_tickness = bottom_tickness - minkowski_radius;

/* --- */

bin();

module base() {
	hull() {
		cube([bottom_depth,width,0.01]);

		translate([0,0,height]) {
			cube([top_depth,width,0.01]);
		}
	}
}

module bin() {
	difference() {
		minkowski() {
			union() {
				difference() {
					base();
					translate([actual_wall_tickness,actual_wall_tickness,actual_bottom_tickness]) {
						resize([top_depth - (actual_wall_tickness*2),width - (actual_wall_tickness*2),0]) {
							base();
						}
					}
					
					translate([bottom_depth,0,height]) {
						rotate([0,front_opening_angle,0])
							cube([height,width,top_depth]);
					}
				}
				
				translate([0, width/2 - cleat_insert_box_depth/2, 0]) {
					cube([cleat_insert_box_depth,cleat_insert_box_width,height]);
				}
			}
			translate([minkowski_radius,0,minkowski_radius]) {
				sphere(minkowski_radius, $fn = 60);
			}
		}
		
			
		// Import model to make the insert for the cleat
		// The scale values are for the tolerances. This still needs work
		translate([0,(15*1.05 + width+2)/2,0]) {
			rotate([90,0,0]) {
				scale([1.075,1.05,1.05]) {
					import("stls/Hook_cleat_modifier.stl");
				}
			}
		}
				
	}
}
	
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