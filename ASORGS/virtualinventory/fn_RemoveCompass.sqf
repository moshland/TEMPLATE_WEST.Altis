#include "macro.sqf"
_Compass = call ASORGS_fnc_GetCompass;
_items = (ASORGS_CurrentInventory select GSVI_Items) - [_Compass];
ASORGS_CurrentInventory set [GSVI_Items, _items];
ASORGS_WeightChanged = true;