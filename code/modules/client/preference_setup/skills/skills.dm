/datum/preferences
	var/list/skills          // FIXME: ;(

/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["skills"]					>> pref.skills

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["skills"]					<< pref.skills

/datum/category_item/player_setup_item/skills/sanitize_character()
	if(!istype(pref.skills))		pref.skills = list()
	if(!pref.skills.len)			pref.ZeroSkills()

/datum/category_item/player_setup_item/skills/content()
	. = list()
	. += "<b>Select your Skills</b><br>"
	. += "<table>"

	var/list/skills = list()
	for(var/T in subtypesof(/datum/skill))
		var/datum/skill/S = new T
		if(S.field in skills)
			skills[S.field] += S
		else
			skills[S.field] = list(S)


	for(var/V in skills)
		. += "<tr><th colspan = 5><b>[V]</b>"
		. += "</th></tr>"
		for(var/datum/skill/S in skills[V])
			var/level = pref.skills[S.ID]
			. += "<tr style='text-align:left;'>"
			. += "<th style='text-align:left;'>[S.name]</th>"
			. += skill_to_button(S, "Untrained"   , level, SKILL_UNSKILLED   )
			. += skill_to_button(S, "Amateur"     , level, SKILL_AMATEUR     )
			. += skill_to_button(S, "Trained"     , level, SKILL_TRAINED     )
			. += skill_to_button(S, "Professional", level, SKILL_PROFESSIONAL)
			. += "</tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/proc/skill_to_button(var/datum/skill/skill, var/level_name, var/current_level, var/selection_level)
	if(current_level == selection_level)
		return "<th><span class='linkOn'>[level_name]</span></th>"
	return "<th><a href='?src=\ref[src];setskill=[skill.ID];newvalue=[selection_level]'>[level_name]</a></th>"

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		pref.skills[href_list["setskill"]] = value
		return TOPIC_REFRESH

	return ..()
