
/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60
	influenced_hormones = list(
		/datum/reagent/hormone/glucagone
	)
	hormones = list(
		/datum/reagent/hormone/glucose = 4
	)

	var/bilirubine_norm = -1
	var/absorbed = 0
	var/absorbed_max = 30

/obj/item/organ/internal/liver/influence_hormone(T, amount)
	if(ishormone(T, glucagone))
		free_hormone(/datum/reagent/hormone/glucose, min(amount, 0.1))
		absorb_hormone(T, min(amount, 0.1) * 10)

/obj/item/organ/internal/liver/Process()
	..()
	if(!owner)
		return

	if(bilirubine_norm < 0)
		bilirubine_norm = rand(15, 21)

	var/cdamage = damage / max_damage
	var/cwork = absorbed / absorbed_max
	make_up_to_hormone(/datum/reagent/hormone/marker/bilirubine, bilirubine_norm + cdamage * 50)
	make_up_to_hormone(/datum/reagent/hormone/marker/ast, 30 + (cwork * 5))
	make_up_to_hormone(/datum/reagent/hormone/marker/alt, 25 + (cwork * 15))

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			to_chat(owner, "<span class='danger'>Your skin itches.</span>")
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	//Detox can heal small amounts of damage
	if (damage < max_damage && !owner.chem_effects[CE_TOXIN])
		heal_damage(0.2 * owner.chem_effects[CE_ANTITOX])

	if(owner.chem_effects[CE_ALCOHOL_TOXIC])
		take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC], prob(90)) // Chance to warn them

	if(absorbed > 0)
		absorbed = max(0, absorbed - 0.15 + LAZYACCESS0(owner.chem_effects, CE_ANTITOX))
	if(absorbed > absorbed_max)
		take_damage(absorbed - absorbed_max)
		absorbed = absorbed_max
	else if(damage > 0)
		var/to_regen = min(damage, absorbed_max - absorbed)
		heal_damage(to_regen)
		absorbed += to_regen

	//Blood regeneration if there is some space
	owner.regenerate_blood(0.1 + owner.chem_effects[CE_BLOODRESTORE])
