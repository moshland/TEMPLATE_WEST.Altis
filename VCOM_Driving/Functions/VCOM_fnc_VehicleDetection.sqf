//This script aims to improve AI driving skills...It's basic. But it works.
//Hunter tops out around 22 velocity
_Unit = _this select 0;
if (isPlayer _Unit) exitWith {};

while {alive _Unit && ((vehicle _Unit) != _Unit)} do 
{

_GetVehicleVelocity = velocity _Unit;
if (!(_GetVehicleVelocity isEqualTo [0,0,0])) then 
{
  _playervelocityX = _GetVehicleVelocity select 0;
  _playervelocityY = _GetVehicleVelocity select 1;
    
  _GetVehiclePosition = GetPosASL _Unit;
  _VehiclePositionX = (_GetVehiclePosition select 0);
  _VehiclePositionY = (_GetVehiclePosition select 1);
  
  _boostX = _playervelocityX * 4;
  _boostY = _playervelocityY * 4;
  
  if (_playervelocityX > 10) then 
  {
    _boostX = _playervelocityX;
    _boostY = _playervelocityY;
  };
  
  _predictX = _VehiclePositionX + _boostX;
  _predictY = _VehiclePositionY + _boostY;
  
  _Position = [_predictX,_predictY,0.2];
  if (VCOM_DRIVE_DEBUG isEqualTo 1) then 
  {
    _Position spawn 
     {
      _arrow = "Sign_Arrow_Cyan_F" createVehicle [0,0,0];_arrow setPos _this;sleep 2;deleteVehicle _arrow;
     };
  };
  _nearestObject = nearestObject [_Position, "ALL"];
  if ((_nearestObject distance (vehicle _unit)) < 100) then 
  {
    _objects = nearestObjects [_nearestObject, ["ALL"],10];
    if (!(_objects isEqualTo [])) then 
    {
    if ((vehicle _unit) in _objects) then {_objects = _objects - [(vehicle _unit)];};
    _objectsArray = [];
      {
      if (!(_x isKindOf "Man")) then {
      if (!(_x isKindOf "Helper_Base_F")) then {
      if (!(_x isKindOf "Logic")) then {
  
      _GetVelocity = velocityModelSpace _x;
      _VelocityCheckY = _GetVelocity select 1;
      if (_VelocityCheckY < 6) then 
      {
        _AlreadySpawned = _x getVariable "VCOM_DRIVERAVOID";
        if (isNil "_AlreadySpawned") then {_AlreadySpawned = 0;};
        if (_AlreadySpawned isEqualTo 0) then 
        {
          _x setVariable ["VCOM_DRIVERAVOID",1,false];
          
          [_x] spawn {_Object = _This select 0;sleep 3;_Object setVariable ["VCOM_DRIVERAVOID",0,false];};
          
          _BoundingBox = boundingBoxReal _x;
          _p2 = _BoundingBox select 1;
      
          _p2maxx = _p2 select 0;
          _p2maxy = _p2 select 1;
          _p2maxz = _p2 select 2;
      
          _TopRightCorner = _x modelToWorld [_p2maxx,_p2maxy,-_p2maxz + 0.1];
          _TopLeftCorner = _x modelToWorld [-_p2maxx,_p2maxy,-_p2maxz + 0.1];
          _BottomLeftCorner = _x modelToWorld [-_p2maxx,-_p2maxy,-_p2maxz + 0.1];
          _BottomRightCorner = _x modelToWorld [_p2maxx,-_p2maxy,-_p2maxz + 0.1];
          //Get mid points of a building.
          _BottomMiddleSection = _x modelToWorld [0,-_p2maxy,-_p2maxz + 0.1];
          _TopMiddleSection = _x modelToWorld [0,_p2maxy,-_p2maxz + 0.1];
          _BottomLeftRightSection = _x modelToWorld [-_p2maxx,0,-_p2maxz + 0.1];
          _TopLeftRightSection = _x modelToWorld [_p2maxx,0,-_p2maxz + 0.1];
          _Vehicle1 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle2 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle3 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle4 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle5 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle6 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle7 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle8 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
          _Vehicle1 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle2 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle3 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle4 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle5 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle6 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle7 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle8 setVariable ["VCOM_DRIVERAVOID",1,false];
          _Vehicle1 setPosATL _TopRightCorner;
          _Vehicle2 setPosATL _BottomRightCorner;
          _Vehicle3 setPosATL _TopLeftCorner;
          _Vehicle4 setPosATL _BottomLeftCorner;
          _Vehicle5 setPosATL _BottomMiddleSection;
          _Vehicle6 setPosATL _TopMiddleSection;
          _Vehicle7 setPosATL _BottomLeftRightSection;
          _Vehicle8 setPosATL _TopLeftRightSection;
          _objectsArray pushback _Vehicle1;
          _objectsArray pushback _Vehicle2;
          _objectsArray pushback _Vehicle3;
          _objectsArray pushback _Vehicle4;
          _objectsArray pushback _Vehicle5;
          _objectsArray pushback _Vehicle6;
          _objectsArray pushback _Vehicle7;
          _objectsArray pushback _Vehicle8;
        };
      };
      };
      };
      };
      } foreach _objects;
      [_objectsArray] spawn 
      {
        _objectsArray = _this select 0;
        sleep 10;
        {
          deleteVehicle _x;
        } foreach _objectsArray;
      };
    };
  };
  _objectsHouse = nearestBuilding _Position;
  if (!(_objectsHouse isEqualTo [])) then 
  {
   _objectsHouseArray = [];

    _AlreadySpawned = _objectsHouse getVariable "VCOM_DRIVERAVOID";
    if (isNil "_AlreadySpawned") then {_AlreadySpawned = 0;};
    if (_AlreadySpawned isEqualTo 0) then 
    {
      _objectsHouse setVariable ["VCOM_DRIVERAVOID",1,false];
      [_objectsHouse] spawn {_Object = _This select 0;sleep 15;_Object setVariable ["VCOM_DRIVERAVOID",0,false];};
      _BoundingBox = boundingBoxReal _objectsHouse;
      _p2 = _BoundingBox select 1;
  
      _p2maxx = _p2 select 0;
      _p2maxy = _p2 select 1;
      _p2maxz = _p2 select 2;
  
      _TopRightCorner = _objectsHouse modelToWorld [_p2maxx,_p2maxy,-_p2maxz + 0.1];
      _TopLeftCorner = _objectsHouse modelToWorld [-_p2maxx,_p2maxy,-_p2maxz + 0.1];
      _BottomLeftCorner = _objectsHouse modelToWorld [-_p2maxx,-_p2maxy,-_p2maxz + 0.1];
      _BottomRightCorner = _objectsHouse modelToWorld [_p2maxx,-_p2maxy,-_p2maxz + 0.1];
      //Get mid points of a building.
      _BottomMiddleSection = _objectsHouse modelToWorld [0,-_p2maxy,-_p2maxz + 0.1];
      _TopMiddleSection = _objectsHouse modelToWorld [0,_p2maxy,-_p2maxz + 0.1];
      _BottomLeftRightSection = _objectsHouse modelToWorld [-_p2maxx,0,-_p2maxz + 0.1];
      _TopLeftRightSection = _objectsHouse modelToWorld [_p2maxx,0,-_p2maxz + 0.1];
      _Vehicle1 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle2 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle3 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle4 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle5 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle6 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle7 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle8 = "Land_CanOpener_F" createVehicleLocal [0,0,0];
      _Vehicle1 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle2 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle3 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle4 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle5 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle6 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle7 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle8 setVariable ["VCOM_DRIVERAVOID",1,false];
      _Vehicle1 setPosATL _TopRightCorner;
      _Vehicle2 setPosATL _BottomRightCorner;
      _Vehicle3 setPosATL _TopLeftCorner;
      _Vehicle4 setPosATL _BottomLeftCorner;
      _Vehicle5 setPosATL _BottomMiddleSection;
      _Vehicle6 setPosATL _TopMiddleSection;
      _Vehicle7 setPosATL _BottomLeftRightSection;
      _Vehicle8 setPosATL _TopLeftRightSection;
      _objectsHouseArray pushback _Vehicle1;
      _objectsHouseArray pushback _Vehicle2;
      _objectsHouseArray pushback _Vehicle3;
      _objectsHouseArray pushback _Vehicle4;
      _objectsHouseArray pushback _Vehicle5;
      _objectsHouseArray pushback _Vehicle6;
      _objectsHouseArray pushback _Vehicle7;
      _objectsHouseArray pushback _Vehicle8;
      {
        _objOnRoad = isOnRoad _x;
        if (_objOnRoad) then {_objectsHouseArray = _objectsHouseArray - [_x];deleteVehicle _x;};
      } foreach _objectsHouseArray;
      
    };
    [_objectsHouseArray] spawn {
      _objectsHouseArray = _this select 0;
      sleep 15;
      {
        deleteVehicle _x;
      } foreach _objectsHouseArray;
    };
  };
};
  sleep 0.5;
};
sleep 3;
_Unit setVariable ["VCOM_DriverDetectionIsDriver",0,false];