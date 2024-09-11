$fn=100;
/*
    Parametric Screwdriver hook For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to screwdriver on it...
*/

use <tslot.scad>

/* [Tslot Spec] */
// CenterDepth
tslot_nut_profile_e = 6.5;
// CenterWidth
tslot_nut_profile_b = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

/* [Screwdriver Spec] */
screwdriver_small_dia = 8;
screwdriver_top_dia = 15;


/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;


/* [Hook Calc] */
// Hook Diameter
hookdia=screwdriver_small_dia+2;
// Hook Width
standoff=tslot_nut_profile_b-1;
// Hook Thickness
hookthickness=screwdriver_top_dia-hookdia; // This is extra rest for the screwdriver head


translate([0, -1, 0])
union()
{

    translate([0,0,0])
        tslot(tslot_nut_profile_e = tslot_nut_profile_e, tslot_nut_profile_b = tslot_nut_profile_b);

    // Hook
    translate([0, -hookthickness*2, 0])
    union()
    {
        rotate([0,-90,0])
        difference()
        {
            hh = 1;
            xx = hookdia/2+hookthickness;
            hull()
            {
                translate([xx+hh,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
                translate([xx,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);

                // Long Flat
                rotate([90,0,0])
                    cylinder(r=tslot_nut_profile_b/2, h=hookdia+hookthickness*2, center=true);
            }

            // Grip Side 1
            hull()
            {
                //Outer
                translate([xx+hh,0,standoff/2+0.5])
                    cylinder(r=(hookdia/2+hookthickness-1), h=0.1, center=true);
                translate([xx   ,0,standoff/2+0.5])
                    cylinder(r=(hookdia/2+hookthickness-1), h=0.1, center=true);
                //Center
                translate([xx+hh,0,0])
                    cylinder(r=hookdia/2, h=1, center=true);
                translate([xx   ,0,0])
                    cylinder(r=hookdia/2, h=1, center=true);
            }

            // Grip Side 2
            hull()
            {
                //Outer
                translate([xx+hh,0,-standoff/2-0.5])
                    cylinder(r=(hookdia/2+hookthickness-1), h=0.1, center=true);
                translate([xx   ,0,-standoff/2-0.5])
                    cylinder(r=(hookdia/2+hookthickness-1), h=0.1, center=true);
                //Center
                translate([xx+hh,0,0])
                    cylinder(r=hookdia/2, h=1, center=true);
                translate([xx   ,0,0])
                    cylinder(r=hookdia/2, h=1, center=true);
            }

            // Degreecut
            translate([hh,0,0])
            hull()
            {
                degreecut = 45;
                // Degreecut
                rotate([0,0,degreecut/2])
                    translate([(hookdia+hookthickness+1),0,0])
                    cube([hookdia+hookthickness+1,1,standoff+2], center=true);
                rotate([0,0,-degreecut/2])
                    translate([(hookdia+hookthickness+1),0,0])
                    cube([hookdia+hookthickness+1,1,standoff+2], center=true);
            }

            // Slide In Cut
            translate([hh,0,0])
            hull()
            {
                translate([(hookdia+hookthickness+10),0,0])
                    cube([1,screwdriver_small_dia+1,standoff+2], center=true);
                translate([((hookdia+hookthickness)/2),0,0])
                    cube([1,screwdriver_small_dia+1,standoff+2], center=true);
            }

            //bottomcut
            translate([-10-standoff/2,-100/2,-100/2])
                cube([10,100,100]);
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
