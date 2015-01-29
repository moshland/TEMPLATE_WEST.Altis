/* //////////////////////////////////////////////
Author: J.Shock

Function: fn_garrison.sqf

Description: Fills defined percentage of building positions with a set of 
			 defined units within defined radius.

Parameters: 
		1- Center position: (string/object/position array) (default: objNull)
		2- Side of units: (side) (default: EAST)
		3- Radius for building search: (scalar) (default: 200)
		4- Percentage of used building positions: (scalar (0-1)) (default: 0.2)
		5- Types of units to spawn: (array of classnames) (default: ["O_Soldier_F","O_Soldier_AR_F"])
		6- (Optional)Define the limit of spawned units: (scalar) (default: -1)
			**This overrides parameter 4  (percent of used building positions) unless (-1) is used**
		
	Example: _units = ["mrkName",EAST,300,0.3,["O_Soldier_F","O_Soldier_AR_F"],-1] spawn SBGF_fnc_garrison;

Return: Array of spawned units.

*///////////////////////////////////////////////

private ["_marker","_sideGrp","_radius","_buildings","_buildCount","_pctFill","_positionCount","_manType","_spawnedUnits"];

_center = [_this,0,objNull,["",objNull,[]],[3]] call BIS_fnc_param;
_sideGrp = createGroup ([_this,1,EAST,[WEST]] call BIS_fnc_param);

_radius = [_this,2,200,[0]] call BIS_fnc_param;
_buildings = [_center,_radius] call SBGF_fnc_buildingPositions;
_buildCount = (_buildings select 0);
_pctFill = [_this,3,0.2,[0.0]] call BIS_fnc_param;

if (_pctFill > 1 || _pctFill < 0) then
{
	_pctFill = 0.2;
	diag_log "_pctFill must be between 0 and 1, defaulted to 0.2 >> SBGF\fn_garrison.sqf";
};

if ((_this select 5) isEqualTo -1) then
{
	_positionCount = round(_buildCount * _pctFill);
}
else
{
	_positionsCount = (_this select 5);
};

_manType = [_this,4,["O_Soldier_F","O_Soldier_AR_F"],[[]]] call BIS_fnc_param;

_spawnedUnits = [];

for "_i" from 0 to (_positionCount) step 1 do 
{
	_rndPos = (_buildings select 1) call BIS_fnc_selectRandom;
	_rndMan = _manType call BIS_fnc_selectRandom;

	_unit = _sideGrp createUnit [_rndMan, (_rndPos), [], 0, "NONE"];

	doStop _unit;

	_unit setDir (random 359);

	_unit setUnitPos "UP";

	_buildings = _buildings - [_rndPos];
	
	_spawnedUnits pushBack _unit;

	sleep 0.02;
};

_spawnedUnits;