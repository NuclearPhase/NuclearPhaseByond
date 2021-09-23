#define DRUGS_MESSAGE_DELAY (30 SECONDS + rand(-1 SECOND, 1 SECOND))
/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = 60
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.02
	flags = IGNORE_MOB_SIZE

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 2)
	M.add_chemical_effect(CE_PAINKILLER, 10)
/datum/reagent/tramadol
	name = "Tramadol"
	description = "A simple, yet effective painkiller. Don't mix with alcohol."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#cb68fc"
	overdose = 30
	scannable = 1
	metabolism = 0.05
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	var/pain_power = 100 //magnitide of painkilling effect
	var/effective_dose = 0.5 //how many units it need to process to reach max power
	var/soft_overdose = 15 //determines when it starts causing negative effects w/out actually causing OD
	var/additiction_coef = 0.8

/datum/reagent/tramadol/affect_blood(mob/living/carbon/M, alien, removed)
	var/effectiveness = 1
	if(M.chem_doses[type] < effective_dose) //some ease-in ease-out for the effect
		effectiveness = M.chem_doses[type]/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	handle_painkiller_overdose(M)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/tramadol/overdose(mob/living/carbon/M, alien)
	..()
	M.hallucination(120, 30)
	M.make_drugged(10)
	M.add_chemical_effect(CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	M.add_chemical_effect(CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(isboozed(M))
		M.add_chemical_effect(CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/datum/reagent/tramadol/proc/handle_painkiller_overdose(mob/living/carbon/M)
	if(M.chem_doses[type] > soft_overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(M.chem_doses[type] > (overdose+soft_overdose)/2)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(M.chem_doses[type] > overdose)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)

/datum/reagent/tramadol/proc/isboozed(mob/living/carbon/M)
	. = 0
	var/datum/reagents/ingested = M.ingested
	if(ingested)
		var/list/pool = M.reagents.reagent_list | ingested.reagent_list
		for(var/datum/reagent/ethanol/booze in pool)
			if(M.chem_doses[booze.type] < 2) //let them experience false security at first
				continue
			. = 1
			if(booze.strength < 40) //liquor stuff hits harder
				return 2

/datum/reagent/tramadol/opium // yes, opium is a subtype of tramadol, for reasons ~Toby
	name = "Opium"
	description = "Latex obtained from the opium poppy. An effective, but addictive painkiller."
	taste_description = "bitterness"
	color = "#63311b"
	overdose = 20
	soft_overdose = 10
	scannable = 0
	reagent_state = SOLID
	data = 0
	pain_power = 120
	var/drugdata = 0
	additiction_coef = 2.1

/datum/reagent/tramadol/opium/affect_blood(mob/living/carbon/M, alien, removed)
	var/effectiveness = 1
	if(volume < effective_dose) //reverse order compared to tramadol for quicker effect uppon injecting
		effectiveness = volume/effective_dose
	else if(M.chem_doses[type] < effective_dose)
		effectiveness = M.chem_doses[type]/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	handle_painkiller_overdose(M)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard
	if(world.time > drugdata + DRUGS_MESSAGE_DELAY)
		drugdata = world.time
		var/msg = ""
		if(pain_power > 200)
			msg = pick("unbeliveably happy", "like living your best life", "blissful", "blessed", "unearthly tranquility")
		else
			msg = pick("happy", "joyful", "relaxed", "tranquility")
		to_chat(M, SPAN("notice", "You feel [msg]."))

/datum/reagent/tramadol/opium/handle_painkiller_overdose(mob/living/carbon/M)
	var/whole_volume = (volume + M.chem_doses[type]) // side effects are more robust (dose-wise) than in the case of *legal* painkillers usage
	if(whole_volume > soft_overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		M.make_drugged(10)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(whole_volume > (overdose+soft_overdose)/2)
		M.eye_blurry = max(M.eye_blurry, 10)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(whole_volume > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 2)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)
	M.make_jittery(whole_volume * 0.5)

/datum/reagent/tramadol/opium/heroin
	name = "Heroin"
	description = "An opioid most commonly used as a recreational drug for its euphoric effects. An extremely effective painkiller, yet is terribly addictive and notorious for its life-threatening side-effects."
	color = "#b79a8d"
	overdose = 15
	soft_overdose = 7.5
	pain_power = 220
	scannable = 0
	reagent_state = SOLID
	additiction_coef = 3

/datum/reagent/tramadol/opium/heroin/affect_blood(mob/living/carbon/M, alien, removed)
	..()
	M.add_chemical_effect(CE_SLOWDOWN, 1)

/datum/reagent/tramadol/opium/heroin/handle_painkiller_overdose(mob/living/carbon/M)
	var/whole_volume = (volume + M.chem_doses[type]) // side effects are more robust (dose-wise) than in the case of *legal* painkillers usage
	if(whole_volume > soft_overdose)
		M.hallucination(30, 30)
		M.eye_blurry = max(M.eye_blurry, 10)
		M.drowsyness = max(M.drowsyness, 5)
		M.make_drugged(10)
		M.add_chemical_effect(CE_SLOWDOWN, 2)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(whole_volume > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 3)
		M.slurring = max(M.slurring, 30)
		M.Weaken(5)
		if(prob(25))
			M.sleeping = max(M.sleeping, 3)
		M.add_chemical_effect(CE_BREATHLOSS, 0.2)
	M.make_jittery(whole_volume * 0.5)

/datum/reagent/tramadol/opium/kodein
	name = "Heroin"
	description = "An mild opium alkaloid most commonly used as basis of other opiates."
	color = "#b79abd"
	overdose = 15
	soft_overdose = 7.5
	pain_power = 80
	scannable = 1
	reagent_state = SOLID
	additiction_coef = 3

/datum/reagent/tramadol/opium/heroin/krokodil
	name = "Krokodil"
	description = "A drug most commonly used as a cheap replacement of heroin."
	color = "#b7ba8d"
	overdose = 15
	soft_overdose = 7.5
	pain_power = 150
	scannable = 1
	reagent_state = SOLID
	additiction_coef = 2.6

/datum/reagent/tramadol/opium/morphine
	name = "Morphine"
	description = "An opioid painkiller drug."
	color = "#aaaabb"
	overdose = 25
	soft_overdose = 15
	scannable = 1
	reagent_state = SOLID
	data = 0
	pain_power = 200
	additiction_coef = 2

/datum/reagent/tramadol/opium/oxycodone
	name = "Oxycodone"
	description = "An effective opiat painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	overdose = 20
	pain_power = 180
	effective_dose = 2
	additiction_coef = 2

/datum/reagent/sterilizine
	name = "Sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	touch_met = 5

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/nicotine
	name = "Nicotine"
	description = "A sickly yellow liquid sourced from tobacco leaves. Stimulates and relaxes the mind and body."
	taste_description = "peppery bitterness"
	reagent_state = LIQUID
	color = "#efebaa"
	metabolism = REM * 0.002
	overdose = 6
	scannable = 1
	data = 0

/datum/reagent/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(volume*20))
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/nicotine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/tobacco
	name = "Tobacco"
	description = "Cut and processed tobacco leaves."
	taste_description = "tobacco"
	reagent_state = SOLID
	color = "#684b3c"
	scannable = 1
	var/nicotine = REM * 0.2

/datum/reagent/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent(/datum/reagent/nicotine, nicotine)

/datum/reagent/tobacco/fine
	name = "Fine Tobacco"
	taste_description = "fine tobacco"

/datum/reagent/tobacco/bad
	name = "Terrible Tobacco"
	taste_description = "acrid smoke"

/datum/reagent/tobacco/liquid
	name = "Nicotine Solution"
	description = "A diluted nicotine solution."
	reagent_state = LIQUID
	taste_mult = 0
	color = "#fcfcfc"
	nicotine = REM * 0.1

/datum/reagent/menthol
	name = "Menthol"
	description = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#80af9c"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE * 0.25
	scannable = 1
	data = 0

/datum/reagent/menthol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	description = "Nitroglycerin is a drug used to reduce CO, increase coronary refill to reduce heart ischemia."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_CARDIAC_OUTPUT, Clamp(1 - volume * 0.05, 0.6, 1))

/datum/reagent/atropine
	name = "Atropine"
	description = "Atropine is a drug what increases HR. Used in severe bradycardia cases"
	reagent_state = LIQUID
	color = "#a76"

/datum/reagent/atropine/affect_blood(mob/living/carbon/human/H, alien, removed)
	..()
	H.add_chemical_effect(CE_PULSE, volume * 5)

/datum/reagent/adenosine
	name = "Adenosine"
	description = "Adenosine is a drug used to produce controlled AV blockade."
	reagent_state = LIQUID
	color = "#a76"
	metabolism = 0.5

/datum/reagent/adenosine/affect_blood(mob/living/carbon/human/H, alien, removed)
	// initial rush.
	if(volume > 2 && H.chem_doses[type] < 2 && H.get_rythme() >= RYTHME_AFIB)
		H.make_heart_rate(-140, "adenosine_av_blockage")
	else
		H.make_heart_rate(-30, "adenosine_av_blockage")
		if(H.get_rythme() == RYTHME_AFIB_RR)
			H.set_rythme(RYTHME_AFIB)
			volume = 0

/datum/reagent/amiodarone
	name = "Amiodarone"
	description = "Amiodarone is a antiarrythmic drug."
	reagent_state = LIQUID
	color = "#76a"
	metabolism = REM

/datum/reagent/amiodarone/affect_blood(mob/living/carbon/human/H, alien, removed)
	H.add_chemical_effect(CE_ANTIARRYTHMIC, 1)

/datum/reagent/lidocaine
	name = "Lidocaine"
	description = "Lidocaine is a antiarrythmic and painkiller drug."
	reagent_state = LIQUID
	color = "#7aa"
	metabolism = REM
	overdose = 10

/datum/reagent/lidocaine/affect_blood(mob/living/carbon/human/H, alien, removed)
	H.add_chemical_effect(CE_ANTIARRYTHMIC, 2)
	H.add_chemical_effect(CE_PAINKILLER, 40)

/datum/reagent/lidocaine/overdose(mob/living/carbon/human/H, alien)
	if(prob(50))
		H.add_chemical_effect(CE_BREATHLOSS)

