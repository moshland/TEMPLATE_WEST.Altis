/* Example Vehicle Init - Can Be deleted */

_this setVehicleAmmo 0;
_this setDammage 0;
_this setObjectTextureGlobal [0,"Mosh_images\black.paa"]; 
_this addAction ["<t color='#ff1111'>Virtual Ammobox</t>", "VAS\open.sqf"];
_this addAction ["Battlefield Re-spawn System", "BRS\BRS_launch.sqf", [[Airport,HQ],west,true,50]];
_null = [_this, 10, 0.01, 2] execVM "scripts\heal.sqf";
//_this AddAction ["<t color='#0000FF'>Heal</t>", "Mosh_scripts\heal.sqf"]; 
//["AmmoboxInit",[_this,true]] call BIS_fnc_arsenal; 
_this addAction["<t color='#111111'>Gear Select</t>", "ASORGS\open.sqf"];

[] spawn {
  while {not isnull Moshpit} do { "mobilehq" setmarkerpos getpos Moshpit; "respawn_west_1" setmarkerpos getpos Moshpit; sleep 0.5; };
};

player sideChat "Hunter Init Set";

