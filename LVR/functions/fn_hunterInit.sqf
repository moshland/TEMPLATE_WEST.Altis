/* Example Vehicle Init - Can Be deleted */

_this setVehicleAmmo 0;
_this setDammage 0;
_this setObjectTextureGlobal [0,"Mosh_images\zebra.paa"]; 
_this setObjectTextureGlobal [1,"Mosh_images\zebra.paa"];
_this addAction ["Battlefield Re-spawn System", "BRS\BRS_launch.sqf", [[Airport,HQ],west,true,50]];
_null = [_this, 10, 0.01, 2] execVM "scripts\heal.sqf";

[] spawn {
  while {not isnull Moshpit} do { "mobilehq" setmarkerpos getpos Moshpit; "respawn_west_1" setmarkerpos getpos Moshpit; sleep 0.5; };
};

player sideChat "Mobile HQ spawned at base";

