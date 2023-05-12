module subtract_tolerance_3d(t) {
    difference() {
        children();
        minkowski() {
            difference() {
                minkowski() {
                    children();
                    sphere(0.01);
                }
                children();
            }
            sphere(t);
        }
    }
}

module subtract_tolerance_2d(t) {
    difference() {
      children();
        minkowski() {
            difference() {
                minkowski() {
                    children();
                    circle(0.01);
                }
                children();
            }
            circle(t);
        }
    }
}

module circular_sector(radius = 1, angle=90) {
    
    points = concat(
        [[0, 0]], 
        [for (a = [0 : angle]) radius * [ cos(a), sin(a) ]]
    );
    paths = [[for (a = [0 : len(points) - 1]) a]];

    polygon(
        points,
        paths
    );

}

module exterior_2d_fillet(
    radius=1,
    rotate_angle=0,
    circle_angle=120,
    offset=[0,0]
) {
    outer_circle_radius = 3*radius;
    
        rotate([0,0,rotate_angle])
        translate(offset)


    difference() {
        circle(r=outer_circle_radius);
        circle(r=radius);
        rotate([0,0,circle_angle])
            circular_sector(radius = outer_circle_radius, angle=360 - circle_angle);

    }
    


}


module hull_points(points, diameter) {
    hull() {
    for (p = points) {
        translate(p) circle(d=diameter);
    }
}
}

module hull_lines(points, diameter) {
    for (i = [0:len(points)-2]) {
        point1 = points[i];
        point2 = points[i+1];
        hull_points([point1, point2], diameter);
    }
}

module annulus(inner_diameter, outer_diameter) {
    difference() {
        circle(d=outer_diameter);
        circle(d=inner_diameter);
    }
}


function serial_sided_isogon_side(
    angle,
    sides,
    polypoints,
    _previous_angle
) = 
    let(
        has_more_points = len(sides) > (len(polypoints) - 1)
        ,previous_point = polypoints[len(polypoints)-1]
//        ,previous_angle = len(polypoints) > 1
//            ? atan(previous_point[1] / previous_point[0])
//            : -angle
        ,current_side = has_more_points ? sides[len(polypoints) - 1] : 0
//        ,next_angle = current_side > 0 ? _previous_angle + angle : _previous_angle - angle
        ,next_angle = current_side > 0 ? _previous_angle + angle : _previous_angle - angle
        ,next_point = previous_point + abs(current_side) * [cos(next_angle),sin(next_angle)]
    )
//    ((len(sides) > len(polypoints) - 1)
    (has_more_points
        ? serial_sided_isogon_side(
            angle,
            sides,
            concat(
                polypoints,
//                [concat(_previous_angle, has_more_points, current_side, next_angle, [next_point])]
                [next_point]
            ),
            next_angle
        )
        : polypoints
);

module serial_sided_isogon(angle, sides) {
    polypoints = serial_sided_isogon_side(
        angle,
        sides,
        [[0,0]],
        -angle
    );
    polygon(polypoints);
}

//angle = 60;
//sides = [1,1,-1,-1,1,1,1,4];
//
////translate([-10,0])
////serial_sided_isogon(60, [1,1,-1,-1,1,1,1,4]);
//
////polypoints = serial_sided_isogon_side(90, [2,1,1,-1,1,2], [[0,0]], -90);
//polypoints = serial_sided_isogon_side(angle, sides, [[0,0]], -angle);
////
//echo(polypoints);
//
//translate([-10,0])
//polygon(polypoints);
//
//
//echo(arctan=atan(2/1));

// module prism
// pyramid
// polyhedron
// equiangular_polygon  - array of left / right turns (square is [-1,-1,-1,-1] or [1,1,1,1]) at 90
// polygon_by_turns - array of length / angle (square is ([1,90],[1,90],[1,90],[1,90])
// polyomino
// polyform
// gnomon
// golygon - similar to equiangular polygon
// types of triangles
// circular_segment


module parallelogram(width, height, angle) {
    points = [
        [0, 0],
        [width, 0],
        [width + height * tan(angle), height],
        [height * tan(angle), height]
    ];
    polygon(points);
}




module diamond(width, height) {
  points = [
    [0, height/2],
    [width/2, 0],
    [0, -height/2],
    [-width/2, 0]
  ];
  polygon(points = points);
}



// module library

translate([0,0,0]) circle(2);
translate([4,0,0]) subtract_tolerance_2d(.5) circle(2);

color("red")
translate([0,-10,0])
circular_sector(radius=3, angle=120);

color("green")
translate([0,-20,0])
exterior_2d_fillet(
    radius=2,
    rotate_angle=20,
    circle_angle=120,
    offset=[0,0]
);

color("purple")
translate([0,-30,0]) hull_points([[0,0], [0,5], [5,5]], 1);

color("orange")
translate([0,-40,0]) hull_lines([[0,0], [0,5], [5,5]], 1);

color("blue")
translate([0,-50,0]) annulus(5,10);


color("white")
translate([-10,0]) serial_sided_isogon(60, [1,1,-1,-1,1,1,1,4]);
//translate([-10,0]) serial_sided_isogon(90, [1,1,1,1]);
//ppoints = serial_sided_isogon_side(90, [1,1,1,1], [[0,0]], -90);
//echo(ppoints=ppoints);

color("teal")
translate([-10,-10,0]) parallelogram(2, 2, 45);

color("brown")
translate([-10,-20,0]) diamond(2, 3);

