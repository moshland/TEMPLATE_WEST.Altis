// Create a mission entry for the server and client RPT file, easier to debug when you know what mission created the error
diag_log text ""; 
diag_log text format["|=============================   %1   =============================|", missionName]; // stamp mission name
diag_log text "";

MISSION_ROOT = call {
    private "_arr";
    _arr = toArray __FILE__;
    _arr resize (count _arr - 8);
    toString _arr
};

waitUntil{!(isNil "BIS_fnc_init")}; //wait until functions module initializes 

debug = false; 

enableSaving [false,false];

player enableFatigue false; 
player addEventhandler ["Respawn", {player enableFatigue false}];


if (debug) then
{
[] execVM "Mosh_scripts\debug.sqf";
0 = ["players","ais","allsides"] execVM "scripts\player_markers.sqf";
null = [] execVM "scripts\strategicMarkers.sqf";
_nul = [] execVM "scripts\buildingPositionLocater.sqf";
}
else
{
0 = ["players","ais"] execVM "scripts\player_markers.sqf";
//[] execVM "Mosh_scripts\intro.sqf";
[] execVM "Mosh_scripts\markers_alpha.sqf";
};

CHVD_allowNoGrass = true; // Set 'false' if you want to disable "None" option for terrain (default: true)
CHVD_maxView = 12000; // Set maximum view distance (default: 12000)
CHVD_maxObj = 12000; // Set maximimum object view distance (default: 12000)

call compile preProcessFileLineNumbers "scripts\fhqtt2.sqf";
call compile preProcessFileLineNumbers "Mosh_scripts\briefing.sqf";

//AI//
player setVariable ["BIS_noCoreConversations", true]; //turns off conversations with AI
//{_x setVariable ["BIS_noCoreConversations", true]} forEach allUnits; 0 fadeRadio 0; enableSentences false; // Disable player units calling out targets automatically
[] execVM "bon_recruit_units\init.sqf";
[]execVM "eos\OpenMe.sqf";
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";
//[10, 500, 10] execVM "scripts\MAD_civilians.sqf";
//[5, 500, 1000] execVM "scripts\MAD_traffic.sqf";
//null = [] execvm "scripts\zlt_civveh.sqf"; //civilian vehicles
//null = [] execVM "DCL\init.sqf"; //dynamic cvilian life
//[] execVM "VCOM_Driving\init.sqf";

//REVIVE//
 call compile preprocessFile "=BTC=_q_revive\config.sqf"; 
 {_x call btc_qr_fnc_unit_init} foreach units group player;

//MISC//
execVM "gvs\gvs_init.sqf";
null= [[Moshpit,HQ,Airport],west,true,50] execVM "BRS\BRS_launch.sqf";

//HUD
[] execVM "scripts\tags.sqf";
//122014 cutrsc ["NameTag","PLAIN"];
nul = [] execVM "scripts\3Dmarkers.sqf";
null = [] execVM "scripts\3ditems.sqf";
call compile preprocessFile "UI\HUD.sqf"; [] spawn ICE_HUD;

//LFC
 PAPABEAR=[(side player),"HQ"];
"GlobalSideChat" addPublicVariableEventHandler
{
private ["_GHint"];
_GHint = _this select 1;
PAPABEAR sideChat _GHint;
};
null = [] execVM "scripts\secure.sqf"; 
//null = [[monitor1,monitor2,monitor3,monitor4],["unit","unit_1","unit_2","mosh","mosh1","mosh2","mosh3"]] execVM "LFC\Feedinit.sqf";

{_x setMarkerAlpha 0;} foreach ["respawn_west","respawn_west_1","HQ"];

[unit_1,"task_1",350] spawn SBGF_fnc_groupGarrison;

[] spawn {
  while {not isnull Moshpit} do { "mobilehq" setmarkerpos getpos Moshpit; "respawn_west_1" setmarkerpos getpos Moshpit; sleep 0.5; };
};


//(_this select 0) spawn Fnc_Set_Textures;  
    Fnc_Set_Textures =
    {        
            if (_this iskindof "C_Van_01_box_F") then {
				_this setObjectTextureGlobal [0,"Mosh_images\black.paa"]; 
				_this setObjectTextureGlobal [1,"Mosh_images\black.paa"]
				_this addAction ["Battlefield Re-spawn System", "BRS\BRS_launch.sqf", [[Airport,HQ],west,true,50]];
				_nul = [_this, 10, 0.01, 2] execVM "scripts\heal.sqf";
				
				Fock_addactionMP = 
				{
					private["_object","_screenMsg","_scriptToCall"];
					_object = _this select 0;
					_screenMsg = _this select 1;
					_scriptToCall = _this select 2;

					if(isNull _object) exitWith {};

					_object addaction [_screenMsg,_scriptToCall];
				};

					[[Moshpit,"call test","test.sqf"],"Fock_addactionMP",nil,false] spawn BIS_fnc_MP;    
	};