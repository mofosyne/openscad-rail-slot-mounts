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
mountStandoff = 5;
mountTol = 1;


/* [PCB Slot Mount Spec] */
// X Width
clipx = 15;
// Y Width
clipy = 2; // 2mm
// Clip Rounding Diameter
hookdia=0.5;
// Clip Width
standoff = mountCenterWidth - mountTol;
// Thickness
hookthickness=1.5;
// Extra Standoff
extStandoff = 5;

/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;

translate([0, 0, 0])
union()
{
    tslot(tslot_nut_profile_e = mountCenterDepth, tslot_nut_profile_b = mountCenterWidth, standoff=mountStandoff, cWidthTol = mountTol);

    // Cable Loop
    translate([0, 0, 0])
    intersection()
    {
        hull()
        {
            rotate([90,0,0])
                cylinder(r=mountCenterWidth/2, h=0.1, center=true);
            translate([clipx/2+hookthickness/4,-extStandoff-hookthickness/2,0])
                cylinder(r=hookthickness/2, h=standoff, center=true);
            translate([-clipx/2-hookthickness/4,-extStandoff-hookthickness/2,0])
                cylinder(r=hookthickness/2, h=standoff, center=true);
        }
        cube([100,100, standoff], center=true);
    }

    // Cable Loop
    translate([0, -hookthickness - extStandoff, 0])
    union()
    {
        translate([clipx/2 + hookthickness/2,0,0])
            cylinder(r=(hookthickness)/2, h=standoff, center=true);
        translate([clipx/2 + hookthickness/2,-clipy-hookdia/2,0])
            cylinder(r=(hookthickness)/2, h=standoff, center=true);
        
        translate([0, -hookdia/2, 0])
        difference()
        {
            hull()
            {
                translate([clipx/2 - hookdia/2,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
                translate([-clipx/2,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
                translate([clipx/2 - hookdia/2,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
                translate([-clipx/2,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
            }
            hull()
            {
                translate([clipx/2 - hookdia/2,0,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([-clipx/2 +hookdia/2,0,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([clipx/2 - hookdia/2,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([-clipx/2 +hookdia/2,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
            }
            // Top Cut
            hull()
            {
                translate([clipx/2 - hookdia/2 + hookthickness+1,0,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([clipx/2 - hookdia/2 + hookthickness+1,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([clipx/2 - hookdia/2,0,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
                translate([clipx/2 - hookdia/2,-clipy+hookdia/2,0])
                    cylinder(r=hookdia/2, h=standoff+1, center=true);
            }
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
