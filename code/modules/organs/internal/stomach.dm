/obj/item/organ/internal/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_STOMACH
	parent_organ = BP_GROIN
	max_damage = 100
	relative_size = 60
	watched_hormones = list(
		/datum/reagent/hormone/glucose
	)
	var/absolutely_normal_glucose_level

/obj/item/organ/internal/stomach/Initialize()
	absolutely_normal_glucose_level = rand(GLUCOSE_LEVEL_NORMAL + 0.1, GLUCOSE_LEVEL_HBAD - 0.55)

/obj/item/organ/internal/stomach/influence_hormone(T, amount)
	if(ishormone(T, glucose))
		var/diff = amount - absolutely_normal_glucose_level
		var/produce_hormone_level = min(abs(diff) / 0.1, 1)
		if(diff > -0.1 && diff < 2)
			return

		if(diff > 0) // >normal
			free_up_to_hormone(/datum/reagent/hormone/insulin, produce_hormone_level)
			absorb_hormone(/datum/reagent/hormone/glucagone, INFINITY, hold = TRUE)
		else if(diff < 0) // <normal
			free_up_to_hormone(/datum/reagent/hormone/glucagone, produce_hormone_level)
			absorb_hormone(/datum/reagent/hormone/insulin, INFINITY, hold = TRUE)

/obj/item/organ/internal/stomach/Process()
	..()
	// wer simulate glucose-nutrition system by this..
	// TODO: detach this from stomach, remove this copy-paste from insulin code.
	absorb_hormone(/datum/reagent/hormone/glucose, DEFAULT_HUNGER_FACTOR)
	absorb_hormone(/datum/reagent/hormone/potassium, max(DEFAULT_HUNGER_FACTOR * 5, 0.1))

	generate_hormone(/datum/reagent/hormone/insulin, 0.1, 15)
	generate_hormone(/datum/reagent/hormone/glucagone, 0.1, 15)


	