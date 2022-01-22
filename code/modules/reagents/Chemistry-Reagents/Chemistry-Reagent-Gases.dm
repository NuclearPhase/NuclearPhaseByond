// Sleeping agent, produced by breathing N2O.
/datum/reagent/nitrous_oxide
	name = "Nitrous Oxide"
	description = "An ubiquitous sleeping agent also known as laughing gas."
	taste_description = "dental surgery"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	var/do_giggle = TRUE

/datum/reagent/nitrous_oxide/xenon
	name = "Xenon"
	description = "A nontoxic gas used as a general anaesthetic."
	do_giggle = FALSE
	taste_description = "nothing"
	color = COLOR_GRAY80

/datum/reagent/nitrous_oxide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/dosage = M.chem_doses[type]
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	if(do_giggle && prob(20))
		M.emote(pick("giggle", "laugh"))
	M.add_chemical_effect(CE_PULSE, -1)

// This is only really used to poison vox.
/datum/reagent/oxygen
	name = "Oxygen"
	description = "An ubiquitous oxidizing agent."
	taste_description = "nothing"
	reagent_state = LIQUID
	color = COLOR_GRAY80

/datum/reagent/oxygen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	// TODO: implement

/datum/reagent/carbon_monoxide
	name = "Carbon Monoxide"
	description = "A dangerous carbon comubstion byproduct."
	taste_description = "stale air"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // As with helium.

/datum/reagent/carbon_monoxide/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(!istype(M) || alien == IS_DIONA)
		return
	var/warning_message
	var/warning_prob = 10
	var/dosage = M.chem_doses[type]
	if(dosage >= 3)
		warning_message = pick("extremely dizzy","short of breath","faint","confused")
		warning_prob = 15
		M.adjustOxyLoss(10,20)
		M.co2_alert = 1
	else if(dosage >= 1.5)
		warning_message = pick("dizzy","short of breath","faint","momentarily confused")
		M.co2_alert = 1
		M.adjustOxyLoss(3,5)
	else if(dosage >= 0.25)
		warning_message = pick("a little dizzy","short of breath")
		warning_prob = 10
		M.co2_alert = 0
	else
		M.co2_alert = 0
	if(warning_message && prob(warning_prob))
		to_chat(M, "<span class='warning'>You feel [warning_message].</span>")

/datum/reagent/helium
	name = "Helium"
	description = "A noble gas."
	taste_description = "nothing"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.

/datum/reagent/helium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()

/datum/reagent/toxin/methyl_bromide
	name = "Methyl Bromide"
	description = "A fumigant derived from bromide."
	taste_description = "pestkiller"
	reagent_state = LIQUID
	color = "#4c3b34"
	strength = 5

/datum/reagent/toxin/methyl_bromide/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	. = (alien != IS_NABBER && ..())

/datum/reagent/toxin/methyl_bromide/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	. = (alien != IS_NABBER && ..())

/datum/reagent/toxin/methyl_bromide/touch_turf(var/turf/simulated/T)
	if(istype(T))
		T.assume_gas(GAS_METHYL_BROMIDE, volume, T20C)
		remove_self(volume)

/datum/reagent/toxin/methyl_bromide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = (alien != IS_NABBER && ..())
	if(!istype(M))
		return
	for(var/obj/item/organ/external/E in M.organs)
		if(!LAZYLEN(E.implants))
			continue
		for(var/obj/effect/spider/spider in E.implants)
			if(prob(75))
				continue
			E.implants -= spider
			M.visible_message("<span class='notice'>The dying form of \a [spider] emerges from inside \the [M]'s [E.name].</span>")
			qdel(spider)
			break