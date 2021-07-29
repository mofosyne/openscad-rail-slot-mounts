$fn=100;
/*
    Parametric Side PCB Slot Mount Tab For Tslot Mounting
    By Brian Khuu (2020)
    
    Got a PCB with slot mount tabs on each end...
*/

use <tslot.scad>

/* tslot spec */
mountCenterDepth = 7;
mountCenterWidth = 10;
mountWidth = 7;
mountStandoff = 5;
mountTol = 1;


/* [PCB Slot Mount Spec] */
// X Width
clipx = 13;
// Y Width
clipy = 2.5; // 2mm
// Clip Rounding Diameter
hookdia=0.5;
// Clip Width
hookwidth = mountCenterWidth - mountTol;
// Thickness
hookthickness=2;
// Extra Standoff
extStandoff = 8;

/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;

translate([0, 0, 0])
union()
{
    tslot(tslot_centerdepth = mountCenterDepth, tslot_centerwidth = mountCenterWidth, hookwidth=mountWidth, standoff=mountStandoff, cWidthTol = mountTol);

    // Cable Loop
    translate([0, 0, 0])
    intersection()
    {
        hull()
        {
            rotate([90,0,0])
                cylinder(r=mountCenterWidth/2, h=0.1, center=true);
            translate([clipx/2+hookthickness/4,-extStandoff-hookthickness/2,0])
                cylinder(r=hookthickness/2, h=hookwidth, center=true);
            translate([-clipx/2-hookthickness/4,-extStandoff-hookthickness/2,0])
                cylinder(r=hookthickness/2, h=hookwidth, center=true);
        }
        cube([100,100, hookwidth], center=true);
    }

    // Cable Loop
    translate([0, -hookthickness - extStandoff, 0])
    union()
    {
        // Teeth Sets
        union()
        {
            // Teeth Set 1
            topExtra = clipy*4+1;
            gripExtra = 0.6;
            gripInset = 0.5;
            intersection()
            {
                translate([-hookdia-gripExtra-0.03, 0, 0])
                union()
                {
                    translate([clipx/2 + topExtra,gripInset,0])
                        cylinder(r=clipy/2+gripExtra, h=hookwidth, center=true);
                    translate([clipx/2 + topExtra - clipy*2,gripInset*1.4,0])
                        cylinder(r=clipy/2+gripExtra, h=hookwidth, center=true);
                }
                // Top Cut
                translate([0, -hookdia/2, 0])
                hull()
                {
                    translate([clipx/2 - clipy/2 + hookthickness+topExtra,hookdia/2,0])
                        cylinder(r=0.1, h=hookwidth, center=true);
                    translate([clipx/2 - clipy/2 + hookthickness+topExtra,-clipy,0])
                        cylinder(r=0.1, h=(hookwidth)/2, center=true);
                    translate([clipx/2 - clipy/2,+hookdia/2,0])
                        cylinder(r=0.1, h=hookwidth, center=true);
                    translate([clipx/2 - clipy/2,-clipy,0])
                        cylinder(r=0.1, h=(hookwidth)/2, center=true);
                }
            }
            // Teeth Set 2
            intersection()
            {
                translate([-hookdia-gripExtra-0.03, 0, 0])
                union()
                {
                    translate([clipx/2 + topExtra - clipy,-clipy-gripInset,0])
                        cylinder(r=clipy/2+gripExtra, h=hookwidth, center=true);
                    translate([clipx/2 + topExtra - clipy*3,-clipy-gripInset*1.4,0])
                        cylinder(r=clipy/2+gripExtra, h=hookwidth, center=true);
                }
                // Top Cut
                translate([0, -hookdia/2, 0])
                hull()
                {
                    translate([clipx/2 - clipy/2 + hookthickness+topExtra,hookdia/2,0])
                        cylinder(r=0.1, h=(hookwidth)/2, center=true);
                    translate([clipx/2 - clipy/2 + hookthickness+topExtra,-clipy,0])
                        cylinder(r=0.1, h=hookwidth, center=true);
                    translate([clipx/2 - clipy/2,+hookdia/2,0])
                        cylinder(r=0.1, h=(hookwidth)/2, center=true);
                    translate([clipx/2 - clipy/2,-clipy,0])
                        cylinder(r=0.1, h=hookwidth, center=true);
                }
            }
        }
        // Loop
        translate([0, -hookdia/2, 0])
        difference()
        {
            hull()
            {
                topExtra = clipy*4;
                bottomExtra = 1;
                translate([clipx/2 - hookdia/2+topExtra,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                translate([clipx/2 - hookdia/2+topExtra-clipy,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                translate([-clipx/2-bottomExtra,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                translate([-clipx/2-bottomExtra,-clipy+hookdia/2,0])
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
            // Top Cut
            hull()
            {
                topExtra = clipy*4+1;
                translate([clipx/2 - hookdia/2 + hookthickness+topExtra,0,0])
                    cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                translate([clipx/2 - hookdia/2 + hookthickness+topExtra,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                translate([clipx/2 - hookdia/2,0,0])
                    cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                translate([clipx/2 - hookdia/2,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2, h=hookwidth+1, center=true);
            }
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
