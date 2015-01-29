task8 = player createSimpleTask ["head back to base"]; 
task8 setSimpleTaskDescription ["We are finished for now. Go back to base and get some rest", "base", "base"]; 
task8 setSimpleTaskDestination (getMarkerPos "HQ");
player setCurrentTask task8;
"obj8" setMarkerAlpha 1;
nul = [] spawn { while {(alive unitf)} do { "HQ" setmarkercolor "colorBlue"; sleep 1; "HQ" setmarkercolor "colorGreen"; sleep 1;}; };
