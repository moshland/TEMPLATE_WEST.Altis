if (!isServer) exitWith {};
playSound "sound2";
[] spawn {
  while {not isnull player} do { ch1 moveTo (getPos player); ch2 moveTo (getPos player); ch3 moveTo (getPos player); ch4 moveTo (getPos player); ch5 moveTo (getPos player); ch6 moveTo (getPos player); ch7 moveTo (getPos player); ch8 moveTo (getPos player); ch9 moveTo (getPos player); ch10 moveTo (getPos player); sleep 1; };
};

sleep 30;
boom1="Grenade" createVehicle [(getPos ch1 select 0),(getPos ch1 select 1),0];
boom2="Grenade" createVehicle [(getPos ch2 select 0),(getPos ch2 select 1),0];
boom3="Grenade" createVehicle [(getPos ch3 select 0),(getPos ch3 select 1),0];
boom4="Grenade" createVehicle [(getPos ch4 select 0),(getPos ch4 select 1),0];
boom5="Grenade" createVehicle [(getPos ch5 select 0),(getPos ch5 select 1),0];
boom6="Grenade" createVehicle [(getPos ch6 select 0),(getPos ch6 select 1),0];
boom7="Grenade" createVehicle [(getPos ch7 select 0),(getPos ch7 select 1),0];
boom8="Grenade" createVehicle [(getPos ch8 select 0),(getPos ch8 select 1),0];
boom9="Grenade" createVehicle [(getPos ch9 select 0),(getPos ch9 select 1),0];
boom10="Grenade" createVehicle [(getPos ch10 select 0),(getPos ch10 select 1),0];

