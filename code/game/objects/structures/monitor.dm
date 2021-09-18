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

	data["hr"] = H.pulse
	data["rythme"] = H.get_rythme_fluffy()
	data["bp"] = H.pressure
	data["ischemia"] = H.ischemia
	data["damage"] = H.damage / H.max_damage
	data["spo2"] = attached.get_blood_saturation()
	data["perfusion"] = attached.get_blood_perfusion()

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "monitor.tmpl", "[attached] Monitor", 300, 510)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/structure/monitor/Topic(href, href_list))
	if(..())
		return 1

/obj/structure/monitor/attack_hand(mob/user)
	ui_interact(user)
/obj/structure/monitor/Examine(mob/user)
	ui_interact(user)