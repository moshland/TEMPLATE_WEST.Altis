/*
	Author: Iceman77
	Parent File: fn_uiInit.sqf
	Description:
		Populate the listbox with useful ammunition
*/

private [ "_listBox", "_specialArray", "_muzzle", "_magArray", "_displayName", "_picture", "_index", "_loops" ];

_listBox = [ _this, 0, -1, [-1] ] call BIS_fnc_param;
lbClear _listBox;
_loops = 0; // FOR ADDING MISC ITEMS TO THE BOTTOM OF TYHE LIST

{
	_loops = _loops + 1;// FOR ADDING MISC ITEMS TO THE BOTTOM OF THE LIST
	
	_magArray = if ( ( count getArray (configfile >> "CfgWeapons" >> _x >> "muzzles") ) > 1 ) then {
		_muzzle = getArray ( configfile >> "CfgWeapons" >> _x >> "muzzles" ) select 1;
		getArray ( configfile >> "CfgWeapons" >> _x >> _muzzle >> "magazines" ) + getArray ( configfile >> "cfgWeapons" >> _x >> "magazines" );
	} else {
		getArray ( configfile >> "cfgWeapons" >> _x >> "magazines" );
	};
			   
	if ( isNil "_specialArray" && { _loops == 3 } ) then { // ADD THE MISC ITEMS TO THE BOTTOM (_LOOPS == 3)
		_specialArray = [ 
				"HandGrenade", "MiniGrenade", "SmokeShell", "SmokeShellBlue", "SmokeShellGreen",  
				"SmokeShellOrange", "SmokeShellRed", "SmokeShellYellow", "SmokeShellPurple", 
				"Chemlight_red", "Chemlight_blue", "Chemlight_green", "Chemlight_yellow", 
				"Laserbatteries", "ClaymoreDirectionalMine_Remote_Mag", "DemoCharge_Remote_Mag", "ATMine_Range_Mag", 
				"APERSBoundingMine_Range_Mag", "APERSMine_Range_Mag", "APERSTripMine_Wire_Mag" 
		];	
			
		{
		
			_magArray pushback _x;
			
		} forEach _specialArray;
	}; 		
		
	{
		_displayName = getText ( configFile >> "cfgMagazines" >> _x >> "displayName" );
		_picture = getText ( configFile >> "cfgMagazines" >> _x >> "picture" );
		_index = lbAdd [ _listBox, _displayName ];
		lbSetData [ _listBox, _index, _x ];
		lbSetPicture [ _listBox, _index, _picture ]; 
		lbSetTooltip [ _listBox, _index, _displayName ];
	} forEach _magArray;

} forEach [ primaryWeapon player, secondaryWeapon player, handGunWeapon player ];

lbSetCurSel [ _listBox, 0 ];
