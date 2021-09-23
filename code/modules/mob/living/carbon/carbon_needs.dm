/mob/living/carbon/proc/print_happiness()
	var/msg = "<span class='info'>*---------*\n<EM>Current mood</EM>\n"
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		msg += "[event.description]\n"

	if(!events.len)
		msg += "<span class='info'>I feel indifferent.</span>\n"


	msg += "<span class='info'>*---------*</span>"
	to_chat(src, msg)

/mob/living/carbon/proc/update_happiness()
	var/old_happiness = happiness
	var/old_icon = null
	if(happiness_icon)
		old_icon = happiness_icon.icon_state
	happiness = 0
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		happiness += event.happiness

	switch(happiness)
		if(-INFINITY to MOOD_LEVEL_SAD4)
			if(happiness_icon)
				happiness_icon.icon_state = "mood7"

		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			if(happiness_icon)
				happiness_icon.icon_state = "mood6"

		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			if(happiness_icon)
				happiness_icon.icon_state = "mood5"

		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			if(happiness_icon)
				happiness_icon.icon_state = "mood5"

		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			if(happiness_icon)
				happiness_icon.icon_state = "mood4"

		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			if(happiness_icon)
				happiness_icon.icon_state = "mood4"

		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			if(happiness_icon)
				happiness_icon.icon_state = "mood3"

		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			if(happiness_icon)
				happiness_icon.icon_state = "mood2"

		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			if(happiness_icon)
				happiness_icon.icon_state = "mood1"

	if(old_icon && old_icon != happiness_icon.icon_state)
		if(old_happiness > happiness)
			to_chat(src, "<span class='warning'>My mood gets worse.</span>")
		else
			to_chat(src, "<span class='info'>My mood gets better.</span>")

/mob/living/carbon/proc/flash_sadness()
	if(prob(abs(happiness)))
		flick("sadness",pain)
		var/spoopysound = pick('sound/effects/badmood1.ogg','sound/effects/badmood2.ogg','sound/effects/badmood3.ogg','sound/effects/badmood4.ogg')
		sound_to(src, spoopysound)

/mob/living/carbon/proc/handle_happiness()
	switch(happiness)
		if(-INFINITY to MOOD_LEVEL_SAD4)
			flash_sadness()
			return 1
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			flash_sadness()
			return 1
		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY2)
			return 1
		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			return 1
		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			return 1


/mob/living/carbon/proc/add_event(category, var/datum/happiness_event/event) //Category will override any events in the same category, should be unique unless the event is based on the same thing like hunger.
	events[category] = event
	update_happiness()

	if(event.timeout)
		spawn(event.timeout)
			clear_event(category)

/mob/living/carbon/proc/clear_event(category)
	events -= category
	update_happiness()

/mob/living/carbon/proc/handle_hygiene()
	adjust_hygiene(-my_hygiene_factor)
	var/image/smell = image('icons/effects/effects.dmi', "smell")//This is a hack, there has got to be a safer way to do this but I don't know it at the moment.
	switch(hygiene)
		if(HYGIENE_LEVEL_NORMAL to INFINITY)
			add_event("hygiene", new /datum/happiness_event/hygiene/clean)
			overlays -= smell
		if(HYGIENE_LEVEL_DIRTY to HYGIENE_LEVEL_NORMAL)
			clear_event("hygiene")
			overlays -= smell
		if(0 to HYGIENE_LEVEL_DIRTY)
			overlays -= smell
			overlays += smell
			add_event("hygiene", new /datum/happiness_event/hygiene/smelly)

/mob/living/carbon/proc/adjust_hygiene(var/amount)
	var/old_hygiene = hygiene
	if(amount>0)
		hygiene = min(hygiene+amount, HYGIENE_LEVEL_CLEAN)

	else if(old_hygiene)
		hygiene = max(hygiene+amount, 0)

/mob/living/carbon/proc/set_hygiene(var/amount)
	if(amount >= 0)
		hygiene = min(HYGIENE_LEVEL_CLEAN, amount)

/mob/living/carbon/proc/adjust_thirst(var/amount)
	var/old_thirst = thirst
	if(amount>0)
		thirst = min(thirst+amount, THIRST_LEVEL_MAX)

	else if(old_thirst)
		thirst = max(thirst+amount, 0)

/mob/living/carbon/proc/set_thirst(var/amount)
	if(amount >= 0)
		thirst = min(THIRST_LEVEL_MAX, amount)