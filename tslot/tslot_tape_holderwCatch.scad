// Remix of SMD tape holder tool by Lon Cecil 
// Original Source: https://www.thingiverse.com/thing:2720307
// Remixed By Mofosyne 2021 July
// 
$fn=100;

use <tslot.scad>

// holder for SMD tape prototype work
// paper tape or plastic slides into slot with
// clear tape up. Uncover only one part !!
// pick up part with vacuum chuck or tweezers
// or tap tape to vibrate out of pocket.
// Lon Cecil   12/17/2017 ver 0.4
Tape1=6;
Tape2=12;
Tape3=8;
Tape4=4;
Tape5=10;
// tape strip area base
Len=80;
Wid=60;
Dep=8;

translate([0,Len/2+Dep+0.5,0.5])
    tslot();

// cut trapezoid slots with 1 mm 
// rectangular relief on bottom
// No provision for pockets on tape
difference(){
   base([Len, Wid, Dep]);
   translate([-30,1+Wid/2,4.5])
   slot(Tape1);
   translate([-27.9,Wid/2,6])
   taperelief(Tape1,3.0); 
    
   translate([-15,1+Wid/2,4.5])
   slot(Tape5);
   translate([-11.6,Wid/2,5])
   taperelief(Tape5,3.0); 
    
   translate([0,1+Wid/2,6])
   slot(Tape2);
   translate([4.2,Wid/2,8.5])
   taperelief(Tape2,6.0);
    
   translate([20,1+Wid/2,4.85])
   slot(Tape3);
   translate([22.8,Wid/2,5.6])
   taperelief(Tape3,3.0);
    
   translate([35,1+Wid/2,4.25])
   slot(Tape4);
   translate([36.4,Wid/2,6.1])
   taperelief(Tape4,3.0); 
     }
 // add block for chip pocket
difference() {
   translate([-Len/2, 0.1+Wid/2, -Dep/2])
   cube([Len,20,Dep]);
   translate([-38,29.9,-1])
   cube([Len-4,18.4,Dep-2]);
    }  
    
module base(Length, Width, Thickness) {
    translate(-Length/2, -Width/2,-Thickness+5)
    cube(Length, Width, Thickness);
     }
module slot(Width, Depth) {
    rotate([90,30,0])
    cylinder(r=Width*0.59, h=62, $fn=3);     
     }
module taperelief(Width, Depth) {
    rotate([-180,0,0])
    translate([-(Width*.85),0,Depth])
    cube([Width,62,1.0]);    
     }