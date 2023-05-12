use <libraries/utils.scad>

$fn=20;

//color("blue")
//translate([21,0,0])
//circle(10);
//
//translate([0,0,10])
//rotate_extrude()
//translate([21,0])
//circle(10);

//polyhedron([[0,0,0], [1,0,0], [1,1,0], [0,1,0]], [[0,1,2,3]]);

//translate([5,0,0])
//difference() {
//    cylinder(d=3);
//    cylinder(d=2);
//}
//
//module parallelogram(base, height, angle) {
//    polygon([
//        [0,0],
//        [1,2],
//        [2,2],
//        [1,0],
//    ]);
//}
//

//linear_extrude(10, twist=360)
//parallelogram(1,1,45);

// inner shape
//rotate([0,0,0])
//    rotate([0, 90, 0])
//      diamond(4, 2, $fn = 30);

module repeate_around_cylinder(
    radius,
    height,
    num_circumference,
    num_height,
    row_offset = 0,
) {
  for (i = [0:num_height-1]) {
      
      z_offset = i * height / num_height;

      for (j = [0:num_circumference-1]) {
        angle = (j * 360 / num_circumference) + row_offset * i;
        translate([radius * cos(angle), radius * sin(angle), z_offset])
        rotate([0, 0, angle])
        children();
    //    rotate([0, 0, angle])
    //      parallelogram(2, 2, 30, $fn = 30);
    //      translate([0, 0, height])
    //      cone(r1 = 0, r2 = radius, h = height/2, $fn = 30);
    //    }
      }
  }
}


module mesh_cylinder(h, r) {
    
    diamond_height = 8;
    diamond_width = 4;
    num_circumference = 10;
    num_height = 16;
    
    difference() {
        
        cylinder(h=h, r=r);
        cylinder(h=h+1, r=r-1);
        
        repeate_around_cylinder(
            radius=r,
            height=h + diamond_height / 2,
            num_circumference=num_circumference,
            num_height=num_height + 1,
            row_offset=(360/num_circumference)/2
        ) {
            rotate([0,0,0])
            rotate([0, 90, 0])
                translate([0,0,-2])
                linear_extrude(3)
              diamond(diamond_height, diamond_width);
        };  // Creates a cylinder with radius 20, height 40, and 8 cones facing the center

    }
}

mesh_cylinder(h=80, r=10);