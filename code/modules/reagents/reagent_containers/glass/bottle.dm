
//Not to be confused with /obj/item/weapon/reagent_containers/food/drinks/bottle

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	randpixel = 7
	center_of_mass = "x=15;y=10"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30"
	w_class = ITEM_SIZE_SMALL
	item_flags = 0
	obj_flags = 0
	volume = 30

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_hand()
		..()
		update_icon()

	New()
		..()
		if(!icon_state)
			icon_state = "bottle-[rand(1,4)]"

	update_icon()
		overlays.Cut()

		if(reagents.total_volume && (icon_state == "bottle-1" || icon_state == "bottle-2" || icon_state == "bottle-3" || icon_state == "bottle-4"))
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

			var/percent = round((reagents.total_volume / volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "[icon_state]--10"
				if(10 to 24) 	filling.icon_state = "[icon_state]-10"
				if(25 to 49)	filling.icon_state = "[icon_state]-25"
				if(50 to 74)	filling.icon_state = "[icon_state]-50"
				if(75 to 79)	filling.icon_state = "[icon_state]-75"
				if(80 to 90)	filling.icon_state = "[icon_state]-80"
				if(91 to INFINITY)	filling.icon_state = "[icon_state]-100"

			filling.color = reagents.get_color()
			overlays += filling
		if(reagents.total_volume && (icon_state == "ampoule"))
			var/image/filling = image('icons/obj/reagentfillings.dmi', src, "ampoule")
			filling.color = reagents.get_color()
			overlays += filling

		if (!is_open_container())
			var/image/lid = image(icon, src, "lid_bottle")
			overlays += lid


/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline/New()
	..()
	reagents.add_reagent(/datum/reagent/inaprovaline, 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/ceftriaxone
	name = "ceftriaxone ampoule."
	desc = "A tiny ampoule. Contains ceftriaxone. 6u."
	icon_state = "ampoule"
	volume = 6

/obj/item/weapon/reagent_containers/glass/bottle/ceftriaxone/New()
	..()
	reagents.add_reagent(/datum/reagent/ceftriaxone, 6)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/morphine
	name = "morphine ampoule."
	desc = "A tiny ampoule. Contains morphine. 6u."
	icon_state = "ampoule"
	volume = 6

/obj/item/weapon/reagent_containers/glass/bottle/ceftriaxone/New()
	..()
	reagents.add_reagent(/datum/reagent/tramadol/opium/morphine, 6)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/glucose
	name = "glucose ampoule"
	desc = "A tiny ampoule. Contains glucose. 4u."
	icon_state = "ampoule"
	volume = 2

/obj/item/weapon/reagent_containers/glass/bottle/glucose/New()
	..()
	reagents.add_reagent(/datum/reagent/hormone/glucose, 4)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/insulin
	name = "insulin ampoule"
	desc = "A tiny ampoule. Contains insulin. 2u."
	icon_state = "ampoule"
	volume = 2

/obj/item/weapon/reagent_containers/glass/bottle/insulin/New()
	..()
	reagents.add_reagent(/datum/reagent/hormone/insulin, 2)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/glucagone
	name = "glucagone bottle"
	desc = "A small bottle. Contains glucagone."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/glucagone/New()
	..()
	reagents.add_reagent(/datum/reagent/hormone/glucagone, 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/adenosine
	name = "adenosine bottle"
	desc = "A small bottle. Contains adenosine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/adenosine/New()
	..()
	reagents.add_reagent(/datum/reagent/adenosine, 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/amiodarone
	name = "amiodarone bottle"
	desc = "A small bottle. Contains amiodarone."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/amiodarone/New()
	..()
	reagents.add_reagent(/datum/reagent/amiodarone, 30)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/lidocaine
	name = "lidocaine ampoule"
	desc = "A small ampoule. Contains lidocaine. 5u"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "ampoule"
	volume = 5

/obj/item/weapon/reagent_containers/glass/bottle/lidocaine/New()
	..()
	reagents.add_reagent(/datum/reagent/lidocaine, 5)
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/dopamine
	name = "dopamine bottle"
	desc = "A small bottle. Contains dopamine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/dopamine/New()
	..()
	reagents.add_reagent(/datum/reagent/hormone/dopamine, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/toxin/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/cyanide/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/cyanide, 30) //volume changed to match chloral
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/stoxin/New()
	..()
	reagents.add_reagent(/datum/reagent/soporific, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate
	name = "Chloral Hydrate Bottle"
	desc = "A small bottle of Choral Hydrate. Mickey's Favorite!"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate/New()
	..()
	reagents.add_reagent(/datum/reagent/chloralhydrate, 30)		//Intentionally low since it is so strong. Still enough to knock someone out.
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"

/obj/item/weapon/reagent_containers/glass/bottle/mutagen/New()
	..()
	reagents.add_reagent(/datum/reagent/mutagen, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"

/obj/item/weapon/reagent_containers/glass/bottle/ammonia/New()
	..()
	reagents.add_reagent(/datum/reagent/ammonia, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/eznutrient
	name = "\improper EZ NUtrient bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/eznutrient/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/fertilizer/eznutrient, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/left4zed
	name = "\improper Left-4-Zed bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/left4zed/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/fertilizer/left4zed, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/robustharvest
	name = "\improper Robust Harvest"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/robustharvest/New()
	..()
	reagents.add_reagent(/datum/reagent/toxin/fertilizer/robustharvest, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/diethylamine/New()
	..()
	reagents.add_reagent(/datum/reagent/diethylamine, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/pacid/New()
	..()
	reagents.add_reagent(/datum/reagent/acid/polyacid, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"


/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine/New()
	..()
	reagents.add_reagent(/datum/reagent/adminordrazine, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/capsaicin/New()
	..()
	reagents.add_reagent(/datum/reagent/capsaicin, 30)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"

/obj/item/weapon/reagent_containers/glass/bottle/frostoil/New()
	..()
	reagents.add_reagent(/datum/reagent/frostoil, 30)
	update_icon()
