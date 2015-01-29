/*********************************************************************************
Author: King_Richard
*********************************************************************************/
// mrkAlpha controls the alpha of all markers, I nomrally leave this at 0.0
_mrkAlpha = 1.0;
// If debug then urban markers are set to dots with names
// if false then urban markers are made ellipse with size 350
_debug = false;

// Barracks = Land_i_Barracks_V1_F, Land_i_Barracks_V2_F, Land_u_Barracks_V2_F
// CargoHouse = Land_Cargo_House_V1_F, Land_Cargo_House_V2_F
// Factory = Land_Factory_Main_F, Land_Factory_Main_F, Land_dp_smallFactory_F
// HQ = Land_Research_HQ_F, Land_Cargo_HQ_V1_F, Land_Cargo_HQ_V2_F, Land_Cargo_HQ_V3_F
// MilOffice = Land_MilOffices_V1_F
// urb_X = NameCityCapital, NameCity, NameVillage,

bld_Barracks = [];
bld_CargoHouse = [];
bld_Factory = [];
bld_HQ = [];
bld_MilOffice = [];
urb_Capital = [];
urb_City = [];
urb_Village = [];

/*********************************************************************************
                        Building Markers
*********************************************************************************/

_Land_Barracks =
[
[3264.61,12466.6,1.11548],
[3657.4,13191.7,0.680398],
[4019.22,12540.3,0.610455],
[4188.96,12817.8,0.97687],
[4566.48,15421.7,0.923828],
[4876.53,14413.3,0.236496],
[6044.76,16231,1.28722],
[6204.42,16223,1.29019],
[7912.92,16154.3,0.824356],
[9274.06,12150.5,0.736227],
[11325.7,14153.6,0.881546],
[11703.7,15916.1,0.58992],
[12648,16412.3,1.11425],
[12670.4,14778.5,0.673956],
[13123.1,16352.7,0.845444],
[14285.1,18870.7,0.576912],
[14389.4,18902.1,0.805176],
[14486.9,16337,0.83987],
[14900.9,17160.1,1.09052],
[15232.6,17441.4,0.828274],
[15331.6,17450.1,0.673567],
[15350.5,17432.6,0.720154],
[15369.2,17414.4,0.82337],
[15559.8,17440.5,0.746491],
[16699,12789.5,0.901918],
[16974.3,12865.2,0.953825],
[17008.7,12809.4,0.680462],
[17178.5,13303.6,1.31122],
[18366,15484.7,0.743267],
[18391,15251.3,1.00703],
[18403.9,15278.9,1.08541],
[20763.6,7259.08,0.316294],
[20809.7,7288.85,0.219959],
[28296.8,25779.3,0.7223]
];


_Land_Factories =
[
[4177.08,15055,2.20753],
[5382.14,17898,0.276787],
[6217.57,16273.2,0.440655],
[6272.72,16269.9,0.446335],
[9546.33,15080.8,0.154991],
[10238,14824.5,1.82037],
[14317.8,18933.5,0.481777],
[14353.8,18989.6,0.751572],
[25388,20324.7,2.22595]
];

_Land_HQs =
[
[12838.6,16683.4,1.67442],
[14192.6,16307.1,1.47733],
[14195.6,21200.4,1.24088],
[14330.9,13045.8,1.57842],
[15195.3,17370,1.50821],
[15361.1,15881.2,1.51188],
[15459.8,15756.8,5.47636],
[15940.2,17035.1,1.55882],
[16008.3,17042,1.53693],
[16012.4,17052.1,1.43337],
[16025.6,17032.4,1.54795],
[16026.8,17043.8,1.60083],
[16040.9,17117.8,1.49642],
[16079.1,16913.7,1.59515],
[17404.4,13240.1,1.45392],
[17438.2,13103.6,1.7596],
[17446.9,13214.8,1.54524],
[17496.5,13152.1,1.42589],
[20101.6,6721.87,1.72124],
[20900.7,19230.4,1.50392],
[20969.9,19196.4,1.50399],
[23632.3,21082.8,1.86131]
];

_Land_MilOffice =
[
[5556,15016.2,0.636641],
[12596.7,16329.6,0.74242],
[14177,16242.1,0.742962],
[15227.8,17319,0.659405],
[15302.1,17463.5,0.578499],
[16013.4,16916.2,0.854142],
[16226.8,17058.7,0.650728],
[17413.8,13135.9,0.701871],
[20952.4,19228.5,0.464581],
[20985.6,19300,0.701962]
];

_Land_CargoHouse =
[
[6815.59,16056,1.04268],
[8309.21,10050.5,0.868767],
[8312.93,10044.8,0.868645],
[8362.82,18246.6,0.977356],
[8379.56,18255.3,0.930756],
[9746.5,22299.8,1.50075],
[9763.7,22321.9,0.855438],
[10012.3,11225,0.883268],
[10015.3,11231.6,0.942047],
[12288.7,8939.43,0.856094],
[12290.8,8865.89,0.845253],
[12453.6,15205.6,0.706306],
[12716.1,16717.5,0.719704],
[12725.6,16398.3,0.631222],
[12863.8,16772.9,0.783302],
[13093.7,16340.9,0.943844],
[13712.5,15212,1.05625],
[13821.7,18948.1,0.974627],
[13827.2,18953.6,0.969391],
[13839,18964.9,0.94454],
[14125.6,16247.1,0.920393],
[14129.5,16259.7,0.919806],
[14134.6,16272.9,0.924374],
[14138.6,16252.9,1.02015],
[14141.9,16284.9,0.896233],
[14144.7,16264.6,0.943144],
[14177.9,16327,0.966679],
[14185.1,16228.2,0.959698],
[14192,16242,1.04408],
[14200.3,16257.8,0.938164],
[14956.3,16285.3,0.946346],
[15136.4,17339.1,0.953398],
[15144.6,17347.7,0.94499],
[15146.4,17329.3,0.925785],
[15155.4,17319.6,0.935957],
[15158.6,18110.3,1.17576],
[15162.7,17319.3,0.940441],
[15171.9,17327.3,0.939331],
[15177.2,17512.3,0.967324],
[15283.6,15856.1,0.956378],
[15284.1,17499.3,0.977037],
[15294.8,15896.2,0.942841],
[15343.3,16213.6,0.946332],
[15403.2,11343.7,0.988396],
[15487.2,15897.8,0.947073],
[15927.5,17068.7,0.923043],
[15932.2,17060.5,0.941858],
[15935.8,17014.7,0.936344],
[15937,17052.7,0.930243],
[15939.6,17070.5,0.938962],
[15944.6,17062.2,0.956547],
[15946.6,17014.6,0.978399],
[15948.6,17053.5,0.961904],
[15951.2,17082.1,0.942658],
[15953.9,17028.4,0.946939],
[15956.4,17073.8,0.945178],
[15956.8,17014.5,0.964159],
[15958.6,17038.2,1.02265],
[15982,17099.1,0.939593],
[15988.5,17088.6,0.934261],
[15994.5,17110.9,0.940726],
[16000.6,17100.5,0.940642],
[16003.4,16983.3,0.891234],
[16005.6,17112.1,0.94732],
[16011.7,17102.2,0.953897],
[16017.3,17125.7,0.951551],
[16023.2,17116.3,0.956445],
[16139.8,17075.7,0.938884],
[16188.6,17018.7,0.93888],
[16561.2,18997.8,0.889709],
[16604.3,18995.1,1.06171],
[16606.6,19047.8,1.21663],
[16642.3,12274.8,0.982602],
[16653.7,12275.8,0.863734],
[16663,12274.9,0.94737],
[16834.3,12062.5,0.859908],
[17323.1,13176.3,0.93106],
[17329.5,13168.7,0.930634],
[17339.4,13208.5,0.943563],
[17340.1,13182.2,0.936998],
[17345.5,13200.7,0.949826],
[17346.5,13175.1,0.932557],
[17349.5,13211.5,0.929685],
[17351.6,13193.5,0.934614],
[17355.5,13203.5,0.934157],
[17357.9,13186.3,0.930326],
[17361.4,13196.5,0.952758],
[17363.7,13217.3,0.946589],
[17368,13189.3,0.953848],
[17369.8,13210.1,0.946833],
[17373.7,13220.1,0.936867],
[17376,13202.9,0.941794],
[17379.6,13213,0.940695],
[17386.1,13205.8,0.942142],
[17408.3,13087,0.93625],
[17414.6,13079.2,0.934986],
[17420.7,13072.3,0.930607],
[17423.4,13225.4,0.926245],
[17425.9,13089.6,0.975122],
[17427.4,13065.3,0.917112],
[17430,13232.3,0.933705],
[17432.6,13082.7,0.963122],
[17451.2,13193.4,1.03513],
[17453.4,13228.7,0.955763],
[17454.3,13183.5,0.854098],
[17458.2,13199.5,0.950809],
[17458.5,13124.5,0.980384],
[17460.1,13221.4,0.957746],
[17461.3,13189.7,0.897591],
[17465.2,13206.1,0.951549],
[17468.4,13196.1,0.933022],
[17477.3,13088.5,0.991831],
[17483.6,13080.9,0.946676],
[17515.6,13169.8,1.00088],
[17522.3,13162.8,0.979436],
[17528.5,13156,0.928685],
[17534.7,13148.2,0.891341],
[18079.4,19194.6,1.30976],
[18443.2,15277.6,0.938667],
[20335.1,18769.5,1.00818],
[20578.8,18818.3,0.982838],
[20951.6,19171,0.835737],
[20961.4,19169.9,0.942087],
[20971.7,19169.1,0.942141],
[20981.6,19168.7,0.941534],
[20991.6,19168,0.941519],
[20996.4,19218.9,0.942947],
[20996.7,19199.7,0.942965],
[20996.7,19209.4,0.943001],
[20996.9,19180.1,0.94252],
[20996.9,19189.5,0.942663],
[21019.6,18989.1,0.939056],
[22589.1,16770.7,0.982783],
[23001.8,7268.47,0.911991],
[23007.2,7272.05,0.94944],
[23440.5,21146.1,1.03062],
[23508.8,21174.4,1.00166],
[23515.6,21173,0.884117],
[23528.5,21169.2,1.08361],
[23571.4,21145.5,0.876312],
[23683.4,21010.9,1.16058],
[25270.5,21656.4,1.25546]
];

for [{_i = 0},{_i < (count _Land_Barracks)},{_i =_i + 1}] do
{
    _pos = _Land_Barracks select _i;
    _marker = createMarker [(format ["Barracks" + "%1", _i]), _pos];
    _marker setMarkerShape "Icon";
    _marker setMarkerSize [1,1];
    _marker setMarkerType "mil_dot";
    _marker setMarkerBrush "Solid";
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerColor "ColorBrown";
    _marker setMarkerText format ["%1", _i];
    bld_Barracks = bld_Barracks + [_marker];
};

for [{_i = 0},{_i < (count _Land_Factories)},{_i =_i + 1}] do
{
    _pos = _Land_Factories select _i;
    _marker = createMarker [(format ["Factory" + "%1", _i]), _pos];
    _marker setMarkerShape "Icon";
    _marker setMarkerSize [1,1];
    _marker setMarkerType "mil_dot";
    _marker setMarkerBrush "Solid";
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerColor "ColorGreen";
    _marker setMarkerText format ["%1", _i];
    bld_Factory = bld_Factory + [_marker];
};

for [{_i = 0},{_i < (count _Land_HQs)},{_i =_i + 1}] do
{
    _pos = _Land_HQs select _i;
    _marker = createMarker [(format ["HQ" + "%1", _i]), _pos];
    _marker setMarkerShape "Icon";
    _marker setMarkerSize [1,1];
    _marker setMarkerType "mil_dot";
    _marker setMarkerBrush "Solid";
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerColor "ColorOrange";
    _marker setMarkerText format ["%1", _i];
    bld_HQ = bld_HQ + [_marker];
};

for [{_i = 0},{_i < (count _Land_MilOffice)},{_i =_i + 1}] do
{
    _pos = _Land_MilOffice select _i;
    _marker = createMarker [(format ["Office" + "%1", _i]), _pos];
    _marker setMarkerShape "Icon";
    _marker setMarkerSize [1,1];
    _marker setMarkerType "mil_dot";
    _marker setMarkerBrush "Solid";
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerColor "ColorYellow";
    _marker setMarkerText format ["%1", _i];
    bld_MilOffice = bld_MilOffice + [_marker];
};

for [{_i = 0},{_i < (count _Land_CargoHouse)},{_i =_i + 1}] do
{
    _pos = _Land_CargoHouse select _i;
    _marker = createMarker [(format ["HCargo" + "%1", _i]), _pos];
    _marker setMarkerShape "Icon";
    _marker setMarkerSize [1,1];
    _marker setMarkerType "mil_dot";
    _marker setMarkerBrush "Solid";
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerColor "ColorKhaki";
    _marker setMarkerText format ["%1", _i];
    bld_CargoHouse = bld_CargoHouse + [_marker];
};


/*********************************************************************************
                        Urban Markers
*********************************************************************************/
_Urb_City =
[
[7062.42,16472.1,-116.425],
[8625.13,18301.6,-179.297],
[9091.81,11961.9,-19.9013],
[9187.95,15947.8,-124.829],
[10966.5,13435.3,-28.4601],
[12282,15732.3,-23.0026],
[12502,14337,-11.5868],
[14479.8,17614.3,-21.6749],
[14612.5,20786.7,-47.0032],
[16207,17296.7,-24.3308],
[18049.1,15264.1,-28.4237],
[18753.4,16597.1,-32.1656],
[19336.9,13252.3,-37.8615],
[20194.6,11660.7,-45.8388],
[20885.4,16958.8,-49.8089],
[21351.6,16361.9,-20.5678],
[25680.5,21365.1,-20.7333],
[26944,23169.5,-18.0891]
];

_Urb_City_Name =
[
"Kore",
"Syrta",
"Zaros",
"Agios Dionysios",
"Poliakko",
"Lakka",
"Neochori",
"Gravia",
"Frini",
"Telos",
"Charkia",
"Rodopoli",
"Dorida",
"Chalkeia",
"Paros",
"Kalochori",
"Sofia",
"Molos"
];

_Urb_Village =
[
[3687.78,13776.1,-10.7639],
[3948.77,17277.8,-11.6385],
[4116.11,11736.1,-50.8535],
[4560.45,21460.6,-302.575],
[4885.98,16171.3,-77.5036],
[5033.31,11245.2,-48.317],
[7375.81,15429.5,-54.782],
[9425.42,20284,-122.26],
[10270.3,19036,-120.191],
[10410.4,17243.1,-82.7311],
[10618.9,12237.3,-16.0326],
[11112.6,14573.7,-42.5353],
[11701.1,13672.1,-12.7303],
[11786.7,18372.4,-51.9314],
[12787,19679.3,-46.1323],
[12950.1,15041.6,-28.1891],
//[14281.2,13469.3,-5.32024],
[16584.3,16104,-15.1762],
[16668.5,20487,-4.767],
[17059.7,9992.32,-21.8159],
[17826.5,18129.4,-1.99341],
[19339.4,17641.6,-37.4067],
[19473.3,15453.7,-22.9098],
[20490.2,8907.12,-34.5332],
[20769.8,6736.46,-37.9427],
[21640.7,7583.93,-14.1929],
[23199.7,19986.6,-14.2541],
[23908.6,20144.7,-14.0692]
];

_Urb_Village_Name =
[
"Aggelochori",
"Agios Konstantinos",
"Neri",
"Oreokastro",
"Negades",
"Panochori",
"Topolia",
"Abdera",
"Galati",
"Orino",
"Therisa",
"Alikampos",
"Katalaki",
"Koroni",
"Ifestiona",
"Stavros",
//"Sagonisi",
"Anthrakia",
"Agia Triada",
"Ekali",
"Kalithea",
"Agios Petros",
"Nifi",
"Panagia",
"Selakano",
"Feres",
"Ioannina",
"Delfinaki"
];

_Urb_Capital =
[
[3458.95,12966.4,-6.1822],
[13993,18709.4,-25.735],
[16780.6,12604.5,-18.9913]
];

_Urb_Capital_Name =
[
"Kavala",
"Athira",
"Pyrgos"
];

for [{_i = 0},{_i < (count _Urb_Village)},{_i =_i + 1}] do
{
    _pos = _Urb_Village select _i;
    _marker = createMarker [(format ["%1", _Urb_Village_Name select _i]), _pos];
    if (_debug) then
    {
        _marker setMarkerShape "Icon";
        _marker setMarkerSize [1,1];
        _marker setMarkerType "mil_dot";
        _marker setMarkerBrush "Solid";
        _marker setMarkerColor "ColorYellow";
    };
    if (!(_debug)) then
    {
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerSize [350,350];
        _marker setMarkerBrush "Solid";
        _marker setMarkerColor "ColorYellow";
    };
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerText format ["%1", _Urb_Village_Name select _i];
    urb_Village = urb_Village + [_marker];
};

for [{_i = 0},{_i < (count _Urb_City)},{_i =_i + 1}] do
{
    _pos = _Urb_City select _i;
    _marker = createMarker [(format ["%1", _Urb_City_Name select _i]), _pos];
    if (_debug) then
    {
        _marker setMarkerShape "Icon";
        _marker setMarkerSize [1,1];
        _marker setMarkerType "mil_dot";
        _marker setMarkerBrush "Solid";
        _marker setMarkerColor "ColorOrange";
    };
    if (!(_debug)) then
    {
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerSize [350,350];
        _marker setMarkerBrush "Solid";
        _marker setMarkerColor "ColorOrange";
    };
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerText format ["%1", _Urb_City_Name select _i];
    urb_City = urb_City + [_marker];
};

for [{_i = 0},{_i < (count _Urb_Capital)},{_i =_i + 1}] do
{
    _pos = _Urb_Capital select _i;
    _marker = createMarker [(format ["%1", _Urb_Capital_Name select _i]), _pos];
    if (_debug) then
    {
        _marker setMarkerShape "Icon";
        _marker setMarkerSize [1,1];
        _marker setMarkerType "mil_dot";
        _marker setMarkerBrush "Solid";
        _marker setMarkerColor "ColorRed";
    };
    if (!(_debug)) then
    {
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerSize [350,350];
        _marker setMarkerBrush "Solid";
        _marker setMarkerColor "ColorRed";
    };
    _marker setMarkerAlpha _mrkAlpha;
    _marker setMarkerText format ["%1", _Urb_Capital_Name select _i];
    urb_Capital = urb_Capital + [_marker];
};