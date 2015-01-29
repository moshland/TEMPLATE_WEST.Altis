/* Example Vehicle Init - Can Be deleted */

player sideChat "Mobile HQ respawned at base";
hint "smoke it";


//_this setVehicleAmmo 0;
//_this setDammage 0;
_this setObjectTextureGLobal [0,"Mosh_images\black.paa"]; 
_this addAction ["<t color='#ff1111'>Virtual Ammobox</t>", "VAS\open.sqf"];
_this addAction ["Battlefield Re-spawn System", "BRS\BRS_launch.sqf", [[Airport,HQ],west,true,50]];
_nul = [_this, 10, 0.01, 2] execVM "scripts\heal.sqf";
//_this AddAction ["<t color='#0000FF'>Heal</t>", "Mosh_scripts\heal.sqf"]; 
["AmmoboxInit",[_this,true]] call BIS_fnc_arsenal; 
_this addAction["<t color='#111111'>Gear Select</t>", "ASORGS\open.sqf"];


//[] spawn {  while {not isnull Moshpit} do { "mobilehq" setmarkerpos getpos Moshpit; "respawn_west_1" setmarkerpos getpos Moshpit; sleep 0.5; };};


Mosh_addactionMP =
{
private["_object","_screenMsg","_scriptToCall"];
_object = _this select 0;
_screenMsg = _this select 1;
_scriptToCall = _this select 2;

if(isNull _object) exitWith {};

_object addaction [_screenMsg,_scriptToCall];
};

[[_this,"Battlefield Respawn System","Mosh_scripts\test.sqf"],"Mosh_addactionMP",nil,false] spawn BIS_fnc_MP;