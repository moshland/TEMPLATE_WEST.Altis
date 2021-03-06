#include "macro.sqf"
_item = _this select 0;
_class = _item call ASORGS_fnc_GetClass;

_backpackitems = ASORGS_CurrentInventory select GSVI_BackpackItems;
_backpackitems = _backpackitems - [_class];
ASORGS_CurrentInventory set [GSVI_BackpackItems, _backpackitems];

_vestitems = ASORGS_CurrentInventory select GSVI_VestItems;
_vestitems = _vestitems - [_class];
ASORGS_CurrentInventory set [GSVI_VestItems, _vestitems];

_uniformitems = ASORGS_CurrentInventory select GSVI_UniformItems;
_uniformitems = _uniformitems - [_class];
ASORGS_CurrentInventory set [GSVI_UniformItems, _uniformitems];

_magazines = ASORGS_CurrentInventory select GSVI_Magazines;
_magazines = _magazines - [_class];
ASORGS_WeightChanged = true;

ASORGS_BackpackCapacityChanged = true;
ASORGS_UniformCapacityChanged = true;
ASORGS_VestCapacityChanged = true;