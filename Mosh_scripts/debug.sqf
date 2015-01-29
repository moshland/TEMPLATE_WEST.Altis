hint "debug mode";

//{_x setcaptive true } foreach units group player;

debugtrig = createTrigger ["EmptyDetector",getPos player]; 
debugtrig setTriggerArea[5,5,0,false]; 
debugtrig setTriggerActivation["ALPHA","PRESENT",true];
debugtrig setTriggerText "heal"; 
debugtrig setTriggerStatements["this", "
hint ""your group is healed""; {_x setDammage 0} foreach units group mosh;
",""]; 

debugtrig_1 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_1 setTriggerArea[5,5,0,false]; 
debugtrig_1 setTriggerActivation["BRAVO","PRESENT",true];
debugtrig_1 setTriggerText "immortal"; 
debugtrig_1 setTriggerStatements["this", "
hint ""your group is immortal""; {_x allowdamage false} foreach units group mosh;
",""]; 

debugtrig_2 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_2 setTriggerArea[5,5,0,false]; 
debugtrig_2 setTriggerActivation["CHARLIE","PRESENT",true];
debugtrig_2 setTriggerText "mortal"; 
debugtrig_2 setTriggerStatements["this", "
hint ""your group is mortal""; {_x allowdamage true} foreach units group mosh;
",""]; 

debugtrig_3 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_3 setTriggerArea[5,5,0,false]; 
debugtrig_3 setTriggerActivation["DELTA","PRESENT",true];
debugtrig_3 setTriggerText "group teleport"; 
debugtrig_3 setTriggerStatements["this", "
[] execVM ""Mosh_scripts\debug_groupteleport.sqf""
",""]; 

debugtrig_4 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_4 setTriggerArea[5,5,0,false]; 
debugtrig_4 setTriggerActivation["ECHO","PRESENT",true];
debugtrig_4 setTriggerText "weapons and vehicles"; 
debugtrig_4 setTriggerStatements["this", "
hint ""weapons and ammo here""; ammo_d1 setpos getpos player
",""]; 

debugtrig_5 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_5 setTriggerArea[5,5,0,false]; 
debugtrig_5 setTriggerActivation["FOXTROT","PRESENT",true];
debugtrig_5 setTriggerText "bomb"; 
debugtrig_5 setTriggerStatements["this", "
[] execVM ""Mosh_scripts\debug_bomb.sqf""
",""];
 
debugtrig_6 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_6 setTriggerArea[5,5,0,false]; 
debugtrig_6 setTriggerActivation["GOLF","PRESENT",true];
debugtrig_6 setTriggerText "test"; 
debugtrig_6 setTriggerStatements["this", "
[] execVM ""Mosh_scripts\debug_test.sqf""
",""];

debugtrig_7 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_7 setTriggerArea[5,5,0,false]; 
debugtrig_7 setTriggerActivation["HOTEL","PRESENT",true];
debugtrig_7 setTriggerText "position"; 
debugtrig_7 setTriggerStatements["this", "
hint ""position copied to clipboard""; copyToClipboard str (getPos player)
",""];

debugtrig_8 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_8 setTriggerArea[5,5,0,false]; 
debugtrig_8 setTriggerActivation["INDIA","PRESENT",true];
debugtrig_8 setTriggerText "single teleport"; 
debugtrig_8 setTriggerStatements["this", "
[] execVM ""Mosh_scripts\debug_tasks.sqf""
",""];

debugtrig_9 = createTrigger ["EmptyDetector",getPos player]; 
debugtrig_9 setTriggerArea[5,5,0,false]; 
debugtrig_9 setTriggerActivation["JULIET","PRESENT",true];
debugtrig_9 setTriggerText "delete units"; 
debugtrig_9 setTriggerStatements["this", "
[] execVM ""Mosh_scripts\debug_units.sqf""
",""];


