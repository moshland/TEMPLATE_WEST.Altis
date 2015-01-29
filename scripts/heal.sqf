//[this, 10, 0.01, 2] execVM "heal.sqf";
private["_obj","_radius","_healPerSleep","_damage","_sleepTime"];
_obj = _this select 0;
_radius = _this select 1;
_healPerSleep = _this select 2;
_sleepTime = _this select 3;
if (isServer) then
{
	while {true} do
	{
		{
			if (alive _x) then
			{
				_damage = damage _x;
				_damage = _damage - _healPerSleep;
				if (_damage < 0) then
				{
					_damage = 0;
				};
				_x setDamage _damage;
			};
		}
		forEach ((getPos _obj) nearEntities [["Man"], _radius]);
		sleep _sleepTime;
	};
};