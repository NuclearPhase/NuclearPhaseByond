#define HEART_NC_DT 0.1

/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	var/pulse = 60
	var/cardiac_output = 1
	var/list/pulse_modificators = list()
	var/list/cardiac_output_modificators = list() // *
	var/list/blood_pressure_modificators = list() // *
	var/last_rythm_change = 0
	var/rythme = RYTHME_NORM
	var/ischemia = 0
	var/heartbeat = 0
	var/beat_sound = 'sound/effects/singlebeat.ogg'
	var/tmp/next_blood_squirt = 0
	relative_size = 15
	max_damage = 100
	var/open
	var/nc
	influenced_hormones = list(
		/datum/reagent/hormone/adrenaline,
		/datum/reagent/hormone/noradrenaline,
		/datum/reagent/hormone/dopamine
	)

/obj/item/organ/internal/heart/influence_hormone(T, amount)
	if(ishormone(T, adrenaline))
		owner.add_chemical_effect(CE_PULSE, amount * 5)
		owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * 0.05)
	if(ishormone(T, noradrenaline))
		owner.add_chemical_effect(CE_PRESSURE, 1 + amount * 0.05)
		owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * -0.01)
		owner.add_chemical_effect(CE_PULSE, amount * 2)
	if(ishormone(T, dopamine))
		owner.add_chemical_effect(CE_PRESSURE, 1 + amount * 0.025)
		owner.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + amount * 0.005)
		var/suggested_rythme = min(RYTHME_NORM + remove_frac(amount / 10), RYTHME_VFIB)
		if(amount > 10 && prob(5) && prob(RYTHME_ASYSTOLE - suggested_rythme) && rythme < suggested_rythme)
			change_rythme(rythme + 1, 30 SECONDS)


/obj/item/organ/internal/heart/die()
	if(dead_icon)
		icon_state = dead_icon
	..()

/obj/item/organ/internal/heart/Process()
	..()
	if(!owner)
		return
	if(owner.stat == DEAD)
		rythme = RYTHME_ASYSTOLE
		pulse = 0
		ischemia = 100
		return

	handle_rythme()
	make_modificators()
	handle_ischemia()

	handle_pulse()
	handle_cardiac_output()

	handle_blood()
	post_handle_rythme()

	make_up_to_hormone(/datum/reagent/hormone/marker/ast, 30 + ((damage / max_damage) * 2))
	make_up_to_hormone(/datum/reagent/hormone/marker/alt, 25 + ((damage / max_damage) * 0.1))


/obj/item/organ/internal/heart/proc/handle_pulse()
	switch(rythme)
		if(RYTHME_ASYSTOLE)
			pulse = sumListAndCutAssoc(pulse_modificators)
		if(RYTHME_VFIB)
			pulse = rand(200, 260)
		else
			var/n_pulse = initial(pulse) + nc + sumListAndCutAssoc(pulse_modificators)
			pulse = Interpolate(pulse, n_pulse, 0.5)
	pulse = Floor(Clamp(pulse, 0, 260))


/obj/item/organ/internal/heart/proc/handle_cardiac_output()
	cardiac_output = initial(cardiac_output) * mulListAndCutAssoc(cardiac_output_modificators)

/obj/item/organ/internal/heart/proc/make_nc()
	if(!pulse)
		nc = 0
		return
	var/last = nc
	nc = BLOOD_PRESSURE_NORMAL * mulListAssoc(blood_pressure_modificators) - owner.mpressure
	nc /= (owner.mpressure / pulse)
	nc = Clamp(Interpolate(last, nc, 0.5), -40, 40)

/obj/item/organ/internal/heart/proc/make_modificators()
	make_nc()
	if(rythme != RYTHME_ASYSTOLE)
		pulse_modificators["hypoperfusion"] = (1 - owner.get_blood_perfusion()) * 100
		pulse_modificators["shock"] = owner.shock_stage
		if(CE_PULSE in owner.chem_effects)
			pulse_modificators["chem"] = owner.chem_effects[CE_PULSE]
	if(CE_PRESSURE in owner.chem_effects)
		blood_pressure_modificators["chem"] = owner.chem_effects[CE_PRESSURE]
	if(CE_CARDIAC_OUTPUT in owner.chem_effects)
		cardiac_output_modificators["chem"] = owner.chem_effects[CE_CARDIAC_OUTPUT]
	cardiac_output_modificators["damage"] = 1 - (damage / max_damage)

/obj/item/organ/internal/heart/proc/handle_rythme()
	switch(rythme)
		if(RYTHME_AFIB)
			if(ischemia < 15)
				ischemia += 0.15
			cardiac_output_modificators["afib"] = 0.85
			pulse_modificators["afib"] = rand(-20, 20)
		if(RYTHME_AFIB_RR)
			if(ischemia < 20)
				ischemia += 0.20
			cardiac_output_modificators["afib_rr"] = 0.3
			pulse_modificators["afib_rr"] = rand(25, 70)
		if(RYTHME_VFIB)
			ischemia += 0.40
			cardiac_output_modificators["vfib"] = 0.05
		if(RYTHME_ASYSTOLE)
			ischemia += 0.70
	if(rythme <= RYTHME_AFIB)
		ischemia = max(0, ischemia - 0.2)

/obj/item/organ/internal/heart/proc/change_rythme(newrythme, timerequired = 0)
	if(timerequired)
		if((last_rythm_change + timerequired) < world.time)
			return

	rythme = newrythme
	last_rythm_change = world.time
	pulse_modificators.Cut()
	blood_pressure_modificators.Cut()
	
/obj/item/organ/internal/heart/proc/post_handle_rythme()
	var/antiarrythmic = LAZYACCESS0(owner.chem_effects, CE_ANTIARRYTHMIC)

	if(rythme < RYTHME_ASYSTOLE && prob(5))
		if(damage / max_damage >= 0.75 && rythme < RYTHME_AFIB_RR)
			change_rythme(rythme + 1, 1.5 MINUTES)
		else if(damage / max_damage >= 0.25 && rythme < RYTHME_AFIB)
			change_rythme(rythme + 1, 1.5 MINUTES)
		else if(owner.mpressure > BLOOD_PRESSURE_HBAD && !antiarrythmic)
			change_rythme(rythme + 1, 1.5 MINUTES)
	switch(rythme)
		if(RYTHME_AFIB)
			change_rythme(RYTHME_NORM, 3 MINUTES)
		if(RYTHME_AFIB_RR)
			change_rythme(RYTHME_AFIB, 5 MINUTES)
		if(RYTHME_VFIB)
			change_rythme(RYTHME_ASYSTOLE, 2 MINUTES)
		if(RYTHME_ASYSTOLE)
			var/critical_point = 145 + (ischemia / 50) * 40 - antiarrythmic * 10
			if(pulse > critical_point)
				change_rythme(RYTHME_VFIB, 10 SECONDS)

	if(antiarrythmic && rythme == RYTHME_AFIB && prob(antiarrythmic * 25))
		rythme = RYTHME_NORM
	if(antiarrythmic > 1 && rythme == RYTHME_AFIB_RR && prob(10))
		rythme = RYTHME_AFIB

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= 90 || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		var/rate = 0.0119 * pulse - 0.1795

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound, 0, 0, 0, 50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_ischemia()
	var/infarct_strength = 0
	if(/datum/organ_disease/infarct in diseases)
		var/datum/organ_disease/infarct/I = locate() in diseases
		infarct_strength = I.strength

	ischemia = min(ischemia, 100 + infarct_strength)

	if(ischemia > 30)
		damage += Interpolate(0.1, 0.5, (ischemia - 30) / 70)
	cardiac_output_modificators["ischemia"] = max(1 - (ischemia / 100), 0.3)
	if(damage / max_damage > (20 / max_damage))
		make_up_to_hormone(/datum/reagent/hormone/marker/troponin_t, damage / max_damage * 2)


/obj/item/organ/internal/heart/proc/handle_blood()
	if(!owner)
		return

	if(owner.stat == DEAD)
		return

	if(!pulse)
		return
	//Bleeding out
	var/blood_max = 0
	var/list/do_spray = list()
	for(var/obj/item/organ/external/temp in owner.organs)
		var/open_wound
		if(temp.status & ORGAN_BLEEDING)
			for(var/datum/wound/W in temp.wounds)
				if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
					open_wound = TRUE

				if(!W.bleeding())
					continue
				if(temp.applied_pressure)
					if(ishuman(temp.applied_pressure))
						var/mob/living/carbon/human/H = temp.applied_pressure
						H.bloody_hands(src, 0)
					//somehow you can apply pressure to every wound on the organ at the same time
					//you're basically forced to do nothing at all, so let's make it pretty effective
					var/min_eff_damage = max(0, W.damage - 10) / 6 //still want a little bit to drip out, for effect
					blood_max += max(min_eff_damage, W.damage - 30) / 40
				else
					blood_max += W.damage / 40

		if(temp.status & ORGAN_ARTERY_CUT)
			var/bleed_amount = Floor((owner.vessel.total_volume / (temp.applied_pressure || !open_wound ? 400 : 250)) * temp.arterial_bleed_severity)
			if(bleed_amount)
				if(open_wound)
					blood_max += bleed_amount
					do_spray += "the [temp.artery_name] in \the [owner]'s [temp.name]"
				else
					owner.vessel.remove_reagent(/datum/reagent/blood, bleed_amount)

		blood_max *= owner.mpressure / BLOOD_PRESSURE_NORMAL

		if(world.time >= next_blood_squirt && istype(owner.loc, /turf) && do_spray.len)
			owner.visible_message("<span class='danger'>Blood squirts from [pick(do_spray)]!</span>")
			// It becomes very spammy otherwise. Arterial bleeding will still happen outside of this block, just not the squirt effect.
			next_blood_squirt = world.time + 100
			var/turf/sprayloc = get_turf(owner)
			blood_max -= owner.drip(ceil(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc)
				owner.drip(blood_max, get_turf(owner))
		else
			owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return pulse

/obj/item/organ/internal/heart/listen()
	if(!pulse)
		return "no pulse."

	var/strength
	if(cardiac_output <= (initial(cardiac_output) / 2))
		strength = "faint "
	var/rythme_d = rythme == RYTHME_NORM ? "regular " : "irregular "

	var/speed
	switch(pulse)
		if(0 to 40)
			speed = "slow"
		if(90 to 140)
			speed = "fast"
		if(140 to 170)
			speed = "very fast"
		if(170 to 220)
			speed = "extreme fast"
		if(220 to INFINITY)
			speed = "thready"

	. = "[strength][rythme_d][speed] pulse."

/obj/item/organ/internal/heart/proc/get_rythme_fluffy()
	switch(rythme)
		if(RYTHME_NORM)
			return "Normal"
		if(RYTHME_AFIB)
			return "Atrial fibrillation"
		if(RYTHME_AFIB_RR)
			return "Atrial fibrillation with rapid heart rate"
		if(RYTHME_VFIB)
			return "Ventricular fibrillation"
		if(RYTHME_ASYSTOLE)
			return "Asystole"
		else
			return "UNKNOWN BIOLOGY"