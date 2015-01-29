
private ["_npc","_target","_newtarget","_targetdist","_reinforcementsent","_fixedtargetPos","_react","_lastreact","_minreact","_timeontarget","_waiting","_wait","_timeout","_cycle","_currcycle","_newpos","_sokilled","_sowounded","_gothit","_Supstate","_fortify","_buildingdist","_exit","_surrender","_surrended","_alliednear","_enynear","_dist","_dist2"];
private ["_Arrayofnearestunit","_nbrwoundedunit","_pursue","_defend","_linkactivate","_isman","_incar","_inheli","_inboat","_isdiver","_targetPos","_swimming","_opfknowval","_targetsnear","_attackPos","_targetdead","_flankdir","_fightmode","_newattackPos","_GetOutDist","_flyInHeight","_cargo","_landing"];
private ["_dir1","_mineposition","_roads","_wptype","_rstuckControl","_lastwptype","_makenewtarget","_nowpType","_ambushwait","_ambushdir","_ambushdist","_linkdistance","_Mines","_Minestype","_members","_membertypes","_vehicletypes","_pause","_nomove","_onroad","_nosmoke","_noveh","_noveh2","_nowp","_linked","_RadioRange","_nofollow","_shareinfo","_noslow","_rfid","_rfidcalled","_nbrwoundedunit"];


_npc = _this select 0;
_Ucthis = _this select 1;
_members = _this select 2;
_membertypes = _this select 3;
_vehicletypes = _this select 4;
_grpidx = _this select 5;
_areamarker = _this select 6;
_centerpos = _this select 7;

_grpname = format["%1_%2",(side _npc),_grpidx];
_side = side _npc;

// remember the original mode & speed
_orgMode = "SAFE";
_orgSpeed = speedmode _npc;
_behaviour = _orgMode;
_speedmode=_orgSpeed;

// set first target to current position (so we'll generate a new one right away)
_currPos = getpos _npc;
_orgPos = _currPos;
_orgDir = getDir _npc;
_orgWatch=[_currPos,50,_orgDir] call KRON_relPos; 
_lastpos = _currPos;

_rfid = 0;
_rfidcalled = false;
_nowpType = 1;
_ambushwait = 10000;
_ambushdir = "";
_ambushType = 1;
_ambushdist = KRON_UPS_ambushdist;
_linkdistance = 100;
_Mines = 3;
_Minestype = 1;
_RadioRange = 10000;

_surrender = 0;
_retreat = 0;
_fortify = false;
_buildingdist = 25;

_target = ObjNull;
_newtarget=objnull;
_targetdist = 1000;
_makenewtarget=true;
_fixedtargetPos=[0,0];
_reinforcementsent = false;

_react = 0;
_lastreact = KRON_UPS_minreact;
_minreact = KRON_UPS_minreact;

_timeontarget = 0;
_waiting = 0;
_wait=90;
_timeout = 0;
_cycle = KRON_UPS_Cycle;
_currcycle = _cycle;
_newpos = false;
_index = 0;

_exit = false;

_surrended = false;
_supressed = false;
_alliednear = 0;
_enynear = 0;
_dist = 0;
_dist2 = 0;
_GetOutDist = 0;
_unitsIn = [];

_wp=[];
_wptype="HOLD";
_lastwptype = "";
_wpformation = "VEE";
_rstuckControl = 0;
_flyInHeight = 0;
_cargo = [];
_landing=false;
_safemode=["CARELESS","SAFE"];

_opfknowval = 0;
_lastknown = 0;
_targetsnear = false;
_attackPos 	= [0,0];
_targetdead = false;
_flankdir = 0;
_fightmode = "WALK";
_newattackPos = [0,0];
_fm = 0;

_dir1 = 0;
_mineposition = [0,0];
_roads = [];
_wptype = "MOVE";
_pursue= false;
_waiting = 0;

_fortifyorig= false;
_attackPos = [0,0];
_rlastPos = [0,0,0];
_currpos = getpos _npc;
_lastcurrpos = [0,0,0];
_positiontoambush = [0,0,0];
_targettext ="currPos";
_swimming = false;
_deadBodiesreact = R_deadBodiesReact; 
_nbrwoundedunit =0;
_closeenough = KRON_UPS_closeenough;
_closenoughV = KRON_UPS_closeenoughV;
_ambushed = false;

_grpid = _npc getvariable "UPSMON_grpid";
	
//Sets min units alive for surrender
if !( _side == civilian ) then 
{ 
	_surrender = call (compile format ["KRON_UPS_%1_SURRENDER",_side]); 
	_retreat = call (compile format ["KRON_UPS_%1_SURRENDER",_side]); 
};

// wait at patrol end points
_pause = if ("NOWAIT" in _UCthis) then {_pause = "NOWAIT"} else {"WAIT"};
_nomove  = if ("NOMOVE" in _UCthis) then {"NOMOVE"} else {"MOVE"};
	
//fortify group in near places
_fortify= if ("FORTIFY" in _UCthis) then {true} else {false};
if (_fortify) then 
{
	_nomove = "NOMOVE";
	_minreact = KRON_UPS_minreact * 3;
	_buildingdist = _buildingdist * 2;
	_wait = 9999;								
};	
	
// create _targerpoint on the roads only (by this group)
_onroad = if ("ONROAD" in _UCthis) then {true} else {false};
// do not use smoke (by this group)
_nosmoke = if ("NOSMOKE" in _UCthis) then {true} else {false};
// do not search for vehicles (unless in fight and combat vehicles)
_noveh = if ("NOVEH" in _UCthis || "NOVEH2" in _UCthis) then {true} else {false};	
_noveh2 = if ("NOVEH2" in _UCthis) then {true} else {false};	// Ajout
	
// don't make waypoints
_nowp = if ("NOWP" in _UCthis || "NOWP2" in _UCthis || "NOWP3" in _UCthis) then {true} else {false};
_nowpType = if ("NOWP2" in _UCthis) then {2} else {_nowpType}; _nowpType = if ("NOWP3" in _UCthis) then {3} else {_nowpType};
	
//Ambush squad will no move until in combat or so close enemy
_ambush= if (("AMBUSH" in _UCthis) || ("AMBUSHDIR:" in _UCthis) || ("AMBUSH2" in _UCthis) || ("AMBUSHDIR2:" in _UCthis)) then {true} else {false};
_ambushwait = ["AMBUSH:",_ambushwait,_UCthis] call KRON_UPSgetArg; _ambushwait = ["AMBUSH2:",_ambushwait,_UCthis] call KRON_UPSgetArg;
_ambushdir = ["AMBUSHDIR:",_ambushdir,_UCthis] call KRON_UPSgetArg;_ambushdir = ["AMBUSHDIR2:",_ambushdir,_UCthis] call KRON_UPSgetArg;
_ambushType = if ("AMBUSH2" in _UCthis) then {2} else {_ambushType};_ambushType = if ("AMBUSHDIR2:" in _UCthis) then {2} else {_ambushType};_ambushType = if ("AMBUSH2:" in _UCthis) then {2} else {_ambushType};
if ("AMBUSHDIST:" in _UCthis) then {_ambushdist = ["AMBUSHDIST:",_ambushdist,_UCthis] call KRON_UPSgetArg;} else {_ambushdist = 100}; 
	
_linked = if ("LINKED:" in _UCthis) then {true} else {false};
_linkdistance = ["LINKED:",_linkdistance,_UCthis] call KRON_UPSgetArg;
	
// Mine Parameter (for ambush)	
if ("MINE:" in _UCthis) then {_Mines = ["MINE:",_Mines,_UCthis] call KRON_UPSgetArg;}; // ajout
if ("MINEtype:" in _UCthis) then {_Minestype = ["MINEtype:",_Minestype,_UCthis] call KRON_UPSgetArg;}; // ajout
	
// Range of AI radio so AI can call Arty or Reinforcement
if ("RADIORANGE:" in _UCthis) then {_RadioRange = ["RADIORANGE:",_RadioRange,_UCthis] call KRON_UPSgetArg;}; // ajout
	
	
// don't follow outside of marker area
_nofollow = if ("NOFOLLOW" in _UCthis) then {"NOFOLLOW"} else {"FOLLOW"};
// share enemy info 
_shareinfo = if ("NOSHARE" in _UCthis) then {"NOSHARE"} else {"SHARE"};
	
// suppress fight behaviour
if ("NOAI" in _UCthis) then {_isSoldier=false};
	
// set behaviour modes (or not)
if ("CARELESS" in _UCthis) then {_orgMode = "CARELESS"}; 
if ("SAFE" in _UCthis) then {_orgMode = "SAFE"};
if ("AWARE" in _UCthis) then {_orgMode = "AWARE"}; 
if ("COMBAT" in _UCthis) then {_orgMode = "COMBAT"}; 
if ("STEALTH" in _UCthis) then {_orgMode = "STEALTH"}; 
	
// set initial speed
_noslow = if ("NOSLOW" in _UCthis) then {"NOSLOW"} else {"SLOW"};
if (_noslow!="NOSLOW") then {
	_orgSpeed = "limited";
} else {	
	_orgSpeed = "FULL";	
}; 
	
// set If enemy detected reinforcements will be sent REIN1
_reinforcement= if ("REINFORCEMENT" in _UCthis) then {"REINFORCEMENT"} else {"NOREINFORCEMENT"}; //rein_yes
If (_reinforcement == "REINFORCEMENT") then {{_x setvariable ["UPS_REINFORCEMENT",true]; _x setvariable ["UPS_PosToRenf",[0,0]];} foreach units _npc;};
_rfid = ["REINFORCEMENT:",0,_UCthis] call KRON_UPSgetArg; // rein_#

if (_rfid>0) then {
	_reinforcement="REINFORCEMENT";
	if (KRON_UPS_Debug>0) then {hintsilent format["%1: reinforcement group %2",_grpidx,_rfid,_rfidcalled,_reinforcement]}; 	
};

// set target tolerance high for choppers & planes
if ("Air" countType [vehicle _npc]>0) then {_closeenough = KRON_UPS_closeenough * 2};




//If a soldier has a useful building takes about ======================================================================================================================		
	if ( _nomove=="NOMOVE") then {			
			sleep 1;
			_unitsIn = [_grpid,_npc,150] call MON_GetIn_NearestStatic;		
			if ( count _unitsIn > 0 ) then { sleep 10};
			[_npc,_buildingdist,false,_wait,true] spawn MON_moveNearestBuildings;
		};
		
// init done
	_waiting = if (_nomove=="NOMOVE") then {9999} else {0};
	_sharedist = if (_nomove=="NOMOVE") then {KRON_UPS_sharedist} else {KRON_UPS_sharedist*1.5};
	_newpos = false;
	_targetPos = [0,0,0];//_currPos;
	_targettext ="_currPos";
	_swimming = false;
	_npc setbehaviour _Behaviour;
	_npc setspeedmode _speedmode;
	
//Gets position of waypoint if no targetpos
	if (format ["%1", _targetPos] == "[0,0,0]") then {
		_index = (count waypoints _grp) - 1;	
		_wp = [_grp,_index];
		_targetPos = waypointPosition _wp;
		if (([_currpos,_targetPos] call KRON_distancePosSqr)<= 20) then {_targetPos = [0,0,0];};
	};

	
// ***********************************************************************************************************
// ************************************************ MAIN LOOP ************************************************
// ***********************************************************************************************************	
_loop=true;

scopeName "main"; 
	
while {_loop} do 
{

	//if (KRON_UPS_Debug>0) then {player sidechat format["%1: _cycle=%2 _currcycle=%3 _react=%4 _waiting=%5",_grpidx,_cycle,_currcycle,_react,_waiting]}; 
	
	 if ( isNil "_react" ) then { diag_log str [_react, _currcycle]; _cycle = KRON_UPS_Cycle; };
	_timeontarget = _timeontarget + _currcycle;
	_react= _react + _currcycle;	
	_waiting = _waiting - _currcycle;
	_lastreact = _lastreact + _currcycle;
	_newpos = false;			

//========================= Marker caracteristics =================================================
	_areamarker = _Ucthis select 1;
	
	// remember center position of area marker
	_centerpos = getMarkerPos _areamarker;
	_centerX = abs(_centerpos select 0);
	_centerY = abs(_centerpos select 1);
	_centerpos = [_centerX,_centerY];
	
	// X/Y range of target area
	_areasize = getMarkerSize _areamarker;
	_rangeX = _areasize select 0;
	_rangeY = _areasize select 1;
	_area = abs((_rangeX * _rangeY) ^ 0.5);
	// marker orientation (needed as negative value!)
	_areadir = (markerDir _areamarker) * -1;
	
//===================================================================================================
	
	_sokilled = false;
	_sowounded = false;
	_gothit = false;
	_Supstate = random 100 < 40;
	

	// did the leader die?
	_npc = [_npc,_members] call MON_getleader;							
	if (!alive _npc || !canmove _npc || isplayer _npc ) then {_exit=true;};
	
	// EXIT FROM LOOP =======================================================================================================
	// nobody left alive, exit routine
	if (count units _npc == 0) then 
	{
		_exit=true;
	}; 
	
	//exits from loop
	if (_exit) exitwith {_loop = false; [_Ucthis,_target,_orgpos,_surrended,_closeenough,_membertypes,_vehicletypes,_grpidx] call UPS_Respawn;};
	
	
	//Checks if surrender is enabled
	If ( KRON_UPS_SURRENDER 
		&& { !(isNull _target) } 
		&& { alive _target } 
		&& { _gothit } 
		&& { _npc == vehicle (_npc) } 
		&& { alive _npc } 
		&& { morale _npc < -1.1 } 
		&& { ((random 100) <= _surrender)} 
	   ) then
	{
		_Arrayofnearestunit = [_npc,180] call Aze_checkallied;
		_alliednear = count (_Arrayofnearestunit select 0);
		_enynear = count (_Arrayofnearestunit select 1);
		
		If (_target distance _npc < 150 && _alliednear < _enynear) then {
		
			// _surrended = call (compile format ["KRON_UPS_%1_SURRENDED",_side]);
			_surrended = true;
		};		
	};
	
	//If surrended exits from script
	if (_surrended) exitwith {	
		{
			[_x] spawn MON_surrender;
		}foreach units group _npc;
		
		if (KRON_UPS_Debug>0) then {_npc globalchat format["%1: %2 SURRENDED",_grpidx,_side]};		
	};

	//=============================================================================================================================	
	
	//Assign the current leader of the group in the array of group leaders
	// KRON_NPCs set [_grpid,_npc];
	If (!(_npc in KRON_NPCs)) then {KRON_NPCs = KRON_NPCs + [_npc];};

	// current position
	_currPos = getpos _npc; _currX = _currPos select 0; _currY = _currPos select 1;
	
	
	// Variable check if Unit is HIT / WOUNDED / KILLED ===========================================================================
	// CHECK IF did anybody in the group got hit or die? 
	
	If (isNil "tpwcas_running") then 
	{
		If (isNil "bdetect_enable") then
		{ 
		if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY) then
		{
			_gothit = true;
			If (_Supstate) then {_supressed = true} else {_supressed = false};
			if (group _npc in R_GOTHIT_ARRAY) then
			{
				_sowounded = true;
				_nbrwoundedunit = 0;
				{
					If (lifestate _x == "INJURED") then {_nbrwoundedunit = _nbrwoundedunit +1;};
				}Foreach units _npc;
			}
			else
			{
				_sokilled = true;
				R_GOTKILL_ARRAY = R_GOTKILL_ARRAY - [group _npc];
			};
			R_GOTHIT_ARRAY = R_GOTHIT_ARRAY - [group _npc];
		};
		}
		else
		{
			_Supstate = _npc getVariable ["bcombat_suppression_level", 0];
			if (_Supstate >= 20) then
			{
				_gothit = true;
				_Supstate = [_npc] call Aze_supstatestatus;
				If (_Supstate >= 75) then {_supressed = true} else {_supressed = false};
			};
		
			if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY) then
			{
				_gothit = true;
			
				if (group _npc in R_GOTHIT_ARRAY) then
				{
					_sowounded = true;
					_nbrwoundedunit = 0;
					{
						If (lifestate _x == "INJURED") then {_nbrwoundedunit = _nbrwoundedunit +1;};
					}Foreach units _npc;
				}
				else
				{
					_sokilled = true;
					R_GOTKILL_ARRAY = R_GOTKILL_ARRAY - [group _npc];
				};
				R_GOTHIT_ARRAY = R_GOTHIT_ARRAY - [group _npc];
			};
		};
			
	} 
	else 
	{
		_Supstate = [_npc] call Aze_supstatestatus; 
		if (_Supstate >= 2) then
		{
			_gothit = true;
			_Supstate = [_npc] call Aze_supstatestatus;
			If (_Supstate == 3) then {_supressed = true} else {_supressed = false};
		};
		
		if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY) then
		{
			_gothit = true;
			_Supstate = [_npc] call Aze_supstatestatus;
			If (_Supstate == 3) then {_supressed = true} else {_supressed = false};
			
			if (group _npc in R_GOTHIT_ARRAY) then
			{
				_sowounded = true;
				_nbrwoundedunit = 0;
				{
					If (lifestate _x == "INJURED") then {_nbrwoundedunit = _nbrwoundedunit +1;};
				}Foreach units _npc;
			}
			else
			{
				_sokilled = true;
				R_GOTKILL_ARRAY = R_GOTKILL_ARRAY - [group _npc];
			};
			R_GOTHIT_ARRAY = R_GOTHIT_ARRAY - [group _npc];
		};
	};	
	
	
	
	// if the AI is a civilian we don't have to bother checking for enemy encounters
	if ( _isSoldier && !_exit && _side != civilian) then 
	{
		_pursue=false;
		_defend = false;
		_linkactivate = false;
				
		//Variables to see if the leader is in a vehicle
		_isman = "Man" countType [ vehicle _npc]>0;
		_incar = "LandVehicle" countType [vehicle (_npc)]>0;
		_inheli = "Air" countType [vehicle (_npc)]>0;
		_inboat = "Ship" countType [vehicle (_npc)]>0;
		_isdiver = ["diver", (typeOf (leader _npc))] call BIS_fnc_inString;

		//=====================================================================================================
		// REFINFORCEMENT = true
		//=====================================================================================================	
		
		//If the group is strengthened and the enemies have been detected are sent to target
		if (_rfid > 0 ) then 
		{
			_rfidcalled = call (compile format ["KRON_UPS_reinforcement%1",_rfid]); // will be TRUE when variable in triger will be true.
			if (isnil "_rfidcalled") then {_rfidcalled=false};	
			_fixedtargetPos = call (compile format ["KRON_UPS_reinforcement%1_pos",_rfid]); // will be position os setfix target of sending reinforcement
			if (isnil "_fixedtargetPos") then {
				_fixedtargetPos=[0,0];
			}else{
				_fixedtargetPos =  [abs(_fixedtargetPos select 0),abs(_fixedtargetPos select 1)];			
				_target = objnull;
			};															
		};
		sleep .01;
		
		//Reinforcement control
		if (_reinforcement=="REINFORCEMENT") then {
			// (global call  OR id call) AND !send yet
			if ( (KRON_UPS_reinforcement || _rfidcalled) && (!_reinforcementsent)) then {				
				_reinforcementsent=true;
				_fortify = false;
				_minreact = KRON_UPS_minreact;
				_buildingdist = 60;			
				_react = _react + 100;		
				_waiting = -1;					
				if (_nowp) then {_nowp = false};
				_fixedtargetPos = _npc getvariable "UPS_PosToRenf";
				if (KRON_UPS_Debug>0) then {player sidechat format["%1 called for reinforcement %2",_grpidx,_fixedtargetPos]};	
			} else {
				// !(global or id call) AND send
				if ( (!KRON_UPS_reinforcement || !_rfidcalled) && (_reinforcementsent)) then {
					_fixedtargetPos = [0,0];
					_attackPos = [0,0];
					_fortify = _fortifyorig;
					_reinforcementsent=false;
					if (_rfid > 0 ) then {
						call (compile format ["KRON_UPS_reinforcement%1_pos = [0,0]",_rfid]);
						call (compile format ["KRON_UPS_reinforcement%1 = false",_rfid]);
					};
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 reinforcement canceled",_grpidx]};	
				};
			};
		};
		//----------- END REINFORCEMENT -------------
			
//*********************************************************************************************************************
// 											ACQUISITION OF TARGET 	
//*********************************************************************************************************************		
	if ( morale _npc > 1 && (_npc getvariable "UPS_CallRenf")) then {{_x setvariable ["UPS_CallRenf",false];} foreach units _npc;_reinforcementsent=false;};
	
	_lastknown = 0;
	_TargetSearch 	= [];
	_Enemies = [];
	
	_TargetSearch 	= [_npc,_shareinfo,_closeenough,_sharedenemy,_flankdir] call Aze_TargetAcquisition;
	_Enemies 		= _TargetSearch select 0;
	_target 		= _TargetSearch select 1;
	_dist 			= _TargetSearch select 2;
	_opfknowval 	= _TargetSearch select 3;
	_targetsnear 	= _TargetSearch select 4;
	_attackPos 		= _TargetSearch select 5;
	_timeontarget 	= _TargetSearch select 6;
	_targetdead 	= _TargetSearch select 7;
	_flankdir 		= _TargetSearch select 8;

	if (KRON_UPS_Debug>0) then {diag_log format ["NearestEnemy: %1 target:%2 dist:%3 opfknowval:%4 targetsnear:%5 attackPos:%6",_NearestEnemy,_target,_dist,_opfknowval,_targetsnear,_attackPos];};
	
	
////////////////////////////////////////// TARGET FOUND ////////////////////////////////////////////////////////////////
	
	//Gets  current known position of target and distance
		if ( !isNull (_target) && alive _target && !_ambush) then 
		{
			//Enemy detected
			if (_fightmode != "fight" ) then 
			{
				_fightmode = "fight";
				{_x setCombatMode "YELLOW";} foreach units _npc;
				_react = KRON_UPS_react;
				
				if (KRON_UPS_Debug>0) then {player sidechat format["%1: Enemy detected %2",_grpidx, typeof _target]}; 	
				
				if (_nowpType == 1) then {
					nul = [_npc] call R_FN_deleteObsoleteWaypoints;
					_nowp = false;
				};
			

				_newattackPos = _target getvariable ("UPSMON_lastknownpos");
			
				if ( !isnil "_newattackPos" ) then 
				{
					_attackPos=_newattackPos;	
					//Gets distance to target known pos
					_dist = ([_currpos,_attackPos] call KRON_distancePosSqr);	
					//Looks at target known pos
					_members lookat _attackPos;							 				
				};
			};

			//If use statics are enabled leader searches for static weapons near or fire artillery.
			// Tanks enemies are contabiliced
			
				_enemytanksnear = false;	
				{
					if ( ("Tank" countType [_x] > 0 || "Wheeled_APC" countType [_x] >0 
						|| "Tank" countType [vehicle _x] > 0 || "Wheeled_APC" countType [vehicle _x] >0 ) 
						&& alive _x && canMove _x && (_npc distance _x <= _closeenough + KRON_UPS_safedist && _npc distance _x >= _closeenough))
						exitwith { _enemytanksnear = true; _enemytanknear = _x;};																					
				} foreach _Enemies;
				
			
			if ( KRON_UPS_useMines && ("ATMine" in (magazines player)) && !_supressed && !_ambush) then 
			{
				
				//If use mines are enabled and enemy armors near and no friendly armor put mine.
				if ( _enemytanksnear && { !(isnull _enemytanknear) } && { alive _enemytanknear } ) then 
				{
					_friendlytanksnear = false;
					{
						if (!( alive _x && canMove _x)) then {_friendlytanks = _friendlytanks - [_x]};
						if (alive _x && canMove _x && _npc distance _x <= _closeenough + KRON_UPS_safedist ) exitwith { _friendlytanksnear = true;}; 
					}foreach _friendlytanks;

					// if group has no AT weapon make them hide
					
					
					if (!_friendlytanksnear && random(100)<30 ) then 
					{
						_dir1 = [_currPos,position _enemytanknear] call KRON_getDirPos;
						_mineposition = [position _npc,_dir1, 25] call MON_GetPos2D;	
						_roads = _mineposition nearroads 50;
						if (count _roads > 0) then {_mineposition = position (_roads select 0);};
						[_npc,_mineposition] call MON_CreateMine;													
					};				
				};
			};

			
	//////////// ARTI REACTION ///////////////////////////////////////////////////////////
		_artillerysideFire = call (compile format ["KRON_UPS_ARTILLERY_%1_FIRE",_side]);
		// If night and there no flare in the sky then launch flare	
		If (_artillerysideFire
			&& _RadioRange > 0
			&& KRON_UPS_Night 
			&& !(FlareInTheAir)
			&& !(_ambush) 
			&& !_supressed
			&& _npc knowsabout _target <= 2
		   ) then
		{
			_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);
	
			If (count _artillerysideunits > 0 ) then 
			{
					_arti = [_artillerysideunits,"FLARE",_RadioRange,_npc] call Aze_selectartillery;
					
					if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
					If !(IsNull _arti) then {
					[_arti,"FLARE",_target] spawn Aze_artilleryTarget;};
			};
		};
						
			
		If (_artillerysideFire
			&& _RadioRange > 0
			&& _enemytanksnear 
			&& !(isnull _enemytanknear)
			&& alive _enemytanknear
			&& ((speed _enemytanknear) <= 5)
			&& !(_ambush) 
			&& !_supressed
			&& _npc knowsabout _target > 2
			&& morale _npc > -0.5 
		   ) then
		{	
			_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);

			If (count _artillerysideunits > 0) then 
			{
					_arti = [_artillerysideunits,"HE",_RadioRange,_npc] call Aze_selectartillery;
					
					If !(IsNull _arti) then {
					[_arti,"HE",_enemytanknear] spawn Aze_artilleryTarget;};
				if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
				
			};
		};			

		// If the group is in inferiority call artillery
		_nbrTargets = [_npc,50,_target] call Aze_checkallied;
		_nbrTargets = count (_nbrTargets select 1);
	
		
		If (_artillerysideFire
			&& _RadioRange > 0
			&& ( _nbrTargets >= 4) 
			&& morale _npc > -0.5
			&& _gothit
			&& !(_ambush)
			&& _npc knowsabout _target > 2
			&& !_supressed ) then
		{
		_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);

			If (count _artillerysideunits > 0) then 
			{
					_arti = [_artillerysideunits,"HE",_RadioRange,_npc] call Aze_selectartillery;
					
					If !(IsNull _arti) then {
					[_arti,"HE",_target] spawn Aze_artilleryTarget;};
					if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
					
			};
		};
		
		
			If ((_supressed || morale _npc < -0.6 || count _members >= (count (units _npc)) - _nbrwoundedunit || _nbrTargets > (count units _npc) *2) && !_reinforcementsent) then 
			{
				_reinforcementsent=[_npc,_target,_radiorange] call Aze_Askrenf;
			};
			
			/////// Group supressed /////////
		
			if (_npc == vehicle (_npc) && (_supressed || morale _npc < -0.7) && _wptype != "HOLD") then
			{				
				if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: gothit: group %1 supressed by fire",_grpidx]};											
				
				//The unit is deleted, delete the current waypoint	
				_targettext ="SUPRESSED";
				_wptype = "HOLD";
				_currcycle = _currcycle + 10;
			
				
				//Prone
				{
					//Motion vanishes
					if ( _x iskindof "Man" && { canmove _x } && { alive _x } ) then 
					{																		
						if ( (random 100)<40 || (primaryWeapon _x ) in KRON_UPS_MG_WEAPONS ) then 
						{
							[_x,"Down",20] spawn MON_setUnitPosTime;			
						}
						else
						{
							[_x,"AUTO"] spawn MON_setUnitPos;
						};												
					};
					//sleep 0.01;
				} foreach units _npc;
				
												
				////// RETREAT ////////////

				If ( KRON_UPS_RETREAT 
				&& ((random 100)<= _retreat)
				&& (morale _npc < -0.7)
				&& !_supressed 
				&& !IsNull _target) then
				{
					_currcycle = _cycle;
					_flankdir = 0;
					_targettext = "avoidPos";
					if (_fortify) then {{_x enableAI "TARGET";} foreach units (group _npc);} else {(group _npc) enableAttack false;};;
					_targetpos = [_npc,_target,_AttackPos,_RadioRange] call Aze_WITHDRAW;
					
					if ((random 100) < 15 && { !_nosmoke } ) then 
					{	
						[_npc,_target] call MON_throw_grenade;
					};
				};				
			};	
				
	};
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// use smoke when hit or s/o killed	
	//If under attack or increasing knowledge speeds up the response and regain control of the AI
	if (_sowounded || _gothit || _sokilled) then 
	{ 
		if (!_supressed) then {_react = _react + 30};
		
		If (!IsNull _target && alive _target && !_fortify) then 
		{
			_waiting = -1;
			_pursue = true;
			_makenewtarget = false;
			
			If (_dist > (_closeenough * 2) || _sokilled) then 
			{
				_Behaviour =  "AWARE";	
				_speedmode = "NORMAL";				
				
				if (!_nosmoke && random 100 < R_USE_SMOKE_wounded && _sokilled && (morale _npc < 0) && isNil "bdetect_enable") then 
				{
					{
						If (alive _x && ( "SmokeShell" in (magazines _x))) then
						{
						_smoke = true;
						If (isNil "tpwcas_running" && _x getvariable "tpwcas_supstate" >= 2) then {_smoke = false;};
						If (_smoke) then {nul= [_x,_target] spawn MON_throw_grenade;};
						};
					} foreach units (group _npc);
				};		
			}
			else
			{
				_waiting = -1;				
				_pause="NOWAIT";				
				_speedmode = "FULL";						
				_Behaviour = "COMBAT";

				if (!_nosmoke && random 100 < R_USE_SMOKE_wounded && count _members >= (count (units _npc)) - _nbrwoundedunit && isNil "bdetect_enable") then 
				{
					{
						If (alive _x && ( "SmokeShell" in (magazines _x))) then
						{
							_smoke = true;
							If (isNil "tpwcas_running" && _x getvariable "tpwcas_supstate" >= 2) then {_smoke = false;};
							If (_smoke) then {nul= [_x,_target] spawn MON_throw_grenade;};
						};
					} foreach units (group _npc);
				};					
			};
		}
		else 
		{
							
			_pause="NOWAIT";				
			_speedmode = "FULL";						
			_Behaviour = "AWARE";
			_makenewtarget = true;

			if (!_nosmoke && random 100 < R_USE_SMOKE_wounded && count _members >= (count (units _npc)) - _nbrwoundedunit) then 
			{
				{
						If (alive _x && ("SmokeShell" in (magazines _x))) then
						{
							_smoke = true;
							If (isNil "tpwcas_running" && _x getvariable "tpwcas_supstate" >= 2) then {_smoke = false;};
							If (_smoke) then {_smokeposition = [getpos _x,getdir _x, (random 100) + 50] call MON_GetPos; nul= [_x,_smokeposition] spawn MON_throw_grenade;};							
						};					
					
				} foreach units (group _npc);
			};
		};
		
		if (_fightmode != "walk") then 
		{
			if (_nowpType != 3) then 
			{
				nul = [_npc] call R_FN_deleteObsoleteWaypoints;
				_nowp = false; 
			};
		};
	};	
	
		
		
		//If the enemy has moved away from the radio coverage is not a reinforcement sent we will have lost track
		if (!isnull(_target) 
		&& _dist < 15
		&& _fightmode != "walk"
		&& _npc knowsabout _target < R_knowsAboutEnemy) then 
		{			
			//If squad is near last position and no target clear position of target
			if (KRON_UPS_Debug>0) then {player sidechat format["%1: Target lost",_grpidx]}; 				
			_fightmode="walk";
			_speedmode = _orgSpeed;			
			_target = objnull;
			_Behaviour = _orgMode;					
			_waiting = -1;				
			_pursue=false;
			_targetdead	= true;
			_makenewtarget = true; //Go back to the original position
		};			
		
		//If knowledge of the target increases accelerate the reaction
		if (_opfknowval>_lastknown ) then 
		{
			_react = _react + 20;
		};	
		if (isnil "_react") then {_react = 60}; 
		
		// if spotted an enemy or got shot, so start pursuit, if in combat and exceed time to react or movecompleted
		if (!_ambush  
		&& (_fightmode != "walk")
		&& ((_react >= KRON_UPS_react && _lastreact >=_minreact) || moveToCompleted _npc)
		) then 
		{
			_pursue = true;
			
			If (_nomove == "NOMOVE"  || (count _members)/2 <= _nbrwoundedunit || _supressed || IsNull _target) then
			{
				_defend = true;
			}
			else
			{
				_defend = false;
			};
		};
		

		//If there is no objective order is canceled persecution
		//If captive or surrended do not pursue
		if ((isNull (_target) || !alive _target ) 
		//|| (_lastreact >=_minreact && { !_targetdead } ) 
		|| isnil "_attackPos" 
		|| captive _target 
		|| format ["%1", _attackPos] == "[0,0]"
		|| _targettext == "avoidPos") then 
		{
			_pursue=false;
		};		

		//If no fixed target check if current target is available
		if (format ["%1",_fixedtargetPos] != "[0,0]") then 
		{	
			//If fixed target check if close enough or near enemy and gothit
			if (([_currpos,_fixedtargetpos] call KRON_distancePosSqr) <= _closeenough || (_dist <= _closeenough && _gothit)) then 
			{		
				_fixedtargetPos = [0,0]; 
			} 
			else 
			{		
				_pursue = false;
				_attackPos=_fixedtargetPos;
				//if (_react >= KRON_UPS_react && _lastreact <=_minreact) then 
				//{
					_makenewtarget = true;
					_speed = "NORMAL";
				//};				
			};
		};	
		
		
			
		if (isnil "_react") then {_react = 0}; 
		
		//If in safe mode if find dead bodies change behaviour
		if ((_fightmode == "walk") && _deadBodiesReact)then 
		{
			_unitsin = [_npc,_buildingdist] call MON_deadbodies;
			//_firenear = _npc getvariable "UPS_hear" select 0;
			//|| _firenear
			if (count _unitsin > 0) then { 
				if (!_isSoldier) then {
					_npc setSpeedMode "FULL";					
				} else {
					if (!_gothit) then {
						_Behaviour =  "AWARE";
					} else {
						_Behaviour =  "COMBAT";
						_fightmode = "fight";
					};	
					_react = _react + 30;
					_currcycle = _cycle / 1.5;
					_npc setBehaviour _Behaviour;
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 dead bodies found! set %2",_grpidx,_Behaviour, count _targets]};	
				}; 
			};
		};

//**********************************************************************************************************************
// 										END ACQUISITION OF TARGET 	
//**********************************************************************************************************************	

		
		//Ambush ==========================================================================================================
		if (_ambush) then 
		{
		
			If (!_ambushed) then 
			{
				{_x setvariable ["UPS_AMBUSH",false]} foreach units _npc;
				_ambushed = true;
				_nowp = true;
				_currcycle = 2;		

				_positiontoambush = [_npc,_ambushdir,_ambushdist,_ambushType,_Mines] call Aze_SetAmbush;
			
				_pursue = false;
			};
				
			//Ambush enemy is nearly aproach
			//_ambushdist = 50;		
			// replaced _target by _NearestEnemy
		
			_gothit = [_npc] call Aze_GothitParam;
			If (_linked) then {{If (_npc distance _x <= _linkdistance && _x getvariable "UPS_AMBUSH" && side _x == _side) exitwith {_linkactivate = true};} foreach KRON_NPCs};
			
			If (_npc knowsabout _target >= 4) then {_ambushwait = _ambushwait - 1;};
			
			if ((_gothit  || _linkactivate || (_ambushwait <= 0))
			||((!isNull (_target) && "Air" countType [_target]<=0) && ((_target distance _npc <= KRON_UPS_ambushdist)||(_target distance _positiontoambush < 20)))) then
			{ 
				sleep ((random 1) + 1); // let the enemy then get in the area 
				
				if (KRON_UPS_Debug>0) then {diag_log format["%1: FIREEEEEEEEE!!! Gothit: %2 linkactivate: %3 Distance: %4 PositionToAmbush: %5 AmbushWait:%6",_grpidx,_gothit,_linkactivate,_target distance _npc <= KRON_UPS_ambushdist,_target distance _positiontoambush < 15,_ambushwait <= 0]};
				_currcycle = _cycle / 1.5;
			
				_npc setBehaviour "COMBAT";
				{_x setCombatMode "YELLOW";_x setvariable ["UPS_AMBUSH",true]} foreach units _npc;

				
				_nowp = false;		
				_ambush = false;				
				_linkactivate = false;
								
				//No engage yet
				_pursue = false;
			};
			
			//Sets distance to target
			_lastdist = _npc distance _NearestEnemy;			
		}; 
		
		//END Ambush ==========================================================================================================
			
		//if (KRON_UPS_Debug>0) then {player sidechat format["%1: _nowp=%2 in vehicle=%3 _inheli=%4 _npc=%5",_grpidx,_nowp,vehicle (_npc) ,_inheli,typeof _npc ]}; 	
		
		//If in vehicle take driver if not controlled by user
		if (alive _npc && !_nowp) then 
		{
			if (!_isman || (vehicle (_npc) != _npc && !_inboat && !(vehicle (_npc) iskindof "StaticWeapon"))) then { 						
				
				//If new target is close enough getout vehicle (not heli)	
				_unitsin = [];

				if (!_inheli) then { 						
					if (_fightmode == "walk") then {
						_GetOutDist =  _area / 20;
					}else{
						If (vehicle _npc iskindof "TANK" || vehicle _npc iskindof "Wheeled_APC_F") then
						{
							_GetOutDist =  _closeenough  * ((random .4) + 0.6);
						}
						else
						{
							_GetOutDist =  _closenoughV  * ((random .4) + 0.6);
						};
					};
					 
					  // ToDo check if obsolete
					_lastcurposcheck = false;
					if (!isnil "_lastcurrpos") then {
						if (_lastcurrpos select 0 == _currpos select 0 && _lastcurrpos select 1 == _currpos select 1 && moveToFailed (vehicle (_npc))) then {
							_lastcurposcheck = true;
						};
					};
					//-------------------------
					
					
					
					//If near target or stuck getout of vehicle and lock or gothit exits inmediately

					if 
					( 
						!canmove (vehicle (_npc))
						|| (_gothit && !(IsNull _target))
						|| { _dist <= _closeenough * 1.5 }
						|| { ( 
								_lastcurrpos select 0 == _currpos select 0
								&& { _lastcurrpos select 1 == _currpos select 1 } 
								&& { moveToFailed (vehicle (_npc)) } 
							  ) } 
						|| { moveToCompleted (vehicle (_npc)) }
					) 
					then 
					{
						_GetOutDist = 10000; // 2000
					};
					//if (KRON_UPS_Debug>0) then {player sidechat format["%1: vehicle=%2 _npc=%3",_grpidx,vehicle (_npc) ,typeof _npc ]};
					
					_unitsin = [_npc] call R_FN_allUnitsInCargo; // return units in cargo in all vehs used by the group
					
					private ["_handle1"];
					_handle1 = [_npc,_targetpos,_GetOutDist] spawn R_SN_GetOutDist;	// getout if as close as _GetOutDist to the target
					_timeout = time + 10;	
					waitUntil {scriptDone _handle1 || time > _timeout};
							
				}
				else 
				{
				
					_GetOutDist = 0; 					
				};
				
				
				
				// if there was getout of the cargo
				if (count _unitsin > 0) then {					
					//if (KRON_UPS_Debug>0) then {player sidechat format["%1: Geting out of vehicle, dist=%2 atdist=%3 _area=%4",_grpidx,([_currpos,_targetpos] call KRON_distancePosSqr),_GetOutDist,_area]}; 											
					_timeout = time + 7;	
					{ 
						waituntil {vehicle _x == _x || !canmove _x || !alive _x || time > _timeout || movetofailed _x  }; 
					} foreach _unitsin;			
					
					
					// did the leader die?
					_npc = [_npc,_members] call MON_getleader;							
					if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};	
					
					if (_fightmode == "fight" || _gothit) then {			
						_npc setBehaviour "COMBAT";		// AWARE																
						_groupOne = group _npc;
						_groupOne setFormation "DIAMOND";							
						nul = [_npc,30] spawn MON_move;	
					};
					
					sleep 0.2;
					// select leader outside of vehicle
					{
						if (alive _x && canmove _x) exitwith {group _x selectLeader _x; _npc = _x};
					} foreach _unitsin;
							
					
					
					if (_fightmode == "fight") then 
					{	
						_pursue = true;
						_defend = false;
					}
					else
					{						
						_pursue = false;	
						_makenewtarget=true;
					};						
				};	
			};									
		};	

	
		//If no waypoint do not move
		if (_nowp) then 
		{
			_makenewtarget = false;
			_pursue = false;
		};		
	
		
		if (_inheli) then {
			_heli = vehicle _npc;  // ToDo check if this is indeed heli an not AI himself
			if (!isnil "_heli") then 
			{
				_landing = _heli getVariable "UPSMON_landing";
				if (isnil ("_landing")) then {_landing=false;};
				if (_landing) then {	
					_pursue = false;
				};
			};
		};		
		sleep 0.2;
		
// **********************************************************************************************************************
//   								PURSUE: CHASE BEGINS THE LENS
// **********************************************************************************************************************
		// UPSMON GROUP ATTACK AND PURSUE NEAREST TARGET
		if (_pursue) then 
		{		
			if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: Group %1 is in pursue",_grpidx]}; 
		
			_pursue = false;
			_newpos = true; 	
			_react = 0;		
			_lastreact = 0;
			_timeontarget = 0; 		
			_makenewtarget = false;			
			_fm = 1;
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};				
		
			// get position of spotted unit in player group, and watch that spot
			_targetPos = _attackPos;		
			_targetX = _targetPos select 0; _targetY = _targetPos select 1;
			_currPos = getpos _npc;									

			 // also go into "combat mode"		
			_pause="NOWAIT";
			_waiting=0;			
			
			// angle from unit to target
			_dir1 = [_currPos,_targetPos] call KRON_getDirPos;
			_dir2 = (_dir1+180) mod 360;
			
			if ( _dist > _closeenough/2) then {
				_result = [_npc,_dir2,_targetPos,_flankdir] call Aze_FlankPosition;

				_targetPos = _result select 0;
				_targettext = _result select 1; 
				_flankdir =_result select 2;			
			};
			
			
			//Establish the type of waypoint
			//DESTROY has worse behavior with and sometimes do not move
			If (_defend) then
			{
					If (_fortify) then
					{
						_wptype = "SENTRY";
					}
					else 
					{
						_wptype = "HOLD";
					};
				if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: Group %1 is in defense",_grpidx]};
				_wpformation = "DIAMOND";
				_targetPos = _currPos;	
				_targettext ="Defend";
				(group _npc ) enableAttack false;
				{_x setCombatMode "YELLOW";} foreach units _npc;
			}
			else
			{
				_wptype = "MOVE";
				_wpformation = "WEDGE";
				(group _npc ) enableAttack true;
			};
			
			//Set speed and combat mode 
			_rnd = random 100;
			if ( _dist <= _closeenough ) then {
				If (!_ambush) then {_currcycle = _cycle/2;};
				//If we are so close we prioritize discretion fire
				if ( _dist <= _closeenough/2 ) then 
				{	
					//Close combat modeo
					_speedmode = "FULL";	
					_wpformation = "LINE";
					If (vehicle _npc != _npc) then {_wpformation = "WEDGE";};
					_react = _react + KRON_UPS_react / 2;
					_minreact = KRON_UPS_minreact / 2;
					
					if (_defend) then 
					{		
						//Defensive combat						
						_Behaviour =  "COMBAT"; 
						_wptype = "HOLD";
					} 
					else 
					{
						 // _rnd < 80
						if (morale _npc <= 0 && _gothit) then 
						{           
							_Behaviour =  "COMBAT";
							{_x setCombatMode "RED";} foreach units _npc;
						} 
						else 
						{
							_Behaviour =  "STEALTH"; // ToDo check impact "STEALTH";
							_speedmode = "LIMITED";
							_wpformation = "DIAMOND";
							{_x setCombatMode "WHITE";} foreach units _npc;
						};	
						_wptype = "SAD"; // MOVE							
					};
					
				_targetPos = _attackPos;
				_targettext = "attackPos"; 
				_flankdir =0;
				
				} 
				else 
				{
					//If the troop has the role of not moving tend to keep the position	
					_speedmode = "NORMAL"; 
					If (vehicle _npc != _npc) then {_wpformation = "VEE";};
					_minreact = KRON_UPS_minreact / 1.5;					

					// _rnd = 80
					if (morale _npc <= 0 && _gothit) then 
					{
						_Behaviour =  "COMBAT";
					} 
					else 
					{
						_Behaviour =  "STEALTH";
						_speedmode = "LIMITED";
					};	
					_wptype = "MOVE";
																	
				};								
			} 
			else	
			{	
				{_x setCombatMode "YELLOW";} foreach units _npc;
				
				if (_dist <= (_closeenough + KRON_UPS_safedist)) then 
				{
					_speedmode = "LIMITED";										
					_minreact = KRON_UPS_minreact;
					_Behaviour =  "AWARE";
									
				} 
				else 
				{
					//In May distance of radio patrol act..
					if (( _dist <  KRON_UPS_sharedist )) then 
					{
						//Platoon from the target must move fast and to the point
						_Behaviour =  "AWARE"; 
						_speedmode = "NORMAL";	
						_minreact = KRON_UPS_minreact * 2;
					} 
					else 
					{
						//Platoon very far from the goal if not move nomove role
						_Behaviour =  "SAFE"; 
						_speedmode = "NORMAL";
						_minreact = KRON_UPS_minreact * 3;	
						_wpformation = "COLUMN";  //COLUMN						
												
					};
				};	
			};	


			
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};	
		
			//If leader is in vehicle will move in  anyway
			if (vehicle _npc != _npc || { !_isman } ) then 
			{
				_wptype = "MOVE";
				_Behaviour =  "AWARE"; 
				if ( _inheli ) then {
					_speedmode = "FULL";	
					_targetPos = _AttackPos;
				};
			};			
		


		//Establecemos el target
			KRON_targetsPos set [_grpid,_targetPos];
			sleep 0.01;					
			
				
			//Si es unidad de refuerzo siempre acosará al enemigo
			if (_reinforcementsent) then 
			{
				_wptype="MOVE";
				_newpos=true; 
				_makenewtarget = false;
			};			
						
			if (_nofollow=="NOFOLLOW" && _wptype != "HOLD") then {

				_targetPos = [_targetPos,_centerpos,_rangeX,_rangeY,_areadir] call KRON_stayInside;
				_targetdist = [_currPos,_targetPos] call KRON_distancePosSqr;
			};
				
			//Is updated with the latest value, changing the target
			_lastknown = _opfknowval; 
				
			//If for whatever reason cancels the new position should make clear the parameters that go into pursuit
			if  (!_newpos) then {
				//If the unit has decided to maintain position but is being attacked is being suppressed, should have the opportunity to react
				_newpos = _gothit;
				
				if  (!_newpos) then {
					_targetPos=_lastpos;
					_wptype = "HOLD";
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 Mantaining orders %2",_grpidx,_nomove]};	
				};
			};	
			
		};	//END PURSUE		
	sleep 0.1;
	}; //((_isSoldier) && ((count _enemies)>0)
	
	
// **********************************************************************************************************************
//   								NO NEWS
// **********************************************************************************************************************
	if (_fightmode == "walk" && !_ambush && !_nowp && !_targetsnear && !_fortify && _nomove != "NOMOVE" && !_newpos) then 
	{
		// did the leader die?
		_npc = [_npc,_members] call MON_getleader;							
		if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};		
		
		// calculate new distance
		// if we're waiting at a waypoint, no calculating necessary	
		_currpos = getpos _npc;	
					
		
		if (isNil "_lastcurrpos") then
		{
			_lastcurrpos = [0,0];
		};
		
		//Stuck control
		if (!_nowp 
		&& { alive _npc } 
		&& { canmove _npc } 
		&& { _lastcurrpos select 0 == _currpos select 0 } 
		&& { _lastcurrpos select 1 == _currpos select 1 }) then 
		{
			[_npc] call MON_cancelstop;	
			_makenewtarget = true;
			if (KRON_UPS_Debug>0) then {player sidechat format["%1 stucked, moving",_grpidx]};	
			if (KRON_UPS_Debug>0) then {diag_log format["%1 stuck for %2 seconds - trying to move again",_grpidx, _timeontarget]};	
		};
		
		_lastpos = _targetPos;
		_lastcurrpos = _currpos; //sets last currpos for avoiding stuk				
			
		If (_Behaviour != "COMBAT") then
		{
		
			_pursue = false;
			_gothit = false;
			_targetdead	= true;		
			_fightmode = "walk";
			_speedmode = _orgSpeed;
			_reinforcementsent = false;
			_target = objnull;			
			_Behaviour = _orgMode;					
			_waiting = -1;	
			_wpformation = "COLUMN";
		
			//Gets distance to targetpos
			_targetdist = [_currPos,_targetPos] call KRON_distancePosSqr;	
			
			//It assesses whether it has exceeded the maximum waiting time and the objective is already shot to return to the starting position.		

			KRON_UPS_reinforcement = false; //there is no threat
					
			if (_rfid > 0 ) then 
			{
				call (compile format ["KRON_UPS_reinforcement%1 = false;",_rfid]);
			};
					
			{
				[_x,"AUTO"] spawn MON_setUnitPos; 
				_x setBehaviour _orgMode;
			}	foreach units _npc;										
					
			// if (KRON_UPS_Debug>0) then {player sidechat format["%1 Without objectives, leaving combat mode",_grpidx]};	
	

			
			//if (KRON_UPS_Debug>0) then {player globalchat format["%1  _targetdist %2  atdist=%3 dist=%4",_grpidx, _targetdist, _area/8,_dist]};	
			// if not in combat and we're either close enough, seem to be stuck, or are getting damaged, so find a new target 
			if (!_swimming
			&& (( _targetdist <= (_area/4) || moveToFailed _npc) && (_timeontarget > KRON_UPS_maxwaiting))) then 
			{
				_makenewtarget=true;
				_Behaviour = _orgMode;
			};

			// make new target
			if (_makenewtarget) then 
			{			
				_gothit = false;
				_react = 0;		
				_lastreact = 0;	
				_makenewtarget = false;				
				_timeontarget = 0;
				_wptype = "MOVE";
				
				if (format ["%1",_fixedtargetPos] !="[0,0]") then 
				{	
					_targetPos = _fixedtargetPos; _targettext ="Reinforcement";					
				} 
				else 
				{				

					_targetPos = [_npc,_rlastPos,_rstuckControl,_areamarker,_mindist,_onroad] call Aze_Patrol;
					_targettext = "PATROL";
					_rlastPos = getpos _npc;

				};
				sleep 0.05;

				
				// distance to target position		  
				_attackPos = [0,0];			
				_fm=0;				
				_newpos=true;								
			};
		};
	};	

	// if in water, get right back out of it again
	if (surfaceIsWater _currPos) then 
	{
		if (_isman && { !_swimming } && { !_isDiver } ) then 
		{
			_drydist=999;
			// look around, to find a dry spot
			for [{_a=0}, {_a<=270}, {_a=_a+90}] do 
			{
				_dp=[_currPos,30,_a] call KRON_relPos; 
				if !(surfaceIsWater _dp) then {_targetPos=_dp};				
			};
			_newpos=true; 
			_swimming=true;
		};
	}
	else 
	{
		_swimming=false;
	};

	sleep 0.05;


// **********************************************************************************************************************
//   								NEWPOS:	SE	EJECUTA		LA	ORDEN 	DE 	MOVIMIENTO
// **********************************************************************************************************************
//	if (KRON_UPS_Debug>0) then {player sidechat format["%1 rea=%2 wai=%3 tim=%4 tg=%5 %6",_grpidx,_react,_waiting,_timeontarget,typeof _target,alive _target]};							

	if ((_waiting<=0) && _newpos) then 
	{			
		_currPos = getpos _npc;		
		_newpos = false;
		_waiting = -1; 	
		_swimming=false;			
		_GetIn_NearestVehicles = false;	
		
		//Gets distance to targetpos
		_targetdist = [_currPos,_targetPos] call KRON_distancePosSqr;		
				
		// did the leader die?
		_npc = [_npc,_members] call MON_getleader;	
		if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};	
		
		//If you have not been removed progress continue
		if (alive _npc) then 
		{
			_currPos = getpos _npc;
			
			if ( _wptype == "MOVE") then 
			{
				//Try to avoid stucked soldiers out of vehicles
				if ( _npc == vehicle _npc) then {
					{
						if (alive _x && canmove _x) then {
							//[_x] spawn MON_cancelstop;
							[_x] dofollow _npc;
						};
					} foreach _members;
				};
				//sleep 0.05;	
				
				if (KRON_UPS_Debug>0) then {diag_log format["UPSMON - group %1 looking for vehicles: [%2] - [%3] - [%4] - [%5] - [%6]",_grpidx, _dist, !_gothit,( _targetdist >= ( KRON_UPS_searchVehicledist )), _isSoldier,!_noveh]};		
				
				
				//Search for vehicle			
				if ((!_gothit 
				&& ( _targetdist >= ( KRON_UPS_searchVehicledist ))) 
				&& _isSoldier 
				&& !_noveh) then 
				{							
					if ( ( vehicle _npc == _npc ) && ( _dist > _closeenough ) ) then 
					{						
						_unitsIn = [_grpid,_npc] call MON_GetIn_NearestVehicles;		
					
						if (KRON_UPS_Debug>0) then {diag_log format["UPSMON - group %1 looking for vehicles to travel %2 m - unitsIn: [%3]",_grpidx, _dist, count _unitsIn]};					
						
						if ( count _unitsIn > 0) then 
						{	
							_GetIn_NearestVehicles = true;
							_speedmode = "FULL";	
							_npc setbehaviour "SAFE";
							_npc setspeedmode "FULL";
							_timeout = time + 60;
							
							_vehicle = objnull;
							_vehicles = [];
							{ 
								waitUntil { (vehicle _x != _x) || { time > _timeout } || { moveToFailed _x } || { !canMove _x } || { !canStand _x } || { !alive _x } }; 
								
								if ( vehicle _x != _x && (isnull _vehicle || _vehicle != vehicle _x)) then 
								{
									_vehicle = vehicle _x ;
									_vehicles = _vehicles + [_vehicle]
								};								
							} foreach _unitsIn;
							//sleep 1;							
							
							{
								_vehicle = _x;
								_cargo = _vehicle getVariable ("UPSMON_cargo");
								if ( isNil("_cargo")) then {_cargo = [];};	
								_cargo orderGetIn true;
								
								//Wait for other groups to getin								
								{ 
									waituntil { (vehicle _x != _x) || { time > _timeout } || { movetofailed _x } || { !canmove _x } || { !canstand _x } || { !alive _x } }; 
								} foreach _cargo;	
								
								//Starts gunner control
								nul = [_vehicle] spawn MON_Gunnercontrol;
								sleep 0.1;
								// nul = [_x,30] spawn MON_domove; //!R just little kick to make sure it moves
							} foreach _vehicles;
							
							//Checks if leader has dead in the mean time
							_npc = [_npc,_members] call MON_getleader;							
							if (!alive _npc || { !canmove _npc } ) exitwith {_exit=true;};	

							
							if ( "Air" countType [vehicle (_npc)]>0) then 
							{											
								_rnd = (random 2) * 0.1;
								_flyInHeight = round(KRON_UPS_flyInHeight * (0.9 + _rnd));
								vehicle _npc flyInHeight _flyInHeight;
								
								//If you just enter the helicopter landing site is defined
								if (_GetIn_NearestVehicles) then { 
									_GetOutDist = round(((KRON_UPS_paradropdist )  * (random 100) / 100 ) + 150);
									
									[vehicle _npc, _TargetPos, _GetOutDist, 90] spawn MON_doParadrop; // org _flyInHeight shay_gman changed from MON_doParadrop to MON_landHely
									sleep 1;
									//Execute control stuck for helys
									[vehicle _npc] spawn MON_HeliStuckcontrol;
									if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: flyingheiht=%2 paradrop at dist=%3",_grpidx, _flyInHeight, _GetOutDist,_rnd]}; 
								};				
							};							
						};					
					};
				};
				sleep 0.05;
			};	
				

			
			//Get in combat vehicles
			if (_isSoldier 
			&& (!_GetIn_NearestVehicles ) 
			&& ( _fightmode != "walk" ) 
			&& !_noveh2
			&& !_ambush) then 
			{					
				_dist2 = _dist / 4;
				if ( _dist2 <= 100 || !_gothit) then {
					_unitsIn = [];					
					_unitsIn = [_grpid,_npc,_dist2,false] call MON_GetIn_NearestCombat;	
					_timeout = time + (_dist2/2);
				
					if ( count _unitsIn > 0) then {							
						if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: Geting in combat vehicle targetdist=%2",_grpidx,_npc distance _target]}; 																						
						_npc setbehaviour "SAFE";
						_npc setspeedmode "FULL";						
						
						{ 
							waituntil {vehicle _x != _x || !canmove _x || !canstand _x || !alive _x || time > _timeout || movetofailed _x}; 
						}foreach _unitsIn;
						
						// did the leader die?
						_npc = [_npc,_members] call MON_getleader;							
						if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};								
						
						//Return to combat mode
						_npc setbehaviour _Behaviour;
						_npc setformation "COLUMN";
						_timeout = time + 150;
						{ 
							waituntil {vehicle _x != _x || !canmove _x || !alive _x || time > _timeout || movetofailed _x}; 
						}foreach _unitsIn;
						
						{								
							if ( vehicle _x  iskindof "Air") then {
								//moving hely for avoiding stuck
								if (driver vehicle _x == _x) then {
									_vehicle = vehicle (_x);									
									nul = [_vehicle,1000] spawn MON_domove;	
									//Execute control stuck for helys
									[_vehicle] spawn MON_HeliStuckcontrol;
									if (KRON_UPS_Debug>0 ) then {diag_log format["UPSMON %1: Getting in combat vehicle - distance: %2 m",_grpidx,_npc distance _target]}; 	
								};									
							};
							
							if (driver vehicle _x == _x) then {
								//Starts gunner control
								nul = [vehicle _x] spawn MON_Gunnercontrol;								
							};
						sleep 0.01;
						} foreach _unitsIn;									
					};	
					
				};
				sleep 0.05;
				// did the leader die?
				_npc = [_npc,_members] call MON_getleader;							
				if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};
				
			};
					
			
			//If use statics are enabled leader searches for static weapons near.
			if ((KRON_UPS_useStatics && {(vehicle _npc == _npc)} && {!_GetIn_NearestVehicles } && {_isSoldier}) 
				&& {((_wptype == "HOLD" && (random 100) < 80) || (_wptype != "HOLD" && (random 100) < 40))}) then 
			{
				 _unitsIn = [_grpid,_npc,_buildingdist] call MON_GetIn_NearestStatic;			
				
				if ( count _unitsIn > 0) then {									
					_npc setbehaviour "SAFE";
					_npc setspeedmode "FULL";					
					_timeout = time + 60;
					
					{ 
						waituntil {vehicle _x != _x || { time > _timeout } || { movetofailed _x } || { !canmove _x } || { !alive _x } }; 
					} foreach _unitsIn;
					
				};
				sleep 0.05;
				// did the leader die?
				_npc = [_npc,_members] call MON_getleader;							
				if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};
				
			};	
			
		
			
			//Check for Static weapon
			If (_fortify 
			&& (_gothit)
			&& vehicle _npc == _npc
			&& _wptype == "HOLD" 
			&& morale _npc >= -0.5) then
			{
				_unitsIn = [_grpid,_npc,150] call MON_GetIn_NearestStatic;
				if ( count _unitsIn > 0 ) then { sleep 10};
			};	
					
			
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};			
		
			if (isnull _grp || _grp != group _npc) then {
				_grp = group _npc;
			};			
							
			
			_index = currentWaypoint _grp;	
			
			//If the waypoing is different than it has or is different from what we set hold
			IF (_wptype != "HOLD" || _lastwptype != _wptype) then {														
				//Has not completed or are waypoints
				//_index = 1 Waypoint by default, not use.	
				if ( _index == 1 || _index > count waypoints _grp && !isnull _grp) then {		
					_wp = _grp addWaypoint [_targetPos, 0];									
					_index = _wp select 1;															
					// if (KRON_UPS_Debug>0) then {player sidechat format["%1: created wp %2 index %3",_grpidx,_wp, _index]}; 						
				} else {					
					_wp = [_grp,_index];
					// if (KRON_UPS_Debug>0) then {player globalchat format["%1: not created wp %2 index %3 %4",_grpidx,_wp, _index,_targetPos]}; 
				};				
			};				
			
			// _wp = [_grp,_index];
			
			
			
			// if iscar the run fast if targetpost is far.
			if ((!_gothit && _targetdist >= (_closeenough * 1.5)) && (vehicle _npc != _npc)) then {
					_speedmode = "FULL";
				//} else { 
					// _speedmode = _orgSpeed;																		
				};
			
			
			
			//We define the parameters of the new waypoint				
			_wp  setWaypointType _wptype;						
			_wp  setWaypointPosition [_targetPos, 0];					
			_wp  setWaypointFormation _wpformation;		
			_wp  setWaypointSpeed _speedmode;	
			_lastwptype = _wptype;
			//_lasttargetpos = _targetPos;
			
			 
			
				//If you have more than 1 waypoints delete the obsolete		
				{	
					if ( _x select 1 < _index ) then {
						deleteWaypoint _x;
					};					
				sleep 0.05;
				} foreach waypoints _grp;		
			
							
			//if (KRON_UPS_Debug>0) then {diag_log format["%1: waypoints %2 %3 %4 %5",_grpidx,count waypoints _grp, _grp, group _npc, group (leader _npc)]}; 											
			
			//Sets behaviour
			if (toupper(behaviour _npc) != toupper (_Behaviour)) then {
				_npc setBehaviour _Behaviour;	
			};						
			
			//Refresh position vector
			KRON_targetsPos set [_grpid,_targetPos];								
				
		};
		//if (KRON_UPS_Debug>0) then {player sidechat format["%1: %2 %3 %4 %5 %6 %7 %8 %9 %10",_grpidx, _wptype, _targettext,_dist, _speedmode, _unitpos, _Behaviour, _wpformation,_fightmode,count waypoints _grp];};											
	};

	
	
	//If in hely calculations must done faster
	if (_inheli) then {
		_currcycle = _cycle/2;
		_flyInHeight = KRON_UPS_flyInHeight;
		vehicle _npc flyInHeight _flyInHeight;					
				
	};

	if ((_exit) || (isNil("_npc"))) exitwith
	{
		_loop = false;
		[_Ucthis,_target,_orgpos,_surrended,_closeenough,_membertypes,_vehicletypes,_grpidx] call UPS_Respawn;
	}; 
	
		// slowly increase the cycle duration after an incident
		sleep _currcycle;
	
}; //while {_loop}