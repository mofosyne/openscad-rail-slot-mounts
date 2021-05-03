$fn=100;
/*
    Parametric Screwdriver hook For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to screwdriver on it...
*/

/* [Tslot Spec] */
// CenterDepth
tslot_centerdepth = 6.5;
// CenterWidth
tslot_centerwidth = 8; // Gap to slot the clip though
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
hookwidth=7;
// Hook Thickness
hookthickness=screwdriver_top_dia-hookdia; // This is extra rest for the screwdriver head


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
                    cylinder(r=tslot_centerwidth/2, h=cheight);
                    translate([0, 0, cheight/2])
                        cube([tslot_centerwidth+10, hookwidth, cheight], center=true);
                }
        }

        // Split
        translate([0, 100/2, 0])
            cube([2,100,100], center=true);

    }

    // Hook
    translate([0, -hookdia/2-hookthickness*2, 0])
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
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);
                translate([xx,0,0])
                    cylinder(r=hookdia/2+hookthickness, h=hookwidth, center=true);

                // Long Flat
                rotate([90,0,0])
                    cylinder(r=tslot_centerwidth/2, h=hookdia+hookthickness*2, center=true);
            }

            // Grip Side 1
            hull()
            {
                //Outer
                translate([xx+hh,0,hookwidth/2+0.5])
                    cylinder(r=(hookdia/2+hookthickness-1), h=0.1, center=true);
                translate([xx   ,0,hookwidth/2+0.5])
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
                translate([xx+hh,0,-hookwidth/2-0.5])
                    cylinder(r=(hookdia/2+hookthickness-1), h=0.1, center=true);
                translate([xx   ,0,-hookwidth/2-0.5])
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
                    cube([hookdia+hookthickness+1,1,hookwidth+2], center=true);
                rotate([0,0,-degreecut/2])
                    translate([(hookdia+hookthickness+1),0,0])
                    cube([hookdia+hookthickness+1,1,hookwidth+2], center=true);
            }

            // Slide In Cut
            translate([hh,0,0])
            hull()
            {
                translate([(hookdia+hookthickness+10),0,0])
                    cube([1,screwdriver_small_dia+1,hookwidth+2], center=true);
                translate([((hookdia+hookthickness)/2),0,0])
                    cube([1,screwdriver_small_dia+1,hookwidth+2], center=true);
            }

            //bottomcut
            translate([-10-hookwidth/2,-100/2,-100/2])
                cube([10,100,100]);
        }
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
