// controlled resistance cable.

/obj/structure/cable/controlled
	name = "heating cable"
	desc = "A cable with controlled resistance for heating air."
	resistance = CABLE_1MM_RESISTANCE / 100
	color = COLOR_BLACK

/obj/structure/cable_controller_beacon
	name = "cable controller beacon"
	desc = "A cable controller beacon used to control heating cables."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccbeacon"
	var/_id

/obj/machinery/cable_controller
	name = "cable controller"
	desc = "A cable controller used to control heating cables."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccpanel"
	var/_id
	var/obj/structure/cable_controller_beacon/beacon

/obj/machinery/cable_controller/proc/find_beacon()
	if(beacon)
		return beacon
	for(var/obj/structure/cable_controller_beacon/B)
		if(B._id == _id)
			beacon = B
			return beacon

/obj/machinery/cable_controller/proc/find_cables()
	if(!beacon)
		return

	. = list()
	for(var/obj/structure/cable/controlled/C in get_area(beacon).contents)
		. += C

/obj/machinery/cable_controller/proc/get_first_cable()		
	if(!beacon)
		return
	return locate(/obj/structure/cable/controlled) in get_area(beacon).contents

/obj/machinery/cable_controller/OnTopic(var/mob/user, href_list, state)
	if(!find_beacon())
		to_chat(user, SPAN_DANGER("Connection failed."))
		return
	
	if (href_list["adj"])
		var/list/obj/structure/cable/controlled/cables = find_cables()

		var/diff = text2num(href_list["adj"])

		var/newresistance = between(CABLE_1MM_RESISTANCE / 100, cables[1].resistance + diff, CABLE_1MM_RESISTANCE)

		for(var/obj/structure/cable/controlled/C in cables)
			C.resistance = newresistance

		return TOPIC_REFRESH

/obj/machinery/cable_controller/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/cable_controller/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!find_beacon())
		to_chat(user, SPAN_DANGER("Connection failed."))
		return


	var/list/data = list()

	var/obj/structure/cable/controlled/FC = get_first_cable()
	data["resistance"] = FC.resistance
	var/turf/T = get_turf(FC)
	var/datum/gas_mixture/air = T.return_air()
	data["temperature"] = air.temperature - T0C
	data["amperage"] = FC.powernet.get_amperage()
	data["minresistance"] = CABLE_1MM_RESISTANCE / 100
	data["maxresistance"] = CABLE_1MM_RESISTANCE

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "cable_controller.tmpl", "Cable controller", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(FALSE)