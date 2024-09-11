$fn=100;
/*
    Parametric Headphone Mount For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to screwdriver on it...
*/

/* [Tslot Spec] */
// CenterDepth
//tslot_nut_profile_e = 6.5;
// CenterWidth
//tslot_nut_profile_b = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

// Note: Total height of this object is (tslot_nut_profile_b - cWidthTol), this is done this way to adjust for varying printing tolerance

// 2021-07-28: tslot_nut_profile_e = 7, tslot_nut_profile_b = 10, standoff=7, standoff=5, cWidthTol = 1

module tslot(tslot_nut_profile_e = 7, tslot_nut_profile_b = 8, tslot_nut_profile_g=1, tslot_nut_profile_a=20, standoff=8.5, cWidthTol = 1)
{
    drillholeDiameter=8-1.3; // Allow Standoff be used as mounting post (Currently using 8mm screws)
    split_grip=1.5;
    split_gap=2;
    split_tol=0.5;

    flexture_standoff = 2;
    
    tslot_flexture = standoff - flexture_standoff;

    stabliserD=4.5; // 4
    
    difference()
    {
        union()
        {
            // Tslot Mount Inner
            extraGrip = 0.25;
            translate([0,tslot_flexture+flexture_standoff+stabliserD,0])
            intersection()
            {
                ss = 0.5; ///< Smoothing
                translate([0,-ss,0])
                minkowski()
                {
                    hull()
                    {
                        negTol = 0.25;
                        posTol = 1.5;
                        translate([0, negTol,0]) cube([(tslot_nut_profile_a)-2*ss, 0.1, tslot_nut_profile_b-cWidthTol-2*ss], center=true);
                        translate([0, tslot_nut_profile_g,0]) cube([(tslot_nut_profile_a)-2*ss, 0.1, tslot_nut_profile_b-cWidthTol-2*ss], center=true);
                        translate([0, tslot_nut_profile_e,0]) cube([tslot_nut_profile_b-2*ss, 0.1, tslot_nut_profile_b-cWidthTol-2*ss], center=true);
                    }
                    sphere(r=ss);
                }
                rotate([-90,0,0])
                    cylinder(r=((tslot_nut_profile_a)/2)+extraGrip, h=tslot_nut_profile_e);
            }

            // Stabliser
            // Note: Added extra 'split_grip' to account for the 'press fit' of the side clips
            translate([0, tslot_flexture+flexture_standoff+stabliserD/2, 0])
            rotate([-90,0,0])
                intersection()
                {
                    stabTol = 0.25;
                    union()
                    {
                        translate([0,0,0])
                            cylinder(r=(tslot_nut_profile_b-stabTol+split_grip)/2+0.12, h=stabliserD, center=true);
                        translate([tslot_nut_profile_b/4+split_grip, tslot_nut_profile_b/4, 0])
                            cube([(tslot_nut_profile_b-stabTol*2)/2, tslot_nut_profile_b/2, stabliserD], center=true);
                        translate([-tslot_nut_profile_b/4-split_grip, -tslot_nut_profile_b/4, 0])
                            cube([(tslot_nut_profile_b-stabTol*2)/2, tslot_nut_profile_b/2, stabliserD], center=true);
                    }
                    translate([0,0,0])
                        cube([tslot_nut_profile_b+split_grip, tslot_nut_profile_b-cWidthTol, stabliserD], center=true);
                }

            // This will change the stiffness
            slimming=0.5;

            // This is more for looking symmetric...
            // but means it's less easy to print
            symmetric_shaft_cube = false;
            connecting_shaft_height = symmetric_shaft_cube ? drillholeDiameter : (tslot_nut_profile_b-cWidthTol);
            
            // tslot mount shaft
            rotate([-90,0,0])
                intersection()
                {
                    cheight = flexture_standoff+tslot_flexture;
                    cylinder(r=tslot_nut_profile_b/2, h=cheight);
                    union()
                    {
                        hull()
                        {
                            translate([0, 0, 0])
                                cube([tslot_nut_profile_b, tslot_nut_profile_b-cWidthTol, 0.01], center=true);
                            translate([0, 0, flexture_standoff/2])
                                cube([tslot_nut_profile_b, tslot_nut_profile_b-cWidthTol, 0.01], center=true);
                            translate([0, 0,  flexture_standoff])
                                cube([tslot_nut_profile_b-slimming, connecting_shaft_height, 0.1], center=true);
                        }
                        hull()
                        {
                            translate([0, 0,  flexture_standoff])
                                cube([tslot_nut_profile_b-slimming, connecting_shaft_height, 0.1], center=true);
                            translate([0, 0,  cheight*0.8])
                                cube([tslot_nut_profile_b-slimming, connecting_shaft_height, 0.1], center=true);
                        }
                        hull()
                        {   
                            translate([0, 0,  cheight*0.8])
                                cube([tslot_nut_profile_b-slimming, connecting_shaft_height, 0.1], center=true);
                            translate([0, 0,  cheight])
                                cube([tslot_nut_profile_b, tslot_nut_profile_b-cWidthTol, 0.01], center=true);
                        }
                    }
                }
        }

        // Split
        translate([0, 100/2+flexture_standoff, 0])
            cube([(split_gap+split_tol),100,100], center=true);

        // Hull
        hull()
        {
            translate([0, 100/2+tslot_flexture+flexture_standoff+stabliserD,0])
                cube([(split_gap+split_tol),100,100], center=true);
            translate([0, 100/2+tslot_flexture+flexture_standoff+stabliserD+tslot_nut_profile_e/2,0])
                cube([tslot_nut_profile_b*2/3,100,100], center=true);
        }
    }
}


/* [Tslot Model] */
// Using tslot_lock_nut_dia.svg as reference for letter dimentions
model_slot_gap = 10;
model_slot_side = 15;
model_slot_depth = 4;
model_slot_centerdepth = 7;
model_slot_g_side = 1;
model_slot_e_side = 6.5;
model_slot_i_side = model_slot_gap;
//%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,model_slot_depth,100], center=true);
//%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,model_slot_depth,100], center=true);

translate([0,4,0])
%difference()
{
    wallDepth=model_slot_depth+5;
    translate([0,model_slot_centerdepth+wallDepth/2,0]) cube([model_slot_side*2+model_slot_gap,wallDepth,100], center=true);

    translate([0,model_slot_centerdepth+model_slot_depth/2,0]) cube([model_slot_gap,model_slot_depth+0.1,100+0.1], center=true);
   
    translate([0,model_slot_centerdepth+model_slot_depth/2+model_slot_g_side/2,0]) cube([20,model_slot_g_side+0.1,100+0.1], center=true);

    hull()
    {
        translate([0,model_slot_centerdepth+model_slot_depth/2+model_slot_g_side,0]) cube([20,0.1,100+0.1], center=true);
        translate([0,model_slot_centerdepth+model_slot_depth/2+(model_slot_g_side+model_slot_e_side),0]) cube([model_slot_i_side,0.1,100+0.1], center=true);
    }
}

//rotate([0,90,0])
tslot();