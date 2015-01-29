trigspot_1

if (alive unit_1) then {    
hint "the CSAT officer has been located";   
playSound "spot"; 
["task1", "succeeded"] call FHQ_TT_setTaskState;  
"task_1" setmarkerpos getpos unit_1;     
"task_1" setMarkerText "CSAT officer";      
 "task_1" setMarkerColor "ColorRed";  
 [["task1a","kill the csat dude","kill the csat dude","csat dude",getmarkerpos "task_1","assigned"]] call FHQ_TT_addTasks;   
 nul = [] spawn {   while {not isnull unit_1}   do   { "task_1" setmarkerpos getpos unit_1;  sleep 15; };   };  } else {}
 
 trig_1
 
 playSound "kill"; 
 ["task1a", "succeeded"] call FHQ_TT_setTaskState;   
 hint "csat dude is dead";   
 "task_1" setMarkerColor "colorGreen";   
 "hint_1" setMarkerColor "colorGreen";