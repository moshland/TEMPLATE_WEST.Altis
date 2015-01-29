[ 
	["Mission",
		"You are to do something."],
			
	["Situation",
		"It is cold"],
			
	["Execution",
		"1. task.
		<br /><br />2. Smoke it."],
			
	["Tips","I strongly suggest playing ARMA III with the following mods, in no particular order... 
		<br /><br />JSRS - the best complete sound package there is, never play without this
		<br /><br />TPW Mods - couldn't play without this either, adds lots of immersion and randomness with nothing game breaking for my missions
		<br /><br />more recommended mods incoming, too lazy right now...
		<br /><br />Local intelligence suggests a few weapons caches and damaged military vehicles are nearby. It would be wise you to look into these reports and explore a little.
		<br /><br />Vehicles can be repaired and refueled by acquiring repair and fuel trucks."],
			
	["Technical Details",
		"Mission  by Mosh<br/><br/>www.moshland.com<br/><img image='Mosh_images\moshpit.paa' />"],
			
	["Credits",
		"Arma III by Bohemia Interactive - Thanks for making the ultimate sandbox
		<br /><br />Music by Bohemia Interactive
		<br /><br />I know nothing abut scripting but have faked my way through thanks to posts and scripts by these people...  Celery, W0lle, Kylania, [sbs]mac, shk, Tophe, bon, Big Dawg KS, JW Custom, [FRL]Myke, to name just a few. Without you guys, and my awesome google skills, I never would have figured this shit out. I wish I could include everyone who has shared their knowledge on the BI and Armaholic Forums.
		<br /><br />Thanks for these great scripts also!
		<br /><br />=BTC= Quick revive
		<br /><br />=BTC= Revive .98
		<br /><br />AI Spawn Script Pack v0.90 by spunFIN
		<br /><br />Architect's Debugging Panel V1.1 by THumbert
		<br /><br />Battlefield Re-spawn System (BRS) .2 by BangaBob
		<br /><br />Bon's Infantry Recruitment Redux -- by Bon_Inf* and Moser
		<br /><br />Civilian Occupation System (COS) .5 by Bangabob
		<br /><br />Civilian Vehicles v1c by [STELS]Zealot
		<br /><br />Digital Loadout System (DLS) 1.4 by Iceman77
		<br /><br />Digital Loadout System Rearmed (DLSR) by Iceman77
		<br /><br />Dynamic Civilian Life 1.2 (DCL) by Nicolas BOITEUX
		<br /><br />Enemy Occupation System (EOS) 1.98 by BangaBob
		<br /><br />FAR_revive 1.5 by Farooq 
		<br /><br />FHQ Task Tracker
		<br /><br />GVS Generic Vehicle Service F by Jacmac
		<br /><br />Live feed control (LFC) 1.2 by BangaBob
		<br /><br />MAD Ambient Life 1.01 by MAD T
		<br /><br />player markers 2.6 by aeroson
		<br /><br />Random House Patrol Script 2.2 by Tophe
		<br /><br />Status Hud 1.5 by Iceman77
		<br /><br />Taskmaster 2 .42 by Shuko
		<br /><br />TAW View Distance Script 1.4  by Tonic-_- 
		<br /><br />TPWC AI Suppression System 5.5 by Ollem
		<br /><br />UPS 2.2 by Kronzky
		<br /><br />UPSMON 6.0.6.6 Cool=Azroul13
		<br /><br />VAS Virtual Ammobox System 2.6 by Tonic-_- 
		<br /><br />VVS Virtual Vehicle System .3 by Tonic-_- 
"]
    
] call FHQ_TT_addBriefing;

[                                                           // Filter
    	["task1",										// Task name
         "find the CSAT dude",				       // Task text in briefing
         "find the CSAT dude",							// Task title in briefing
         "find the CSAT dude",											// Waypoint text
         getmarkerpos "task_1"											// Optional: Position or object
														// Optional: Initial state
        ]
		
] call FHQ_TT_addTasks;


