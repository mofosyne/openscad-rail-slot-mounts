$fn=100;
/*
    Parametric Cable Loop For Tslot Mounting
    By Brian Khuu (2020)
    
    Got a desk with tslot rails, would be nice to organise cable
*/

use <tslot.scad>

/* tslot spec */
mountCenterDepth = 7;
mountCenterWidth = 10;
mountWidth = 7;
mountStandoff = 5;
mountTol = 1;


/* [Clip Spec] */
// X Width
clipx = 35;
// Y Width
clipy = 15;
// Clip Rounding Diameter
hookdia=5;
// Clip Width
hookwidth = mountCenterWidth - mountTol;
// Thickness
hookthickness=2;

/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;

translate([0, 0, 0])
union()
{
    translate([0,0,0])
        tslot(tslot_centerdepth = mountCenterDepth, tslot_centerwidth = mountCenterWidth, hookwidth=mountWidth, standoff=mountStandoff, cWidthTol = mountTol);

    // Cable Loop
    translate([0, -hookdia/2-hookthickness, 0])
    union()
    {
       difference()
       {
            union()
            {
                difference()
                {
                    hull()
                    {
                        translate([clipx/2 - hookdia/2,0,0])
                            cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                        translate([-clipx/2 +hookdia/2,0,0])
                            cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                        translate([clipx/2 - hookdia/2,-clipy+hookdia/2,0])
                            cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                        translate([-clipx/2 +hookdia/2,-clipy+hookdia/2,0])
                            cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                    }
                    hull()
                    {
                        translate([clipx/2 - hookdia/2,0,0])
                            cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                        translate([-clipx/2 +hookdia/2,0,0])
                            cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                        translate([clipx/2 - hookdia/2,-clipy+hookdia/2,0])
                            cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                        translate([-clipx/2 +hookdia/2,-clipy+hookdia/2,0])
                            cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                    }
                }
                hull()
                {
                    translate([5,-clipy-hookdia/2+1.5,0])
                        cylinder(r=hookthickness*0.8, h=hookwidth, center=true);
                    translate([-5,-clipy-hookdia/2+1.5,0])
                        cylinder(r=hookthickness*0.8, h=hookwidth, center=true);
                }
            }
            // Cut
            #translate([0,-clipy-hookdia/2+1.5,0])
                rotate([0,0,80])
                cube([0.5,hookthickness+15,hookwidth+2], center=true);
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
