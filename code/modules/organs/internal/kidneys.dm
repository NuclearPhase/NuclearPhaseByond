/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	min_bruised_damage = 45
	min_broken_damage = 75
	max_damage = 100

/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return

	absorb_hormone(/datum/reagent/hormone/potassium, 0.5)

	generate_hormone(/datum/reagent/hormone/noradrenaline, 0.1, 10)
	generate_hormone(/datum/reagent/hormone/adrenaline, 0.1, 10)

	if(owner.spressure <= BLOOD_PRESSURE_LBAD || owner.get_blood_perfusion() <= BLOOD_PERFUSION_OKAY)
		var/to_increase = owner.spressure * (0.0008 * owner.spressure - 0.8833) + 94
		free_up_to_hormone(/datum/reagent/hormone/noradrenaline, (to_increase / 2 - 1) / 1.1)
		free_up_to_hormone(/datum/reagent/hormone/adrenaline   , (to_increase / 2 - 5) / 1.6)