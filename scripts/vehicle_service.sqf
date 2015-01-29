private ["_object", "_time", "_magazines","_cmagazines"];

_object = _this select 0; 
_time = 10;
_cmagazines = _object magazinesTurret[0];
_object vehicleChat "Servicing...please hold position";
sleep _time;
if (isEngineOn _object) exitwith {_object vehicleChat "Service Cancelled"};
_object vehicleChat "Repairing...";
sleep _time;
if (isEngineOn _object) exitwith {_object vehicleChat "Service Cancelled"};
_object setDammage 0;
_object vehicleChat "Rearming...";
_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

if (count _magazines > 0) then {
	_removed = [];
	{
		if (!(_x in _removed)) then {
			_object removeMagazines _x;
			_removed set [count _removed, _x];
		};
	} forEach _magazines;
	{
		if (!isDedicated) then {[_object, format ["Reloading %1", _x]] call XfVehicleChat};
		sleep x_reload_time_factor;
		if (!alive _object) exitWith {};
		_object addMagazine _x;
	} forEach _magazines;
};