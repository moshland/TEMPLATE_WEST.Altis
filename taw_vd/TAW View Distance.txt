Welcome! Thank you for using TAW's View Distance Script!
This script can be easily implemented into your mission to give your player base the ability to adjust view distances for:

While on foot
While in a car / boat
While in Aircraft

And also gives them the ability to disable grass for those that have performance issues!

To install this system simply place the follow code below someone in your description.ext
#include "taw_vd\dialog.hpp"

class CfgFunctions
{
	#include "taw_vd\CfgFunctions.hpp"
};

If CfgFunctions already exists then put #include "taw_vd\CfgFunctions.hpp" in it.

To disable the grass Option 'None' place:
tawvd_disablenone = true;

in your init.sqf

Changelog:
v1.2:
Changed: Updated the script version to be on par with the addon (updated technologies).
Added: Ability to disable the grass option 'None'

v1.1
Fixed: JIP players couldn't use the menu

And you are done! You can then access the menu by scrolling on your mouse wheel and selecting 'Settings' in red and your done!
This was created by Tonic of TAW (The Art of Warfare).