UPS_Respawn = {
private ["_npc","_grpidx","_track","_target","_orgpos","_respawn","_respawnmax","_surrended","_closeenough","_unittype","_membertypes","_rnd","_grp","_lead","_initstr","_targetpos","_spawned","_vehicletypes","_UCthis"];

_UCthis = _this select 0;
_target = _this select 1;
_orgpos = _this select 2;
_surrended = _this select 3;
_closeenough = _this select 4;
_membertypes = _this select 5;
_vehicletypes = _this select 6;
_grpidx = _this select 7;

_npc = _UCthis select 0;
_grp = group _npc;


_dist = 1000;
_respawnmax = 0;


		if (KRON_UPS_Debug>0) then {hint format["%1 exiting mainloop",_grpidx]};	

		//Limpiamos variables globales de este grupo
		KRON_targetsPos set [_grpid,[0,0]];
		// KRON_NPCs set [_grpid,objnull];
		KRON_UPS_Exited=KRON_UPS_Exited+1;

		// respawn
		_respawn = if ("RESPAWN" in _UCthis) then {true} else {false};
		_respawn = if ("RESPAWN:" in _UCthis) then {true} else {_respawn};
		_respawnmax = ["RESPAWN:",_respawnmax,_UCthis] call KRON_UPSgetArg;

		//Gets dist from orinal pos
		if (!isnull _target) then {
			_dist = ([_orgpos,position _target] call KRON_distancePosSqr);	
		};
		// if (KRON_UPS_Debug>0) then {player sidechat format["%1 _dist=%2 _closeenough=%3",_grpidx,_dist,_closeenough]};	

		//does respawn of group =====================================================================================================
		if (_respawn && _respawnmax > 0 &&  !_surrended  && _dist > _closeenough) then {
			if (KRON_UPS_Debug>0) then {player sidechat format["%1 doing respawn",_grpidx]};	

			// copy group leader
			_unittype = _membertypes select 0;

			// any init strings?
			_initstr = ["INIT:","",_UCthis] call KRON_UPSgetArg;
	
			// make the clones civilians
			// use random Civilian models for single unit groups
			if ((_unittype=="Civilian") && (count _members==1)) then {_rnd=1+round(random 20); if (_rnd>1) then {_unittype=format["Civilian%1",_rnd]}};
			
			_grp=createGroup _side;
			_lead = _grp createUnit [_unittype, _orgpos, [], 0, "form"];
			[[netid _lead, _initstr], "KRON_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;
			[_lead] join _grp;
			_grp selectLeader _lead;
				
			// copy team members (skip the leader)
			_i=0;
			{
				_i=_i+1;
				if (_i>1) then {
					_newunit = _grp createUnit [_x, _orgpos, [],0,"form"];
					[[netid _newunit, _initstr], "KRON_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;
					[_newunit] join _grp;
					sleep 0.1;
				};
			} foreach _membertypes;
			
			
			if ( _lead == vehicle _lead) then {
					{
						if (alive _x && canmove _x) then {
							[_x] dofollow _lead;
						};
					sleep 0.1;
					} foreach units _lead;
			};
			
			{				
				_targetpos = _orgpos findEmptyPosition [10, 200];
				sleep .4;
				if (count _targetpos <= 0) then {_targetpos = _orgpos};
				//if (KRON_UPS_Debug>0) then {player globalchat format["%1 create vehicle _newpos %2 ",_x,_targetpos]};	
				_newunit = _x createvehicle (_targetpos);											
			} foreach _vehicletypes;		
			
			
			//if (KRON_UPS_Debug>0) then {player globalchat format["%1 _vehicletypes: %2",_grpidx, _vehicletypes]};
			
			_spawned= if ("SPAWNED" in _UCthis) then {true} else {false};
			//Set new parameters
			if (!_spawned) then { 
				
				_UCthis = _UCthis + ["SPAWNED"]; 		
			
				if ((count _vehicletypes) > 0) then {
						_UCthis = _UCthis + ["VEHTYPE:"] + ["dummyveh"];	
				};
			};	
				
			
			_UCthis set [0,_lead];
			_respawnmax = _respawnmax - 1;
			_UCthis =  ["RESPAWN:",_respawnmax,_UCthis] call KRON_UPSsetArg;
			sleep 0.1;
			_UCthis =  ["VEHTYPE:",_vehicletypes,_UCthis] call KRON_UPSsetArg;
			
			
			// if (KRON_UPS_Debug>0) then {player globalchat format["%1 _UCthis: %2",_grpidx,_UCthis]};	
			//Exec UPSMON script			
			_UCthis spawn UPSMON;
			sleep 0.1;
		};	

		_friends=nil;
		_enemies=nil;
		_enemytanks = nil;
		_friendlytanks = nil;
		_roads = nil;
		_targets = nil;
		_members = nil;
		_membertypes = nil;
		_UCthis = nil;

		if (!alive _npc) then {
			deleteGroup _grp;
		};
};