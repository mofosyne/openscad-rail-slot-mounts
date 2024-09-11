$fn=100;
/*
    Parametric Cable Hooks For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to mount cable on it...

    Inspired by https://www.thingiverse.com/thing:2676595 "V-Slot Cable Clips by pekcitron November 30, 2017"
*/

use <tslot.scad>

/* [Tslot Spec] */
// CenterDepth
tslot_nut_profile_e = 6.5;
// CenterWidth
tslot_nut_profile_b = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

/* [Hook Spec] */
// Spacing between centerpoint
hookcenterspacing=10;
// Hook Diameter
hookdia=10;
// Hook Flange
hookflange=3;
// Hook Width
standoff=tslot_nut_profile_b-1;
// Hook Thickness
hookthickness=2;

/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;

translate([0, -1, 0])
union()
{

    translate([0,0,0])
        tslot(tslot_nut_profile_e = tslot_nut_profile_e, tslot_nut_profile_b = tslot_nut_profile_b);

    // Hook
    translate([0, -hookdia/2-hookthickness, 0])
    union()
    {
        difference()
        {
            hull()
            {
                translate([hookdia/2+hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
                translate([-hookdia/2-hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
            }
            hull()
            {
                translate([hookdia/2+hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([-hookdia/2-hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
            }
            translate([hookdia+hookdia/2+hookthickness/2,0,0])
                cube([hookthickness+1,1,standoff+2], center=true);
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
