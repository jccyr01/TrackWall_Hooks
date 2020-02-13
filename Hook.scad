$fn = 60;
//difference() {
//    cylinder(h = 10, r = 5, center = true);
//    translate([2.5, 2.5, 0])
//        cylinder(h = 10, r = 5, center = true);
//}

slice(r = 2, d = 90, center = true);
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