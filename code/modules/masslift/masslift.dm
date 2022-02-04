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
/area/masslift/e

/obj/effect/masslift_transit/Initialize()
	. = ..()
	masslift_transits |= src
	icon_state = ""

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
	var/datum/cord/C
	var/last = 0

	var/list/targets = list()

/datum/masslift/New()
	. = ..()
	masslifts |= src

/datum/masslift/Destroy()
	. = ..()
	masslifts -= src

/datum/masslift/proc/get_zlevel(lvl)
	var/D = round(lvl)

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

/datum/masslift/proc/apply_move_effect(var/mob/living/carbon/human/H)
	shake_camera(H, 20, 3)
	var/is_safe = H.buckled

	if(!is_safe && H.grab_restrained())
		for(var/obj/item/grab/G in H.grabbed_by)
			if(G.assailant.buckled)
				is_safe = TRUE
				break

	if(is_safe)
		return

	if(get_distance_by_power(cable.power) > 100)
		H.gib() // ;(
		return

	H.Paralyse(1)
	if(depth > last)
		switch(rand(1, 3))
			if(1 to 2) // body fall
				for(var/organ in list(BP_GROIN, BP_CHEST))
					H.apply_damage(get_distance_by_power(cable.power) * 0.5, BRUTE, organ)
			if(3) // head fall
				H.apply_damage(get_distance_by_power(cable.power) * 0.25, BRUTE, BP_HEAD)

	else
		switch(rand(1, 6))
			if(1 to 3) // legs hit
				for(var/organ in pick(list(BP_L_LEG, BP_L_FOOT, BP_R_FOOT), list(BP_R_LEG, BP_R_FOOT, BP_L_FOOT)))
					H.apply_damage(get_distance_by_power(cable.power) * 0.8, BRUTE, organ)
			if(4 to 5) // body hit
				for(var/organ in list(BP_GROIN, BP_CHEST))
					H.apply_damage(get_distance_by_power(cable.power) * 0.5, BRUTE, organ)

			if(6) // head hit
				H.apply_damage(get_distance_by_power(cable.power) * 0.25, BRUTE, BP_HEAD)
/datum/masslift/proc/transit()
	for(var/obj/effect/masslift_transit/T in masslift_transits)
		if(!T.busy)
			transit = T
			break
	. = transit ? TRUE : FALSE
	if(transit)
		get_area(C.to_turf()).move_contents_to(get_area(transit), with_gases = TRUE)

	for(var/mob/living/carbon/human/H in mobs_in_area(get_area(transit)))
		apply_move_effect(H)


/datum/masslift/proc/from_transit(var/datum/cord/dest)
	transit.busy = FALSE
	get_area(transit).move_contents_to(get_area(dest.to_turf()), with_gases = TRUE)
	transit = null
	for(var/mob/living/carbon/human/H in mobs_in_area(get_area(dest.to_turf())))
		apply_move_effect(H)

/datum/masslift/proc/work()
	if(wait_end > 0)
		if(world.time > wait_end)
			wait_end = 0
			status = MASSLIFT_STATE_DESCENT
		else
			return

	if(istype(cable) && status == MASSLIFT_STATE_BUSY)
		var/dist = get_distance_by_power(cable.power)
		if(targets[1] < depth)
			depth = max(targets[1], depth - dist)
		else
			depth = min(targets[1], depth + dist)

	if(get_zlevel(depth) > 0 && status == MASSLIFT_STATE_BUSY)
		status = MASSLIFT_STATE_WAIT
		wait_end = world.time + 15 SECONDS

		if(depth > last)
			from_transit(C.make_step(DOWN))
		else
			from_transit(C.make_step(UP))
		last = depth

		if(get_zlevel(depth) == get_zlevel(targets[1]))
			targets.Remove(round(depth))
			status = MASSLIFT_STATE_DESCENT

	if(status == MASSLIFT_STATE_DESCENT && targets.len && transit())
		status = MASSLIFT_STATE_BUSY
		last = depth
		wait_end = 0

/obj/machinery/masslift_panel
	name = "panel"
	icon = 'icons/obj/masslift.dmi'
	icon_state = "panel"
	desc = "Lift controller"
	anchored = 1.0
	use_power = 1
	idle_power_usage = 64
	active_power_usage = 128
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

	lift?.C = get_cord(loc)
	lift?.depth = lift.zlevel2depth(loc.z)

/obj/machinery/masslift_panel/proc/find_cable()
	if(!istype(lift) || istype(lift.cable))
		return
	lift.cable = masslift_cables[cable_id]

/obj/machinery/masslift_panel/attack_hand(mob/user)
	tg_ui_interact(user)
	..()

/obj/machinery/masslift_panel/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	find_lift()
	find_cable()
	if(!istype(lift))
		return

	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "masslift_panel", name, 300, 300, master_ui, state)
		ui.set_autoupdate(1)
		ui.open()

/obj/machinery/masslift_panel/ui_data(mob/user)
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
			status = "Falling"
	data["status"] = status
	data["depth"] = lift.depth
	data["zlevel"] = lift.get_zlevel(round(lift.depth, 100))
	data["depth_max"] = lift.zlevel2depth(1)
	data["requests"] = lift.targets

	return data

/obj/machinery/masslift_panel/ui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("request")
			var/val = params["zlevel"]
			lift?.request(val)

/obj/machinery/masslift_panel/update_icon()
	. = ..()
	overlays.Cut()

	if(!istype(lift))
		return

	var/level = lift.get_zlevel(round(lift.depth, 100))
	if(level < 1 || level > 5)
		level = lift.get_zlevel(lift.last)
	overlays += image(icon, "[level]")
	if(lift.status != MASSLIFT_STATE_OFF)
		overlays += image(icon, "on")

	var/status = null
	switch(lift.status)
		if(MASSLIFT_STATE_DESCENT)
			status = "descent"
		if(MASSLIFT_STATE_BUSY)
			status = "busy"
		if(MASSLIFT_STATE_WAIT)
			status = "wait"
		if(MASSLIFT_STATE_FALL)
			status = "fall"

	if(status)
		overlays += image(icon, status)

/obj/machinery/masslift_panel/Process()
	lift?.work()
	update_icon()

/obj/machinery/masslift_panel/control_interact(mob/living/carbon/human/H, obj/machinery/controller/C)
	if(!istype(lift))
		return

	if(lift.zlevel2depth(get_z(C)) in lift.targets)
		return

	lift.request(get_z(C))

/obj/machinery/controller/lift_button
	name = "lift request button"
	icon = 'icons/obj/masslift.dmi'
	icon_state = "request"
	desc = "Lift request button"
	ccontrol = new /datum/control/custom