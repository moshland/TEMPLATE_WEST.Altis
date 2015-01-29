playMusic "intro"; 
titleCut ["", "BLACK FADED", 999];
	[] Spawn {
	waitUntil{!(isNil "BIS_fnc_init")};

	titleText ["you need to find and kill some csat dude","PLAIN"]; 
	titleFadeOut 7;
	sleep 5;

	titleText ["you will have to blow something up too","PLAIN"];
	titleFadeOut 7;
	sleep 5;

	titleText ["you have to kill stuff","PLAIN"];
	titleFadeOut 12;
	sleep 10;

	titleText ["Altis Security Squad","PLAIN"];
	titleFadeOut 9;
	sleep 7;

	titleText ["Mission by Mosh\n\nArma III by Bohemia Interactive","PLAIN"];
	titleFadeOut 12;
	sleep 10;

	// Info text
	[str ("in a land far away..."), str("many years from now..."), str(date select 1) + "." + str(date select 2) + "." + str(date select 0)] spawn BIS_fnc_infoText;

	sleep 3;
	"dynamicBlur" ppEffectEnable true;   
	"dynamicBlur" ppEffectAdjust [6];   
	"dynamicBlur" ppEffectCommit 0;     
	"dynamicBlur" ppEffectAdjust [0.0];  
	"dynamicBlur" ppEffectCommit 5;  

	titleCut ["", "BLACK IN", 3];
	};
	
