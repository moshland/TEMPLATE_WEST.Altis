/* //////////////////////////////////////////////
Author: J.Shock

Function: fn_buildingPositions.sqf

Description: Gets all building positions within a defined radius of 
			 given marker/object/position center.

Parameters: 
		1- Center position: (string/object/position array) (default: objNull)
		2- Radius from center: (scalar) (default: 200)
		
	Example: ["mrkName",200] call JSHK_fnc_buildingPositions;

Return: A multi-dimension array of the number of buildings and building positions: 
							[#,[[x,y,z],[x,y,z],[x,y,z]]]

**DISCLAIMER**
Do not remove this header from this function. Any reproduced and/or otherwise used 
portions of this code must include credits to the author (J.Shock).

*///////////////////////////////////////////////

private ["_center","_radius","_houses","_insideHousePos","_singlePosArray"];  

_center = [_this,0,objNull,["",objNull,[]],[3]] call BIS_fnc_param;
_radius = [_this,1,200,[0]] call BIS_fnc_param;

switch (typeName _center) do
{
	case "OBJECT": { _center = getPos _center; };
	case "STRING": { _center = getMarkerPos _center; };
	case "ARRAY": { _center; };
	default { diag_log "Center position undefined >> SBGF\fn_buildingPositions.sqf"; };
};

_houses = nearestObjects [_center, ["House"], _radius];

_insideHousePos = [];

{ 
	if ([_x] call BIS_fnc_isBuildingEnterable) then 
	{ 
		_buildPos = [_x] call BIS_fnc_buildingPositions; 
		_insideHousePos pushBack _buildPos; 
	};
}forEach _houses;

_singlePosArray = [];

for "_i" from 0 to ((count _insideHousePos) - 1) step 1 do
{
	_singleHouse = _insideHousePos select _i;

	for "_a" from 0 to ((count _singleHouse) - 1) step 1 do
	{
		_singlePos = _singleHouse select _a;
		_singlePosArray pushBack _singlePos;
	};
};

[count _insideHousePos,_singlePosArray];