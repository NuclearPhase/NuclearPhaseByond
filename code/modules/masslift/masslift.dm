#define MASSLIFT_STATE_OFF 0
#define MASSLIFT_STATE_DESCENT 1
#define MASSLIFT_STATE_BUSY 2
#define MASSLIFT_STATE_WAIT 3
#define MASSLIFT_STATE_FALL 4

/obj/effect/masslift_transit
	name = "map object"
	icon = 'icons/masslift/masslift.dmi'
	icon_state = "transit"
	var/busy = FALSE

/obj/var/can_be_transfered = TRUE
/obj/effect/masslift
	name = "masslift"
	can_be_transfered = FALSE

var/global/list/obj/effect/masslift_transit/masslift_transits = list()

/area/masslift
	name = "masslift"
	icon_state = "blue"

/area/masslift/a
/area/masslift/b
/area/masslift/c
/area/masslift/d

/obj/effect/masslift_transit/Initialize()
	. = ..()
	masslift_transits |= src

/obj/effect/masslift_transit/Destroy()
	. = ..()
	masslift_transits -= src

var/global/list/datum/masslift/masslifts = list()
// master datum
/datum/masslift
	var/status = MASSLIFT_STATE_DESCENT
	var/datum/masslift/cable/cable
	var/lift_id = "lift"
	var/depth = 0
	var/wait_end = 0
	var/obj/effect/masslift_transit/transit
	var/turf/T
	var/turf/Tup
	var/turf/Tdown
	var/last = 0

	var/list/targets = list()

/datum/masslift/New()
	. = ..()
	masslifts |= src

/datum/masslift/Destroy()
	. = ..()
	masslifts -= src

/datum/masslift/proc/get_zlevel()
	var/D = round(depth)

	switch(D)
		if(0)
			return 5
		if(100)
			return 4
		if(200)
			return 3
		if(300)
			return 2
		if(400)
			return 1
	return -1

/datum/masslift/proc/zlevel2depth(z)
	switch(z)
		if(5)
			return 0
		if(4)
			return 100
		if(3)
			return 200
		if(2)
			return 300
		if(1)
			return 400
	return -1

/datum/masslift/proc/request(z)
	targets += zlevel2depth(z)

/datum/masslift/proc/get_distance_by_power(power) // KWt
	return power / 100

/datum/masslift/proc/gen_ts()
	Tup = get_step(T, UP)
	Tdown = get_step(T, DOWN)

/datum/masslift/proc/transit(var/turf/from)
	for(var/obj/effect/masslift_transit/T in masslift_transits)
		if(!T.busy)
			transit = T
			break

	gen_ts()
	get_area(from).move_contents_to(get_area(transit), with_gases = TRUE)

/datum/masslift/proc/from_transit(var/turf/dest)
	transit.busy = FALSE
	get_area(transit).move_contents_to(get_area(dest), with_gases = TRUE)
	transit = null

/datum/masslift/proc/work()
	if(wait_end > 0)
		if(world.time > wait_end)
			wait_end = 0

			if(status == MASSLIFT_STATE_WAIT)
				transit(T)
				status = MASSLIFT_STATE_BUSY
			else
				status = MASSLIFT_STATE_DESCENT
		else
			return

	if(status == MASSLIFT_STATE_DESCENT && targets.len)
		status = MASSLIFT_STATE_BUSY
		transit(T)

	if(istype(cable) && status == MASSLIFT_STATE_BUSY)
		var/dist = get_distance_by_power(cable.power)
		var/dir = 0
		if(targets[1] < depth)
			depth = max(targets[1], depth - dist)
			dir = 1
		else
			depth = min(targets[1], depth + dist)
			dir = -1

		if(abs(depth - targets[1]) < 1)
			wait_end = world.time + 15 * TICKS_IN_SECOND
			status = MASSLIFT_STATE_DESCENT
			targets.Cut(1, 1)

			from_transit(dir < 0 ? Tdown : Tup)
			last = depth

	if(get_zlevel() > 0 && status == MASSLIFT_STATE_BUSY)
		status = MASSLIFT_STATE_WAIT
		wait_end = world.time + 15 * TICKS_IN_SECOND

		if(depth > last)
			from_transit(Tdown)
		else if(depth < last)
			from_transit(Tup)

/obj/machinery/masslift_panel
	name = "panel"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "Lift controller"
	anchored = 1.0
	use_power = 1
	idle_power_usage = 8
	active_power_usage = 16
	var/lift_id = "lift"
	var/cable_id = "id"
	var/datum/masslift/lift

/obj/machinery/masslift_panel/proc/find_lift()
	if(istype(lift))
		return

	for(var/datum/masslift/masslift in masslifts)
		if(masslift.lift_id == lift_id)
			lift = masslift
			break

	lift?.T = get_turf(loc)
	lift?.depth = lift.zlevel2depth(loc.z)

/obj/machinery/masslift_panel/proc/find_cable()
	if(!istype(lift) || istype(lift.cable))
		return
	lift.cable = masslift_cables[cable_id]

/obj/machinery/masslift_panel/attack_hand(mob/user)
	ui_interact(user)
	..()

/obj/machinery/masslift_panel/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	find_lift()
	find_cable()
	if(!istype(lift))
		return

	var/list/data = list()

	var/status = "?"
	switch(lift.status)
		if(MASSLIFT_STATE_OFF)
			status = "OFF"
		if(MASSLIFT_STATE_DESCENT)
			status = "Descent"
		if(MASSLIFT_STATE_BUSY)
			status = "Transit"
		if(MASSLIFT_STATE_WAIT)
			status = "Waiting"
		if(MASSLIFT_STATE_FALL)
			status = "FALL"
	data["status"] = status
	data["depth"] = lift.depth
	//data["targets"] = lift.targets

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "massliftpanel.tmpl", "Lift Panel", 520, 410)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)

		ui.set_auto_update()
		// open the new ui window
		ui.open()

/obj/machinery/masslift_panel/Topic(href, href_list)
	..()
	if(href_list["target"])
		var/val = text2num(href_list["target"])
		if(istype(lift))
			lift.request(val)

/obj/machinery/masslift_panel/Process()
	lift?.work()