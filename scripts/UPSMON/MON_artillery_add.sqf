/*  =====================================================================================================
	MON_spawn.sqf
	Author: Monsada (chs.monsada@gmail.com) 
		Comunidad Hispana de Simulaci�n: 
		http://www.simulacion-esp.com
 =====================================================================================================		
	Par�meters: [_artillery,(_rounds,_area,_cadence,_mincadence)] execvm "scripts\UPSMON\MON_artillery_add.sqf";	
		<- _artillery 		object to attach artillery script, must be an object with gunner.
		<- ( _rounds ) 		number of rounds for the artillery [FLARE,SMOKE,HE]
		<- ( _area ) 		Dispersion area, 150m by default
		<- ( _maxcadence ) 	Cadence of fire, is random between min, default 10s
		<- ( _mincadence )	Minimum cadence, default 5s
 =====================================================================================================
	1.  Place a static weapon on map.
	2. Exec module in int of static weapon

		nul=[this] execVM "scripts\UPSMON\MON_artillery_add.sqf";

	1. Be sure static weapon has a gunner or place a "fortify" squad near, this will make squad to take static weapon.
	2. Create a trigger in your mission for setting when to fire. Set side artillery variable to true:

		KRON_UPS_ARTILLERY_EAST_FIRE = true;

	This sample will do east artilleries to fire on known enemies position, when you want to stop fire set to false.

	For more info:
	http://dev-heaven.net/projects/upsmon/wiki/Artillery_module
 =====================================================================================================*/
//if (!isserver) exitWith {}; 
if (!isServer) exitWith {};

//Waits until UPSMON is init
waitUntil {!isNil("KRON_UPS_INIT")};
waitUntil {KRON_UPS_INIT==1};
	
private ["_artillery","_smoke1","_i","_area","_position","_maxcadence","_mincadence","_sleep","_rounds","_dummypos","_salvobreak","_sidearty","_artillerysupport"];

_area = 150;
_maxcadence = 10;
_mincadence = 5;
_sleep = 0;
_rounds = [3,4,10];	
_vector =[];
_artillerysupport = ["B_Mortar_01_F","O_Mortar_01_F","I_G_Mortar_01_F","B_MBT_01_arty_F","B_MBT_01_mlrs_F","O_MBT_02_arty_F"];

_artillery  = _this select 0;
If (!(typeof _artillery in _artillerysupport)) exitwith {if (KRON_UPS_Debug>0) then {player sidechat "This kind of static is not supported"};};

//if (KRON_UPS_Debug>0) then {player globalchat format["MON_artillery_add before %1 %2 %3",isnull _artillery,alive _artillery]};		
if (isnull _artillery || !alive _artillery) exitwith{};
if ((count _this) > 1) then {_rounds = _this select 1;};	
if ((count _this) > 2) then {_area = _this select 2;};	
if ((count _this) > 3) then {_maxcadence = _this select 3;};	
if ((count _this) > 4) then {_mincadence = _this select 4;};	
	
//Add artillery to array of artilleries
_vector = [false,_rounds,_area,_maxcadence,_mincadence];

_sidearty = side (gunner _artillery);
// _artilleryarray = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_sidearty]);


	switch (_sidearty) do {
		case West: {
		if (isnil "KRON_UPS_ARTILLERY_WEST_UNITS") then  {KRON_UPS_ARTILLERY_WEST_UNITS = []};
		KRON_UPS_ARTILLERY_WEST_UNITS = KRON_UPS_ARTILLERY_WEST_UNITS + [_artillery];
		PublicVariable "KRON_UPS_ARTILLERY_WEST_UNITS";		
		};
		case EAST: {
		if (isnil "KRON_UPS_ARTILLERY_EAST_UNITS") then  {KRON_UPS_ARTILLERY_EAST_UNITS = []};
		KRON_UPS_ARTILLERY_EAST_UNITS = KRON_UPS_ARTILLERY_EAST_UNITS + [_artillery];
		PublicVariable "KRON_UPS_ARTILLERY_EAST_UNITS";	
		};
		case GUER: {
		if (isnil "KRON_UPS_ARTILLERY_GUER_UNITS") then  {KRON_UPS_ARTILLERY_GUER_UNITS = []};
		KRON_UPS_ARTILLERY_GUER_UNITS = KRON_UPS_ARTILLERY_GUER_UNITS + [_artillery];
		PublicVariable "KRON_UPS_ARTILLERY_GUER_UNITS";			
		};
	
	};
	
(vehicle _artillery) setVariable ["ArtiOptions",_vector];

_dummypos = [getpos _artillery, 50, getdir _artillery] call R_relPos3D;
(gunner _artillery) lookAt [_dummypos select 0, _dummypos select 1,(_dummypos select 2)+100];
