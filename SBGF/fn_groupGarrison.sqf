/* //////////////////////////////////////////////
Author: J.Shock

Function: fn_groupGarrison.sqf

Description: Fills buildings within a defined radius with pre-spawned (editor placed) units.

Parameters: 
		1- Unit/Group Leader: (object) (note: for use with unit's name or init field using "this" as the parameter)
		2- Center position: (string/object/position array) (default: objNull)
		3- Radius for building search: (scalar) (default: 200)
		
	Example: [this,"mrkName",200] spawn SBGF_fnc_groupGarrison;

Return: True when completed.

*///////////////////////////////////////////////

private ["_unitsGroup","_center","_radius","_completed","_buildings"];

_unitsGroup = units (group (_this select 0));
_center = [_this,1,objNull,["",objNull,[]],[3]] call BIS_fnc_param;
_radius = [_this,2,200,[0]] call BIS_fnc_param;
_completed = false;

_buildings = [_center,_radius] call SBGF_fnc_buildingPositions;

{
	_rndPos = (_buildings select 1) call BIS_fnc_selectRandom;
	
	_x setPosATL (_rndPos);
	
	doStop _x;

	_x setDir (random 359);

	_x setUnitPos "UP";

	_buildings = _buildings - [_rndPos];
	
} forEach _unitsGroup;
_completed = true;

_completed;
