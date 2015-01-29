MON_Bld_ruins = ["Land_Unfinished_Building_01_F","Land_Unfinished_Building_02_F","Land_d_Stone_HouseBig_V1_F","Land_d_Stone_Shed_V1_F","Land_u_House_Small_02_V1_F","Land_i_Stone_HouseBig_V1_F","Land_u_Addon_02_V1_F"];

Aze_GothitParam = 
{
	private ["_npc","_gothit"];
	
	_npc = _this select 0;
	_gothit = false;
	
	If (!isNil "tpwcas_running") then 
	{
		if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY) then
		{
			_gothit = true;
		};
	}
	else
	{
		_Supstate = [_npc] call Aze_supstatestatus;
		if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY || _Supstate >= 2) then
		{
			_gothit = true;
		};
	};
	
	_gothit
};


////////////////////////////////////////////////////////////////// Artillery Module //////////////////////////////////////////////////////////////////
Aze_selectartillery = {

	private ["_support","_artiarray","_askMission","_RadioRange","_arti","_rounds","_artiarray","_artillerysideunits","_npc","_support","_artibusy"];
	
	_artillerysideunits = _this select 0;
	_askMission = _this select 1;
	_RadioRange = _this select 2;
	_npc = _this select 3;
	
	_arti = ObjNull;
	_rounds = 0;
	_artiarray = [_artillerysideunits, [], { _npc distance _x }, "ASCEND"] call BIS_fnc_sortBy;
	{
		_support = (vehicle _x) getVariable "ArtiOptions";
		_artibusy  = _support select 0;
		
		Switch (_askmission) do {
			case "HE": {
				_rounds = (_support select 1) select 2;
			};
		
			case "WP": {
				_rounds = (_support select 1) select 1;
			};
		
			case "FLARE": {
				_rounds = (_support select 1) select 0;
			};
	
		};
		
		If (!_artibusy && _x distance _npc <= _RadioRange && _rounds > 0) exitwith {_arti = _x;};
		if (KRON_UPS_Debug>0) then {player sidechat format ["Busy:%1 Distance:%2 RadioRange:%3 Rounds:%4",_artibusy,_x distance _npc,_RadioRange,_rounds];};
		
	} ForEach _artiarray;

	_arti
	
};
Aze_artilleryTarget = {
	// [_arti,"",_target] spawn Aze_artilleryTarget;
	
	private ["_support","_askBullet","_target","_arti","_missionabort","_rounds","_range","_area","_nbrbullet","_maxcadence","_mincadence","_askmission","_fire","_artibusy","_targetpos","_auxtarget","_npc"];
	_arti = _this select 0;
	
	_support = (vehicle _arti) getVariable "ArtiOptions";
	
	If (isnull (gunner _arti) 
	&& !(canmove (gunner _arti))) 
	exitwith 
	{
		if (KRON_UPS_Debug>0) then {player sidechat "ABORT: no gunner";};
	};
	
	// If (count _support <= 0 ) exitwith {if (KRON_UPS_Debug>0) then {player sidechat "ABORT: no support";};};
	
	
	_askMission = _this select 1;
	_target = _this select 2;

	
	_artibusy  = _support select 0;
	_rounds = _support select 1;					
	_area = _support select 2;	
	_maxcadence = _support select 3;	
	_mincadence = _support select 4;	

	_nbrbullet = 0;
	_askbullet = "";
	_missionabort = false;
	
	_npc = objNull;
	if (count _this > 3) then {_npc = _this select 3;}; 
	
	
	_side = side gunner _arti;
	_munradius = 150;	

	Switch (_askmission) do {
		case "HE": {
			If ((typeof (vehicle _arti)) in ["B_Mortar_01_F","O_Mortar_01_F","I_G_Mortar_01_F"]) then {_askbullet = "8Rnd_82mm_Mo_shells";};
			If ((typeof (vehicle _arti)) in ["B_MBT_01_arty_F","O_MBT_02_arty_F"]) then {_askbullet = "32Rnd_155mm_Mo_shells";_munradius = 300;};	
			_nbrbullet = _rounds select 2;
		};
		
		case "WP": {
			If ((typeof (vehicle _arti)) in ["B_Mortar_01_F","O_Mortar_01_F","I_G_Mortar_01_F"]) then {_askbullet = "8Rnd_82mm_Mo_Smoke_white";};
			If ((typeof (vehicle _arti)) in ["B_MBT_01_arty_F","O_MBT_02_arty_F"]) then {_askbullet = "6Rnd_155mm_Mo_smoke";};
			_nbrbullet = _rounds select 1;
		};
		
		case "FLARE": {
			If ((typeof (vehicle _arti)) in ["B_Mortar_01_F","O_Mortar_01_F","I_G_Mortar_01_F"]) then {_askbullet = "8Rnd_82mm_Mo_Flare_white";_nbrbullet = _rounds select 0;};
			If ((typeof (vehicle _arti)) in ["B_MBT_01_arty_F","O_MBT_02_arty_F"]) then {_nbrbullet = 0;};
		};
	
	};
	
	If(_artibusy 
	|| isNull _target 
	|| !alive _target 
	|| _nbrbullet <= 0) 
	exitwith 
	{
		if (KRON_UPS_Debug>0) then {player sidechat format ["ABORT: Arti: %1   Target: %2   Munition: %3",_artibusy,_target,_nbrbullet];};
	};
	

	
	if (!isnull _target  || alive _target) then 
	{
	
	
	switch (_side) do {
		case West: {
			KRON_UPS_ARTILLERY_WEST_UNITS = KRON_UPS_ARTILLERY_WEST_UNITS - [_arti];
		};
		case EAST: {
			KRON_UPS_ARTILLERY_EAST_UNITS = KRON_UPS_ARTILLERY_EAST_UNITS - [_arti];
		};
		case GUER: {
			KRON_UPS_ARTILLERY_GUER_UNITS = KRON_UPS_ARTILLERY_GUER_UNITS - [_arti];
		};
	
	};
		
		
	(vehicle _arti) setVariable ["ArtiOptions",[true,_rounds,_area,_maxcadence,_mincadence]];
	
	_auxtarget = _target;
	_targetPos = [];

	If ((_askbullet == "8Rnd_82mm_Mo_Smoke_white" || _askbullet == "6Rnd_155mm_Mo_smoke") 
	&& !IsNull _npc 
	&& alive _npc) 
	then 
	{ 
		_vcttarget = [_npc, _target] call BIS_fnc_dirTo;
		_dist = (_npc distance _target)/2;
		_targetPos = [position _npc,_vcttarget, _dist] call MON_GetPos2D;
	}
	else 
	{
		_targetPos = _auxtarget getvariable ("UPSMON_lastknownpos");
	};
	
	
		if (!isnil "_targetPos" || count _targetPos > 0) then 
		{
			//If target in range check no friendly squad near									
			if (alive _auxtarget 
			&& !(_auxtarget iskindof "Air") 
			&& (_targetPos inRangeOfArtillery [[_arti], _askbullet])) 
			then 
			{
			
				_target = _auxtarget;
				//Must check if no friendly squad near fire position
				If (_askbullet != "8Rnd_82mm_Mo_Flare_white") then
				{
					{	
						if (!isnull _x && _side == side _x) then 
						{																								
							if ((round([position _x,_targetPos] call KRON_distancePosSqr)) < (_munradius)) exitwith {_target = objnull;};
						};										
					} foreach KRON_NPCs;
				};
			};
		};
	
	If (!isNull _target || count _targetPos > 0) then 
	{
		//Fix current target
		_targetPos = [];	
		
		If (
		(_askbullet == "8Rnd_82mm_Mo_Smoke_white" || _askbullet == "6Rnd_155mm_Mo_smoke") 
		&& !IsNull _npc 
		&& alive _npc) 
		then 
		{ 
		_vcttarget = [_npc, _target] call BIS_fnc_dirTo;
		_dist = (_npc distance _target)/2;
		_targetPos = [position _npc,_vcttarget, _dist] call MON_GetPos2D;
		}
		else 
		{
		_targetPos = _auxtarget getvariable ("UPSMON_lastknownpos");
		};
		
		if (!isnil "_targetPos") then 
		{									
			// _arti removeAllEventHandlers "fired"; 
			// chatch the bullet in the air and delete it
			// _arti addeventhandler["fired", {deletevehicle (nearestobject[_this select 0, _this select 4])}];
			sleep 5;
			if (KRON_UPS_Debug>0) then {player sidechat "FIRE";};
			[_arti,_targetPos,_nbrbullet,_area,_maxcadence,_mincadence,_askbullet,_support] spawn Aze_artillerydofire;
		}
		else 
		{
			if (KRON_UPS_Debug>0) then {player sidechat "ABORT: no more target";}; 
			_missionabort = true;
		};
	
	}
	else
	{
		_missionabort = true
	};
	
	If (_missionabort) then
	{
	
		if (KRON_UPS_Debug>0) then {player sidechat "ABORT: no more target";};
		
			switch (_side) do {
		case West: {
			KRON_UPS_ARTILLERY_WEST_UNITS = KRON_UPS_ARTILLERY_WEST_UNITS + [_arti];
		};
		case EAST: {
			KRON_UPS_ARTILLERY_EAST_UNITS = KRON_UPS_ARTILLERY_EAST_UNITS + [_arti];
		};
		case GUER: {
			KRON_UPS_ARTILLERY_GUER_UNITS = KRON_UPS_ARTILLERY_GUER_UNITS + [_arti];
		};
	
		};
		
		(vehicle _arti) setVariable ["ArtiOptions",[false,_rounds,_area,_maxcadence,_mincadence]];
	};
};
};

Aze_artillerydofire = {
	 
		private ["_smoke1","_i","_area","_position","_maxcadence","_mincadence","_sleep","_nbrbullet","_rounds","_arti","_timeout","_bullet"];
		
		_arti = _this select 0;
		_position  = _this select 1;
		_nbrbullet = _this select 2;	
		_area = _this select 3;	
		_maxcadence = _this select 4;	
		_mincadence = _this select 5;	
		_bullet = _this select 6;
		_rounds = 0;
		_support = _this select 7;
		_supportrounds = _support select 1;
		_support2 = [];

		
		If (_bullet == "8Rnd_82mm_Mo_Flare_white")
		then {_rounds = 2; [] spawn Aze_Flaretime;} else {_rounds = 4;};
		
		If (_rounds > _nbrbullet) then {_rounds = _nbrbullet};
	
	
	Switch (_bullet) do {
		case "8Rnd_82mm_Mo_shells": {
			_support2 = [false,[_supportrounds select 0, _supportrounds select 1, (_supportrounds select 2) - _rounds],_support select 2, _support select 3,_support select 4];
			
		};
		
		case "32Rnd_155mm_Mo_shells": {
			_support2 = [false,[_supportrounds select 0, _supportrounds select 1, (_supportrounds select 2) - _rounds],_support select 2, _support select 3,_support select 4];
			
		};
		
		case "8Rnd_82mm_Mo_Smoke_white": {
			_support2 = [false,[_supportrounds select 0, (_supportrounds select 1) - _rounds, _supportrounds select 2],_support select 2, _support select 3,_support select 4];
			
		};
		
		case "6Rnd_155mm_Mo_smoke": {
			_support2 = [false,[_supportrounds select 0, (_supportrounds select 1) - _rounds, _supportrounds select 2],_support select 2, _support select 3,_support select 4];
			
		};
		
		case "8Rnd_82mm_Mo_Flare_white": {
			_support2 = [false,[(_supportrounds select 0) - _rounds, _supportrounds select 1, _supportrounds select 2],_support select 2, _support select 3,_support select 4];
		};
	
	};		
		
		_area2 = _area * 2;
		if (KRON_UPS_Debug>0) then { player globalchat format["artillery doing fire on %1",_position] };	
		
		for [{_i=0}, {_i<_rounds}, {_i=_i+1}] do 
		{ 		
			_sleep = random _maxcadence;			
			if (_sleep < _mincadence) then {_sleep = _mincadence};
			_com = effectiveCommander (vehicle _arti);
			sleep 2;
			_com commandArtilleryFire [[(_position select 0)+ random _area2 - _area, (_position select 1)+ random  _area2 - _area, 0], _bullet, 1];	
			sleep _sleep; 
			//Swap this
			_arti setVehicleAmmo 1;
		};
		
	sleep 15;
	_side = side gunner _arti;

		switch (_side) do {
		case West: {
			KRON_UPS_ARTILLERY_WEST_UNITS = KRON_UPS_ARTILLERY_WEST_UNITS + [_arti];
		};
		case EAST: {
			KRON_UPS_ARTILLERY_EAST_UNITS = KRON_UPS_ARTILLERY_EAST_UNITS + [_arti];
		};
		case GUER: {
			KRON_UPS_ARTILLERY_GUER_UNITS = KRON_UPS_ARTILLERY_GUER_UNITS + [_arti];
		};
	
		};
		
	(vehicle _arti) setVariable ["ArtiOptions",_support2];
};


Aze_Flaretime = {
	FlareInTheAir = true;
	sleep 120;
	FlareInTheAir = false;
	Publicvariable "FlareInTheAir";
};

////////////////////////////////////////////////////////////////// END Artillery Module //////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////// Ambush module //////////////////////////////////////////////////////////////////////

Aze_SetAmbush = {

	private ["_npc","_ambushdir","_ambushdist","_ambushType","_Mines","_vdir","_npcdir","_positiontoambush","_diramb","_soldier","_mineposition","_roads","_minetype1","_minetype2","_rdmdir","_gothit"];
	
	_npc = _this select 0;
	_ambushdir = _this select 1;
	_ambushdist = _this select 2;
	_ambushType = _this select 3;
	_Mines = _this select 4;
	
	(group _npc) setFormation "LINE";
	(group _npc) setBehaviour "STEALTH";	// In stead of "AWERE" -> will make AI go prone and look for cover
	(group _npc) setSpeedMode "FULL";
	(group _npc) setCombatMode "BLUE";
	_vdir = vectordir _npc; // Ajout
	_npcdir= 0;
	sleep 2;
	_positiontoambush = getpos _npc;
	_soldier = _npc;
			
	if ((count units _npc) > 1) then {_soldier = (units _npc) select 1;};	
		
	{					
	// _x stop true;
	dostop _x;
	} foreach ((units _npc) - [_soldier]);
	
	_soldier setunitpos "UP";
			
	If (_ambushdir != "") then 
	{
		switch (_ambushdir) do 
		{
			case "NORTH": {_vdir = [0,1,0];_npcdir = 0;};
			case "NORTHEAST":{_vdir = [0.842,0.788,0];_npcdir = 45;};
			case "EAST": {_vdir = [1,0,0];_npcdir = 90;};
			case "SOUTHEAST": {_vdir = [0.842,-0.788,0];_npcdir = 135;};
			case "SOUTH": {_vdir = [0,-1,0];_npcdir = 180;};
			case "SOUTHWEST": {_vdir = [-0.842,-0.788,0];_npcdir = 225;};
			case "WEST": {_vdir = [-1,0,0];_npcdir = 270;};
			case "NORTHWEST": {_vdir = [-0.842,0.788,0];_npcdir = 315;};
		};
	};	


	_gothit = [_npc] call Aze_GothitParam;
	
	If (_gothit) exitwith {_positiontoambush};
	
	_diramb = getDir _npc;
			
	If (_ambushdir != "") then {_diramb = _npcdir;};
	If ("gdtStratisforestpine" == surfaceType getPosATL _npc) then {_ambushdist = 50;};
	If ((count(nearestobjects [_npc,["house","building"],20]) > 4)) then {_ambushdist = 18;};
			
			
	//Puts a mine if near road
	if ( KRON_UPS_useMines && _ambushType == 1 ) then 
	{	
		if (KRON_UPS_Debug>0) then {player sidechat format["%1: Putting mine for ambush",_grpidx]}; 	
		if (KRON_UPS_Debug>0) then {diag_log format["UPSMON %1: Putting mine for ambush",_grpidx]}; 
				
		sleep 1;
		_mineposition = [position _npc,_diramb, _ambushdist] call MON_GetPos2D;					
		_roads = (getpos _npc) nearRoads 50; // org value 40 - ToDo check KRON_UPS_ambushdist value
				
		If (count _roads <= 0) then 
		{
			_roads = (getpos _npc) nearRoads 100;			
		};
				
		if (count _roads > 0) then 
		{
			_roads = [_roads, [], { _npc distance _x }, "ASCEND"] call BIS_fnc_sortBy;
			_positiontoambush = position (_roads select 0);
		};	

		if (KRON_UPS_Debug>0) then {diag_log format["%1: Roads #:%2 Pos:%3 Dir:%4",_grpidx, _roads,_positiontoambush,_npcdir]}; 
				_minetype1 = "ATMine";
				_minetype2 = "APERSBoundingMine";
				
		switch (_Minestype) do 
		{
			case "1": {_minetype2 = _minetype1;};
			case "2":{_minetype2 = _minetype2;};
			case "3": {_minetype1 = _minetype2;};
		};
				
		if (count _roads < 0 && _Mines > 0) then 
		{				
			if ([_soldier,_mineposition,_minetype2] call MON_CreateMine) then {_Mines = _Mines -1;_i =1;};
		};
		
		while {_Mines > 0} do
		{

			_i = 0;
			if (KRON_UPS_Debug>0) then {diag_log format["%1 Current Roads #:%2 _Mines:%3",_grpidx, (count _roads),_Mines]}; 
			if (count _roads > 0) then 
			{
				_mineposition = position (_roads select 0); 
				_roads = [];
				if ([_soldier,[(_mineposition select 0) + (random 1),(_mineposition select 1) + (random 1),_mineposition select 2],_minetype1] call MON_CreateMine) then {_Mines = _Mines -1; _i =1;};
			} 
			else 
			{	
			
			
					if (floor random 50 > 100) then 
				{
					_rdmdir = (_npcdir + (random 80) + 10) mod 360;				
				}
				else
				{
					_rdmdir = (_npcdir + 270 + (random 80)) mod 360;
				};		
			
				_mineposition = [_positiontoambush,_rdmdir,(random 30) + 10] call MON_GetPos2D;						
				if (_Mines > 0) then {_Mine=createMine [_minetype2, _mineposition , [], 0]; (side _npc) revealMine _Mine;_Mines = _Mines -1;_i =1;};	
				if (KRON_UPS_Debug>0) then {_ballCover = "Sign_Arrow_Large_GREEN_F" createvehicle [0,0,0];_ballCover setpos _mineposition;};
						
			};
					
			if (KRON_UPS_Debug>0) then {diag_log format["UPSMON %1: mines left: [%2]",_grpidx, _Mines]};
					
			sleep 0.1;
			
			if (_i != 1) then {_Mines = _Mines -1;}; //in case no mine was set
		};
				
		_mineposition = _positiontoambush;
				
	};				
	_AmbushPosition = [_npc,_diramb,_ambushdir,_positiontoambush,_ambushdist,_soldier] call Aze_FindAmbushPos;
	sleep 0.05;	
	{
		_x domove _AmbushPosition; 
	} foreach units _npc;
	
	_npc setbehaviour "CARELESS";
	
	waituntil {((_soldier distance _AmbushPosition <=10) && (_npc distance _AmbushPosition <=10)) || (!alive _npc) || (!canstand _npc) || (!alive _soldier) || (!canstand _soldier)};
	sleep 1;
										
	if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_positiontoambush};
	
	_gothit = [_npc] call Aze_GothitParam;
		
	If (!_gothit) then 
	{
		_npc dowatch objNull;
		sleep 0.5;
		_npc dowatch [_positiontoambush select 0,_positiontoambush select 1,1];
		sleep 0.5;
		_vdir = vectordir _npc;
		_npc dowatch objNull;
			
		If ((count(nearestobjects [_npc,["house","building"],30]) > 2)) then 
		{
			[_npc,50,false,9999,true] spawn MON_moveNearestBuildings;
		} 
		else 
		{
			_dist = 50;
			If ("gdtStratisforestpine" == surfaceType getPosATL _npc) then {_dist = 20;};
			If ((count(nearestobjects [_npc,["house","building"],40]) > 3)) then {_dist = 15;};
			[units group _npc,_vdir,_positiontoambush,_dist] spawn UPS_fnc_find_cover;
		};
			
	}
	else
	{
		(group _npc) setCombatMode "YELLOW";
	};
	
	_positiontoambush
};


Aze_FindAmbushPos = {

	private ["_npc","_diramb","_ambushdir","_positiontoambush","_ambushdist","_soldier","_AmbushPosition","_AmbushPositions","_markerstr","_dirposamb"];
	_npc = _this select 0;
	_diramb = _this select 1;
	_ambushdir = _this select 2;
	_positiontoambush = _this select 3;
	_ambushdist = _this select 4;
	_soldier = _this select 5;
		
			
	_dirposamb = ((_diramb) +180) mod 360;
	
	
	_AmbushPosition = [_positiontoambush,_dirposamb, _ambushdist] call MON_GetPos2D;
	_AmbushPositions = [_positiontoambush,_dirposamb,_ambushdist,_soldier,_ambushdir] call Aze_fnc_Overwatch;
			
			
	if (count _AmbushPositions > 0) then 
	{
		_AmbushPositions = [_AmbushPositions, [], { _npc distance _x }, "ASCEND"] call BIS_fnc_sortBy;
		_AmbushPosition = _AmbushPositions select 0;
	
	};
	
	_AmbushPosition
};

Aze_fnc_Overwatch = {
	private ["_position","_dirposamb","_distance","_man","_ambushdir","_direction","_i","_obspos","_FS","_insight"];
	_position = _this select 0;
	_dirposamb = _this select 1;
	_distance = _this select 2;
	_man = _this select 3;
	_ambushdir = _this select 4;
	
	_direction = 0;
	_i = 0;
	_obspos = [];
	
	_loglos = "logic" createVehicleLocal [0,0,0];
	_orig = "RoadCone_F" createVehicleLocal _position;
	
	while {count _obspos < 3 && _i < 30} do
	{
		_direction = ((floor random 360) +180) mod 360;
		
		If (_ambushdir != "") then
		{
			if (floor random 50 > 100) then 
			{
				_direction = (_dirposamb + (random 100)) mod 360;				
			}
			else
			{
				_direction = (_dirposamb + 270 +(random 100)) mod 360;
			};
			diag_log format["PosDirAmb #:%1 Direction:%2",_dirposamb,_direction];
		};
		
		_obspos1 = [_position,_direction, _distance + (random 30)] call MON_GetPos2D;

		_dest = "RoadCone_F" createVehicleLocal _obspos1;
		hideObject _dest;
		hideObject _orig;
		_los_ok = [_loglos,_orig,_dest,20, 0.5] call mando_check_los;

		If (_los_ok) then 
		{
			_objects = [ (nearestObjects [_obspos1, [], 50]), { _x call fnc_filter } ] call BIS_fnc_conditionalSelect;
			If (count _objects < 10) then
			{
				_los_ok = false;
			};
			If (count (_obspos1 nearRoads 50) > 0) then
			{
				_los_ok = false;
			};
		};
		
		if (_los_ok) then 
		{
			_obspos = _obspos + [_obspos1];
			if (KRON_UPS_Debug>0) then 
			{
				diag_log format["Positions #:%1",_obspos1];
				//Make Marker
				_markerstr = createMarker[format["markername%1_%2",_i,name _npc],_obspos1];
				_markerstr setMarkerShape "ICON";
				_markerstr setMarkerType "mil_flag";
				_markerstr setMarkerColor "ColorGreen";
				_markerstr setMarkerText format["markername%1_%2",_i,_npc];
			};
		};

		sleep 0.5;
		deletevehicle _dest;
		_i = _i +1;
	};
	
	
	deletevehicle _loglos;
	deletevehicle _orig;
	_obspos
};


Aze_haslos = {
	private ["_a","_b","_dirTo","_eyeD","_eyePb","_eyePa","_eyeDV","_abs","_boolean","_range"];

	//who to see or not
	_a = _this select 0;
	//AI to see or not
	_b = _this select 1;

	_eyeDV = eyeDirection _b;
	_eyeD = ((_eyeDV select 0) atan2 (_eyeDV select 1));
	if (_eyeD < 0) then {_eyeD = 360 + _eyeD};
	_dirTo = [_b, _a] call BIS_fnc_dirTo;
	_eyePb = eyePos _b;
	_eyePa = eyePos _a;
	_abs = abs(_dirTo - _eyeD); 
	_range = if (_a distance _b < 20) then {_abs >= 90 && _abs <= 270} else {_abs >= 60 && _abs <= 240};
	
	if (_range || (lineIntersects [_eyePb, _eyePa]) || (terrainIntersectASL [_eyePb, _eyePa])) then 
	{
		if (KRON_UPS_Debug>0) then {hintsilent "NOT IN SIGHT";};
		_boolean = false;
	} else {
		if (KRON_UPS_Debug>0) then {hintsilent "IN SIGHT";};
		_boolean = true;
	};
	
	_boolean
};


Aze_CanSee = {
	private ["_see","_infront","_uposASL","_opp","_adj","_hyp","_eyes","_obstruction","_angle"];

	_unit = _this select 0;
	_angle = _this select 1;
	_hyp = _this select 2;


	_eyes = eyepos _unit;

	
	_adj = _hyp * (cos _angle);
	_opp = sqrt ((_hyp*_hyp) - (_adj * _adj));

	
	_infront = if ((_angle) >=  180) then 
	{
		[(_eyes select 0) - _opp,(_eyes select 1) + _adj,(_eyes select 2)]
	} 
	else 
	{
		[(_eyes select 0) + _opp,(_eyes select 1) + _adj,(_eyes select 2)]
	};

	_obstruction = (lineintersectswith [_eyes,_infront,_unit]) select 0;


	_see = if (isnil("_obstruction")) then {true} else {false};

	_see
};



/////////////////////////////////////////////////////////END MODULE AMBUSH//////////////////////////////////////////////////////////////////////////

Aze_supstatestatus = {
	private ["_npc","_azesupstate","_tpwcas_running"];
	
	_tpwcas_running = if (isNil "tpwcas_running") then {true} else {false};;

	_npc = _this select 0;
	_azesupstate = 0;

	if (_tpwcas_running) then
	{
		{
			If (_x getvariable "tpwcas_supstate" == 3) exitwith {_azesupstate = 3;};
			If (_x getvariable "tpwcas_supstate" == 2) exitwith {_azesupstate = 2;};
		} foreach units group _npc;
	};
	
	_azesupstate
};


///////////////////////////////////////////////// Dir to watch (Module Fortify) //////////////////////////////////////////////////////
Aze_UnitWatchDir = {

	private ["_see","_infront","_uposASL","_opp","_adj","_hyp","_eyes","_obstruction","_angle","_inbuilding"];
	
	_unit = _this select 0;
	_angle = _this select 1;
	_bld = _this select 2;
	_essai = 0;
	_see = false;
	_ouverture = false;
	_findoor = false;

	_inbuilding = [_unit] call Aze_inbuilding;
	
	If (!_inbuilding) then {
	
		// check window
		_windowposition = [_bld] call Aze_checkwindowposition;
		sleep 0.4;
		_watch = [];
		If (count _windowposition > 0) then 
		{
			{
				_x = [_x select 0,_x select 1,(getPosATL _unit) select 2];
				If ((_unit distance _x) <= 3) exitwith {_watch = _x;};
			} forEach _windowposition;
	
			if (count _watch > 0) then 
			{
		
				_posATL = getPosATL _unit;

				_abx = (_watch select 0) - (_posATL select 0);
				_aby = (_watch select 1) - (_posATL select 1);
				_abz = (_watch select 2) - (_posATL select 2);

				_vec = [_abx, _aby, _abz];

				// Main body of the function;

				_unit setVectorDir _vec;		
		
				sleep 0.2;
				_unit lookat ObjNull;
				_unit lookat _watch;
				_ouverture = true;
			
			
				// _ballCover = "Sign_Arrow_Large_Blue_F" createvehicle [0,0,0];
				// _ballCover setpos _watch;	
			};
		};
 
		// If no window found check for door
		If (!_ouverture) then
		{
			_doorposition = [_bld] call Aze_checkdoorposition;
			sleep 0.4;
			_watch = [];
			
			If (count _doorposition > 0) then 
		{
			{
				_x = [_x select 0,_x select 1,(getPosATL _unit) select 2];
				If ((_unit distance _x) <= 5) exitwith {_watch = _x;};
			} forEach _doorposition;
	
			if (count _watch > 0) then 
			{
				_posATL = getPosATL _unit;

				_abx = (_watch select 0) - (_posATL select 0);
				_aby = (_watch select 1) - (_posATL select 1);
				_abz = (_watch select 2) - (_posATL select 2);

				_vec = [_abx, _aby, _abz];

				// Main body of the function;

				_unit setVectorDir _vec;	
				sleep 0.2;
				_unit lookat ObjNull;
				_unit lookat _watch;
				

				// _ballCover = "Sign_Arrow_Large_RED_F" createvehicle [0,0,0];
				// _ballCover setpos _watch;	

				_ouverture = true;
				_findoor = true;
			};
		};	
	};
	};
	Sleep 2;
	// Check if window not blocking view or search direction for AI if he doesn't watch window or door.
	If (!(_findoor)) then 
	{
		_cansee = [_unit,getdir _unit,_bld] spawn Aze_WillSee;
	};	
};

Aze_checkdoorposition = {
	private [];
	_house = _this select 0;
	_anim_source_pos_arr = [];
	
	_cfgUserActions = (configFile >> "cfgVehicles" >> (typeOf _house) >> "UserActions");

	for "_i" from 0 to count _cfgUserActions - 1 do 
	{
		_cfg_entry = _cfgUserActions select _i;
    
		if (isClass _cfg_entry) then
		{
			_display_name = getText (_cfg_entry / "displayname");
			if (_display_name == "Open hatch" or {_display_name == "Open door"}) then
			{
				_selection_name = getText (_cfg_entry / "position");
				_model_pos = _house selectionPosition _selection_name;
				_world_pos = _house modelToWorld _model_pos;
				_anim_source_pos_arr = _anim_source_pos_arr + [_world_pos];
			};
		};
	};

	_anim_source_pos_arr
};

Aze_checkwindowposition = {
	private ["_model_pos","_world_pos","_armor","_cfg_entry","_veh","_house","_window_pos_arr","_cfgHitPoints","_cfgDestEff","_brokenGlass","_selection_name"];
	_house = _this select 0;
	_window_pos_arr = [];

	_cfgHitPoints = (configFile >> "cfgVehicles" >> (typeOf _house) >> "HitPoints");

	for "_i" from 0 to count _cfgHitPoints - 1 do 
	{
		_cfg_entry = _cfgHitPoints select _i;
    
		if (isClass _cfg_entry) then
		{
			_armor = getNumber (_cfg_entry / "armor");

			if (_armor < 0.5) then
			{
				_cfgDestEff = (_cfg_entry / "DestructionEffects");
				_brokenGlass = _cfgDestEff select 0;
				_selection_name = getText (_brokenGlass / "position");
				_model_pos = _house selectionPosition _selection_name;
				_world_pos = _house modelToWorld _model_pos;
				_window_pos_arr = _window_pos_arr + [_world_pos];
			};
		};
	}; 
	
	_window_pos_arr
};


Aze_WillSee = {
// garrison func from ....
	private ["_see","_infront","_opp","_adj","_hyp","_eyes","_obstruction","_angle"];

	_unit = _this select 0;
	_angle = _this select 1;
	_bld = _this select 2;
	_essai = 0;

	If (count _this > 3) then {_essai = _this select 3;};

	_eyes = eyepos _unit;

	_hyp = 10;
	_adj = _hyp * (cos _angle);
	_opp = sqrt ((_hyp*_hyp) - (_adj * _adj));

	
	_infront = if ((_angle) >=  180) then 
	{
		[(_eyes select 0) - _opp,(_eyes select 1) + _adj,(_eyes select 2)]
	} 
	else 
	{
		[(_eyes select 0) + _opp,(_eyes select 1) + _adj,(_eyes select 2)]
	};

	_obstruction = (lineintersectswith [_eyes,_infront,_unit]) select 0;


	_see = if (isnil("_obstruction")) then {true} else {false};

	If (!_see && _essai < 15) exitwith 
	{
		_essai = _essai + 1;
		_angle = random 360;
		[_unit,_angle,_bld,_essai] call Aze_WillSee;
	};

	If (_see) then 
	{
		_posATL = getPosATL _unit;

		_abx = (_infront select 0) - (_posATL select 0);
		_aby = (_infront select 1) - (_posATL select 1);
		_abz = (_infront select 2) - (_posATL select 2);

		_vec = [_abx, _aby, _abz];

		// Main body of the function;

		_unit setVectorDir _vec;
		sleep 0.02;
		_unit lookat ObjNull;
		_unit lookat [_infront select 0,_infront select 1, 1];
		
		// _ballCover = "Sign_Arrow_Large_GREEN_F" createvehicle [0,0,0];
		// _ballCover setpos [_infront select 0,_infront select 1, 1];
	};
};



Aze_Inbuilding = {
private ["_Inbuilding","_posunit","_unit","_abovehead","_roof"];
	_unit = _this select 0;

	_posunit = [(getposASL _unit) select 0,(getposASL _unit) select 1,((getposASL _unit) select 2) + 0.5];
	_abovehead = [_posunit select 0,_posunit select 1,(_posunit select 2) + 20];

	_roof = (lineintersectswith [_posunit,_abovehead,_unit]) select 0;

	_Inbuilding = if (isnil("roof")) then {false} else {true};

_Inbuilding
};


Aze_SortOutBldpos = {
	private ["_bld","_bldpos","_windowspos","_doorspos","_otherspos","_windowsposition","_doorsposition"];
	_bld = _this select 0;
	_bldpos = _this select 1;

	_windowspos = [];
	_doorspos = [];
	_otherspos = [];
	_allpos = [];
	_roofspos = [];

	if (!(typeof _bld in MON_Bld_ruins)) then {
	_windowsposition = [_bld] call Aze_checkwindowposition;
	_doorsposition = [_bld] call Aze_checkdoorposition;};

		sleep 0.1;
	{
		_bldpos1 = _x;
		_loop = true;
		if (!(typeof _bld in MON_Bld_ruins)) then 
		{
			If (count _windowsposition > 0) then 
			{
				{
					_windowpos1 = _x;
					If (_bldpos1 distance _windowpos1 <= 2) then {_windowspos = _windowspos + [_bldpos1]; _loop = false;};
				} foreach _windowsposition;
			};
			If (count _doorsposition > 0 && _loop) then 
			{
				{
					_doorpos1 = _x;
					If (_bldpos1 distance _doorpos1 <= 2) then {_doorspos = _doorspos + [_bldpos1]; _loop = false;};			
				} foreach _doorsposition;
		
			};
		} 
		else 
		{
			_pos1 = _bldpos1 select 2;
			If (_pos1 >= 3) then {_roofspos = _roofspos + [_bldpos1]; _loop = false;};
		};
		
		
		If (_loop) then {
		_otherspos = _otherspos + [_bldpos1];
		};
	
	} foreach _bldpos;
	
	
//	if (count _windowspos > 0) then {
//	{
//	_ballCover = "Sign_Arrow_Large_BLUE_F" createvehicle [0,0,0];
// 	_ballCover setpos _x;	
//	} foreach _windowspos;
//	};
	
//	if (count _doorspos > 0) then {
//	{
//	_ballCover = "Sign_Arrow_Large_RED_F" createvehicle [0,0,0];
// 	_ballCover setpos _x;	
//	} foreach _doorspos;
//	};
	
//	if (count _otherspos > 0) then {
//	{
//	_ballCover = "Sign_Arrow_Large_GREEN_F" createvehicle [0,0,0];
//	_ballCover setpos _x;	
//	} foreach _otherspos;
//	};

		if (count _windowspos > 0) then 
	{
		_windowspos call BIS_fnc_arrayShuffle;
		sleep 0.1;
		_allpos = _allpos + _windowspos;
	};
	
	if (count _doorspos > 0) then 
	{
		_doorspos call BIS_fnc_arrayShuffle;
		sleep 0.1;
		_allpos = _allpos + _doorspos;
	};
		if (count _roofspos > 0) then 
	{
		_roofspos call BIS_fnc_arrayShuffle;
		sleep 0.1;
		_allpos = _allpos + _roofspos;
	};
		if (count _otherspos > 0) then 
	{
		_otherspos call BIS_fnc_arrayShuffle;
		sleep 0.1;
		_allpos = _allpos + _otherspos;
	};
	
	

	// if (isNil (_bld getvariable "Aze_bldPos")) then {_bld setvariable ["Aze_bldPos",_allpos];};
	
	_allpos

};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Aze_checkallied = {
private ["_npc","_mennear","_result","_pos","_radius"];

	_npc = _this select 0;
	_radius = _this select 1;
	_pos = _npc;
	
	if (count _this > 2) then {_pos = _this select 2;};
	
	_mennear = nearestobjects [_pos,["CAManBase"],_radius];
	_result = false;
	_allied = [];
	_eny = [];

	{
		If ((alive _x) && (side _x == side _npc) && !(_x in (units _npc))) then {_allied = _allied + [_x];};
		If ((alive _x) && (side _x != side _npc) && _npc knowsabout _x >= R_knowsAboutEnemy) then {_eny = _eny + [_x];}
	} foreach _mennear;
	

	_result = [_allied,_eny];
	_result
};

////////////////////////////////////////////////////////////////////// Target Module ////////////////////////////////////////////////////////

Aze_TargetAcquisition = {

	private ["_npc","_shareinfo","_closeenough","_NearestEnemy","_sharedenemy","_target","_targets","_dist","_opfknowval","_newtarget","_newattackPos","_targetsnear","_attackPos","_Enemies"];
	
	_npc = _this select 0;
	_shareinfo = _this select 1;
	_closeenough = _this select 2;
	_sharedenemy = _this select 3;
	_flankdir = _this select 4;
	
	_NearestEnemy = objNull;
	_target = objNull;
	_opfknowval = 0;
	_attackPos = [0,0];
	_Enemies = [];
	
	
	//Gets targets from radio
	_targets = call (compile format ["KRON_targets%1",_sharedenemy]);		
		
	// if (KRON_UPS_Debug>0) then {player globalchat format["targets from global upsmon: %1",_targets]};	//!R
		
	_Enemies = _npc call Aze_findnearestenemy;
	If (count _Enemies > 0) then
	{
		_NearestEnemy = _Enemies select 0;
	};

		If (IsNull _NearestEnemy) then 
		{	
			//Reveal targets found by members to leader
			{
				_Enemies = _x call Aze_findnearestenemy;
				
				If (count _Enemies > 0) then
				{
					_NearestEnemy = _Enemies select 0;
				};
				
				if ((!IsNull _NearestEnemy) && (_x knowsabout _NearestEnemy > R_knowsAboutEnemy) 
				&& (_npc knowsabout _NearestEnemy <= R_knowsAboutEnemy)) then 	
				{		
				
					if (_npc knowsabout _NearestEnemy <= R_knowsAboutEnemy ) then 	
					{		 
						_npc reveal [_NearestEnemy,1.5];	
					};
				

					_target = _NearestEnemy;
					_opfknowval = _npc knowsabout _target;
					_NearestEnemy setvariable ["UPSMON_lastknownpos", position _NearestEnemy, false];						
					if (KRON_UPS_Debug>0) then {player globalchat format["%1: %3 added to targets",_grpidx,typeof _x, typeof _target]}; 						
				};
			} foreach units (group _npc);
		}
		else
		{
			_target = _NearestEnemy;
			_opfknowval = _npc knowsabout _target;
			_NearestEnemy setvariable ["UPSMON_lastknownpos", position _NearestEnemy, false];
		};

		
		//if no target but _npc knows enemy then this is _target
		if (isNull (_target)) then 
		{
			{	
				if ((_npc knowsabout _x > R_knowsAboutEnemy) && (alive _x) && (canmove _x)) then 
				{
					if (!isNull (_x)) exitWith {_target =_x;};
				};							
			} foreach _targets;
		};
		
		//Resets distance to target
		_dist = 10000;
		
		
		
		//Gets  current known position of target and distance
		if ( !isNull (_target) && alive _target ) then 
		{
			_newattackPos = _target getvariable ("UPSMON_lastknownpos");
			
			if ( !isnil "_newattackPos" ) then {
				_attackPos=_newattackPos;	
				//Gets distance to target known pos
				_dist = ([_currpos,_attackPos] call KRON_distancePosSqr);				
			};
		};
					
		
		_newtarget = _target;
		

		if ((_shareinfo=="SHARE")) then 
		{			
			
			//Requests for radio the enemy's position, if it is within the range of acts
			if ((KRON_UPS_comradio == 2)) then
			{	
				_targetsnear = false;			
							
				//I we have a close target alive do not search another
				if (IsNull _target || !alive _target || { !canmove _target } || { _dist > _closeenough } ) then 
				{					
					{															
						 if ( !isnull _x && { canmove _x } && { alive _x } ) then 
						 {													
							_newattackPos = _x getvariable ("UPSMON_lastknownpos");		
	
							if (  !isnil "_newattackPos" ) then 
							{	
								_dist3 = ([_currpos,_newattackPos] call KRON_distancePosSqr);	
															
								//Sets if near targets to begin warning
								// _dist3 <= (_closeenough + KRON_UPS_safedist)
								IF ( _dist3 <= _closeenough) then { _targetsnear = true };				
								
								//Sets new target
								if ( ( isnull (_newtarget) || captive _newtarget|| !alive _newtarget|| !canmove _newtarget || _dist3 < _dist ) 								
									&& ( _dist3 <= _sharedist || _reinforcementsent || _dist <= _closeenough)
									&& ( !(_x iskindof "Air") || (_x iskindof "Air" && _inheli ))
									&& ( !(_x iskindof "Ship") || (_x iskindof "Ship" && _inboat ))
									&& ( _x emptyPositions "Gunner" == 0 && _x emptyPositions "Driver" == 0 
									|| (!isnull (gunner _x) && canmove (gunner _x))
									|| (!isnull (driver _x) && canmove (driver _x))) 	
									) then 
								{
									_Enemies = _targets;
									_newtarget = _x;				
									_opfknowval = _npc knowsabout _x; 
									_dist = _dist3;	
								};	
							};
						};					
					} foreach _targets;
					sleep 0.5;
				};
			};				
					
			//If you change the target changed direction flanking initialize
			if ( !isNull (_newtarget) && alive _newtarget && canmove _newtarget && (_newtarget != _target || isNull (_target)) ) then {
				_timeontarget = 0;
				_targetdead = false;
				_flankdir= if (random 100 <= 10) then {0} else {_flankdir};	
				_target = _newtarget;			
			};						
		};	

		_result = [_Enemies,_target,_dist,_opfknowval,_targetsnear,_attackPos,_timeontarget,_targetdead,_flankdir];
		
		_result
};

Aze_findnearestenemy = {
	private["_npc","_targets","_enemies","_enemySides","_side","_unit"];
	_npc = _this;
	_enemies = [];

	_targets = _npc nearTargets KRON_UPS_sharedist;
	
	_enemySides = _npc call BIS_fnc_enemySides;
	
	if (KRON_UPS_Debug>0) then {diag_log format ["Targets found by %1: %2",_npc,_targets];};
	
	{
		_unit = (_x select 4);
		_side = (_x select 2);

		if ((_side in _enemySides) && (count crew _unit > 0) && _npc knowsabout _unit >= R_knowsAboutEnemy) then
		{
			if ((side driver _unit) in _enemySides) then
			{
				_enemies set [count _enemies, _unit];
			};
		};
	} forEach _targets;

	If (count _enemies > 0) then
	{
		_enemies = [_enemies, [], { _npc distance _x }, "ASCEND"] call BIS_fnc_sortBy;
	};
	
	_enemies
};

///////////////////////////////////////////////////////////////// WITHDRAWAL MODULE ////////////////////////////////////////////////////

Aze_WITHDRAW = {
		private ["_npc","_target","_AttackPos","_dir1","_dir2","_targetPos","_artillerysideunits","_RadioRange","_array"]; 	
		_npc = _this select 0;
		_target = _this select 1;
		_AttackPos = _this select 2;
		_RadioRange = _this select 3;
		
		// angle from unit to target
		_dir1 = [getpos _npc,_AttackPos] call KRON_getDirPos;
		_dir2 = (_dir1+180) mod 360;
		
		_targetPos = [_npc,_dir2] call Aze_RetreatPosition;
		
					
		if (KRON_UPS_Debug>=1) then 
		{
			"avoid" setmarkerpos _targetPos;							
		};	
					
		_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);
		_artillerysideFire = call (compile format ["KRON_UPS_ARTILLERY_%1_FIRE",_side]);
		
		If (_artillerysideFire
		&& _RadioRange > 0 
		&& count _artillerysideunits > 0) then 
		{
			_arti = [_artillerysideunits,"WP",_RadioRange,_npc] call Aze_selectartillery;
					
			If !(IsNull _arti) then 
			{
				[_arti,"WP",_target,_npc] spawn Aze_artilleryTarget;};
				if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
			};
				
			// New Code:
			If (_npc distance _target >= 200 && morale _npc < -1.2) then 
			{
				{
					{_x setCombatMode "BLUE";} foreach units _npc;
					_x setbehaviour "CARELESS"; 
					_x allowfleeing 1;
				} foreach units group _npc;
			} 
			else 
			{
				{
					{_x setCombatMode "GREEN";} foreach units _npc;
					_x setbehaviour "AWARE"; 
					_x allowfleeing 1;
				} foreach units group _npc;
			};
			// end new code
					
			if (KRON_UPS_Debug>0) then {player sidechat format["%1 All Retreat!!!",_grpidx]};

			_targetPos;
};