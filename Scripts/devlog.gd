#devlog

#august
	##19/08
	#began
	#22:24
	#just added mouselook functionality and a cursor. Got basic movement down and i will most likely push this to github now.
	#21/08
	#10:25
	#planning to migrate some old assets from dustrialis onto here simply for temporary graphical quality.
	#as i get home i plan to immediately start work on an inventory system similar to the one i made for dustrialis.
	#This game shall carry the heart and soul of dustrialis but in another form.
	#after all they are quite similar.
	#
	##24/08
	#22:22
	#i will now begin NPC functionality.
	#combat will be turn based, Fairly simple afaik. Implementing the actual system for it wont be too hard but making the ai work is a whole other story.
	#im kind of skeptical about making a non grid turn based isometric game but i trust itll work.
	#22:46
	#got the most basic of NPC rigs active. Now i got to set up pathfinding so i can get some actual npc behaviours running
	#23:18
	#ive got the basic behaviour I.E most of the basic actor system down. I will now go to bed
	#
	##25/08
	#08:58
	#today i shalt finish up the last of the actor system and begin work on the combat, inventory or ability systems.
	#12:53
	#scrap turn based were going full diabolo
	#18:42
	#finished ability for NPCs to speak, not the full dialogue system of course.
	#22:35
	#planning to implement the director now
	#typing in here to not do so in any documents, each game chapter (or reincarnation) is fairly long but split into parts, Each time you complete a part you kinda prestige and only bring with you that which is bound to your soul and go on to the next part.
	#23:00
	#added the basic function for adding everything in and thus adding the basis for the save function.
	#23:28
	#got the basics of a window for the menu up and running.
	#
	##26/08
	#13:23
	#i have an oppurtunity
	#14:29
	#just finished up saving and loading. twas not easy.
	#
	##28/08
	#14:10
	#one might observe that the saving only saves locally. 
	#Thats because godot is an evil piece of software coded for the displeasure of he who wishes to make anything but phone games.
	#it will be put off for now as i prioritize spells/inventory.
	#18:37
	#forgot to log but ive been working on the gui for a while now.
	#
	##29/08
	#10:45
	#finished ui styling yesterday forgot to push doey
	#
	##30/08
	#19:37
	#been working on UI
	#
	##31/08
	#14:00
	#been working even more on UI
	#22:10
	#i was thinking of getting some coding done.
	#22:50
	#finished up some more functionality for the spells

#september
	##01/09
	#09:55
	#this is the first actual pass or whatever we have in our gymnasiearbete, which i assume whoever dares read this knows is what this game is for.
	#loke requested something, shut up bitch #ignored !!!
	#10:39
	#i am kind of lost as to how to make an inventory but im chipping away at it from the remnants of how i remember it working. wml
	#11:15
	#having the absolute basics set up it is time to figure out the NIGHTMARE that is picking items up. I remember this not so fondly from dustrialis and i fear it yet.
	#if i remember correctly dustrialis handled the picking up in some spaghetti between the inventory and item node but i think im going to handle such things from the inventory now.
	#12:12
	#finished up the basic inventory system. Its now time for the menu(for equipping and whatnot)
	#12:54
	#finished spell equipping
	#13:01
	#added a much tuffer placeholder icon
	#13:12
	#improved the item menu and added ability to discard
	#13:40
	#implemented spell cost
	#13:45
	#i do not know what to do now
	#14:05
	#oh my god bruh
	#14:21
	#added equip/unequip to the dropdown, unassign
	#14:46
	#added a heal spell
	#15:12
	#added rudimentary health and mana bars
	#16:15
	#on the train now, finished basics for a lightning strike ability
	#18:18
	#managed to fix the evil bug preventing spell replacing from working fully
	#18:47
	#finally managed to fix all the spell issues that i know of
	#i do not know what to do now.
	#19:12
	#finished a sexy ass lightning bolt and doubled the debugger errors
	#22:32
	#made a whole lot of bullshit im done for today
	#
	##03/09
	#10:59
	#missed out on coding all of yesterday. Today i need to implement more systematic menus (settings, pause that kinda stuff)
	#i also need to implement fancy stuff like item quantities and that kinda stuff.
	#11:05
	#i will now implement a pause menu. The whole scale issue is very annoying.
	#13:02
	#finished up basic pause menu, settings menu and setting saving.
	#13:09
	#started implementing resolution change. Will finish once able to work again.
	#13:45
	#finished adding resolution to settings menu
	#
	##04/09
	#10:36
	#it is today that the big development day shall happen.
	#i will now do minor bugfixed
	#11:19
	#idek what to do bro i gotta implement quests shiiet
	#straight up stole the quest class from dustrialis. This means ill have to add dialogue. Shit.
	#12:12
	#soon done with the dialogue system
	#12:42
	#finished basic dialogue i will now never code again
	#14:42
	#i really should add leveling. Instead i shall begin work on a simple test map
	#14:51
	#realized mapping in blender is a futile effort so i shall begin setting up trenchbroom.
	#15:13
	#set trenchbroom up and made a test map. I will need to add some sort of fancy shader to make stuff thats in the way of the character be kinda shadowed.
	#i will try to start that at least now
	#15:26
	#easier than expected
	#
	##06/09
	#23:02
	#really been lacking. only writing this to say i finally managed to figure out entities in trenchbroom.
	#
	##07/09
	#09:45
	#i wish to get shit done today. I think i will implement doors and interiors. Simply because im way too lazy to actually finish the dialogue/quest system
	#no fuck that ill make some cool models
	#13:40
	#been doing a whole lot of bullshit
	#14:49
	#redid the mouselook/cursor function
	#im just wasting my fucking time i gotta implement quests into dialogue, just finish the dialogue in general (AND CHANGE ITS FONT !!!)
	#finish the actual functionalities of dialogue (conditions, quests)1
	#15:29
	#im starting to lose it i dont want to touch any of this this game will suck ass and im the only one putting any effort into it
	#18:02
	#i dont know what to do
	#20:29
	#after a bunch of tomfoolery ive managed to fix the issues surrounding spells misfiring.
	#21:29
	#added a cool lantern
	#21:44 
	#fully implemented said lantern.
	#
	##08/09
	#00:40
	#i mean i got jack nor shit done today but the game made huge progress
	#how
	#also the game is running REALLY slowly so i really need to optimize some things.
	#i think its time for the ticks.
	#01:04
	#finished a tick and update system. This will be inconvenient in the future but i managed to get process time down to a third.
	#of course getting it down to a third is because i only run at a third.
	#01:15
	#ive optimized a bunch and realized a crucial flaw. Software rendering.
	#of course the process time and rendering time somehow correlate when its the same spyware laden chip doing it.
	#shite
	#09:52
	#going to start off by adding shadow size to settings.
	#10:00
	#I believe ive at the very least added basic functionality for changing the shadow size.
	#22:07
	#ive not really gotten much done today outside of mapping and textures.
	#began work on FULL london map.
	#
	##10/09
	#17:17
	#i havent written anything here but ive been working.
	#
	##14/09
	#10:57
	#i am deeply sorry for not doing much.
	#ive been trying to figure out this fuck ass tram for long now it just refuses to work completely.
	#god i wish i could license malice mizer for this.
	#11:01
	#honestly godot is such a strange engine i dont understand it sometimes, why do characterbodies get stuck, why do pathfollowers start at origin???
	#11:09
	#managed to fix the root issue but now it isnt moving at all.
	#11:20
	#i managed to get the tram working. what a strange system
	#11:34
	#upon adding a second tram line it for some strange reason only adds one. Shit
	#12:20
	#trams working now. They only need models, tracks and some fancy animations.
	#13:53
	#added an insanely ugly model for the tram. Crashing out soon
	#14:02
	#i dont even want to do this anymore
	#14:19
	#fixed a bug with the trams, feeling like im gonna lose it.
	#14:21
	#i need to get some actual work done so im gonna implement the character sheet.
	#17:03
	#i am home now. I will immediately do the things ive been forgetting to. (I.E migrating the id handler to be a global class.
	#17:34
	#fixed some odd issues and improved leveling system. It still only supports magic though. I will attempt to add other stats
	#17:53
	#implemented agility leveling.
	#for some strange reason i cant enter locations anymore
	#17:59
	#i had for some reason placed literally ONE if check on tick as if that was gonna do anything which caused it to only work if it was overlapping with the tick
	#and for some reason the trams STILL break upon going out and in
	#
	##15/09
	#09:57
	#ive been fucking around for a few minutes and i think ill go get a coffee and then fix the dialogue system.
	#or should i work on making sound for the game?
	#09:58
	#fuck music i must get this dialogue system working
	#10:34
	#successfully implemented quests within dialogue and such
	#i will now grab another cup and get to work on making the dialogue menu better,
	#making a quest menu and some other bullshit.
	#must say im quite proud of the notification stuff.
	#ALSO THIS IS VERY IMPORTANT SET THE DIALOGUE FONT TO MS GOTHIC
	#LOOK UP THE RIGHTS FIRST THOUGH
	#10:51
	#finished up improvements to the dialogue menu. Of course i use ms gothic, since i legally own windows i can legally MAKE REFERENCE to MS gothic.
	#of course i can not bundle it with the game but since i already have it on my mac its all good and as long as one has it installed it should work no matter the system
	#of course there is a fallback.
	#i will now commit, push and then get to work on a quest menu.
	#10:55
	#i moved the check dialogue function from tick to process. No idea why i even put inputs in tick to begin with its retarded and it breaks everything.
	#anyways time to get a dialogue system going.
	#11:38
	#finished the quest tracker. time to push it.
	#12:05
	#added support for sfx. I will now add ambience.
	#12:15
	#idrk what to do now
	#i gotta add item quantities
	#12:23
	#trying to add a consumable but for some strange reason the timer for it only triggers once.
	#why the fuck is it like this
	#12:29
	#i am the most retarded man on the planet. i had forgotten that the heal spell gives you like a trillion xp
	#12:34
	#fixed the bug and commented most of the debugging prints
	#12:48
	#updated minimum size. Done for this period.
	#16:45
	#minor adjustments. Once i get home i will start making big things.
	#i will need to make a good enemy ai, matter of fact several.
	#i will also need to make a dash ability. just make a "spell" that increases your speed tenfold for 0.2 seconds
	#also i need to nerf leveling
	#21:38
	#ive spent a while now mapping. Result looks like it was pushed out of my anus
	#
	##17/09
	#10:51
	#good day. been kinda stuck. i will now implement zones.
	#17:53
	#highk forgot to actually do that so ill do so now.
	#
	##18/09
	#09:50
	#been really lacking as of late. i never even implemented the goddamned zones. Matter of fact i think im going to focus primarily on writing today.
	#nevermind today i shall add a simple enemy.
	#i will need to implement signals into enemies and then add a separate monitor node that takes all these signals and does something with them.
	#10:08
	#finished a very basic enemy ai. im considering scrapping the trams. THey dont work thematically
	#10:11
	#removed trams, or atleast made them not be used.
	#10:20
	#added said monitor
	#10:29
	#added so that if an enemy is alerted it will alert the enemies nearby.
	#11:48
	#almost done adding status effects
	#12:24
	#effects implemented.
	#13:08
	#i fucked the inventory up big time.
	#13:14
	#fixed the bug and managed to add level unlocks and a dash ability.
	#i wonder if its time to start making dungeons soon
	#i am enslaving mikhail and forcing him to actually work. poor guy has to actually do something.
	#13:52
	#further implemented a basic test quest. I believe that the game is at a playable state now and that all that needs to be added is all the assets.
	#13:57
	#its time to start playtesting. I will implement a basic info screen in the pause that contains info kinda like i did in dustrialis and i will polish some stuff
	#14:15
	#implemented hiding of options
	#14:29
	#i believe ive added most of the polish needed to start the playtest i just gotta inform about the leveling.
	#14:31
	#i will now build and upload playtest.
	#14:39
	#ive now uploaded the builds
	#
	##19/09
	#10:24
	#borodji is here now. i will try to get some work done.
	#16:23
	#the update is practically fucking everything up. upon lowering the update rate from 10 to 2.5 the fps goes from 25 to appearing smooth (but somehow not being smooth fps wise)
	#
	##20/09
	#17:28
	#i have found out that culling wasnt set up. how wise of me.
	#anyhow i need to set somethings up in the settings menu. Most notably max fps, vsync, whether or not to use culling (why would you not)
	#
	##21/09
	#10:05
	#im planning to get atleast something done today. I honestly think i will add in malice mizer as a placeholder. Also i gotta get to work on a main menu soon.
	
