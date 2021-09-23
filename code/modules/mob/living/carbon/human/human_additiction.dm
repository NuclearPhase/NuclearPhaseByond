/datum/additiction
	var/name

// NEG - withdrawal
// POS - addictive
	var/power = 0
	var/time = 0
	var/time_start = 0
	var/chronic = FALSE
	var/max_power = 0

/datum/additiction/proc/update(var/mob/living/carbon/human/H)

/datum/additiction/proc/tick(var/mob/living/carbon/human/H)
	return

/datum/additiction/proc/can_gone(var/mob/living/carbon/human/H)
	return TRUE

/mob/living/carbon/human/var/list/datum/additiction/additictions = list()

/mob/living/carbon/human/proc/add_additiction(datum/additiction/A)
	A.time_start = world.time
	additictions[A.name] = A

/mob/living/carbon/human/proc/handle_additictions()
	for(var/T in subtypesof(/datum/additiction))
		var/datum/additiction/A = new T
		if(A.name in additictions)
			continue

		A.update(src)
		A.time_start = world.time
		if(A.power > 0)
			add_additiction(A)

	for(var/N in additictions)
		var/datum/additiction/A = additictions[N]
		A.tick(src)
		A.time = world.time - A.time_start
		A.update(src)

		if(A.can_gone(src))
			additictions -= A.name

/datum/additiction/opioid
	name = "Opioid"

/datum/additiction/opioid/can_gone(var/mob/living/carbon/human/H)
	return chronic ? FALSE : power <= (-max_power * 1.5)

/datum/additiction/opioid/update(var/mob/living/carbon/human/H)
	H.clear_event("opiates")
	var/power_diff = 0
	for(var/datum/reagent/tramadol/T in (H.reagents.reagent_list | H.ingested.reagent_list))
		if(power < T.pain_power / 5)
			power_diff += (T.pain_power / 20 * H.chem_doses[T.type] * 0.05)
	power += power_diff
	if(power_diff < 0.1)
		if(power >= 0)
			power -= max(0.01, power * (chronic ? 0.008 : 0.01))
		else if(abs(power) < (max_power * 0.8))
			power -= 0.1

	if(power_diff > 0.1 && max_power > 30)
		var/msg
		if(power < -10)
			msg = SPAN_NOTICE("You feel <big>[pick("unbeliveably happy", "like living your best life", "blissful", "blessed", "unearthly tranquility")]</big>")
		else
			msg = SPAN_NOTICE("You feel [pick("happy", "joyful", "relaxed", "tranquility")]")

		var/datum/happiness_event/HE = new
		HE.description = msg
		HE.happiness = power < -10 ? 10 : 5
		H.add_event("opiates", HE)

		if(prob(15))
			to_chat(H, msg)

	max_power = max(power, max_power)

/datum/additiction/opioid/tick(var/mob/living/carbon/human/H)
	H.add_chemical_effect(CE_PAINKILLER, max_power * -0.5)
	if(power >= 0)
		return
	var/P = abs(power)
	if(prob(10))
		H.take_overall_damage(brute = P * 0.25, "Opioid additiction")
		switch(P)
			if(0 to 6)
				H.custom_pain("Your body stings slightly.", P * 2, 0, null, 0)
			if(6 to 13)
				H.custom_pain("Your body stings.", P * 1.5, 0, null, 0)
				if(prob(20))
					spawn()
						H.vomit()
			if(13 to 30)
				H.custom_pain("Your body stings strongly.", P * 2, 0, null, 0)
				if(prob(30))
					spawn()
						H.vomit()
			if(30 to INFINITY)
				if(chronic && power > 60)
					H.custom_pain("Your body crushes all over.", P * 3.5, 0, null, 0)
				else
					H.custom_pain("Your body aches all over, it's driving you mad.", P * 3, 0, null, 0)
				if(prob(60))
					spawn()
						H.vomit()
		H.adjustToxLoss(P / 40)

	var/datum/happiness_event/HE = new
	switch(P)
		if(0 to 6)
			HE.description = SPAN_WARNING("You wanna opiates.")
		if(6 to 13)
			HE.description = SPAN_WARNING("You really want opiates!")
		if(13 to 30)
			HE.description = SPAN_DANGER("You need opiates!")
		if(30 to 60)
			HE.description = SPAN_DANGER("<big>You really need opiates!</big>")
		if(60 to INFINITY)
			HE.description = SPAN_DANGER("<big>OH GOD! You cannot live without opiates.</big>")
	HE.happiness = -P / 3

	H.add_event("opiates", HE)

/datum/additiction/alcohol
	name = "Alcohol"

/datum/additiction/alcohol/can_gone(var/mob/living/carbon/human/H)
	return chronic ? FALSE : power < -max_power

/datum/additiction/alcohol/proc/isboozed(mob/living/carbon/human/H)
	. = 0
	var/datum/reagents/ingested = H.ingested
	if(ingested)
		var/list/pool = H.reagents.reagent_list | ingested.reagent_list
		for(var/datum/reagent/ethanol/booze in pool)
			if(H.chem_doses[booze.type] < 2)
				continue
			. = 1
			if(booze.strength < 40)
				return 2

/datum/additiction/alcohol/update(var/mob/living/carbon/human/H)
	var/power_diff = isboozed(H)
	if(power < 0)
		power_diff *= 10
	power += power_diff / 10

	H.clear_event("alcohol")

	if(power_diff >= 1 && max_power > 30)
		var/msg
		if(power < -10)
			msg = SPAN_NOTICE("You feel [pick("relaxed", "blissful")]")
		else if(power >= -10)
			msg = SPAN_NOTICE("You feel [pick("decent", "relaxed", "tranquility")]")

		if(prob(7))
			to_chat(H, msg)
		var/datum/happiness_event/HE = new
		HE.description = msg
		HE.happiness = power < -10 ? 5 : 2
		H.add_event("alcohol", HE)

	max_power = max(power - 0.025, max_power)

/datum/additiction/alcohol/tick(var/mob/living/carbon/human/H)
	if(power >= 0)
		return
	var/P = abs(power)
	var/msg
	switch(P)
		if(0 to 12)
			msg = SPAN_NOTICE("You wanna drink.")
		if(12 to 30)
			msg = SPAN_WARNING("You really wanna drink.")
		if(30 to INFINITY)
			msg = SPAN_DANGER("You need to drink right now, it's driving you mad.")
	var/datum/happiness_event/HE = new
	HE.description = msg
	HE.happiness = power < -10 ? -5 : -2
	H.add_event("alcohol", HE)

	if(prob(3))
		H.adjustToxLoss(P / 100)
		to_chat(H, msg)

/datum/additiction/nicotine
	name = "Nicotine"

/datum/additiction/nicotine/can_gone(var/mob/living/carbon/human/H)
	return chronic ? FALSE : power < -max_power

/datum/additiction/nicotine/update(var/mob/living/carbon/human/H)
	var/power_diff = H.chem_doses[/datum/reagent/nicotine] || 0
	if(power < 0)
		power_diff *= 200
	power += power_diff / 10
	power -= 0.1
	max_power = max(power, max_power)
	H.clear_event("smoke")

/datum/additiction/nicotine/tick(var/mob/living/carbon/human/H)
	if(power >= 0)
		return
	var/P = abs(power)
	var/msg
	switch(P)
		if(0 to 12)
			msg = SPAN_NOTICE("You wanna smoke.")
		if(12 to 30)
			msg = SPAN_WARNING("You really wanna smoke.")
		if(30 to INFINITY)
			msg = SPAN_DANGER("You need to smoke right now, it's driving you mad.")
	if(prob(3))
		to_chat(H, msg)
	var/datum/happiness_event/HE = new
	HE.description = msg
	HE.happiness = power < -10 ? -5 : -2
	H.add_event("smoke", HE)