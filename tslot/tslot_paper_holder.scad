$fn=100;
/*
    Parametric Tslot Mounting of Paper Clip
    By Brian Khuu (2020)

    Got a desk with tslot rails, would be nice to be able to clip paper to it

    Remixed from https://www.thingiverse.com/thing:3045980 "Clip on paper holder" by Ken_Applications August 12, 2018
*/

use <tslot.scad>

/* [Tslot Spec] */
// CenterDepth
tslot_nut_profile_e = 6.5;
// CenterWidth
tslot_nut_profile_b = 8; // Gap to slot the clip though
// For the wedge... its based on a 4040mm Tslot... so may need to modify polygon() in this script

/* [Clip Spec] */
// Clip Width
standoff=tslot_nut_profile_b-1;
// Clip Standoff
hookthickness=2;

/* [Tslot Model] */
model_slot_gap = 10;
model_slot_side = 15;


/////////////// Modified Source From "Clip on paper holder" by Ken_Applications August 12, 2018 ////////

Alter_spring_gap=4;//[0:1:7]
paper_gap=0.5;//[0.2:0.1:0.5]
thickness=standoff;
grip_end_L1=20;
grip_end_L2=17;
grip_radius=13;

module round2d(OR=3,IR=1){
    offset(OR)offset(-IR-OR)offset(IR)children();
}

//////caculate sagitta (cord height)
sagitta=grip_radius-sqrt(grip_radius*grip_radius-(thickness/2)*(thickness/2));
echo (sagitta);

module main_shape()
{
    //Top
    intersection()
    {
        round2d(0.1,15)
        {
            translate([0,5.5,0]) rotate([0,0,0]) square([70,3],false);
            translate([0,-8,0]) rotate([0,0,-12]) square([70,3],false);
        }
        translate([79.5,-7.5,0]) circle(19);//spring radius .. need to calculate
    }
    //Bottom
    intersection()
    {
        round2d(0.8,8)
        {
            translate([0,5.5,0]) rotate([0,0,0]) square([100,3],false);
            translate([0,-8,0]) rotate([0,0,-12]) square([100,3],false);
        }
        translate([36,-3,0]) circle(19);//spring radius .. need to calculate
    }
    translate([0,5.5,0]) rotate([0,0,0]) square([70,3],false);//back straight
    translate([0,-8,0]) rotate([0,0,-12]) square([69,3],false);//front straight
    round2d(3,0) square([grip_end_L1,grip_end_L2],true);//grip end shape
}

module main_shape_3()
{
    round2d(0,1)
        main_shape();
}

module main_shape_2()
{
    linear_extrude(height=thickness)
        round2d(1,0)
        {
            main_shape_3();
        }
}

module ring(){
    difference(){
        circle(grip_radius);
        circle(grip_radius-paper_gap);
    }
}

module ring2()
{
    rotate([0,90,0])
        translate([-thickness/2,-grip_radius+sagitta/2,-grip_end_L1/2-.1])
            linear_extrude(height=grip_end_L1+.2)
                ring();
}

module main_minus_ring()
{
    difference()
    {
        main_shape_2();
        ring2();
   }
}

//main_minus_ring();


///////// End of Modified Source From "Clip on paper holder" by Ken_Applications August 12, 2018 ////////

/*****************
    Tslot Clip
******************/

if (1)
union()
{
    
    translate([0,0,0])
        tslot(tslot_nut_profile_e = tslot_nut_profile_e, tslot_nut_profile_b = tslot_nut_profile_b);


    translate([-0, -6.5-hookthickness, -thickness/2])
        main_minus_ring();
}


%translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);
%translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,100], center=true);

