/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/list/will_assist_languages = list()
	var/list/datum/language/assists_languages = list()
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/list/datum/organ_disease/diseases
	var/list/hormones // list of amount of hormones by type.
	var/list/influenced_hormones // list of hormones, what process in proc/influence_hormone
	var/list/watched_hormones // list of hormones, what always process in influence_hormone

	var/list/waste_hormones = list(
		/datum/reagent/hormone/potassium = 0.02
	)

	var/max_damage_regen = 0.1

/obj/item/organ/internal/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;add_organ_disease=\ref[src]'>Add disease</option>
		"}

/obj/item/organ/internal/proc/influence_hormone(T, amount)
	return

/obj/item/organ/internal/proc/make_hormone(T, amount)
	if(!owner)
		return
	owner.bloodstr.add_reagent(T, amount, safety = TRUE)

/obj/item/organ/internal/proc/make_up_to_hormone(T, amount)
	if(!owner)
		return
	var/cur_amount = owner.bloodstr.get_reagent_amount(T)
	if(amount <= cur_amount)
		return
	make_hormone(T, amount - cur_amount)

/obj/item/organ/internal/proc/free_hormone(T, amount)
	if(!owner || !(LAZYISIN(hormones, T)))
		return
	var/to_use = min(amount, hormones[T])
	make_hormone(T, to_use)
	hormones[T] -= to_use

/obj/item/organ/internal/proc/free_up_to_hormone(T, amount)
	if(!owner)
		return
	var/cur_amount = owner.bloodstr.get_reagent_amount(T)
	if(amount <= cur_amount)
		return
	free_hormone(T, amount - cur_amount)

/obj/item/organ/internal/proc/generate_hormone(T, amount, max = INFINITY)
	if(!owner)
		return
	var/cur_amount = LAZYACCESS0(hormones, T)
	amount = min(cur_amount + amount, max) - cur_amount
	if(amount <= 0)
		return

	LAZYINITLIST(hormones)
	if(T in hormones)
		hormones[T] += amount
	else
		hormones[T] = amount

	for(var/T1 in SANITIZE_LIST(waste_hormones))
		make_hormone(T1, waste_hormones[T1] * amount * 0.01)
	
/obj/item/organ/internal/proc/absorb_hormone(T, amount, desired = 0, hold = FALSE)
	if(!owner)
		return
	if(!desired)
		desired = owner.bloodstr.get_reagent_amount(T) // TODO: remove this hack.
	var/to_absorb = min(desired, owner.bloodstr.get_reagent_amount(T), amount)
	owner.bloodstr.remove_reagent(T, to_absorb)
	if(hold)
		LAZYINITLIST(hormones)
		if(T in hormones)
			hormones[T] += to_absorb
		else
			hormones[T] = to_absorb


/obj/item/organ/internal/New(var/mob/living/carbon/holder)
	if(max_damage)
		min_bruised_damage = round(max_damage / 4)
	..()
	if(istype(holder))
		holder.internal_organs |= src

		var/mob/living/carbon/human/H = holder
		if(istype(H))
			var/obj/item/organ/external/E = H.get_organ(parent_organ)
			if(!E)
				CRASH("[src] spawned in [holder] without a parent organ: [parent_organ].")
			E.internal_organs |= src
			E.cavity_max_w_class = max(E.cavity_max_w_class, w_class)

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	return ..()

//disconnected the organ from it's owner but does not remove it, instead it becomes an implant that can be removed with implant surgery
//TODO move this to organ/internal once the FPB port comes through
/obj/item/organ/proc/cut_away(var/mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent)) //TODO ensure that we don't have to check this.
		removed(user, 0)
		parent.implants += src

/obj/item/organ/internal/removed(var/mob/living/user, var/drop_organ=1, var/detach=1)
	if(owner)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		owner.internal_organs_by_name -= null
		owner.internal_organs -= src

		if(detach)
			var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
			if(affected)
				affected.internal_organs -= src
				status |= ORGAN_CUT_AWAY
	..()

/obj/item/organ/internal/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)

	if(!istype(target))
		return 0

	if(status & ORGAN_CUT_AWAY)
		return 0 //organs don't work very well in the body when they aren't properly attached

	// robotic organs emulate behavior of the equivalent flesh organ of the species
	if(robotic >= ORGAN_ROBOT || !species)
		species = target.species

	..()

	STOP_PROCESSING(SSobj, src)
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src
	return 1

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/remove_rejuv()
	if(owner)
		owner.internal_organs -= src
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		while(null in owner.internal_organs)
			owner.internal_organs -= null
		var/obj/item/organ/external/E = owner.organs_by_name[parent_organ]
		if(istype(E)) E.internal_organs -= src
	..()

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/robotize()
	..()
	min_bruised_damage += 5
	min_broken_damage += 10

/obj/item/organ/internal/proc/getToxLoss()
	if(isrobotic())
		return damage * 0.5
	return damage

/obj/item/organ/internal/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/internal/proc/is_damaged()
	return damage > 0

/obj/item/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/internal/take_damage(amount, var/silent=0)
	if(isrobotic())
		damage = clamp(src.damage + (amount * 0.8), 0, max_damage)
	else
		damage = clamp(src.damage + amount, 0, max_damage)

		//only show this if the organ is not robotic
		if(owner && can_feel_pain() && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(damage < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree].", amount, affecting = parent)

// note that ..() in begin of Process()
/obj/item/organ/internal/Process()
	. = ..()
	if(!owner)
		return
	
	for(var/datum/organ_disease/OD in SANITIZE_LIST(diseases))
		if(OD.can_gone())
			diseases -= OD
			qdel(OD)
			break
		OD.update()
	for(var/T in SANITIZE_LIST(influenced_hormones))
		if(owner.bloodstr.has_reagent(T))
			influence_hormone(T, min(owner.bloodstr.get_reagent_amount(T), owner.bloodstr.get_overdose(T)))
	for(var/T in SANITIZE_LIST(watched_hormones))
		influence_hormone(T, min(owner.bloodstr.get_reagent_amount(T), owner.bloodstr.get_overdose(T)))
	for(var/T in SANITIZE_LIST(waste_hormones))
		make_hormone(T, waste_hormones[T])

	if(!vital && damage && owner.bloodstr.get_reagent_amount(/datum/reagent/hormone/glucose) >= GLUCOSE_LEVEL_NORMAL)
		var/regen = min(max_damage_regen, damage)
		absorb_hormone(/datum/reagent/hormone/glucose, regen)
		damage = max(0, damage)

/obj/item/organ/internal/rejuvenate(var/ignore_prosthetic_prefs)
	germ_level = 0
	diseases?.Cut()
	hormones = initial(hormones)

	..()