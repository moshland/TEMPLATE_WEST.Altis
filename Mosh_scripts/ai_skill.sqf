//setSkill for ai on map from editor
//AI Skill  

DebugDeep=false;

{
_x setUnitAbility 0.1;
_x setskill ["aimingAccuracy",0.2];
_x setskill ["aimingShake",0.2];
_x setskill ["aimingSpeed",0.2];
_x setskill ["Endurance",0.5];
_x setskill ["spotDistance",0.2];
_x setskill ["spotTime",0.2];
_x setskill ["courage",0.4];
_x setskill ["reloadSpeed",0.3];
_x setSkill ["commanding", 0.5]; 
_x setSkill ["general", 0.7];

_aA = _x skill "aimingAccuracy";
_aS = _x skill "aimingShake";
_aSp = _x skill "aimingSpeed";
_e = _x skill "Endurance";
_sD = _x skill "spotDistance";
_sT = _x skill "spotTime";
_c = _x skill "courage";
_rS =_x skill "reloadSpeed";
_co =_x skill "commanding";
_g = _x skill "general";

if (DebugDeep) then {
hint format [
				"unit: %1\naimingAccuracy: %2\naimingShake: %3
				\naimingSpeed: %4\nEndurance: %5\nspotDistance: %6
				\nspotTime: %7\ncourage: %8\nreloadSpeed: %9\ncommanding: %10\ngeneral: %11"
				
				,_x,_aA,_aS,_aSp,_e,_sD,_sT,_c,_rS,_co,_g];
//sleep 0.1;
};
} forEach allUnits;


