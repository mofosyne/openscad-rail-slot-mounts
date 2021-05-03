$fn=100;
/*
    Parametric Cable Hooks For Tslot Mounting of ethernet cables
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to mount cable on it...

    Inspired by https://www.thingiverse.com/thing:2676595 "V-Slot Cable Clips by pekcitron November 30, 2017"

    // Also need to add https://makerware.thingiverse.com/thing:1719073
*/

use <tslot.scad>

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

/* [Clip Spec] */
// number of cable for holder
nClips=4;
// cable diameter
cableDia = 6.5;
// wall thikness */
wallThickness = 1.5;
// size of opening for cable
anglecut = 55; // [90]



/*****************
    clip() and clips() Functions from "cable clip / cable holder" by kenjo123 August 14, 2016
    Modified slightly for this design
    Source: https://makerware.thingiverse.com/thing:1719073
******************/

outer = cableDia + 2*wallThickness;

/* single clip, centered */
module clip(cable, outer, angel) {
    difference() {
	union() {
	    /* fill in the middle */
	    translate([-outer/2,0])
            square(outer/2);
	    translate([-outer/2,-outer/2])
            square(outer/2);

	    /* outer circle */
	    circle(d=outer);
	}
	/* remove cable circle */
	circle(d=cable);
	polygon(points=[[0,0],[ outer/2, tan(angel)*outer/2],[outer/2,-tan(angel)*outer/2]]);
    }
    /* Add rouded edge */
    hyp = ((outer-cable)/2 + cable)/2;

    translate([ cos(angel)*hyp , sin(angel)*hyp])
    circle(d=(outer-cable)/2);
    translate([ cos(angel)*hyp , -sin(angel)*hyp])
    circle(d=(outer-cable)/2);
}

module clips(num, h, cable, outer, angel) {
    w = outer * num;
    translate([outer/2,-w/2+outer/2,-h/2])
    linear_extrude(height=h) {
	for(idx=[0 : 1 : num-1  ]) {
	    translate([0, outer * idx])
	    clip(cable, outer, angel);
	}
    }
}

/*****************
    Tslot Clip
******************/

module tslotEthernetClip()
{
    union()
    {
        // Tslot
        tslot();

        // Hook
        difference()
        {
            union()
            {
                // tslot mount shaft
                translate([0, -hookthickness, 0])
                rotate([-90,0,0])
                    intersection()
                    {
                        cheight = tslot_centerdepth+hookthickness+hookwidth/2;
                        cylinder(r=tslot_centerwidth/2, h=hookthickness);
                        translate([0, 0, cheight/2])
                            cube([tslot_centerwidth+10, hookwidth, cheight], center=true);
                    }
            }
        }

        // Clip
        translate([0, -hookthickness, 0])
            rotate([0,0,-90])
            clips(nClips, hookwidth, cableDia, outer, anglecut);
    }
}


// Hook Stack
if (1)
{ 
    for(i = [0:1:4])
    {
        layerGapSpacing = 0.45;
        translate([0,0,i*(hookwidth+layerGapSpacing)])
            tslotEthernetClip();
    }
}

%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);

