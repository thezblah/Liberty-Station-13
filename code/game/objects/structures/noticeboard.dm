#define MAX_NOTICES 5

/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	density = FALSE
	anchored = TRUE
	var/notices = 0

/obj/structure/noticeboard/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(notices >= MAX_NOTICES)
			break
		if(istype(I, /obj/item/paper))
			I.loc = src
			notices++
	icon_state = "nboard0[notices]"


//attaching papers!!
/obj/structure/noticeboard/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/paper))
		if(notices < MAX_NOTICES)
			O.add_fingerprint(user)
			add_fingerprint(user)
			user.drop_from_inventory(O)
			O.loc = src
			notices++
			icon_state = "nboard0[notices]"	//update sprite
			to_chat(user, SPAN_NOTICE("You pin the paper to the noticeboard."))
		else
			to_chat(user, SPAN_NOTICE("You reach to pin your paper to the board but hesitate. You are certain your paper will not be seen among the many others already attached."))

/obj/structure/noticeboard/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/noticeboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoticeBoard", name)
		ui.open()

/obj/structure/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["allowed"] = allowed(user)
	data["items"] = list()
	for(var/obj/item/content in contents)
		var/list/content_data = list(
			name = content.name,
			ref = REF(content)
		)
		data["items"] += list(content_data)
	return data

/obj/structure/noticeboard/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/obj/item/item = locate(params["ref"]) in contents
	if(!istype(item) || item.loc != src)
		return

	var/mob/user = usr

	switch(action)
		if("examine")
			if(istype(item, /obj/item/paper))
				item.examine(user)
			else
				user.examinate(item)
			return TRUE
		if("remove")
			if(!allowed(user))
				return
			remove_item(item, user)
			return TRUE

/**
 * Removes an item from the notice board
 *
 * Arguments:
 * * item - The item that is to be removed
 * * user - The mob that is trying to get the item removed, if there is one
 */
/obj/structure/noticeboard/proc/remove_item(obj/item/item, mob/user)
	item.forceMove(drop_location())
	if(user)
		user.put_in_hands(item)
		//balloon_alert(user, "removed from board")
	notices--
	icon_state = "nboard0[notices]"

// put actual, filled noticeboards here. These are for adding actual notices via code. Be careful! Anything written here will likely be taken as law by those that read them

/obj/structure/noticeboard/marshal
	name = "Marshal bulletin board"
	desc = "A board containing vital notices and official memos for Marshal Officers."
	icon_state = "nboard03"
	notices = 3

/obj/structure/noticeboard/marshal/New()
//add some memos, make sure to break them up so it's relatively readable in code!
	var/obj/item/paper/P = new()
	P.name = "Memo RE: Equipment handling"
	P.info = "<br>Officers and Troopers alike, remember to properly secure lockers and weaponry. This is not a daycare, you should not need to be reminded that duty-gear is not to be left lying around and unsecured - Agent Sanja"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

	P = new()
	P.name = "Memo RE: Recorder"
	P.info = "<br>A small note for all personnel, new and old alike. It has come to our attention that there is a fatal operating error in the software of handheld universal recorders that causes them to make \
	audio files inaccessible should the file fill up. Make a note of it, and switch to a new file BEFORE the recorder turns off due to a full-file, the techies are getting a bit tired of recovering data from these broken files - Ranger Doe"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

	P = new()
	P.name = "Memo; Daily Routine"
	P.info = "<hr><hr><b><center>Daily Routine check list</b><br><small>Marshal E.R.T. Officer Moore</small></center><hr> <ul><li>Record checks <small>{Every hour or when needed. Keeping our eyes on the past and those around us is key to stopping any issues that may fall on the colony. As the old saying goes 'The devil hides in the details'.}</small> \
<li> Clearing hallway maintenance tunnels and any potential dangers <small>{The main point is to avoid any local vermin from wandering into the hallways and to reduce any potential injuries. Take it slow if you must and bring back up when needed. You're the last line of defence for the colony when others fail or are too weak to defend themselves. Stay alive and stay smart}</small><li> Scocial presence and patrols \
<small>{Our job is not to sit around and hide in our box, get out there and keep the public trust with a simple 'Hello' and asking about their day. We're what they look to for support when times get tough. Keep your eyes open for possible infractions and always represent the marshals with the safety of the colony in mind}</small> <li> Study and training\
<small>{It's not a shameful thing to look back on your knowledge for help, some days we all need a hand. Being able to keep an active mind like steel and the ability to accurately divine the law will be a well  used skill. Much like our local church they teach us to keep body spirit and mind in balance, so to must we learn to improve on these with mental drills, situational training with our team, and rest when we need it.}</small></ul> <hr><hr>"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

	P = new()
	P.name = "Instructions; Bullet Fabrication Operation"
	P.info = "<br>An instructional guide to the usage of our newly aquired bullet fabricator. <br> - Do <b>NOT</b> stick your hand in it. <br> - Do <b>NOT</b> stick your head in it. <br> - Do <b>NOT</b> insert wood into it. <br> - The <b>better</b> quality of the resources inserted, the more ammo you can print; including refined scrap."
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

/obj/structure/noticeboard/blackshield
	name = "Blackshield bulletin board"
	desc = "A board containing vital notices and official memos for the Blackshield Militia"
	icon_state = "nboard02"
	notices = 2

/obj/structure/noticeboard/blackshield/New()
	var/obj/item/paper/P = new()
	P.name = "Memo RE: Equipment handling"
	P.info = "<br>Officers and Troopers alike, remember to properly secure lockers and weaponry. This is not a daycare, you should not need to be reminded that duty-gear is not to be left lying around - Agent Sanja"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

	P = new()
	P.name = "Memo RE: Gate procedure"
	P.info = "<br>This is a firm reminder to all Blackshield Personnel to draw their attention to the Gate Operations section of S.O.P, <b>particularly</b> the section detailing proper bolting of the gate when present and \
	<b><i>UNBOLTING</b></i> of the gate when NOT present. The next trooper to get a fax sent because he left the foreman bolted outside is going to be scrubbing the latrines with his toothbrust - Sgt Dansen"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

/obj/structure/noticeboard/medical
	name = "Medical bulletin board"
	desc = "A board containing vital notices and official memos for CAPSA Medical"
	icon_state = "nboard01"
	notices = 1

/obj/structure/noticeboard/medical/New()
	var/obj/item/paper/P = new()
	P.name = "Memo RE: Initial setup"
	P.info = "<br>Note to all biolab staff:<br> Please remember to set up the cryo cooler to 80K, attach anesthetic tanks to the surgery stands and make the following basic chems -<br><ul> <li> Bicaridine<br><li> Keloderm (1 part Kelotane, 1 part Dermaline)<br>\
	<li> Carthatoline<br><li> Dexalin Plus (in 5u pills)<br> <li> Tramadol (in 5u pills)<br><li> Sanguinum<br><li> Peridaxon using the leftover Cronexadone<br><li> Cronexadone (to be mixed in two parts with the beakers next to the cryo tubes)</ul><br>Thank you Dears - Dr M. Bright"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P


/obj/structure/noticeboard/research
	name = "Research bulletin board"
	desc = "A board containing vital notices and official memos for the Phokorus Institute research"
	icon_state = "nboard00"
	notices = 1

/obj/structure/noticeboard/research/New()
	var/obj/item/paper/P = new()
	P = new()
	P.name = "Memo RE: Ameridian handling"
	P.info = "Remember, when dealing with Ameridian Crystals, to :<ol> \
	<li> Wear a Radiation Suit. The crystals are radioactive with a radius of 2 meters, and the small ones are as radioactive as the grown ones.\
	<li> Let the crystals grow. Only a fully grown crystal will spread and allow for a sustainable field.\
	<li> Not let it grow out of control. If enough fully matured crystals are close enough together, golems can appear.\
	<li> Retreat past the Sonic Fence if golems appear. The Sonic Fence will instantly destroy the golems that touches it. You can also use the Handheld Sonic emitter to destroy the golem.\
	<li> Not turn off the Sonic Fence or allow it to be turned off. The Sonic Fence is a perfect containment to Ameridian, when it is active. If it turned off, the crystal will be able to spread out of control. If it needs to be turned off for whatever reason, either keep an eye on the crystals, or harvest them all to prevent unwanted spread.\
	<li> Reseed the field. In case the field get removed completely, more crystals can be seeded with either 5 ameridian shard, or by splashing at least 10u of Liquid Ameridian on the floor.\
	<li> Refine the shards. While Ameridian is valuable on its own, it's true value can only be used when refining it into Liquid Ameridian using an Ameridian Refinery, after which it can be further transformed into regular materials in the Liquid Ameridian Processor.\
	<li> Carry the shards through the fence. Your body interfere with the Sonic Fence, allowing you to carry ameridian shards through the fence. The same cannot be said for dragged or thrown crystals, which will get destroyed on contact. Do not throw money away.</ol> "
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

/obj/structure/noticeboard/guild
	name = "Artificers Guild bulletin board"
	desc = "A board containing vital notices and official memos for the colonies resident Guild"
	icon_state = "nboard00"
	notices = 0

/obj/structure/noticeboard/prospectors
	name = "Fontaine bulletin board"
	desc = "A board containing vital notices and official memos for the colonies most underappreciated trashmen"
	icon_state = "nboard00"
	notices = 0

/obj/structure/noticeboard/Skylight_service
	name = "Skylight Shipping bulletin board"
	desc = "A board containing vital notices and official memos for Skylight-Service Employees"
	icon_state = "nboard00"
	notices = 0

/obj/structure/noticeboard/Skylight_supply
	name = "Skylight Shipping bulletin board"
	desc = "A board containing vital notices and official memos for Skylight-Supply Employees"
	icon_state = "nboard00"
	notices = 2

/obj/structure/noticeboard/Skylight_supply/New()
	var/obj/item/paper/P = new()
	P.name = "Memo RE: Mining Drills"
	P.info = "<ul><li>seismic activity 1: The lowest possible pretty much. Should be a cakewalk even if you've got basic equipment or don't quite know what you're doing just yet. \
	The scariest you'll run into is a spitter or two, at worst maybe a singular warrior. It'll also be only two burrows per drill, each spewing out groups of three until you smash'em. \
	<li>Seismic activity 2: The biggest difference between 1 and 2 is the fact that the chances for warriors, spitters or worse is higher. Otherwise it is just three burrows that spit out groups of three. \
	<li> Seismic activity 3: While we stay with only three burrows, each of them will now spew out four termites up until you break it, also at a faster rate. \
	<li>Seismic activity 4: Four burrows, four termites and a relatively high chance for beefier termites to show up. \
	<li> Seismic activity 5: Five burrows, four termites. At this point you can expect termites almost every minute out of a burrow, and a burrow every two minutes. Should have some serious firepower if you wanna tackle that. \
	<li> Seismic activity 6: SEVEN BURROWS. FIVE TERMITES. Expect basically ONLY the beefy motherfuckers and get ready to BEAT SHIT DOWN FAST. THEY ARE COMING, AND THERE ARE MANY. Now it's literally two minutes between burrows and only sixty seconds between large groups coming from them. \
	<b>Do not put your drill on an activity 6 spot if you ain't prepared for it, stuff WILL get out of hand, you WILL be overrun.</b></ul><br>Yeah that's about it, see ya'.<br>\
P.S - <u><h1>Don't leave the drills running unattended!</u></h1>"
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P

	P = new()
	P.name = "Memo RE: Ameridian handling"
	P.info = "Remember, when dealing with Ameridian Crystals, to :<ol> \
	<li> Wear a Radiation Suit. The crystals are radioactive with a radius of 2 meters, and the small ones are as radioactive as the grown ones.\
	<li> Let the crystals grow. Fully grown crystals are the best to harvest as they give the most.\
	<li> If you need to leave, DONT DESTORY THE SPIRE UNLESS NESSARY. You can let it spread out and clear the golems, and then walk away safely, golems only grow when new shards uproot up.\
	<li> Golems will only grow when a new shard growth is spread. Meaning if you let the main spire grow out its maximum  amount clearing all the golems, the area is safe from any golems regrowing, but not the radiation.\
	<li> Crystals grown from the spire itself can also spread to its neighboring area, the offspring of these lesser growths can not spread.\
	<li> You can also use the Handheld Sonic emitter to destroy the golem, using said Sonic emitter will not result in you getting extra shards from the golems, or from the crystals if used.\
	<li> Refine the shards. While Ameridian is valuable on its own, it's true value can only be used when refining it into Liquid Ameridian using an Ameridian Refinery, after which it can be further transformed into regular materials in the Liquid Ameridian Processor.\
	<li> If you set up a Sonic Fence, carry the shards through the fence. Your body interfere with the Sonic Fence, allowing you to carry ameridian shards through the fence. The same cannot be said for dragged or thrown crystals, which will get destroyed on contact. Do not throw money away.</ol> "
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P


/obj/structure/noticeboard/church
	name = "Church of the Bonfire bulletin board"
	desc = "A board containing vital notices and official memos for the faithful"
	icon_state = "nboard00"
	notices = 0
/*
/obj/structure/noticeboard/church/New()

	var/obj/item/paper/P = new()  write this later, idr the steps
	P.name = "Memo RE: Bio-gen troubleshooting"
	P.info = "<br> "
	P.copy_overlays(list("paper_stamp-dots"), TRUE)
	P.stamped &= STAMP_FACTION
	src.contents += P
	*/
#undef MAX_NOTICES
