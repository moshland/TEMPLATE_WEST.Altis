// =========================================================================================================
//  Biblioteca de funciones comunes
//  Version: 5.2.0
//  Author: Monsada (smirall@hotmail.com)
//		http://www.simulacion-esp.com/
//		Comunidad Hispana de Simulaci�n
// =========================================================================================================

MON_bugged_vehicles = ["BIS_alice_emptydoor","ACE_Grenade_Geometry"];

// in Vanilia extra bugged vehicle
if !(AcePresent) then {
	MON_bugged_vehicles = MON_bugged_vehicles + ["HMMWV_M998A2_SOV_DES_EP1"];
};	
// ---------------------------------------------------------------------------------------------------------
//Funci�n que permite posicionar objetos a la altura definida
//param1: objeto
//param2: altura
MON_subir = {
if (!isserver) exitwith{};
private ["_object","_altura","_pos","_x","_y","_z","_bld","_bldpos"];

_object = _this select 0;
_altura = _this select 1;

_x = 0;
_y = 0;
_z = 0;
_pos =0;
_bld = objnull;
_bldpos =0;

_pos = getposasl _object;

_x = _pos select 0;
_y = ( _pos select 1 );
_z = ( _pos select 2 ) + _altura;
_object setposasl [_x,_y ,_z];
};
//Retorna la direcci�n entre dos posiciones
MON_getDirPos = {private["_a","_b","_from","_to","_return"]; _from = _this select 0; _to = _this select 1; _return = 0; _a = ((_to select 0) - (_from select 0)); _b = ((_to select 1) - (_from select 1)); if (_a != 0 || _b != 0) then {_return = _a atan2 _b}; if ( _return < 0 ) then { _return = _return + 360 }; _return};
// ---------------------------------------------------------------------------------------------------------
//Funci�n de borra unidades que han sido matadas
//param1: objeto a borrar cuando muera
//param2: tiempo a esperar antes de borrar el objeto
MON_deleteDead = {private["_u","_s"];_u=_this select 0; _s= _this select 1; _u removeAllEventHandlers "killed"; sleep _s; deletevehicle _u};
MON_deleteDeadDist = {private["_u","_s","_dist","_OCercanos","_cicle","_deleted","_isplayer"];
	_i = 0;
	_cicle = 10;
	_deleted = false;
	_isplayer = false;
	_u = _this select 0; _s = _this select 1; _dist = _this select 2; 	
	_u removeAllEventHandlers "killed"; 
	sleep _s; 
	
	while {!_deleted} do {	
		_isplayer = false;
		//Buscamos objetos cercanos
		_OCercanos = _u nearentities ["Man" , _dist];		
		
		//Validamos si alguno de los soldados cerca es un jugador y est� vivo
		{if (isplayer _x) exitwith {_isplayer = true;}}foreach _OCercanos;
	
		if (!_isplayer) then {		
			deletevehicle _u;	
			_deleted = true;
		};		
		sleep _cicle; 
	};
};
// ---------------------------------------------------------------------------------------------------------
//Funci�n tomada de UPS, busca el comando en la lista y devuelve el siguiente elemento
//param1: comando a buscar
//param2: valor por defecto del comando
//param3: array con los comandos
//Retorna valor del comando encontrado o valor por defecto
MON_getArg = {private["_cmd","_arg","_list","_a","_v"]; _cmd=_this select 0; _arg=_this select 1; _list=_this select 2; _a=-1; {_a=_a+1; _v=format["%1",_list select _a]; 
if (_v==_cmd) then {_arg=(_list select _a+1)}} foreach _list; _arg};

// ---------------------------------------------------------------------------------------------------------
//Funci�n que devuelve una posici�n en 3D a partir de otra, una direcci�n y una distancia
//param1: posici�n
//param2: direcci�n
//param3: distancia
//Retorna vector de posicion en 3D [0,0,0]
MON_GetPos =
{
	private ["_pos","_dir","_dist","_cosU","_cosT","_relTX","_sinU","_sinT","_relTY","_newPos","_newPosX","_newPosY", "_targetZ" ];
	_pos = _this select 0;
	_dir = _this select 1;
	_dist = _this select 2;
			
			_targetX = _pos select 0; _targetY = _pos select 1; _targetZ = _pos select 2;
			
			//Calculamos posici�n 	
			_cosU = [_dir] call MON_GetCOS;		_sinU = [_dir] call MON_GetSIN;			
			_cosT = abs cos(_dir);				_sinT = abs sin(_dir);
			_relTX = _sinT * _dist * _cosU;  	_relTY = _cosT * _dist * _sinU;
			_newPosX = _targetX + _relTX;		_newPosY = _targetY + _relTY;		
			_newPos = [_newPosX,_newPosY,_targetZ];
			_newPos;
};

// ---------------------------------------------------------------------------------------------------------
//Funci�n que devuelve una posici�n en 2D a partir de otra, una direcci�n y una distancia
//param1: posici�n
//param2: direcci�n
//param3: distancia
//Retorna vector de posicion en 2D [0,0]
MON_GetPos2D =
{
	private ["_pos","_dir","_dist","_cosU","_cosT","_relTX","_sinU","_sinT","_relTY","_newPos","_newPosX","_newPosY" ];
	_pos = _this select 0;
	_dir = _this select 1;
	_dist = _this select 2;
			
			if (isnil "_pos") exitWith {}; 
			_targetX = _pos select 0; _targetY = _pos select 1; 
			
			//Calculamos posici�n 	
			_cosU = [_dir] call MON_GetCOS;		_sinU = [_dir] call MON_GetSIN;			
			_cosT = abs cos(_dir);				_sinT = abs sin(_dir);
			_relTX = _sinT * _dist * _cosU;  	_relTY = _cosT * _dist * _sinU;
			_newPosX = _targetX + _relTX;		_newPosY = _targetY + _relTY;		
			_newPos = [_newPosX,_newPosY];
			_newPos;
};

// ---------------------------------------------------------------------------------------------------------
//Funci�n que devuelve las posiciones que se pueden ocupar dentro de un edificio
//param1: objeto location
//Retorna numero de posiciones que tiene el edificio
MON_BldPos = {private ["_bld","_bldpos"];
					_bld=_this; _bldpos = 1;
					while {format ["%1", _bld buildingPos _bldpos] != "[0,0,0]"}  do {_bldpos = _bldpos + 1;};
				_bldpos = _bldpos - 1; _bldpos;};
				
// ---------------------------------------------------------------------------------------------------------				
//Funci�n que devuelve la casa que hay m�s cerca del objeto param1 y las posiciones que se pueden ocupar dentro de ella.
//param1: objeto 
//Retorna vector con [objeto location, posiciones que tiene]
MON_PosInfo = {
	private["_obj","_bld","_bldpos"];
	_obj=_this; 
	_bld = nearestbuilding _obj; 
	_bldpos= _bld call MON_BldPos; 
	[_bld,_bldpos];
	};		

// ---------------------------------------------------------------------------------------------------------
//Funci�n que devuelve el valor negativo o positivo del seno en base a un angulo
MON_GetSIN = {
	private["_dir","_sin","_cos"];	
	_dir=_this select 0; 
	if (isnil "_dir") exitWith {}; 
		 if (_dir<90)  then  
		 {
			_sin=1;
		 } else 
		{ 
			if (_dir<180) then 
			{
				_sin=-1;
			} else 
			{ 
				if (_dir<270) then 
				{
					_sin=-1;
				}
				else 
				{
					_sin=1;
				};				
			};
		};
	_sin
};

// ---------------------------------------------------------------------------------------------------------
//Funci�n que devuelve el valor negativo o positivo del coseno en base a un angulo
MON_GetCOS = {
	private["_dir","_cos"];	
	_dir=_this select 0; 
	if (isnil "_dir") exitWith {}; 
		 if (_dir<90)  then  
		 {
			_cos=1;
		 } else 
		{ 
			if (_dir<180) then 
			{
				_cos=1;
			} else 
			{ 
				if (_dir<270) then 
				{
					_cos=-1;
				}
				else 
				{
					_cos=-1;
				};				
			};
		};
	_cos
};	

///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// Little Functions ///////////////////////////////////////////////////////////////////
//Mueve a todo el grupo adelante
MON_move = {
	private["_npc","_dir1","_targetPos","_dist"];	
	_npc = _this select 0;
	_dist = _this select 1;

	sleep 0.05;	
	if (!alive _npc  || !canmove _npc ) exitwith{};
	
	_dir1 = getDir _npc;
	_targetPos = [position _npc,_dir1, _dist] call MON_GetPos2D;	
	_npc move _targetPos;		
};	

//Mueve al soldado adelante
MON_domove = {
	private["_npc","_dir1","_targetPos","_dist"];	
	_npc = _this select 0;
	_dist = _this select 1;
	if ((count _this) > 2) then {_dir1 = _this select 2;} else{_dir1 = getDir _npc;};
	
	sleep 0.05;	
	if (!alive _npc  || !canmove _npc ) exitwith{};
	
	_targetPos = [position _npc,_dir1, _dist] call MON_GetPos2D;		
	//If position water and not boat, plane nor diver no go
	
	if (surfaceIsWater _targetPos && { !( _npc iskindof "boat" || _npc iskindof "air" || ["diver", (typeOf (leader _npc))] call BIS_fnc_inString ) } ) exitwith 
	{
		if (KRON_UPS_Debug>0) then { 
		diag_log format ["UPSMON 'MON_domove' exit: targetPos is water: [%1] - [%2] - [%3]", _npc iskindof 'boat', _npc iskindof 'air', ['diver', (typeOf (leader _npc))] call BIS_fnc_inString];
		};
	};	
	_npc doMove _targetPos;	
};	

//Funci�n que detiene al soldado y lo hace esperar x segundos
MON_doStop = {
	private["_sleep","_npc"];	
	
	_npc = _this select 0;
	_sleep = _this select 1;		
	
	sleep 0.05;	
	if (!alive _npc  || !canmove _npc ) exitwith{};
	if 	( _sleep == 0 ) then {_sleep = 0.1};	
	
	//Restauramos valores por defecto de movimiento
	if 	( _sleep >= 9999 ) then 
	{	
		dostop _npc ;
		_npc disableAI "TARGET";
	} 
	else 
	{
		dostop _npc ;
		sleep _sleep;	
		[_npc] spawn MON_cancelstop;
	};
};

//Funci�n que detiene al soldado y lo hace esperar x segundos
MON_cancelstop = {
	private["_npc"];
	_npc = _this select 0;
	_npc stop false;
};

//Make grenade dodge animation
MON_evadeGrenade = {	
	if (!alive _this || (vehicle _this) != _this  || !canmove _this) exitwith{};
	
	_this playmovenow "AmovPercMstpSlowWrflDnon_ActsPpneMstpSlowWrflDr_GrenadeEscape";							
	sleep 8;
	if (!alive _this || (vehicle _this) != _this  || !canmove _this) exitwith{};
	_this switchmove "AmovPpneMstpSrasWrflDnon_AmovPpneMevaSlowWrflDr"; //croqueta														
	_this playmovenow "AmovPpneMstpSrasWrflDnon"; //prone							
};

//Realiza la animaci�n de la croqueta
MON_animCroqueta = {	
	if (!alive _this || (vehicle _this) != _this || !canmove _this || !(_this iskindof "Man")) exitwith{};
		
	if ((random 1)<=.50) then {													
		_this switchmove "AmovPpneMstpSrasWrflDnon_AmovPpneMevaSlowWrflDl"; //croqueta																														
	} else {
		_this switchmove "AmovPpneMstpSrasWrflDnon_AmovPpneMevaSlowWrflDr"; //croqueta																				
	};		
};

//Throw a grenade
MON_throw_grenade = {
	private["_target","_npc"];	
	_npc = _this select 0;
	_target = _this select 1;		
	sleep random 1.5;
	if (!alive _npc || (vehicle _npc) != _npc || !canmove _npc) exitwith{};	
	[_npc,_target] call MON_dowatch;
	sleep 0.5;
		
	// R_Functions
	// [_npc] spawn R_ThrowSmoke;
			
	_npc addMagazine "SmokeShell";
	_npc selectWeapon "throw";
	sleep .1;
	_npc fire ["SmokeShellMuzzle","SmokeShellMuzzle","SmokeShell"];
	sleep 2;
	_npc lookat ObjNull;
};

//Establece el tipo de posici�n
MON_setUnitPos = {
	private["_pos","_npc"];	
	_npc = _this select 0;
	_pos = _this select 1;	
	if (isnil "_npc") exitWith {}; 
	sleep 0.5;
	if (!alive _npc || !canmove _npc || _npc != vehicle _npc || !(_npc iskindof "Man")) exitwith{};
	_npc setUnitPos _pos;
	sleep 1;
};
//Establece el tipo de posici�n
MON_setUnitPosTime = {
	private["_pos","_npc"];	
	_npc = _this select 0;
	_pos = _this select 1;	
	_time = _this select 2;
	
	if (!alive _npc || !canmove _npc) exitwith{};
	_npc setUnitPos _pos;
	sleep _time;
	_npc setUnitPos "AUTO";
	sleep 1;
};

// Funci�n para  mirar en una direcci�n
MON_dowatch = {
	private["_target","_npc"];		
	_npc = _this select 0;
	_target = _this select 1;	

	if (!alive _npc) exitwith{};
	_npc lookat ObjNull;
	_npc lookat _target;

};

//Funci�n que mueve al soldado a la posici�n de conductor
//Par�meters: [_npc,_vehicle]
//	<-	 _npc: unit to move to driver pos
//	<-	 _vehicle
MON_movetoDriver = {
	private["_vehicle","_npc"];		
	_npc = _this ;
	_vehicle = vehicle _npc;

	//Si est� muerto
	if (vehicle _npc == _npc || !alive _npc || !canmove _npc || !(_npc iskindof "Man")) exitwith{};
	
	if (isnull(driver _vehicle) || !alive(driver _vehicle) || !canmove(driver _vehicle)) then { 	
		//if (KRON_UPS_Debug>0) then {player sidechat format["%1: Moving to driver of %2 ",_npc,typeof _vehicle]}; 	
		 _npc action ["getOut", _vehicle];
		 doGetOut _npc;
		WaitUntil {vehicle _npc==_npc || !alive _npc || !canmove _npc};
		//Si est� muerto
		if (!alive _npc || !canmove _npc) exitwith{};		
		unassignVehicle _npc;
		_npc assignasdriver _vehicle;
		_npc moveindriver _vehicle;
	};
};

//Funci�n que mueve al soldado a la posici�n de conductor
//Par�meters: [_npc,_vehicle]
//	<-	 _npc: unit to move to driver pos
//	<-	 _vehicle
MON_movetogunner = {
	private["_vehicle","_npc"];		
	_npc = _this ;
	_vehicle = vehicle _npc;
	
	sleep 0.05;
	//Si est� muerto
	if (vehicle _npc == _npc || !alive _npc || !canmove _npc || !(_npc iskindof "Man")) exitwith{};
	
	if (isnull(gunner _vehicle) || !alive(gunner _vehicle) || !canmove(gunner _vehicle)) then { 	
		if (KRON_UPS_Debug>0) then {player sidechat format["%1: Moving to gunner of %2 ",_npc,typeof _vehicle]}; 	
		 _npc action ["getOut", _vehicle];
		 doGetOut _npc;
		WaitUntil {vehicle _npc==_npc || !alive _npc || !canmove _npc};
		//Si est� muerto
		if (!alive _npc || !canmove _npc) exitwith{};		
		unassignVehicle _npc;
		_npc assignasgunner _vehicle;
		_npc moveingunner _vehicle;
	};
};


/////////////////////////////////////////////// Little Functions ///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//Funci�n que busca vehiculos cercanos y hace entrar a las unidades del lider
//Par�meters: [_grpid,_npc]
//	<-	_grpid: id of group to assign to vehicle
//	<-	_npc: lider
//	->	_getin: true if any getin
MON_GetIn_NearestVehicles = {
	private["_vehicles","_npc","_units","_unitsIn","_grpid","_getin","_subs","_isdiver"];
	_grpid = _this select 0;	
	_npc = _this select 1;				
	
	_vehicles=[[]];
	_air=[[]];
	_subs=[[]];
	_units = [];
	_unitsIn = [];
	_getin=false;
	
	if (leader _npc == _npc) then {
		_units = units _npc;
	} else {
		_units = _units + [_npc];
	};
	
	{
		if ( (_x!= vehicle _x && !((vehicle _x) iskindof "StaticWeapon" )) || !(_x iskindof "Man") || !alive _x || !canmove _x || !canstand _x) then {_units = _units-[_x];};
	}foreach _units;
	
	_unitsIn = _units;
	
	//First catch combat vehicles
	if ( (count _units) > 0) then 
	{	
		_air = [_npc,200] call MON_NearestsAirTransports;
		{if (_npc knowsabout (_x select 0) <= 0.5) then{ _air = _air - [_x]};}foreach _air;
		_units = [_grpid, _units, _air, false] call MON_selectvehicles;				
	};
	sleep 0.05;
	if ( (count _units) > 1) then 
	{	
		_vehicles = [_npc,200,true] call MON_NearestsLandCombat;
		{if (_npc knowsabout(_x select 0) <= 0.5) then{ _vehicles = _vehicles - [_x]};}foreach _vehicles;
		_units = [_grpid, _units, _vehicles, false] call MON_selectvehicles;		
	};		
	sleep 0.05;
	if ( (count _units) > 0) then 
	{	
		_vehicles = [_npc,200] call MON_NearestsLandTransports;
		{if (_npc knowsabout (_x select 0) <= 0.5) then{ _vehicles = _vehicles - [_x]};}foreach _vehicles;
		_units = [_grpid, _units, _vehicles, false] call MON_selectvehicles;		
	};
	sleep 0.05;
	if ( (count _units) > 0) then 
	{	
		//_isdiver = ["diver", (typeOf (leader _npc))] call BIS_fnc_inString;
		//if ( _isDiver ) then 
		if ( surfaceIsWater getPosASL _npc ) then // either diver or AI floating in the water
		{
			_vehicles = [_npc,200] call MON_Nearestsboats;
			diag_log format ["UPSMON: boats: [%1]", _vehicles];			
			{if (_npc knowsabout (_x select 0) <= 0.5) then{ _vehicles = _vehicles - [_x]};}foreach _vehicles;
			_units = [_grpid, _units, _vehicles, false] call MON_selectvehicles;		
		};
	};
	sleep 0.05;
	if ( (count _units) > 0 &&  (count _vehicles) > 0) then 
	{
		sleep 1;
		_vehicles = _vehicles + _air;
		_units = [_grpid, _units, _vehicles, true] call MON_selectvehicles;
	};	
	sleep 0.05;
	_unitsIn = _unitsIn - _units;

	_unitsIn;
	//sleep 0.05;
};

//Funci�n que busca vehiculos cercanos y hace entrar a las unidades del lider
//Par�meters: [_grpid,_npc]
//	<-	_grpid: id of group to assign to vehicle
//	<-	_npc: lider
//	->	_getin: true if any getin
MON_GetIn_NearestCombat = {
	private["_vehicles","_npc","_units","_unitsIn","_grpid","_getin","_dist","_all"];
	_grpid = _this select 0;	
	_npc = _this select 1;		
	_dist = _this select 2;	
	_all = _this select 3;	
	
	_vehicles=[[]];
	_units = [];
	_unitsIn = [];
	_getin=false;
	
	if (leader _npc == _npc) then {
		_units = units _npc;
	} else
	{
		_units = _units + [_npc];
	};
	
	{
		if ( (_x!= vehicle _x && !((vehicle _x) iskindof "StaticWeapon" )) || !(_x iskindof "Man") || !alive _x || !canmove _x || !canstand _x) then {_units = _units-[_x];};
	}foreach _units;
	
	//If suficient units leader will not get in
	if !(_all) then {
		if (count _units > 2 ) then {_units = _units - [leader _npc]};	
	};
	
	_unitsIn = _units;
	
	//We need 2 units available if not any leave vehicle to another squad	
	if ( (count _units) > 1) then {	
		_vehicles = [_npc,_dist,_all] call MON_NearestsAirCombat;
		{if (_npc knowsabout (_x select 0) <= 0.5) then{ _vehicles = _vehicles - [_x]};}foreach _vehicles;
		_units = [_grpid, _units, _vehicles, false] call MON_selectvehicles;				
	};
	sleep 0.05;
	
	if ( (count _units) > 1) then {	
		_vehicles = [_npc,_dist,_all] call MON_NearestsLandCombat;
		{if (_npc knowsabout(_x select 0) <= 0.5) then{ _vehicles = _vehicles - [_x]};}foreach _vehicles;
		_units = [_grpid, _units, _vehicles, false] call MON_selectvehicles;		
	};
	
	_unitsIn = _unitsIn - _units;

	 _unitsIn;
};

//Funci�n que busca vehiculos cercanos y hace entrar a las unidades del lider
//Par�meters: [_grpid,_npc]
//	<-	_grpid: id of group to assign to vehicle
//	<-	_npc: lider
//	->	_getin: true if any getin
MON_GetIn_NearestBoat = {
	private["_vehicles","_npc","_units","_unitsIn","_grpid","_getin","_dist"];
	_grpid = _this select 0;	
	_npc = _this select 1;		
	_dist = _this select 2;		
	
	_vehicles=[[]];
	_units = [];
	_unitsIn = [];
	_getin=false;
	
	if (leader _npc == _npc) then {
		_units = units _npc;
	} else
	{
		_units = _units + [_npc];
	};
	
	{
		if ( (_x!= vehicle _x && !((vehicle _x) iskindof "StaticWeapon" )) || !(_x iskindof "Man") || !alive _x || !canmove _x || !canstand _x) then {_units = _units-[_x];};
	}foreach _units;
	
	_unitsIn = _units;
	
	//We need 2 units available if not any leave vehicle to another squad	
	if ( (count _units) > 0) then {			
		_vehicles = [_npc,_dist] call MON_Nearestsboats;
		{if (_npc knowsabout (_x select 0) <= 0.5) then{ _vehicles = _vehicles - [_x]};}foreach _vehicles;
		_units = [_grpid, _units, _vehicles, false] call MON_selectvehicles;			
	};
	
	if ( (count _units) > 1 &&  (count _vehicles) > 0) then {
		sleep 1;
		_units = [_grpid, _units, _vehicles, true] call MON_selectvehicles;
	};
	
	_unitsIn = _unitsIn - _units;
	_unitsIn;
};

//Funci�n que busca staticos cercanos y hace entrar a las unidades del lider
//Par�meters: [_grpid,_npc]
//	<-	_grpid: id of group to assign to vehicle
//	<-	_npc: lider
//	->	_getin: true if any getin
MON_GetIn_NearestStatic = {
	private["_vehicles","_npc","_units","_unitsIn","_grpid","_getin","_count"];
	_grpid = _this select 0;	
	_npc = _this select 1;	
	_count = 0;
	_distance = 100;		
	if ((count _this) > 2) then {_distance = _this select 2;};	
	
	_vehicles=[];
	_units = [];
	_unitsIn = [];
	_getin=false;
	
	//Buscamos staticos cerca
	_vehicles = [_npc,_distance] call MON_NearestsStaticWeapons;

	if (KRON_UPS_Debug>0 ) then {diag_log format["%1: Found %2 estatic weapons %3 ",_grpid,count _vehicles,_npc]};
	if ( count _vehicles == 0) exitwith {_unitsIn;};	
	
	if (leader _npc == _npc) then {
		_units = (units _npc) - [_npc];
	} else
	{
		_units = _units + [_npc];
	};
	
	//Solo tomamos las unidades vivas y que no est�n en vehiculo
	{
		if ( (_x iskindof "Man") && _x == vehicle _x && alive _x && canmove _x && canstand _x) then {
			_unitsIn = _unitsIn + [_x];			
		};
	}foreach _units;
	
	//Intentamos tomar solo las que est�n disponibles
	_units = [];
	{
		if (unitready _x) then {
			_units = _units + [_x];			
		};
	}foreach _unitsin;	
	
	//Si hay unidades disponibles las usamos
	if (count _units > 0) then {
		_unitsIn = _units;
	};
	
	if (KRON_UPS_Debug>0 ) then {diag_log format["%1: Found %2 estatic weapons %3 men available",_grpid,count _vehicles, count _unitsIn]}; 
	
	 _units = _unitsIn;
	if ( count _unitsIn > 0) then {		
		_units = [_grpid, _units, _vehicles, true] call MON_selectvehicles;				
	};
	
	_unitsIn = _unitsIn - _units;

	_unitsIn;
};

//Function to assign units to vehicles
//Par�meters: [_grpid,_unitsin,_vehicle]
//	<-	_grpid: id of group to assign to vehicle
//	<-	_units: array of units to getin
//	<-	_vehicles: array of vehicles to use
//	->	_untis:  array of units getin
 MON_selectvehicles = {
	private["_vehicles","_emptypositions","_units","_unitsIn","_i","_grpid","_vehgrpid","_unit","_wp","_any","_index","_cargo"];
	_grpid = _this select 0;	
	_units = _this select 1;
	_vehicles = _this select 2;	
	_any = _this select 3;	//meter en cualquier vehiculo
	
	_wp = [];	
	_vehicle = [];
	_unitsIn = [];
	_emptypositions = 0;
	_i = 0;
	_vehgrpid = 0;
	_unit = objnull;
	_index = 0;
	_cargo = [];	
	
  	{
		if ((count _units) == 0 )  exitwith {};
		
		_vehicle = _x select 0 ;
		_emptypositions = _x select 1;		
		_unitsIn = [];
		_i = 0;
		_vehgrpid = _vehicle getVariable ["UPSMON_grpid", 0];
		_cargo = _vehicle getVariable ["UPSMON_cargo", [] ];
		//if ( isNil("_vehgrpid") ) then {_vehgrpid = 0;};	
		//if ( isNil("_cargo") ) then {_cargo = [];};		

		//Asignamos el vehiculo a a la escuadra si contiene las posiciones justas
		//Assign the vehicle to the group
		if (_vehgrpid == 0) then {
			_vehicle setVariable ["UPSMON_grpid", _grpid, false];		
			_vehicle setVariable ["UPSMON_cargo", _unitsIn, false];						
			_vehgrpid = _grpid;				
		};	
		
		{
			if (!alive _x || !canmove _x) then 
			{
				_cargo = _cargo - [_x]; 
			};
		} foreach _cargo;
		
		_emptypositions = _emptypositions - (count _cargo - count ( crew _vehicle) );		

				
		if (KRON_UPS_Debug>0) then {diag_log format["%1 %2 positions=%3 cargo=%4 crew=%5",_grpid, typeof _vehicle, _emptypositions, count _cargo,count (crew _vehicle)]};
		
		//ahora buscamos en cualquier vehiculo
		//look for vehicle and count spaces
		if ( _vehgrpid == _grpid || (_emptypositions > 0 && _any)) then 
		{
			while {_i < _emptypositions && _i < count _units} do
			{
				_unit = _units select _i;		
				_unitsIn = _unitsIn + [_unit];				
				_i = _i + 1;
			};
			_units = _units - _unitsIn;
			
			if ( (count _unitsIn) > 0) then 
			{			
				//Metemos las unidades en el vehiculo
				//Let units board vehicle
				[_grpid,_unitsIn,_vehicle] spawn MON_UnitsGetIn;	
				if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: Get in %2 %3 units of %4 available",_grpid,typeof _vehicle,count _unitsIn,_emptypositions]}; 				
				if (KRON_UPS_Debug>0 ) then {diag_log format["UPSMON %1: Moving %3 units into %2 with %4 positions",_grpid,typeof _vehicle,count _unitsIn,_emptypositions]}; 
			};
		};		
		_index 	= _index  + 1;
		sleep 0.05;
	} foreach _vehicles;
	
	_units;
 };


//Funcion que mete la tropa en el vehiculo
//Par�meters: [_grpid,_unitsin,_vehicle]
//	<-	_grpid: id of group to assign to vehicle
//	<-	_unitsin: array of units to getin
//	<-	_vehicle
MON_UnitsGetIn = {
	private["_grpid","_vehicle","_npc","_driver","_gunner", "_unitsin", "_units" , "_Commandercount","_Drivercount","_Gunnercount","_cargo",
			"_Cargocount","_emptypositions","_commander","_vehgrpid","_cargo"];	
			
	_grpid = _this select 0;
	_unitsin = _this select 1;
	_vehicle = _this select 2;
	
	_units = _unitsin;				
	_driver = objnull;
	_gunner = objnull;	
	_commander	= objnull;
	_Cargocount = 0;
	_Gunnercount = 0;
	_Commandercount = 0;
	_Drivercount = 0;
	_cargo = [];
	
	_Cargocount = (_vehicle) emptyPositions "Cargo";
	_Gunnercount = (_vehicle) emptyPositions "Gunner"; 
	_Commandercount = (_vehicle) emptyPositions "Commander"; 
	_Drivercount = (_vehicle) emptyPositions "Driver"; 					

	//Obtenemos el identificador del vehiculo
	_vehgrpid = _vehicle getvariable ("UPSMON_grpid");
	_cargo = _vehicle getvariable ("UPSMON_cargo");
	if ( isNil("_vehgrpid") ) then {_vehgrpid = 0;};	
	if ( isNil("_cargo") ) then {_cargo = [];};			

	_cargo = _cargo - _unitsin; //Para evitar duplicados
	_cargo = _cargo + _unitsin; //A�adimos a la carga
	_vehicle setVariable ["UPSMON_cargo", _cargo, false];			

	//Hablitamos a la IA para entrar en el vehiculo
	//Tell AI to get in vehicle
	{		
		[_x,0] call MON_dostop;
		
		if ("StaticWeapon" countType [vehicle (_x)]>0) then 
		{
			_x spawn MON_doGetOut;
		};			

		unassignVehicle _x;				
		_x spawn MON_Allowgetin;						
	} foreach _units;				
	
	//Assigned to the leader as commander or cargo		
	{
		if ( _vehgrpid == _grpid && _x == leader _x && _Commandercount > 0 ) exitwith
		{
			_Commandercount = 0;
			_commander = _x;		
			_commander assignAsCommander _vehicle;			
			_units = _units - [_x];
			[_x] orderGetIn true;
		};

		if ( _x == leader _x && _Cargocount > 0 ) exitwith
		{
			_x assignAsCargo _vehicle;	
			_units = _units - [_x];
			_Cargocount = _Cargocount - 1;
			[_x] orderGetIn true;
		};
	} foreach _units;			
	//if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: _vehgrpid %2 ,_Gunnercount %3, %4",_grpid,_vehgrpid,_Gunnercount,count _units]}; 	
				
	//Si el vehiculo pertenece al grupo asignamos posiciones de piloto, sin� solo de carga
	//Make sure some AI will get in as driver (and if available as gunner(s))
	if ( _vehgrpid == _grpid ) then 
	{		
		//Asignamos el conductor
		if ( _Drivercount > 0 && count (_units) > 0 ) then 
		{ 
			_driver =  _units  select (count _units - 1);									
			[_driver,_vehicle,0] spawn MON_assignasdriver;	
			_units = _units - [_driver];
		};
		
		//Asignamos el artillero
		if ( _Gunnercount > 0 && count (_units) > 0 ) then 
		{ 				
			_gunner = [_vehicle,_units] call MON_getNearestSoldier;				
			[_gunner,_vehicle] spawn MON_assignasgunner;					
			_units = _units - [_gunner];
		};					
	};
	
	//if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: _vehgrpid=%2 units=%4",_grpid,_vehgrpid,_cargocount,count _units]}; 	
	//Movemos el resto como carga
	if ( _Cargocount > 0 && count (_units) > 0 ) then 
	{ 	
		{			 
			_x assignAsCargo _vehicle;				
			[_x] orderGetIn true;		
			sleep 0.05;			
		} forEach _units;  
	};	
	
	{						
		[_x] spawn MON_avoidDissembark;				
	} forEach _unitsin - [_driver] - [_gunner] -[_commander]; 
	
};	

MON_getNearestSoldier = {
	private["_units","_obj","_near"];
		
	_obj = _this select 0;
	_units = _this select 1;
	
	_near = objnull;
	
	{
		if (isnull _near) then {
			_near = _x;
		} else {
			if ( _x distance _obj < _near distance _obj ) then {_near = _x;};
		};
	}foreach _units;
	_near;
};
	
MON_avoidDissembark = {
	private["_npc","_vehicle","_timeout"];
	
	_npc = _this select 0;
	_vehicle = vehicle _npc ;
	
	_timeout = 120;
	_timeout = time + _timeout;
	
	while {_npc == vehicle _npc && alive _npc && canmove _npc && time < _timeout} do {
		sleep 1;
	};
		
	if (!alive _npc || !canmove _npc || time >= _timeout || driver vehicle _npc == _npc) exitwith{};	
	_npc stop true;
	
	while {_npc != vehicle _npc && alive _npc && canmove _npc} do {sleep 1;};
	_npc stop false;
	sleep 0.5;	
	
	if (!alive _npc || !canmove _npc) exitwith{};		
};


//Funci�n que devuelve un vehiculo de transporte cercano	
//Par�meters: [_npc]
//	<-	_npc: object for  position search
//	->	_vehicle:  vehicle
MON_NearestLandTransport = {
	private["_vehicle","_npc","_transportSoldier","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount"];	
	
	_npc = _this;				

	_OCercanos = [];
	_transportSoldier = 0;
	_vehicle = objnull;
	_Cargocount = 0;
	_Gunnercount = 0;
	_Commandercount = 0;
	_Drivercount = 0;
		
	
	//Buscamos objetos cercanos
	_OCercanos = _npc nearentities [["Car","TANK","Truck","Motorcycle"], 150];		
	
	{
		_Cargocount = (_x) emptyPositions "Cargo";
		_Gunnercount = (_x) emptyPositions "Gunner"; 
		_Commandercount = (_x) emptyPositions "Commander"; 
		_Drivercount = (_x) emptyPositions "Driver"; 
		
		_transportSoldier = _Cargocount + _Gunnercount + _Commandercount + _Drivercount;
		
		//ToDo check impact (locked _x != 2)
		if ((locked _x==1)  && canMove _x && _transportSoldier >= count (units _npc) && !(typeof _x in MON_bugged_vehicles)
			&& (_drivercount > 0 || side _npc == side _x )) exitwith {_vehicle = _x;};
	}foreach _OCercanos;
	
	_vehicle;
};	
	
//Funci�n que devuelve un array con los vehiculos terrestres m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_NearestsLandTransports = {
		private["_vehicles","_npc","_emptypositions","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount","_distance"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;					
		
	_OCercanos = [];
	_emptypositions = 0;
	_vehicles = [];
	_Cargocount = 0;
	_Gunnercount = 0;
	_Commandercount = 0;
	_Drivercount = 0;
	
	//Buscamos objetos cercanos
	_OCercanos = _npc nearentities [["Car","TANK","Truck","Motorcycle"], _distance];
		
	{
		_Cargocount = (_x) emptyPositions "Cargo";
		_Gunnercount = (_x) emptyPositions "Gunner"; 
		_Commandercount = (_x) emptyPositions "Commander"; 
		_Drivercount = (_x) emptyPositions "Driver"; 
		
		_emptypositions = _Cargocount + _Gunnercount + _Commandercount + _Drivercount;
		
		//ToDo check impact (locked _x != 2)
		if ((locked _x==1) && _emptypositions > 0 && canMove _x && !(typeof _x in MON_bugged_vehicles)
			&& (_drivercount > 0 || side _npc == side _x )) then { _vehicles = _vehicles + [[_x,_emptypositions]];};
	}foreach _OCercanos;
	
	_vehicles;
};	

//Funci�n que devuelve un array con los vehiculos terrestres m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_NearestsLandCombat = {
		private["_vehicles","_npc","_emptypositions","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount","_distance","_all"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;		
	_all = _this select 2;		
		
	_OCercanos = [];
	_emptypositions = 0;
	_vehicles = [];
	_Cargocount = 0;
	_Gunnercount = 0;
	_Commandercount = 0;
	_Drivercount = 0;
	
	//Buscamos objetos cercanos
	_OCercanos = _npc nearentities [["Car","TANK","Truck","Motorcycle"] , _distance];
		
	{
		if (_all) then {
			_Cargocount = (_x) emptyPositions "Cargo";
		};
		_Gunnercount = (_x) emptyPositions "Gunner"; 
		_Drivercount = (_x) emptyPositions "Driver"; 
		_Commandercount = (_x) emptyPositions "Commander"; 
		
		_emptypositions = _Cargocount + _Gunnercount + _Commandercount + _Drivercount;
		
		//ToDo check impact (locked _x != 2)
		if ((locked _x==1) && (_Gunnercount > 0) && (canMove _x) && !(typeof _x in MON_bugged_vehicles)
			&& (_drivercount > 0 || side _npc == side _x )) then { _vehicles = _vehicles + [[_x,_emptypositions]];};
	}foreach _OCercanos;
	
	_vehicles;
};		

//Funci�n que devuelve un array con los vehiculos aereos m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_NearestsAirTransports = {
		private["_vehicles","_npc","_emptypositions","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount","_distance"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;					
		
	_OCercanos = [];
	_emptypositions = 0;
	_vehicles = [];
	_Cargocount = 0;
	_Gunnercount = 0;
	_Commandercount = 0;
	_Drivercount = 0;
	
	//Searching for close vehicle objects
	_OCercanos = _npc nearentities ["Helicopter", _distance];
		
	{
		_Cargocount = (_x) emptyPositions "Cargo";
		_Gunnercount = (_x) emptyPositions "Gunner"; 
		_Commandercount = (_x) emptyPositions "Commander"; 
		_Drivercount = (_x) emptyPositions "Driver"; 
		
		_emptypositions = _Cargocount + _Gunnercount + _Commandercount + _Drivercount;
		
		//ToDo check impact (locked _x != 2)
		if ((locked _x==1) && _emptypositions > 0 && canMove _x && !(typeof _x in MON_bugged_vehicles)
			&& (_drivercount > 0 || side _npc == side _x )) then { _vehicles = _vehicles + [[_x,_emptypositions]];};
	}foreach _OCercanos;
	
	_vehicles;
};	
	
//Function that returns an array with the closest air vehicles
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_NearestsAirCombat = {
		private["_vehicles","_npc","_emptypositions","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount","_distance","_all"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;		
	_all  = _this select 2;	
		
	_OCercanos = [];
	_emptypositions = 0;
	_vehicles = [];
	_Cargocount = 0;
	_Gunnercount = 0;
	_Commandercount = 0;
	_Drivercount = 0;
	
	
	
	//Buscamos objetos cercanos
	_OCercanos = _npc nearentities ["Helicopter", _distance];
		
	{
		if (_all) then {
			_Cargocount = (_x) emptyPositions "Cargo";
		};
		
		// _Gunnercount = [_x] call RAF_numberOfTurrets;
		_Gunnercount = (_x) emptyPositions "Gunner"; 
		_Drivercount = (_x) emptyPositions "Driver"; 
		_Commandercount = (_x) emptyPositions "Commander"; 
		
		_emptypositions = _Cargocount + _Gunnercount + _Commandercount + _Drivercount;
		
		//ToDo check impact (locked _x != 2)
		if ((locked _x==1) && _Gunnercount > 0 && canMove _x && !(typeof _x in MON_bugged_vehicles)
			&& (_drivercount > 0 || side _npc == side _x )) then { _vehicles = _vehicles + [[_x,_emptypositions]];};
	}foreach _OCercanos;
	_vehicles //return
};		

//Funci�n que devuelve un array con los vehiculos staticos m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_NearestsStaticWeapons = {
		private["_vehicles","_npc","_emptypositions","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount","_distance"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;					
		
		_OCercanos = [];
		_emptypositions = 0;
		_vehicles = [];
		_Cargocount = 0;
		_Gunnercount = 0;
		_Commandercount = 0;
		_Drivercount = 0;
		
		//Buscamos objetos cercanos
		_OCercanos = _npc nearentities ["StaticWeapon" , _distance];
			
		{
			_Gunnercount = (_x) emptyPositions "Gunner"; 			
			_emptypositions = _Gunnercount;
			
			//ToDo check impact (locked _x != 2)
			if ((locked _x==1) && alive _x && _emptypositions > 0 && !(typeof _x in MON_bugged_vehicles) ) then { _vehicles = _vehicles + [[_x,_emptypositions]];};
		}foreach _OCercanos;
		
		_vehicles //return
	};		
	
//Funci�n que devuelve un array con los vehiculos marinos m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_Nearestsboats = {
		private["_vehicles","_npc","_emptypositions","_OCercanos","_driver", "_Commandercount","_Drivercount","_Gunnercount","_Cargocount","_distance"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;					
		
		_OCercanos = [];
		_emptypositions = 0;
		_vehicles = [];
		_Cargocount = 0;
		_Gunnercount = 0;
		_Commandercount = 0;
		_Drivercount = 0;
		
		//Buscamos objetos cercanos
		_OCercanos = _npc nearentities ["Ship" , _distance];
			
		{
			_Cargocount = (_x) emptyPositions "Cargo";
			_Gunnercount = (_x) emptyPositions "Gunner"; 
			_Commandercount = (_x) emptyPositions "Commander"; 
			_Drivercount = (_x) emptyPositions "Driver"; 
			
			_emptypositions = _Cargocount + _Gunnercount + _Commandercount + _Drivercount;
			
			//ToDo check impact (locked _x != 2)
			if ((locked _x==1) && _emptypositions > 0 && canMove _x && (_drivercount > 0 || side _npc == side _x )) then { _vehicles = _vehicles + [[_x,_emptypositions]];};
		}foreach _OCercanos;
		
		_vehicles //return
	};
	
//Function to delay the taking of the steering wheel and the vehicle will not have time to rise and	
MON_assignasdriver = {
	private["_vehicle","_driver","_wait"];	
	_driver =  _this  select 0;
	_vehicle = _this select 1;		
	_wait = _this select 2;		
	
	[_driver,_wait] spawn MON_dostop;
	sleep _wait;
	
	unassignVehicle _driver;
	_driver assignasdriver _vehicle;
	[_driver] orderGetIn true;	

	//if (KRON_UPS_Debug>0) then {player sidechat format["%1: assigning to driver of %2 ",_driver,  typeof _vehicle]}; 
};

MON_assignasgunner = {
	private["_vehicle","_gunner","_dist"];	
	_gunner =  _this  select 0;
	_vehicle = _this select 1;	
	_dist=0;
	
	_gunner assignasgunner _vehicle;
	[_gunner] orderGetIn true;	
	
	waituntil  { _gunner != vehicle _gunner || !alive _gunner || !canmove _gunner ||!alive _vehicle || !canfire _vehicle};
	
	if ( alive _gunner && alive _vehicle && canmove _gunner && canfire _vehicle) then {				
		_dist = _gunner distance _vehicle;
		if (_dist < 3) then {
			_gunner moveInTurret [_vehicle, [0]] ;	
		};		
	};
};


//Allow getin
MON_Allowgetin = {
	//Hablitamos a la IA para entrar en el vehiculo		
	[_this] allowGetIn true;		
};
	

//If every on is outside, make sure driver can move
 MON_checkleaveVehicle={
	_npc = _this select 0;
	_vehicle = _this select 1;
	_driver = _this select 2;
	_in = false;
	
	//Take time to go all units
	sleep 5;
	{
		if (_x != vehicle _x) then {_in = true};
	}foreach units _npc;
	
	
	// if no one is inside
	if (!_in) then {
		_driver enableAI "MOVE"; 
		sleep 1;
		_driver stop false;
		sleep 1;
		_driver leaveVehicle _vehicle; 
		sleep 1;
 	};
 };

 
//Function for order a unit to exit if no gunner
//Par�meters: [_npc]
//	<-	_npc: 
MON_GetOut = {
		private["_vehicle","_npc","_getout" ,"_gunner"];	
				
		_npc = _this;
		_vehicle = vehicle (_npc);	
		_gunner = objnull;
		_gunner = gunner _vehicle;	
		
		sleep 0.05;	
		if (!alive _npc) exitwith{};
		
		//If no leave the vehicle gunner
		if ( isnull _gunner || !alive _gunner  || !canmove _gunner || (_gunner != _npc && driver _vehicle != _npc && commander _vehicle != _npc) ) then { 			
			[_npc] allowGetIn false;
			_npc spawn MON_doGetOut;										 
			unassignVehicle _npc;
			
			//sleep 0.2;
		};	
	};	

//Function for order a unit to exit
//Par�meters: [_npc]
//	<-	_npc: 	
MON_doGetOut = {	
	private["_vehicle","_npc","_getout" ,"_gunner","_groupOne","_timeout","_dir"];	
			
	_npc = _this;
	_vehicle = vehicle (_npc);	
	
	sleep 0.05;	
	if (_vehicle == _npc) exitwith{};	

	//Wait until vehicle is stopped
	waituntil {!alive _npc || !canmove _npc || !alive _vehicle || ( (abs(velocity _vehicle select 0)) <= 0.1 && (abs(velocity _vehicle select 1)) <= 0.1 )
							 || ( _vehicle iskindof "Air" && ((position _vehicle) select 2) <= 1.5)};	

	if (!alive _npc || !canmove _npc) exitwith{};	
	unassignVehicle _npc;	
	_npc action ["getOut", _vehicle];
	doGetOut _npc;
	[_npc] allowGetIn false;	
	nul = [_npc] spawn MON_cancelstop;
	
	waituntil {!alive _npc || !canmove _npc || vehicle _npc == _npc};	
	if (!alive _npc || !canmove _npc) exitwith{};
		
	if (leader _npc != _npc) then {
		//Moves out with dispersion of 45�
		_dir = getDir _npc;	
		_dir = _dir + 45 - (random 90);
		nul = [_npc,25,_dir] spawn MON_domove;
		//if (KRON_UPS_Debug>0 ) then { player globalchat format["%1 Moving away from %2 %2�",_npc, typeof _vehicle,_dir];};	
	};
};

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////// helicopter Module ////////////////////////////////////////////////////////////////////////	
//Function for exiting of heli	
//Par�meters: [_heli,_targetPos,_atdist]
//	<-	_heli: 
//	<-	_targetPos:  position for exiting(if no waypoint used)
//	<- 	_atdist:  distance for doing paradrop or landing
MON_doParadrop = {
	if (KRON_UPS_Debug>0 ) then { player globalchat format["Mon_doParadrop started"];};
	private["_heli","_startpos","_npc","_getout" ,"_gunner","_targetpos","_helipos","_dist","_index","_grp","_wp","_targetPosWp","_targetP","_units","_crew","_timeout","_jumpers"];				
	_heli = _this select 0;
	_targetPos = [0,0];
	_atdist = 250;
	_flyingheigh =  KRON_UPS_flyInHeight;	
	_landonBeh = ["CARELESS","SAFE","AWARE","COMBAT"];
	//_landonBeh = ["CARELESS","SAFE"];  // ToDo check impact
	_timeout=0;
	
	_startpos = getpos _heli; 
	//Gets optional parameters
	if ((count _this) > 1) then {_targetPos = _this select 1;};
	if ((count _this) > 2) then {_atdist = _this select 2;};
	if ((count _this) > 3) then {_flyingheigh = _this select 3;};		

	_helipos = [0,0];
	_targetposWp = [0,0];
	_gunner = objnull;
	_gunner = gunner _heli;		
	_dist = 1000000;
	_index = 0;
	_grp = GRPNULL;
	_wp = [];
	_units =[];
	_crew =[];
	
	waituntil {count crew _heli > 0 || !alive _heli || !canmove _heli};
	_grp = group ((crew _heli) select 0);
	_npc = leader ((crew _heli) select 0);
	_units = units _npc;
	
	while { (_dist >= _atdist || _dist < 10) && alive _heli && canmove _heli && count crew _heli > 0} do 
	{			
		_heli flyInHeight _flyingheigh;
				
		
		//	//Take last waypoint
		//	_index = (count waypoints _grp) - 1;	
		//	_wp = [_grp,_index];
		//	_targetPosWp = waypointPosition _wp;
		//	if (format ["%1", _targetPosWp] == "[0,0,0]") then {_targetPosWp = _targetPos};
				
		
		_targetPosWp = _targetPos;
		
		_helipos = position _heli;	
		_dist = round([_helipos,_targetPosWp] call KRON_distancePosSqr);
		if (KRON_UPS_Debug>0 ) then {diag_log format["UPSMON 'MondoParaDrop' - Going to dropzone _dist=%1, _atdist=%2", _dist, _atdist ];};	
		sleep 1;
	};
	
	if (!alive _heli || count crew _heli == 0) exitwith{};
	
	_crew = crew _heli;

	if ( ((position _heli) select 2) >= 60 && !surfaceIsWater _helipos && (!canMove _heli || (toUpper (behaviour _npc) IN _landonBeh))) then 
	{			
		    //[_heli] spawn MON_landHely;				
			[_heli,_startpos] spawn MON_landHely;
	} 
	else 
	{				
		If (alive _heli && canMove _heli && count crew _heli > 0) then {
			if (KRON_UPS_Debug>0 ) then {_heli globalChat format["%1 failed paradrop, trying another time",typeOf _heli];};
			//Try another time
			_heli flyInHeight _flyingheigh;
			sleep 3;
			[_heli, _targetPos, _atdist*1.5,_flyingheigh] spawn MON_doParadrop; 
		};
	};
};	
//};		

//Lands hely	
MON_landHely = {
	private["_heli","_npc","_crew","_NearestEnemy","_timeout","_landing","_targetpos","_jumpers","_startpos"];				
	_heli = _this select 0;
	if ((count _this) > 1) then {_startpos = _this select 1};
	_crew =[];
	_targetpos=[0,0];
	_timeout = 0;
	_landing = false;
	
	sleep 0.05;	
	if (!alive _heli  || !canmove _heli ) exitwith{};
	_crew = crew _heli;
	_npc = leader (_crew select 0);	
	
	//Checks hely is already landing
	_landing = _heli getVariable "UPSMON_landing";	
	if (isnil ("_landing")) then {_landing=false; _heli setVariable ["UPSMON_landing", false, false];};
	if (_landing) exitwith {};
	
	//Orders to land heli	
	_heli land "GET OUT";
	if (KRON_UPS_Debug>0 ) then {player globalchat format["%1 is landing",typeof _heli];};
	
	//Puts a mark for knowing hely is landing
	_heli setVariable ["UPSMON_landing", true, false];	
	
	//Waits for land position	
	waituntil {!alive _heli || toUpper(landResult _heli) != "NOTREADY" };	
	if (alive _heli && (toUpper(landResult _heli) == "NOTFOUND")) exitwith { 
		if (KRON_UPS_Debug>0 ) then { player globalchat format["%1 no landing zone, doing paradrop",typeof _heli];};
		_heli setVariable ["UPSMON_landing", false, false];	
		[_heli] spawn MON_doparadrop;
	};		
	
	//1rt try-Waits until velocity and heigh are good for getting out
	_timeout = time + 160; 
	waituntil {!alive _heli || time > _timeout || ((abs(velocity _heli select 2)) <= 1 && ((position _heli) select 2) < 3)};
		
	//2nd try-Waits until velocity and heigh are good for getting out
	if (((position _heli) select 2) > 2 && ((position _heli) select 2) < 30 && !surfaceiswater position _heli) then { 		
		//_heli land "LAND";
		_heli land "GET OUT";
		_timeout = 120 + time;
		//waituntil {!alive _heli || time > _timeout || ( (abs(velocity _heli select 2)) <= 1 && ((position _heli) select 2) <= 0.7)};	
		  waituntil {!alive _heli || time > _timeout || ( (abs(velocity _heli select 2)) <= 1 && ((position _heli) select 2) <= 6)};	
		
		//Failed landing doing paradrop
		if ( ((position _heli) select 2) > 30) exitwith { 
			if (KRON_UPS_Debug>0 ) then { player globalchat format["%1 landing timeout, doing paradrop",typeof _heli];};
			_heli setVariable ["UPSMON_landing", false, false];	
			sleep 5;
			[_heli] spawn MON_doparadrop;
		};
	};	
	
	//Chechs if alive before continuing
	if (!alive _heli) exitwith{};
	

	//If there is pilot and gunner, get out only cargo
	if ((!isnull gunner _heli)  || (!isnull driver _heli)) then {
		_jumpers = [_heli] call R_FN_unitsInCargo;	
	} else {
		_jumpers = crew _heli;	
	};
	
	
	//dogetout each of _jumpers
	{
		_x spawn MON_doGetOut;	
		sleep 0.5;
	} forEach _jumpers;
	
	_timeout = 20 + time;
	
	//Waits until all getout of heli
	{
		waituntil {vehicle _x == _x || !canmove _x || !alive _x || movetofailed _x  || time > _timeout };
		_x switchMove "AmovPercMstpSrasWrflDnon";
	} forEach _jumpers;
	
	sleep 1;
	_heli land "NONE";
	sleep 1;
	//[_heli,3000] spawn MON_domove;
	[(driver _heli)] join grpNull; 
	_heli doMove _startpos; 
	
	// If leader alive sets combat mode							
	if (alive _npc && canmove _npc) then {	
		//Gets nearest known enemy for putting in combat mode
		_NearestEnemy = _npc findNearestEnemy _npc;
		if (!isnull _NearestEnemy ) then {
			_npc setBehaviour "AWARE"; 
			_groupOne = group _npc;
			_groupOne setFormation "DIAMOND";			
		};	
		
		//Moves to current target Position
		_grpid = _npc getvariable "UPSMON_grpid";
		if !(isnil "_grpid") then {
			_targetpos =(KRON_targetsPos select _grpid);
			_npc move _targetpos;
			if (KRON_UPS_Debug>0 ) then { player globalchat format["%1 landed, moving to %2 %3",_grpid,_targetpos,count KRON_targetsPos];};
		};			
	};
	
	//Quitamos el id al vehiculo para que pueda ser reutilizado
	_heli setVariable ["UPSMON_grpid", 0, false];	
	_heli setVariable ["UPSMON_cargo", [], false];	
	_heli setVariable ["UPSMON_landing", false, false];	
	
	//sleep 60;
	//_heli land "LAND";
	//_timeout = time + 120; 
	//waituntil {!alive _heli || time > _timeout || ((abs(velocity _heli select 2)) <= 1 && ((position _heli) select 2) <= 6)};
	//_crew = crew _heli; 
	//deleteVehicle _heli;
	//{deleteVehicle _x} foreach _crew; 
	
	// New code
	_timeout = time + 600; 
	waituntil {!alive _heli || time > _timeout || ((_heli distance _startpos) < 100)};
	_heli land "LAND";
	_timeout = 120 + time;
	waituntil {!alive _heli || time > _timeout || ( (abs(velocity _heli select 2)) <= 1 && ((position _heli) select 2) <= 1)};
	(driver _heli) action ["getOut",_heli];
	sleep 1;
	deletevehicle (driver _heli);
};

//Controls that heli not stoped flying
MON_HeliStuckcontrol = {
	private["_heli","_landing","_stuckcontrol","_dir1","_targetPos","_lastpos"];				
	_heli = _this select 0;
	
	_landing = false;
	_stuckcontrol = false;
	_targetPos=[0,0,0];
	_dir1 = 0;
	
	sleep 0.05;	
	if ( !alive _heli  || !canmove _heli ) exitwith{};
	
	//Checks stuckcontrol not active
	_stuckcontrol = _heli getVariable "UPSMON_stuckcontrol";
	if (isnil ("_stuckcontrol")) then {_stuckcontrol=false};	
	if (_stuckcontrol) exitwith {};
	
	_heli setVariable ["UPSMON_stuckcontrol", true, false];													
	//if (KRON_UPS_Debug>0 ) then {player globalchat format["%1 stuck control begins",typeof _heli];};
	
	//Stuck loop control
	while {(alive _heli) && (count crew _heli) > 0 } do {	
		sleep 5;		
		if ((abs(velocity _heli select 0)) <= 5 && (abs(velocity _heli select 1)) <= 5 && (abs(velocity _heli select 2)) <= 5 && ((position _heli) select 2) >= 30) then {
		
			_landing = _heli getVariable "UPSMON_landing";	
			if (isnil ("_landing")) then {_landing=false;};
			
			if (!_landing) then {		
				//moving hely for avoiding stuck
				[_heli,800] spawn MON_domove;					
				if (KRON_UPS_Debug>0 ) then {player GLOBALCHAT format["%1 stucked at %2m height, moving",typeof _heli,(position _heli) select 2];};
				sleep 25;			
			};			
		};
	};	
	//if (KRON_UPS_Debug>0 ) then {player globalchat format["%1 exits from stuck control",typeof _heli];};
	_heli setVariable ["UPSMON_stuckcontrol", false, false];
};

//Function that checks is gunner is alive, if not moves a cargo
MON_Gunnercontrol = {
	private["_vehicle","_gunnercontrol","_hasgunner","_crew","_crew2"];				
	_vehicle = _this select 0;

	_targetPos=[0,0,0];
	_dir1 = 0;
	_gunnercontrol = false;
	_hasgunner = (_vehicle) emptyPositions "Gunner" > 0 || !isnull gunner _vehicle; 
	_crew = [];
	_crew2 = []; //Without driver and gunner
	
	sleep 0.05;	
	if ( !alive _vehicle  || !canmove _vehicle ) exitwith{};
	
	//Checks stuckcontrol not active
	_gunnercontrol = _vehicle getVariable "UPSMON_gunnercontrol";
	if (isnil ("_gunnercontrol")) then {_gunnercontrol=false};	
	if (_gunnercontrol) exitwith {};
	
	_vehicle setVariable ["UPSMON_gunnercontrol", true, false];													
	
	_crew = crew _vehicle;
	//gunner and driver loop control
	while {	alive _vehicle && canmove _vehicle && count _crew > 0} do {
		_crew = crew _vehicle;
		{
			if (!canmove _x || !alive _x) then {_crew = _crew -[_x];};
		}foreach _crew;
		
		//Driver control	
		if ((isnull (driver _vehicle) || !alive (driver _vehicle) || !canmove (driver _vehicle)) && count _crew > 0) then {
			_crew2 = _crew - [gunner _vehicle];
			if (count _crew2 > 0) then {
				(_crew2 select (count _crew2 - 1)) spawn MON_movetodriver;
			};
		};	
		
		//Gunner control	
		if ( _hasgunner && (isnull (gunner _vehicle) || !alive (gunner _vehicle) || !canmove (gunner _vehicle)) && count _crew > 1) then {
			_crew2 = _crew - [driver _vehicle];
			if (count _crew2 > 0) then {
				(_crew2 select (count _crew2 - 1)) spawn MON_movetogunner;
			}else{
				(_crew select 0) spawn MON_movetogunner;
			};
		};
		sleep 20;		
		//if (KRON_UPS_Debug>0 ) then {player globalchat format["%1 crew=%2",typeof _vehicle, count _crew];};		
	};	
	//if (KRON_UPS_Debug>0 ) then {player globalchat format["%1 exits from gunner control",typeof _vehicle];};
	_vehicle setVariable ["UPSMON_gunnercontrol", false, false];
};

///////////////////////////////////////// helicopter Module ////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// Ambush Module //////////////////////////////////////////////////////////////

//Function to put a mine
//Par�meters: [_npc,(_position)]
//	<-	 _npc: leader
// 	<-	 _position:location for mine (optional)
MON_CreateMine = {
	private ["_npc","_rnd","_soldier","_mine","_dir","_position"];
	_position = [0,0];
	_minetype = "ATMine";
	
	_soldier = _this select 0;
	
	//if (KRON_UPS_Debug>0) then { diag_log format ["sol: %1",_soldier]; }; 
	
	 if ((count _this) > 1) then {_position = _this select 1;};
	 if ((count _this) > 2) then {_minetype = _this select 2;};
	 
	_mine = objnull;
	_rnd = 0;
	_dir = 0;
	_mineposee = false;
	
	
	//leader only control not work
	//Si est� en un vehiculo ignoramos la orden
	if (isnil "_soldier") exitWith {};
	if (!(_soldier iskindof "Man" ) || _soldier != vehicle _soldier || !alive _soldier || !canstand _soldier) exitwith {false};		
	_soldier enableAI "MOVE";
	_soldier setUnitPos "UP";
	//Animaci�n para montar el arma
	if ((count _this) > 1) then {
		_mineposee = [_soldier,_position,_minetype] call MON_doCreateMine;
		if (KRON_UPS_Debug>0) then { diag_log format ["UPSMON 'MON_CreateMine': sol: %1 - pos: %2",_soldier, _position]; }; 
	}else{
		_mineposee = [_soldier] call MON_doCreateMine;
		if (KRON_UPS_Debug>0) then { diag_log format ["UPSMON 'MON_CreateMine': sol: %1",_soldier]; }; 
	};
	
	waituntil {_mineposee || !alive _soldier || !canstand _soldier};
	If (_mineposee) exitwith 
	{
	true;
	};
	false;
};

MON_doCreateMine = {
	private ["_npc","_rnd","_soldier","_mine","_dir","_position"];
	_position = [0,0];
	_minetype = "ATMine";
	 
	_soldier = _this select 0;
	if (isnil "_soldier") exitWith {false;}; 
	if ((count _this) > 1) then {_position = _this select 1;};
	if ((count _this) > 2) then {_minetype = _this select 2;};
	

	//If not is Man or dead exit
	if (!(_soldier iskindof "Man" ) || _soldier != vehicle _soldier || !alive _soldier || !canstand _soldier) exitwith {false;};		
	
	
	
	if ((count _this) > 1) then {
		_soldier domove _position;
		if (! isnil "_soldier") then {
			waituntil {unitReady _soldier || moveToCompleted _soldier || moveToFailed _soldier || !alive _soldier || !canstand _soldier}};
	};

	if (moveToFailed _soldier || !alive _soldier || _soldier != vehicle _soldier || !canmove _soldier) exitwith {false;};	

	//Crouche
	//_soldier playMove "ainvpknlmstpslaywrfldnon_1";

	sleep 1;
	if (isnil "_soldier") exitWith {false;}; 
	if (!alive _soldier || !canstand _soldier) exitwith {false;};

	
	_dir = getdir _soldier;	
	_position = [position _soldier,_dir, 0.5] call MON_GetPos2D;
	if (_minetype == "ATMine") then
	{
		_mine = createMine [_minetype, _position , [], 0];
		(side _soldier) revealMine _Mine;
	}
	else
	{
		[_position,_soldier,_minetype] spawn 
		{
			_position = _this select 0;
			_soldier = _this select 1;
			_minetype = _this select 2;
			waituntil {_position distance _soldier > 20}; 
			_mine = createMine [_minetype, _position , [], 0];
			(side _soldier) revealMine _Mine;
		};
	};
	//Prepare mine
	//_soldier playMoveNow "AinvPknlMstpSlayWrflDnon_medic";
	sleep 1;
	
	//Return to formation
	if (isnil "_soldier") exitWith {true;}; 
	
	true;
};

////////////////////////////////////////////////////// Ambush Module //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

//Function to surrender AI soldier
//Par�meters: [_npc]
//	<-	 _npc: soldier to surrender
MON_surrender = {
	private ["_npc","_vehicle"];
	_npc = _this select 0;

	if (!alive _npc || !canmove _npc) exitwith {};
	
	_npc addrating -1000;
	_npc setcaptive true;	
	sleep 0.5;
	
	_vehicle = vehicle _npc;
	
	if ( _npc != _vehicle || !(_npc iskindof "Man" )) then {		
		_vehicle setcaptive true;	
		
		if ( "Air" countType [_vehicle]>0) then {											
			
			//Si acaba de entrar en el heli se define punto de aterrizaje
			if (_npc == driver _vehicle ) then { 
				[_vehicle] call MON_landHely;							
			};				
		} else {			
			_npc spawn MON_doGetOut;			
		};	
		
		//Esperamos a que est� parado		
		waituntil {_npc == vehicle _npc || !alive _npc};
	};	
	
	if (!alive _npc || !canmove _npc) exitwith {};
	_npc setcaptive true;
	_npc stop true;

	[_npc,"UP"] call MON_setUnitPos;	
	removeAllWeapons _npc;	
	sleep 1;
	_npc playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";

};

//Returns leader if was dead
MON_getleader = {
	private ["_npc","_members"];
	
	_npc = _this select 0;	
	_members = _this select 1;	
	
	//sleep 0.05;
	if (!alive _npc ) then 
	{	
		KRON_NPCs = KRON_NPCs - [_npc];
		If (_npc in KRON_GRPINNEED) then {KRON_GRPINNEED - [_npc]};
		//soldier not in vehicle takes the lead or not in tank vehicle
		{
			if (alive _x && { canmove _x } && { _x == vehicle _x || vehicle _x iskindof "TANK" || vehicle _x iskindof "Wheeled_APC"} && { !isplayer _x } ) exitwith 
			{				
				_npc = _x;				
			};			
		} foreach _members;					
		
		//if no soldier out of vehicle takes any
		if (!alive _npc ) then 
		{
			{
				if (alive _x && canmove _x) exitwith {_npc = _x;};
			} foreach _members;	
		};

		//If not alive or already leader or is player exits
		if (isPlayer _npc || !alive _npc || !canmove _npc ) then 
		{
			{
				if (alive _x && !isPlayer _x) exitwith {_npc = [_npc, _members] call MON_getleader;};
			} foreach _members;				
		};	

		if (leader _npc == _npc) exitwith {_npc};			
		
		//Set new _npc as leader		
		group _npc selectLeader _npc;					
	};	
	_npc // return		
};				


MON_ACE_Watersurvival = {
	private ["_lb","_pos","_ejector","_in","_grpid","_rnd"];
	_in =[];
	_rnd = 0;
	_ejector = _this select 0;
	//if (KRON_UPS_Debug>0) then {player globalchat format["MON_ACE_Watersurvival %1",typeof _ejector]};							
	
	waitUntil { !canmove _ejector || !alive _ejector || isnull (_ejector) || ((getPos vehicle _ejector) select 2 < 1) };
	if ( !surfaceIsWater (getpos _ejector) || !canmove _ejector || !alive _ejector || isnull (_ejector) ) exitWith {};
	
	//Miramos de entrar en un barco cercano
	_grpid = _ejector getvariable "UPSMON_grpid";
	if (isnil "_grpid") then {_grpid = 0};		
	_in = [_grpid,_ejector,30] call MON_GetIn_NearestBoat;
	
	//If no boat near creates a zodiac	
	if (count _in <= 0) then {
		if (!(isNil "ace_main")) then {
			_lb = "ACE_Lifeboat_US" createVehicle getposASL _ejector;
		}else{
			_lb = "B_Lifeboat" createVehicle getposASL _ejector;		
		};
		_pos = getposASL _ejector;
		_pos set [0, ((_pos select 0) + 2)];
		_pos set [1, ((_pos select 1) + 2)];
		//_pos set [2, 0];
		_lb setPos _pos;
		
		//Moves in boat
		if !(isPlayer _ejector) then {
			[_ejector,_lb,0] call MON_assignasdriver;						
		};				
	};

	//Wait until reached eart
	waitUntil { !canmove _ejector || !alive _ejector || isnull (_ejector) || !surfaceIsWater (position _ejector) };	
	if (KRON_UPS_Debug>0) then {player globalchat format["Exit from boat%1",typeof _lb]};	
	_ejector spawn MON_dogetout;
};	



//Funci�n que devuelve un array con los vehiculos terrestres m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_deadbodies = {
		private["_vehicles","_npc","_bodies","_OCercanos","_distance","_side"];	
					
	_npc = _this select 0;	
	_distance = _this select 1;					
	//_side = _this select 2;	
		
		_OCercanos = [];
		_bodies = [];
		
		//Buscamos objetos cercanos
		_OCercanos = nearestObjects [_npc, ["Man"] , _distance];
			
		{			
			if (_npc knowsabout _x >0.5 && (!canmove _x || !alive _x)) then { _bodies = _bodies + [_x];};
		}foreach _OCercanos;
		
		_bodies;
	};	

//Funci�n que devuelve un array con los vehiculos terrestres m�s cercanos
//Par�meters: [_npc,_distance]
//	<-	_npc: object for  position search
//	<-	_distance:  max distance from npc
//	->	_vehicles:  array of vehicles
MON_nearestSoldiers = {
	private["_vehicles","_npc","_soldiers","_OCercanos","_distance","_side"];	
				
	_npc = _this select 0;	
	_distance = _this select 1;					
	
	if (isnull _npc) exitwith {};
	
	_OCercanos = [];
	_soldiers = [];
	
	//Buscamos objetos cercanos
	_OCercanos = _npc nearentities ["Man" , _distance];					
	_OCercanos = _OCercanos - [_npc];			
	
	{			
		if (canmove _x ) then { _soldiers = _soldiers + [_x];};
	}foreach _OCercanos;
	
	_soldiers;
};

/////////////////////////////////////
// ArmA 3 MP object init functions
KRON_fnc_setVehicleInit = {
	private ["_netID","_unit","_unitinit"];
	
	_netID = _this select 0;
	_unit = objectFromNetID _netID;
	_unitinit = _this select 1;
	
	_unit call compile format ["%1",_unitinit];
	
	if (KRON_UPS_Debug>0) then { diag_log format ["UPSMON 'KRON_fnc_setVehicleInit': %1",_unitinit]; };
};


KRON_fnc_setVehicleVarName = {
	private ["_netID","_unit","_unitname"];
	
	_netID = _this select 0;
	_unit = objectFromNetID _netID;
	_unitname = _this select 1;
	
	_unit setVehicleVarName _unitname;
	_unit call compile format ["%1=_This; PublicVariable ""%1""",_unitname];
	
	if (KRON_UPS_Debug>0) then { diag_log format ["UPSMON 'KRON_fnc_setVehicleVarName': %1=_This; PublicVariable ""%1""",_unitname]; };
};


	