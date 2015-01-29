clicked = false;

hint "Click on map to teleport";

openmap true;

onMapSingleClick "player setpos _pos; clicked=true; onMapSingleClick """""; 

waituntil {clicked};

{_x setPos getPos player} forEach units group mosh;

openmap false;

hint "smoke it";