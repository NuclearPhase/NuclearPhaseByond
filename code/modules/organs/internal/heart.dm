#define HEART_NC_DT 0.1

/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	var/pulse = 70
	var/cardiac_output = BLOOD_PRESSURE_NORMAL / 70
	var/pressure = BLOOD_PRESSURE_NORMAL
	var/list/pulse_modificators = list()
	var/list/cardiac_output_modificators = list() // *
	var/list/blood_pressure_modificators = list()
	var/rythme = RYTHME_NORM
	var/ischemia = 0
	var/heartbeat = 0
	var/beat_sound = 'sound/effects/singlebeat.ogg'
	var/tmp/next_blood_squirt = 0
	relative_size = 15
	max_damage = 45
	var/open
	var/nc

/obj/item/organ/internal/heart/Initialize()
	. = ..()
/obj/item/organ/internal/heart/die()
	if(dead_icon)
		icon_state = dead_icon
	..()

/obj/item/organ/internal/heart/robotize()
	. = ..()
	icon_state = "heart-prosthetic"

/obj/item/organ/internal/heart/Process()
	if(owner)
		handle_rythme()
		make_modificators()
		handle_ischemia()

		handle_pulse()
		handle_cardiac_output()
		handle_blood_pressure()

		handle_blood()
		post_handle_rythme()
	..()

/obj/item/organ/internal/heart/proc/handle_pulse()
	pulse = max(0, initial(pulse) + nc + sumListAndCutAssoc(pulse_modificators))

/obj/item/organ/internal/heart/proc/handle_cardiac_output()
	cardiac_output = initial(cardiac_output) * mulListAndCutAssoc(cardiac_output_modificators)

/obj/item/organ/internal/heart/proc/make_nc()
	nc = BLOOD_PRESSURE_NORMAL + sumListAssoc(blood_pressure_modificators) - pressure
	nc /= (pressure / pulse)
	nc = Clamp(nc, -20, 20)

/obj/item/organ/internal/heart/proc/make_modificators()
	make_nc()
	pulse_modificators["hypoperfusion"] = (1 - owner.get_blood_perfusion()) / 0.75
	pulse_modificators["shock"] = owner.shock_stage / 0.75
	if(CE_PULSE in owner.chem_effects)
		pulse_modificators["chem"] = owner.chem_effects[CE_PULSE]
	if(CE_PRESSURE in owner.chem_effects)
		blood_pressure_modificators["chem"] = owner.chem_effects[CE_PRESSURE]
	if(CE_CARDIAC_OUTPUT in owner.chem_effects)
		cardiac_output_modificators["chem"] = owner.chem_effects[CE_CARDIAC_OUTPUT]

/obj/item/organ/internal/heart/proc/handle_rythme()
	switch(rythme)
		if(RYTHME_NORM)
			
		if(RYTHME_AFIB)
			if(ischemia < 15)
				ischemia += 0.15
			cardiac_output_modificators["afib"] = 0.08
			pulse_modificators["afib"] = rand(-20, 20)
		if(RYTHME_AFIB_RR)
			if(ischemia < 20)
				ischemia += 0.20
			cardiac_output_modificators["afib_rr"] = 0.85
			pulse_modificators["afib_rr"] = rand(25, 70)
		if(RYTHME_VFIB)
			ischemia += 0.40
			cardiac_output_modificators["vfib"] = 0.15
			pulse_modificators["afib_rr"] = rand(100, 130)
		if(RYTHME_ASYSTOLE)
			ischemia += 0.70
			var/critical_point = 130 + (ischemia / 50) * 120
			pulse_modificators["asystole"] = -critical_point

/obj/item/organ/internal/heart/proc/post_handle_rythme()
	var/static/last_rythm_change = world.time
	var/changed = FALSE
	switch(rythme)
		if(RYTHME_AFIB)
			if(world.time - last_rythm_change > 3 MINUTES)
				rythme = RYTHME_NORM
				changed = TRUE
		if(RYTHME_AFIB_RR)
			if(world.time - last_rythm_change > 5 MINUTES)
				rythme = RYTHME_AFIB
				changed = TRUE
		if(RYTHME_VFIB)
			if(world.time - last_rythm_change > 1.5 MINUTES)
				rythme = RYTHME_ASYSTOLE
				changed = TRUE
		if(RYTHME_ASYSTOLE)
			var/critical_point = 130 + (ischemia / 50) * 120
			if(pulse > critical_point + 30)
				rythme = RYTHME_VFIB
				changed = TRUE

	if(!changed && rythme < RYTHME_ASYSTOLE && world.time - last_rythm_change > 1.5 MINUTES && prob(50))
		if(pulse >= 170)
			++rythme
		else if(damage / max_damage >= 0.75 && rythme < RYTHME_AFIB_RR)
			++rythme
		else if(damage / max_damage >= 0.25 && rythme < RYTHME_AFIB)
			++rythme

	if(changed)
		last_rythm_change = world.time

/obj/item/organ/internal/heart/proc/handle_blood_pressure()
	pressure = sumListAndCutAssoc(blood_pressure_modificators)
	pressure += 35 + (pulse - 20) * cardiac_output * (M_E ** -((pulse - 60) / (M_PI * 100)))
	pressure *= owner.get_blood_volume()

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= 90 || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		var/rate = 0.0119 * pulse - 0.1795

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound, 0, 0, 0, 50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_ischemia()
	ischemia = min(ischemia, 100)
	if(/datum/organ_disease/infarct in diseases)
		var/datum/organ_disease/infarct/I = locate() in diseases
		ischemia = max(I.strength, ischemia)

	if(ischemia > 30)
		damage += Interpolate(0.1, 0.5, (ischemia - 30) / 70)
	cardiac_output_modificators["ischemia"] = max(1 - (ischemia / 100), 0.3)


/obj/item/organ/internal/heart/proc/handle_blood()

	if(!owner)
		return

	if(owner.stat == DEAD)
		return

	if(pulse)
		//Bleeding out
		var/blood_max = 0
		var/list/do_spray = list()
		for(var/obj/item/organ/external/temp in owner.organs)
			if(temp.robotic >= ORGAN_ROBOT)
				continue

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

		blood_max *= pressure / BLOOD_PRESSURE_NORMAL

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
	if(robotic == ORGAN_ROBOT && is_working())
		if(is_bruised())
			return "sputtering pump"
		else
			return "steady whirr of the pump"

	if(!pulse || (owner.status_flags & FAKEDEATH))
		return "no pulse"

	var/pulsesound = "normal"
	if(is_bruised())
		pulsesound = "irregular"

	. = "[pulsesound] pulse"