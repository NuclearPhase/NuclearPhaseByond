/obj/machinery/food_compressor
	name = "replicator"
	desc = "like a microwave, except better."
	icon = 'icons/obj/vending.dmi'
	icon_state = "soda"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/protein = 100
	var/protein_max = 100
	var/protein_per = 10
	var/protein_extract_eff = 0.25
	var/power_use = 75000

/obj/machinery/food_compressor/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/food_compressor(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)

	RefreshParts()

/obj/machinery/food_compressor/proc/add_protein(amount)
	protein = Clamp(protein + amount * protein_extract_eff, 0, biomass_max)

/obj/machinery/food_compressor/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		user.drop_item(O)
		for(var/datum/reagent/nutriment/protein/P in S.reagents.reagent_list)
			add_protein(P.volume)
		qdel(O)
	else if(istype(O, /obj/item/weapon/storage/plants))
		if(!O.contents || !O.contents.len)
			return
		to_chat(user, "You place \the [O] into \the [src]")
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in O.contents)
			var/obj/item/weapon/storage/S = O
			S.remove_from_storage(G, null)
			for(var/datum/reagent/nutriment/protein/P in S.reagents.reagent_list)
				add_protein(P.volume)
			qdel(G)

	if(default_deconstruction_screwdriver(user, O))
		return
	else if(default_deconstruction_crowbar(user, O))
		return
	else if(default_part_replacement(user, O))
		return
	else
		..()

/obj/machinery/food_compressor/update_icon()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if(!(stat & NOPOWER))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/food_compressor/proc/state_status()
	audible_message("<b>\The [src]</b> states, \"Protein is [protein / (protein_max * 100)]%, can dispence [round(protein / 10)] packages.\"")

/obj/machinery/food_compressor/proc/dispence()
	var/dispence_number = round(protein / 10)

	for(var/i in 1 to dispence_number)
		if(use_power(power_use) < power_use)
			audible_message("<b>\The [src]</b> states, \"Not enough power.\"")
			return
		
		var/obj/item/weapon/reagent_containers/food/snacks/protein_package = new(loc)
		protein -= 10

/obj/machinery/food_compressor/RefreshParts()
	protein_extract_eff = 0
	protein_max = 0
	power_use = 55000
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			protein_max += 100 * P.rating
			power_use += 10000 * P.rating
		if(istype(P, /obj/item/weapon/stock_parts/micro_laser))
			protein_extract_eff += 0.25 * P.rating
			power_use += 10000 * P.rating

/obj/machinery/food_compressor/proc/queue_dish(var/text)
	if(!(text in menu))
		return

	if(!queued_dishes)
		queued_dishes = list()

	queued_dishes += text
	if(world.time > make_time)
		start_making = 1

/obj/machinery/food_compressor/attack_hand(mob/user)
	. = ..()
	dispence()
	src.audible_message("<b>\The [src]</b> rumbles and vibrates.")
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)

/obj/machinery/food_compressor/examine(mob/user)
	. = ..(user)
	if(panel_open)
		to_chat(user, "The maintenance hatch is open.")
