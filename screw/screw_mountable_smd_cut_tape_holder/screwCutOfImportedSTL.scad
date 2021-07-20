// This was used to cut a hole in https://www.thingiverse.com/thing:2463048/files

module drillHole(){
    backplateThickness=8;
    drillholeDiameter=8;
    countersunkDiameter=15;
    countersunkHeight=2;
    slideInSlot=true;
    translate([0,-backplateThickness-0.001,0])
        rotate([-90,0,0])
        {
            translate([0,0,-0.001])
                cylinder(r=drillholeDiameter/2,h=backplateThickness,$fn=fn);
            translate([0,0,backplateThickness-countersunkHeight+0.001])
                cylinder(r1=drillholeDiameter/2,r2=countersunkDiameter/2,h=countersunkHeight+0.002,$fn=fn);
            if (slideInSlot)
            hull()
            {
                translate([0,0,-0.001])
                    cylinder(r=drillholeDiameter/2,h=backplateThickness+countersunkHeight,$fn=fn);
                translate([0,100,-0.001])
                    cylinder(r=drillholeDiameter/2,h=backplateThickness+countersunkHeight,$fn=fn);
            }
        }
}

rotate([0,90,0])
{    
    difference()
    {   
        //import("headphonehook_new.stl");
        translate([0,-0.5,0]) rotate([180,0,0]) drillHole();
    }
}