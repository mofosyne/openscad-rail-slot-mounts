/*
    Screw mountable SMD Tray
    Remixed By Brian Khuu (2020 July)
    
    (Based off Screw mountable wire holder but with settings changes)

    Adjusted for pixel lab (2020 July):
    * backplateThickness : Thicker for easier mounting
    * holderLengthA : Reduced to keep screwdriver in place
    * holderLengthB : Reduced to keep screwdriver in place
    * holderAngle : Reduced to keep screwdriver in place
    * countersunkDiameter : Increased a mm to be easier to screw include
    * holderGapSizeDef : 7.5 -> 10.5mm for pixel's mini screwdriver

---------------- Old description ------------
    Screw mountable wire holder
    For use with T-slot V-slots nuts and screws

    Remixed From: Customizable OpenSCAD Wire Holder, Kabelkamm by AndreasG4ris 
    licensed under the Creative Commons - Attribution license. (https://www.thingiverse.com/thing:2823064)
    
    ## For typical usage, just changes these two variables
    drillholeDiameter=8;
    countersunkDiameter=14;
    
*/

backplateThickness=8;
backplateHeight=0; // Set to minimum as we don't need it...
backplateSupportHeight=20;
supportWallThickness=3;
holderThickness=4;
holderLengthA=15;
holderLengthB=10;
holderAngle=40;
cnt=7;
holderGapSizeDef=[10.5,0];
holderGapSizeDefCount=[cnt,1];
holderSizeDef=[11];
holderSizeDefCount=[cnt+1];
fn=40;
drillholeDiameter=8;
countersunkDiameter=15;
countersunkHeight=2;
roundEdge=[true,true,true,true];
backplateHeightTotal=backplateHeight+holderThickness+backplateSupportHeight;
holderGapSize=declareVector(holderGapSizeDef,holderGapSizeDefCount);
holderSize=declareVector(holderSizeDef,holderSizeDefCount);
holderTotalSize=holderSize+holderGapSize;
totalLength=sumVector(holderTotalSize);
totalLengthAccumulate=accumulateVector(holderTotalSize);
count=sumVector(holderSizeDefCount);
assert(count==sumVector(holderGapSizeDefCount));

function sumVector(v) = sumVectorRun(v,0);
function sumVectorRun(v,i) = i<len(v) ? sumVectorRun(v,i+1)+v[i] : 0; 
function accumulateVector(v) = accumulateVectorRun(v,[0]);
function accumulateVectorRun(v,vret) = len(vret)<=len(v) ? accumulateVectorRun(v,concat(vret,[vret[len(vret)-1]+v[len(vret)-1]])) : vret;
function declareVector(v,cnt) = declareVectorRun(v,cnt,[],0,0);
function declareVectorRun(v,cnt,vret,cntNr,vNr) = vNr <= len(v) ? (cntNr < cnt[vNr] ? declareVectorRun(v,cnt,concat(vret,[v[vNr]]),cntNr+1,vNr) : declareVectorRun(v,cnt,vret,0,vNr+1)) : vret;

module quarterZylinder(radius,height,edge) union(){
    intersection(){
        union(){
            cylinder(r=radius,h=height,$fn=fn);
            if(edge)
            sphere(r=radius,$fn=fn);
        }
        translate([0,0,-height])
        cube([radius*2,radius*2,height*4]);
    }
}

module drillHole(){
    %translate([0,-backplateThickness-0.001,0])
    rotate([-90,0,0]){
        translate([0,0,-0.001])
        cylinder(r=drillholeDiameter/2,h=backplateThickness,$fn=fn);
    }
    
    translate([0,-backplateThickness-0.001,0])
    rotate([-90,0,0])
    hull(){
        translate([0,-2,backplateThickness-countersunkHeight+0.001])
        cylinder(r1=drillholeDiameter/2,r2=countersunkDiameter/2,h=countersunkHeight+0.002,$fn=fn); ///< Extra cut for alignment
        translate([0,0,backplateThickness-countersunkHeight+0.001])
        cylinder(r1=drillholeDiameter/2,r2=countersunkDiameter/2,h=countersunkHeight+0.002,$fn=fn);
        translate([0,100,backplateThickness-countersunkHeight+0.001])
        cylinder(r1=drillholeDiameter/2,r2=countersunkDiameter/2,h=countersunkHeight+0.002,$fn=fn);
    }

    translate([0,-backplateThickness-0.001,0])
    rotate([-90,0,0]){
        difference()
        {
            union()
            {
                hull()
                {
                    translate([0,-2,-0.001])
                        cylinder(r=drillholeDiameter/2,h=backplateThickness+countersunkHeight,$fn=fn); ///< Extra cut for alignment
                    translate([0,0,-0.001])
                        cylinder(r=drillholeDiameter/2,h=backplateThickness+countersunkHeight,$fn=fn);
                    translate([0,100,-0.001])
                        cylinder(r=drillholeDiameter/2,h=backplateThickness+countersunkHeight,$fn=fn);
                }
                translate([drillholeDiameter/2+(3)/2,drillholeDiameter/4-1.5+3,-0.001+(backplateThickness+countersunkHeight)/2])
                    cube([4,8,backplateThickness+countersunkHeight], center=true);
                translate([-drillholeDiameter/2-(3)/2,drillholeDiameter/4-1.5+3,-0.001+(backplateThickness+countersunkHeight)/2])
                    cube([4,8,backplateThickness+countersunkHeight], center=true);
            }

            translate([drillholeDiameter/2+0.6,drillholeDiameter/4+3,-0.001])
                cylinder(r=1.5,h=backplateThickness+countersunkHeight,$fn=fn);
            translate([-drillholeDiameter/2-0.6,drillholeDiameter/4+3,-0.001])
                cylinder(r=1.5,h=backplateThickness+countersunkHeight,$fn=fn);

            translate([drillholeDiameter/2+(1.25)/2,drillholeDiameter/4-2+2,-0.001+(backplateThickness+countersunkHeight)/2])
                cube([(1.25),6,backplateThickness+countersunkHeight], center=true);
            translate([-drillholeDiameter/2-(1.25)/2,drillholeDiameter/4-2+2,-0.001+(backplateThickness+countersunkHeight)/2])
                cube([(1.25),6,backplateThickness+countersunkHeight], center=true);
        }
    }
}

module singleHolder(curHolderGapSize,curHolderSize) union(){
    translate([0,-backplateThickness,-backplateSupportHeight])
    cube([curHolderSize+curHolderGapSize,backplateThickness,backplateHeightTotal]);//Backplate
}



module smdHolder_bulk() union(){
    // https://www.vishay.com/docs/60034/tapereeldalethinfilm.pdf
    smdWidth8mm = 8.8; // (8mm +- 0.2mm) + 0.5mm tolerance
    smdLedge8mm = (0.8*2); // Measured 
    smdThickMin8mm = 1.5; // Tape Measured: 0.8mm
    smdThickMax8mm = 3;
    translate([0,-1-0.001-2,-10])
        rotate([-90,0,0]){
        union()
        {
            // Window
            hull()
            {
                translate([-2,-10,2])
                    cube([smdWidth8mm+4,0.1,0.1]);
                translate([-2,-8,2])
                    cube([smdWidth8mm+4,0.1,5]);
                translate([-2,-5,2])
                    cube([smdWidth8mm+4,0.1,5]);
                translate([-2,-3,2])
                    cube([smdWidth8mm+4,0.1,0.1]);
            }
        }
    }
}

module smdHolder(){
    // https://www.vishay.com/docs/60034/tapereeldalethinfilm.pdf
    smdWidth8mm = 8.5; // (8mm +- 0.2mm) + 0.5mm tolerance
    smdLedge8mm = (0.8*2); // Measured 
    smdThickMin8mm = 1.5; // Tape Measured: 0.8mm
    smdThickMax8mm = 3;
    translate([0,-1-0.001-3,-10])
        rotate([-90,0,0]){
        union()
        {
            topOffset = 10;
            // tapepeel
            hull()
            {
                translate([0,-4,5])
                    cube([smdWidth8mm,0.1,2]);
                translate([0,-10,3])
                    cube([smdWidth8mm,0.1,3]);
            }
            // Window
            hull()
            {
                translate([0,-20,2])
                    cube([smdWidth8mm,0.1,10]);
                translate([0,-10,2])
                    cube([smdWidth8mm,0.1,10]);
            }
            // Top
            hull()
            {
                translate([0,-100,topOffset])
                    cube([smdWidth8mm,0.1,smdThickMin8mm]);
                translate([0,0,-0.001])
                    cube([smdWidth8mm,0.1,smdThickMin8mm]);
            }                
            hull()
            {
                translate([0,0,-0.001])
                    cube([smdWidth8mm,0.1,smdThickMin8mm]);
                translate([0,100,-0.001])
                    cube([smdWidth8mm,0.1,smdThickMin8mm]);
            }
            // Lower
            hull()
            {
                translate([smdLedge8mm/2,-100,topOffset-smdThickMax8mm])
                    cube([smdWidth8mm-smdLedge8mm,0.1,smdThickMax8mm]);
                translate([smdLedge8mm/2,0,-0.001-smdThickMax8mm])
                    cube([smdWidth8mm-smdLedge8mm,0.1,smdThickMax8mm]);
            }                
            hull()
            {
                translate([smdLedge8mm/2,0,-0.001-smdThickMax8mm])
                    cube([smdWidth8mm-smdLedge8mm,0.1,smdThickMax8mm]);
                translate([smdLedge8mm/2,100,-0.001-smdThickMax8mm])
                    cube([smdWidth8mm-smdLedge8mm,0.1,smdThickMax8mm]);
            }
            // Flang               
            union()
            {
                hull()
                {
                translate([0,15,-0.001])
                    cube([smdWidth8mm,0.1,smdThickMin8mm]);
                translate([-1,18,-0.001])
                    cube([smdWidth8mm+2,0.1,smdThickMin8mm]);
                }
                hull()
                {
                    translate([smdLedge8mm/2,15,-0.001-smdThickMax8mm])
                    cube([smdWidth8mm-smdLedge8mm,0.1,smdThickMax8mm]);
                translate([-1,18,-0.001-smdThickMax8mm])
                    cube([smdWidth8mm+2,0.1,smdThickMax8mm]);
            
                }
            }
        }
    }
}


module totalHolder(){
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    for(i = [0 : count-1]) union(){
                        translate([totalLengthAccumulate[i],0,0])
                            singleHolder(holderGapSize[i],holderSize[i]);
                    }
                    // SMD Holder Bulk
                    translate([27,0,0])
                    for(i = [0 : 9]){
                        translate([i*11,0,0])
                            smdHolder_bulk(holderGapSize[i],holderSize[i]);
                    }
                }

                translate([-holderGapSize/2,-backplateThickness,-backplateSupportHeight])
                cube([holderGapSize/2,backplateThickness,backplateHeightTotal]);
                translate([totalLength,-backplateThickness,-backplateSupportHeight])
                cube([holderGapSize/2,backplateThickness,backplateHeightTotal]);
            }
            if(roundEdge[0])
            translate([0,-backplateThickness,-backplateSupportHeight])
            rotate([0,90,0])
            quarterZylinder(backplateThickness,totalLength,roundEdge[3]);

            if(roundEdge[1])
            translate([totalLength,-backplateThickness,-backplateSupportHeight])
            quarterZylinder(backplateThickness,backplateHeightTotal,roundEdge[0]);

            if(roundEdge[2])
            translate([totalLength,-backplateThickness,backplateHeight+holderThickness])
            rotate([0,-90,0])
            quarterZylinder(backplateThickness,totalLength,roundEdge[1]);

            if(roundEdge[3])
            translate([0,-backplateThickness,backplateHeight+holderThickness])
            rotate([0,180,0])
            quarterZylinder(backplateThickness,backplateHeightTotal,roundEdge[2]);
        }
        translate([totalLengthAccumulate[sumVector(holderSizeDefCount)-1]-holderGapSizeDef[0]/2,0,-holderSizeDef[0]+holderThickness])
            drillHole();
        translate([totalLengthAccumulate[1]-holderGapSizeDef[0]/2,0,-holderSizeDef[0]+holderThickness])
            drillHole();

        translate([27,0,0])
        for(i = [0 : 9]){
            translate([i*11,0,0])
                smdHolder();
        }
    }
}


rotate([90,0,0])
{
    /* Screw Mount Wire Holder */
    totalHolder();
    echo(totalLength);//<350

    /* [Tslot Model] */
    model_slot_gap = 10;
    model_slot_side = 15;

    if (0)
    translate([0,-5,-holderSizeDef[0]+holderThickness])
    rotate([0,90,0])
    union()
    {
        %translate([model_slot_side/2+model_slot_gap/2,0,0]) cube([model_slot_side,0.1,1000], center=true);
        %translate([-model_slot_side/2-model_slot_gap/2,0,0]) cube([model_slot_side,0.1,1000], center=true);
    }
}