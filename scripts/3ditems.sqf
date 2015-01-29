// // // // // // // // // // // // // // // // // // // // // // // // // // // // //
// 3D Items Script
// Version 1.2
// Date: 2014.05.29
// Author: Lala14, Kilzone_Kid
// // // // // // // // // // // // // // // // // // // // // // // // // // // // //

// init line:
// null = [] execVM "3ditems.sqf";

waitUntil{!isNull player};
sleep 0.1;

LALA_FNC_TURN_AROUND = {
	_turntable = _this select 0;
	_obj = _this select 1;

	waitUntil {player distance _obj < 10};

	_dir = getDir _turntable;
			waitUntil {
				_dir = _dir + (
					if (_dir > 360) then [{-360},{3}]
				);
				_turntable setDir _dir;
				player distance _obj > 10
			};
		[_turntable,_obj] spawn LALA_FNC_TURN_AROUND;
};

[] spawn {
	while {true} do {
		_stuff = nearestObjects [position player, ["GroundWeaponHolder","WeaponHolderSimulated","WeaponHolder"], 10];
		[_stuff] spawn {
		_stuff = _this select 0;
			{
				if ( isNil {_x getVariable "newholder"} ) then {
					_x setVariable ["newholder",true,true];

					_turntable = createVehicle ["Land_Can_V3_F", position _x, [], 0, "CAN_COLLIDE"];
					_turntable hideObject true;
					_x attachTo [_turntable,[0,-0.63,0.7]];
					_x setVectorDirAndUp [[0,0,1],[0,-1,0]];

					_dir = getDir _turntable;
					waitUntil {
						_dir = _dir + (
							if (_dir > 360) then [{-360},{3}]
						);
						_turntable setDir _dir;
						player distance _x > 10
					};

					[_turntable,_x] spawn LALA_FNC_TURN_AROUND;
				};
			}forEach _stuff;
		};
	};
};
systemChat "3D Items: Initialized";