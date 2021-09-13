/obj/machinery/power/massslift/powerplant/unit
	icon = 'icons/masslift/powerplant.dmi'
	icon_state = "unit"
	var/obj/machinery/power/massslift/powerplant/core/core = null
	use_power = 0
	idle_power_usage = 1000

	anchored = 0
	density = 1
	

/obj/machinery/power/massslift/powerplant/unit/attackby(obj/item/O, mob/user)
	. = ..()
	if(isWrench(O))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		use_power = anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet.")

		if(anchored)
			var/obj/machinery/power/massslift/powerplant/core/C = locate(/obj/machinery/power/massslift/powerplant/core/, get_step(loc, dir))
			if(!istype(C))
				user.visible_message("The bolts holding [src.name] to the floor unsecures suddenly.", \
					"You failed to secure [src] to core.", \
					"You hear a electrical ratchet.")
				anchored = FALSE
			else
				core = C
				C.units |= src
				user.visible_message("[user.name] secures the bolts connecting [src.name] to the [C].", \
					"You secure the bolts holding [src] to the [C].", \
					"You hear a ratchet")
		else
			if(istype(core))
				user.visible_message("The bolts holding [src.name] to the [core] unsecures suddenly.", \
					"[src.name] unsecures from [core].", \
					"You hear a electrical ratchet.")
				core.units -= src
				core = null


/obj/machinery/power/massslift/powerplant/core
	icon = 'icons/masslift/powerplant.dmi'
	icon_state = "core"
	var/list/obj/machinery/power/massslift/powerplant/unit/units = list()
	var/datum/masslift/cable/cable = null

	anchored = 0
	density = 1

	use_power = 1
	idle_power_usage = 10000

	var/datum/masslift/lift
	var/ncable_id = null
	var/will_be_anchored = FALSE

/obj/machinery/power/massslift/powerplant/core/proc/update_cable()
	var/obj/masslift/cable/C = locate(/obj/masslift/cable, loc)

	if(istype(C) && istype(cable))
		return

	if(!istype(C))
		var/obj/masslift/cable/Cu = locate(/obj/masslift/cable, get_step(src, UP))
		var/obj/masslift/cable/cab = new /obj/masslift/cable(loc)
		cab.cable_id = Cu ? Cu.cable_id : (ncable_id || get_random_masslift_id())
		cable = cab.get_cable()

/obj/machinery/power/massslift/powerplant/core/Process()
	if(!anchored && will_be_anchored)
		will_be_anchored = FALSE
		anchored = TRUE
		lift = new
		
	if(!anchored || !powered())
		return

	update_cable()
	. = ..()

/obj/machinery/power/massslift/powerplant/core/attackby(obj/item/O, mob/user)
	. = ..()
	if(isWrench(O))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		use_power = anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")

		if(anchored)
			lift = new
		else
			QDEL_NULL(lift)