$fn=100;
/*
    Parametric Hooks For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to mount stuff on it...
*/

use <tslot.scad>

/* [Stacking] */
// Extra Copies
extraStackCopies = 0;

/* [Tslot Spec] */
// CenterDepth
//tslot_nut_profile_e = 6.5;
// CenterWidth
tslot_nut_profile_b = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

/* [Hook Spec] */
// Hook Diameter
hookdia=12;
// Hook Flange
hookflange=3;
// Hook Width
standoff=tslot_nut_profile_b-1;
// Hook Thickness
hookthickness=4;

module tslotHook()
{
    difference()
    {
        union()
        {
            // Tslot
            tslot();

            // tslot mount shaft
            translate([0, -hookthickness, 0])
                rotate([-90,0,0])
                intersection()
                {
                    cheight = hookthickness+hookthickness+standoff/2;
                    union()
                    {
                        cylinder(r=tslot_nut_profile_b/2, h=hookthickness);
                        translate([-(tslot_nut_profile_b+3)/4, 0, 1/2])
                            cube([(tslot_nut_profile_b+3)/2,standoff,1], center=true);
                    }
                    translate([0, 0, hookthickness/2])
                        cube([tslot_nut_profile_b, standoff, hookthickness], center=true);
                }

            // Hook
            translate([-hookdia/2-1, -hookdia/2-hookthickness, 0])
                rotate([0,0,-90])
                union()
                {
                    // Hook Bulk  
                    translate([0, 0, 0])
                        difference()
                        {
                            cylinder(r=hookdia/2+hookthickness, h=standoff, center=true);
                            translate([0,0,0])
                                cylinder(r=hookdia/2, h=standoff+2, center=true);
                            translate([0,hookdia/2,0])
                                cube([hookdia,hookdia,standoff+2], center=true);
                            rotate([0,0,10])
                                translate([hookdia/2,hookdia/2,0])
                                cube([hookdia,hookdia,standoff+2], center=true);
                        }
                    // Flange
                    translate([1, 3, 0])
                        hull()
                        {
                            translate([hookdia/2+hookthickness/2,0,0])
                                cylinder(r=hookthickness/2, h=standoff, center=true);
                            translate([hookdia/2+hookthickness/2+hookflange,hookflange,0])
                                cylinder(r=hookthickness/2, h=standoff, center=true);
                        }
                    // Grip for screwdriver
                    translate([7,2,0])
                        cylinder(r=3, h=standoff, center=true);
                }
        }

        // Holes
        translate([-hookdia/2-1, -hookdia/2-hookthickness, 0])
            rotate([0,0,-90])
            union()
            {
                screwHolderCut=(standoff+1)/2;
                translate([0,0,0])
                    cylinder(r=hookdia/2, h=standoff+2, center=true);
                translate([0,0,(screwHolderCut/4-standoff/2)-0.5])
                    cylinder(r1=hookdia/2+hookthickness-1, r2=hookdia/2, h=screwHolderCut/2, center=true);
                translate([0,0,-(screwHolderCut/4-standoff/2)+0.5])
                    cylinder(r2=hookdia/2+hookthickness-1, r1=hookdia/2, h=screwHolderCut/2, center=true);
            }
    }
}

// Hook Stack
if (1)
{ 
    for(i = [0:1:extraStackCopies])
    {
        layerGapSpacing = 0.45;
        translate([0,0,i*(standoff+layerGapSpacing)])
            tslotHook();
    }
}