/datum/computer_file/program/mri_control
	filename = "mricontrol"
	filedesc = "MRI control"
	nanomodule_path = /datum/nano_module/mri_control
	program_icon_state = "crew"
	program_key_state = "med_key"
	program_menu_icon = "heart"
	extended_desc = "This program connects to MRI and provides control of them and information from them."
	required_access = access_medical
	network_destination = "crew lifesigns monitoring system"
	size = 15

/datum/nano_module/mri_control
	name = "MRI control"

/datum/nano_module/mri_control/Topic(href, href_list)
	if(..()) return 1

/*
	if(href_list["track"])
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list["track"]) in SSmobs.mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		return 1


/datum/nano_module/mri_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["isAI"] = isAI(user)
	data["crewmembers"] = list()
	for(var/z_level in GLOB.using_map.map_levels)
		data["crewmembers"] += crew_repository.health_data(z_level)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "crew_monitor.tmpl", "Crew Monitoring Computer", 900, 800, state = state)

		// adding a template with the key "mapContent" enables the map ui functionality
		ui.add_template("mapContent", "crew_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the map header content
		ui.add_template("mapHeader", "crew_monitor_map_header.tmpl")

		ui.set_initial_data(data)
		ui.open()

		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)
*/