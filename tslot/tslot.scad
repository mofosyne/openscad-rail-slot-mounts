$fn=100;
/*
    Parametric Headphone Mount For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to screwdriver on it...
*/

/* [Tslot Spec] */
// CenterDepth
//tslot_centerdepth = 6.5;
// CenterWidth
//tslot_centerwidth = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

// Note: Total height of this object is (tslot_centerwidth - cWidthTol), this is done this way to adjust for varying printing tolerance

// 2021-07-28: tslot_centerdepth = 7, tslot_centerwidth = 10, hookwidth=7, standoff=5, cWidthTol = 1

module tslot(tslot_centerdepth = 7, tslot_centerwidth = 10, hookwidth=7, standoff=5, cWidthTol = 1)
{
    drillholeDiameter=8-1.3; // Allow Standoff be used as mounting post (Currently using 8mm screws)
    tslot_centerdepth = tslot_centerdepth + standoff;
    difference()
    {
        union()
        {
            // Tslot Mount Inner
            translate([0,tslot_centerdepth+hookwidth/2-2,0])
            intersection()
            {                        
                extraGrip = 0.25;
                minkowski()
                {
                    ss = 0.5; ///< Smoothing
                    hull()
                    {
                        negTol = 0.25;
                        posTol = 1.5;
                        translate([0,   negTol,0]) cube([20+extraGrip-2*ss, 0.1, tslot_centerwidth-cWidthTol-2*ss], center=true);
                        translate([0, 4-negTol,0]) cube([20+extraGrip-2*ss, 0.1, tslot_centerwidth-cWidthTol-2*ss], center=true);
                        translate([0, 6-posTol,0]) cube([15-2*ss,           0.1, tslot_centerwidth-cWidthTol-2*ss], center=true);
                    }
                    sphere(r=ss);
                }
                rotate([-90,0,0])
                    cylinder(r=10+extraGrip, h=10);
            }

            // Stabliser
            translate([0, 4, 0])
            rotate([-90,0,0])
                intersection()
                {
                    stabliserD=4;
                    cheight = tslot_centerdepth+hookwidth/2+2;
                    stabTol = 0.25;
                    union()
                    {
                        translate([0,0,cheight/2])
                            cylinder(r=(tslot_centerwidth-stabTol)/2+0.12, h=stabliserD, center=true);
                        translate([tslot_centerwidth/4, tslot_centerwidth/4, cheight/2])
                            cube([(tslot_centerwidth-stabTol*2)/2, tslot_centerwidth/2, stabliserD], center=true);
                        translate([-tslot_centerwidth/4, -tslot_centerwidth/4, cheight/2])
                            cube([(tslot_centerwidth-stabTol*2)/2, tslot_centerwidth/2, stabliserD], center=true);
                    }
                    translate([0,0,cheight/2])
                        cube([tslot_centerwidth, tslot_centerwidth-cWidthTol, stabliserD], center=true);
                }

            // This will change the stiffness
            slimming=1.5;

            // tslot mount shaft
            translate([0, 0, 0])
            rotate([-90,0,0])
                intersection()
                {
                    cheight = tslot_centerdepth+hookwidth/2+3;
                    cylinder(r=tslot_centerwidth/2, h=cheight);
                    union()
                    {
                        hull()
                        {
                            translate([0, 0, 0])
                                cube([tslot_centerwidth, tslot_centerwidth-cWidthTol, 0.01], center=true);
                            translate([0, 0,  cheight/2 - standoff])
                                cube([tslot_centerwidth-slimming, drillholeDiameter, 0.1], center=true);
                        }
                        hull()
                        {
                            translate([0, 0,  cheight/2 - standoff])
                                cube([tslot_centerwidth-slimming, drillholeDiameter, 0.1], center=true);
                            translate([0, 0,  cheight/2+1])
                                cube([tslot_centerwidth-slimming, drillholeDiameter, 0.1], center=true);
                        }
                        hull()
                        {   
                            translate([0, 0,  cheight/2+1])
                                cube([tslot_centerwidth-slimming, drillholeDiameter, 0.1], center=true);
                            translate([0, 0,  cheight/2+2-0.5])
                                cube([tslot_centerwidth, tslot_centerwidth-cWidthTol, 0.01], center=true);
                        }
                    }
                }
        }

        // Split
        translate([0, 100/2+standoff-1.5, 0])
            cube([2.3,100,100], center=true);
    }
}


/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;
model_slot_depth = 4;
model_slot_centerdepth = 7;
//%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,model_slot_depth,100], center=true);
//%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,model_slot_depth,100], center=true);

translate([0,4,0])
%difference()
{
    wallDepth=model_slot_depth+4;
    translate([0,model_slot_centerdepth+wallDepth/2,0]) cube([model_slot_side*2+model_slot_gap,wallDepth,100], center=true);

    translate([0,model_slot_centerdepth+model_slot_depth/2,0]) cube([model_slot_gap,model_slot_depth+0.1,100+0.1], center=true);
   
    translate([0,model_slot_centerdepth+model_slot_depth/2+(4)/2,0]) cube([20,4+0.1,100+0.1], center=true);

    hull()
    {
        translate([0,model_slot_centerdepth+model_slot_depth/2+4,0]) cube([20,0.1,100+0.1], center=true);
        translate([0,model_slot_centerdepth+model_slot_depth/2+6,0]) cube([15,0.1,100+0.1], center=true);
    }
}

//rotate([0,90,0])
tslot();