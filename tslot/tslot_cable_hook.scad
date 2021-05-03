$fn=100;
/*
    Parametric Cable Hooks For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to mount cable on it...

    Inspired by https://www.thingiverse.com/thing:2676595 "V-Slot Cable Clips by pekcitron November 30, 2017"
*/

/* [Tslot Spec] */
// CenterDepth
tslot_centerdepth = 6.5;
// CenterWidth
tslot_centerwidth = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

/* [Hook Spec] */
// Spacing between centerpoint
hookcenterspacing=10;
// Hook Diameter
hookdia=10;
// Hook Flange
hookflange=3;
// Hook Width
hookwidth=7;
// Hook Thickness
hookthickness=2;

/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;

translate([0, -1, 0])
union()
{
    difference()
    {
        union()
        {
            // Tslot Mount Inner
            translate([0, tslot_centerdepth, 0])
                intersection()
                {
                    heightlim=6;
                    es=1;
                    linear_extrude(height = hookwidth, center = true)
                        polygon(points=[[-10-es,0],[-5-es,8],[5+es,8],[10+es,0]]);
                    rotate([-90,0,0])
                        intersection()
                        {
                            hull()
                            {
                                translate([0,0,0]) cylinder(r=10+es, h=0.1);
                                translate([0,0,8]) cylinder(r=5+es, h=0.1);
                            }
                            union()
                            {
                                translate([0,0,heightlim/2+tslot_centerdepth/4])
                                    cube([20+es*2,20,heightlim-tslot_centerdepth/2], center = true);
                                intersection()
                                {
                                    rotate([0,90,0])
                                        translate([-tslot_centerdepth/2,0,0])
                                        cylinder(r=hookwidth/2, h=20+es*2, center = true);
                                    cube([20+es*2,20,hookwidth+1], center = true);
                                }
                            }
                        }
                }

            // tslot mount shaft
            translate([0, -hookthickness, 0])
            rotate([-90,0,0])
                intersection()
                {
                    cheight = tslot_centerdepth+hookthickness+hookwidth/2;
                    union()
                    {
                        cylinder(r=tslot_centerwidth/2, h=cheight);
                        translate([-hookwidth/2+1, 0, hookthickness-hookthickness/2])
                            cube([tslot_centerwidth,hookwidth,hookthickness], center=true);
                    }
                    translate([0, 0, cheight/2])
                        cube([tslot_centerwidth+10, hookwidth, cheight], center=true);
                }
        }

        //
        translate([0, 100/2, 0])
            cube([2,100,100], center=true);

    }

    // Hook
    translate([0, -hookdia/2-hookthickness, 0])
    union()
    {
        difference()
        {
            hull()
            {
                translate([hookdia/2+hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                translate([-hookdia/2-hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
            }
            hull()
            {
                translate([hookdia/2+hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2, h=hookwidth+1, center=true);
                translate([-hookdia/2-hookcenterspacing/2,0,0])
                    cylinder(r=hookdia/2, h=hookwidth+1, center=true);
            }
            translate([hookdia+hookdia/2+hookthickness/2,0,0])
                cube([hookthickness+1,1,hookwidth+2], center=true);
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
