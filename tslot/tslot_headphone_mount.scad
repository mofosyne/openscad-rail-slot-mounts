$fn=100;
/*
    Parametric Headphone Mount For Tslot Mounting
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to screwdriver on it...
*/

use <tslot.scad>

/* [Tslot Spec] */
// CenterDepth
tslot_centerdepth = 6.5;
// CenterWidth
tslot_centerwidth = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script


/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;

/* [Hook Calc] */
// Hook Width
hookwidth=7;

/* [Headphone Spec] */
headphoneRestWidth = 50;

/*****************/

module plug_inc_trrs_socket(plugdia, pluglength, plugdepth, outerdia, outerheight, sideshift)
{
  /* TRRS Spec */
  trrs_plugdia    = 3.5-0.2; //Make slightly smaller for snug fit
  trrs_plugdepth  = 15;
  trrs_pluglength = 3.5;
  /* TRRS Plug Lock */
  trrsLockRadius = 0.6;
  trrsLockHeight = outerheight-10;
  union()
  {
      /* TRRS Plug Lock */
      translate([0, (trrs_pluglength)/2 -sideshift, trrsLockHeight])
        rotate([0,90,0])
          cylinder(r = trrsLockRadius, trrs_plugdia, center=true);
      translate([0, -(trrs_pluglength)/2 -sideshift, trrsLockHeight])
        rotate([0,90,0])
          cylinder(r = trrsLockRadius, trrs_plugdia, center=true);
      /* Main Body */
      translate([0, -sideshift,0])
      difference()
      {
        union()
        {
          difference()
          {
            hull()
            {
              translate([0,(pluglength-plugdia)/2,0])
                cylinder(r = outerdia/2, outerheight);
              translate([0,-(pluglength-plugdia)/2,0])
                cylinder(r = outerdia/2, outerheight);
              
              /* Side Shift */
              translate([0,(pluglength-plugdia)/2 + sideshift,0])
                cylinder(r = outerdia/2, outerheight);
            }
          }
        }
        
        /* Socket Align cut */
        translate([0,0,outerheight])
          hull()
          {
            translate([0,(pluglength-plugdia)/2,0])
              cylinder(r=(outerdia/2), 1);
            translate([0,-(pluglength-plugdia)/2,0])
              cylinder(r=(outerdia/2), 1);
            translate([0,(pluglength-plugdia)/2,-1])
              cylinder(r=(plugdia/2), 1);
            translate([0,-(pluglength-plugdia)/2,-1])
              cylinder(r=(plugdia/2), 1);
          }

        /* TRRS Cut */
        translate([0,0,outerheight])
        hull()
        {
          translate([0,0,-plugdepth])
          cylinder(r=(trrs_plugdia)*2/3, plugdepth);
          translate([0,0,-plugdepth-1])
          cylinder(r=(trrs_plugdia/2), 1);
        }
        translate([0,0,outerheight-trrs_plugdepth])
          cylinder(r=(trrs_plugdia/2), trrs_plugdepth+1);

        /* Socket Cut */
        translate([0,0,outerheight-plugdepth])
          hull()
          {
            translate([0,(pluglength-plugdia)/2,0])
              cylinder(r=(plugdia/2), plugdepth+1);
            translate([0,-(pluglength-plugdia)/2,0])
              cylinder(r=(plugdia/2), plugdepth+1);
          }
        
        /* top wire wrap cut */
        difference()
        {
          hull()
          {
            translate([0,0,outerheight])
              cube( [outerdia+1, trrs_plugdia*2/3, 0.1], center=true);
            translate([0,0,outerheight-trrs_plugdepth+1])
              rotate([0,90,0])
                cylinder(r=1, outerdia, center=true);
          }
          
          // Enable to cut only on one side
          if (0)
          rotate([0,0,180])
            translate([(outerheight+4)/2,0,(outerheight+2)/2])
              cube((outerheight+4), center=true); 
        }
      }
    }
}

module typec_trrs_socket(outerdia, outerheight, sideshift, tol)
{
  typec_plugdia    = 2.5;
  typec_pluglength = 8.3;
  typec_plugdepth  = 6.5;
  plug_inc_trrs_socket(
      typec_plugdia+tol,
      typec_pluglength+0.5+tol,
      typec_plugdepth+tol,
      outerdia, outerheight, sideshift
    );
}

/*****************/


translate([0, -1, 0])
union()
{
    // Tslot
    tslot();

    // Hook
    union()
    {
        rotate([0,-90,0])
        intersection()
        {
            hh = 1;
            union()
            {
                // Long Flat
                rotate([90,0,0])
                    cylinder(r=tslot_centerwidth/2, h=headphoneRestWidth, center=false);
                translate([0, -headphoneRestWidth, 0])
                    rotate([90,0,0])
                        typec_trrs_socket(hookwidth, 16, 0, 0);

            }

            //bottomcut
            cw = hookwidth;
            translate([-cw/2,-1000/2,-1000/2])
                cube([cw,1000,1000], center=false);
        }
    }
}

