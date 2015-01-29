// ----> Hint
hint "Open your map and mark the target with a single click.";


// ----> (Re)Set variable
MapClicked = false;

openmap true

// ----> Get the map click
onMapSingleClick "clickPos = _pos; MapClicked = true; onMapSingleClick {};";


// ----> Wait until clicked
waitUntil {MapClicked};


// ----> Create bomb
"Bo_Mk82" createVehicle clickPos;

openmap false;

hint "smoke it";