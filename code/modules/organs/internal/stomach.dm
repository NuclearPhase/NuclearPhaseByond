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
	absolutely_normal_glucose_level = rand(GLUCOSE_LEVEL_LBAD + 0.1, GLUCOSE_LEVEL_HBAD - 0.1)

/obj/item/organ/internal/stomach/influence_hormone(T, amount)
	if(ishormone(T, glucose))
		var/diff = amount - absolutely_normal_glucose_level
		var/produce_hormone_level = min(abs(diff) / 0.1, 2)
		if(abs(diff) < 1)
			return

		if(diff > 0) // >normal
			free_up_to_hormone(/datum/reagent/hormone/insulin, produce_hormone_level)
			absorb_hormone(/datum/reagent/hormone/glucagon, INFINITY, hold = TRUE)
		else if(diff < 0) // <normal
			free_up_to_hormone(/datum/reagent/hormone/glucagon, produce_hormone_level)
			absorb_hormone(/datum/reagent/hormone/insulin, INFINITY, hold = TRUE)

/obj/item/organ/internal/stomach/Process()
	..()
	generate_hormone(/datum/reagent/hormone/insulin, 0.1, 15)
	generate_hormone(/datum/reagent/hormone/glucagon, 0.1, 15)


	