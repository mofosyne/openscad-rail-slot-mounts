$fn=100;
/*
    Parametric Caliper Mount For Tslot Mounting
    By Brian Khuu (2024)
*/

use <tslot.scad>

// Tslot
tslot();

difference() {
    hull()
    {
        bulk_width = 45;
        smoothing_dia = 7; // This is fixed to tslot hooks diameter
        backface_shift = 1;
        
        cube([bulk_width,0.1,7],center=true);
        translate([0,-smoothing_dia-2,0])
            rotate([0,90,0])
                cylinder(d=smoothing_dia, h=bulk_width, center=true);
        translate([0,0,0])
            rotate([0,90,0])
                cylinder(d=smoothing_dia, h=bulk_width, center=true);
        translate([0,0,15+7])
        {
            translate([0,-smoothing_dia-2,0])
                rotate([0,90,0])
                    cylinder(d=smoothing_dia, h=bulk_width, center=true);
            translate([0,-smoothing_dia/2,0])
                rotate([0,90,0])
                    cylinder(d=smoothing_dia, h=bulk_width, center=true);
        }
    }

    caliper_backface_thickness = 4;
    caliper_frontface_thickness = 4;

    translate([0,-1,0])
    {
    
        translate([0,-20/2,0])
            cube([35,20,60], center=true);
        
        hull()
        {
            translate([-(25/2)/2,-caliper_frontface_thickness/2-caliper_backface_thickness,0])
                cube([25/2,caliper_frontface_thickness,0.1], center=true);
            translate([-43/2,-caliper_frontface_thickness/2-caliper_backface_thickness,8])
                cube([43,caliper_frontface_thickness,0.1], center=true);
            translate([-43/2,-4/2-caliper_backface_thickness,50])
                cube([43,caliper_frontface_thickness,0.1], center=true);
        }

        hull()
        {
            // Cut out
            translate([-(25/2)/2,-(caliper_frontface_thickness*2)/2-caliper_backface_thickness,5])
                cube([25/2,(caliper_frontface_thickness*2),0.1], center=true);
            translate([-43/2,-8/2-caliper_backface_thickness,8+5])
                cube([43,(caliper_frontface_thickness*2),0.1], center=true);
            translate([-43/2,-8/2-caliper_backface_thickness,50+5])
                cube([43,8,0.1], center=true);
        }

        translate([0,0,15])
        hull()
        {
            translate([(25/2)/2,-caliper_frontface_thickness/2-caliper_backface_thickness,0])
                cube([25/2,caliper_frontface_thickness,0.1], center=true);
            translate([29/2,-caliper_frontface_thickness/2-caliper_backface_thickness,7])
                cube([29,caliper_frontface_thickness,0.1], center=true);
            translate([29/2,-4/2-caliper_backface_thickness,50])
                cube([29,4,0.1], center=true);
        }
    }
}
