Aze_Askrenf = {
private ["_npc","_target","_radiorange","_renf","_fixedtargetpos"];

	_npc = _this select 0;
	_target = _this select 1;
	_radiorange = _this select 2;
	_renf = false;
	_fixedtargetpos = getpos _npc;
	
	_ArrayGrpRenf = [KRON_NPCs, [], { _npc distance _x }, "ASCEND"] call BIS_fnc_sortBy;
	{
		If (alive _x && _npc distance _x <= _radiorange && _x getvariable "UPS_REINFORCEMENT") exitwith {{_x setvariable ["UPS_PosToRenf",[_fixedtargetpos select 0,_fixedtargetpos select 1]];_x setvariable ["UPS_REINFORCEMENT",false];} foreach units (group _x); _renf = true;};

	} count KRON_NPCs > 0;


	_renf

};
