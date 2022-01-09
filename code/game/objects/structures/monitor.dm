/obj/structure/monitor
	name = "\improper Monitor"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "monitor"
	anchored = 0
	density = 0
	var/mob/living/carbon/human/attached

/obj/structure/monitor/MouseDrop(mob/living/carbon/human/over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return

	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
	else if(over_object)
		visible_message("\The [usr] connects \the [over_object] up to \the [src].")
		if(!do_after(usr, 30, over_object))
			return
		attached = over_object
		START_PROCESSING(SSobj, src)

	update_icon()

/obj/structure/monitor/Destroy()
	STOP_PROCESSING(SSobj, src)
	attached = null
	. = ..()

/obj/structure/monitor/update_icon()
	overlays.Cut()
	if(!attached)
		icon_state = "monitor"
		return

	var/obj/item/organ/internal/heart/H = attached.internal_organs_by_name[BP_HEART]

	if(!H)
		icon_state = "monitor-asystole"
		return

	if(H.rythme < RYTHME_VFIB)
		icon_state = "monitor-normal"
	else if(H.rythme == RYTHME_VFIB)
		icon_state = "monitor-vfib"
	else if(H.rythme == RYTHME_ASYSTOLE)
		icon_state = "monitor-asystole"

	if(H.pressure < BLOOD_PRESSURE_L2BAD || H.pressure > BLOOD_PRESSURE_H2BAD)
		overlays += image(icon, "monitor-r")
	if(attached.get_blood_saturation() < 0.80)
		overlays += image(icon, "monitor-c")
	if(attached.get_blood_perfusion() < 0.7)
		overlays += image(icon, "monitor-y")

/obj/structure/monitor/Process()
	if(!attached)
		return PROCESS_KILL
	if(!Adjacent(attached))
		attached = null
		update_icon()
		return PROCESS_KILL

	update_icon()

/obj/structure/monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/obj/item/organ/internal/heart/H = attached?.internal_organs_by_name[BP_HEART]
	if(!attached || !H)
		return

	var/list/data = list()
	data["name"] = "[attached]"
	data["hr"] = H.pulse
	data["rythme"] = H.get_rythme_fluffy()
	data["bp"] = attached.get_blood_pressure_fluffy()
	switch(H.pressure)
		if(-INFINITY to BLOOD_PRESSURE_L2BAD)
			data["bp_s"] = "bad"
		if(BLOOD_PRESSURE_L2BAD to BLOOD_PRESSURE_NORMAL - 30)
			data["bp_s"] = "average"
		if(BLOOD_PRESSURE_HBAD to BLOOD_PRESSURE_H2BAD)
			data["bp_s"] = "average"
		if(BLOOD_PRESSURE_H2BAD to INFINITY)
			data["bp_s"] = "bad"

	switch(attached.get_blood_perfusion())
		if(0 to 0.6)
			data["perfusion_s"] = "bad"
		if(0.6 to 0.8)
			data["perfusion_s"] = "average"
	data["ischemia"] = H.ischemia
	data["saturation"] = round(attached.get_blood_saturation() * 100)
	data["perfusion"] = round(attached.get_blood_perfusion() * 100)
	data["status"] = (attached.stat == CONSCIOUS) ? "CONSCIOUS" : "UNCONSCIOUS"

	data["ecg"] = list()
	
	var/obj/item/organ/internal/brain/brain = attached.internal_organs_by_name[BP_BRAIN]
	if(attached.stat == DEAD || !brain)
		data["ecg"] += list("Neurological activity not present")
	else
		data["ecg"] += list("Neurological system activity: [100 - round(100 * CLAMP01(brain.damage / brain.max_damage))]% of normal.")

	if(attached.bloodstr.get_reagent_amount(/datum/reagent/hormone/potassium) > POTASSIUM_LEVEL_HBAD)
		data["ecg"] += list("Hypercaliemia.")
	if(H.ischemia)
		data["ecg"] += list("Ischemia.")
	
	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "monitor.tmpl", "Monitor", 450, 270)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/structure/monitor/attack_hand(mob/user)
	ui_interact(user)
/obj/structure/monitor/examine(mob/user)
	ui_interact(user)