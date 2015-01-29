Moshpit
MHQ

_nul = [ this, 3600, 30, LVR_fnc_hunterInit ] spawn LVR_fnc_vehRespawn;
this setObjectTexture [0,"Mosh_images\black.paa"]; 
this addAction["<t color='#ff1111'>Virtual Ammobox</t>", "VAS\open.sqf"]; 
this addAction ["Battlefield Re-spawn System", "BRS\BRS_launch.sqf", [[Airport,HQ],west,true,50]]; 
_null = [this, 10, 0.01, 2] execVM "scripts\heal.sqf"; 
this addAction["<t color='#111111'>Gear Select</t>", "execvm 'ASORGS\open.sqf'"];

