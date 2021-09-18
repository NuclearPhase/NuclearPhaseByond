var/global/pu_denominations = list(10, 5, 4, 3, 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/protein_package
	name = "protein package"
	desc = "Ew... what is this?"
	icon = 'icons/obj/items.dmi'
	icon_state = "pu1"
	filling_color = "#fffee0"
	center_of_mass = "x=17;y=10"
	w_class = ITEM_SIZE_TINY
	nutriment_amt = 3
	nutriment_desc = list("raw" = 3, "bitter" = 4)
	bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/protein_package/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)

/obj/item/protein_package
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "pu1"
	var/num = 0

/obj/item/protein_package/proc/create(n, loc)
	if(n == 1)
		return new /obj/item/weapon/reagent_containers/food/snacks/protein_package(loc)

	var/obj/item/protein_package/cash = new(loc)
	cash.num = n
	cash.update_icon()

	return cash

/obj/item/protein_package/attack_self(mob/user)
	var/amount = input(usr, "How many PP do you wanna take? (0 to [num-1])", "Take PP", 1) as num
	amount = round(Clamp(amount, 0, num - 1))
	if(!amount)
		return

	num -= amount

	user.put_in_hands(create(amount, user.loc))

	user.drop_from_inventory(src)
	user.put_in_hands(create(num, user.loc))

	update_icon()
	qdel(src)

/obj/item/protein_package/update_icon()
	var/iconn = 0
	for(var/d in reverselist(sortList(pu_denominations)))
		if(num >= d)
			icon_state = "pu[d]"
			iconn = d
			break

	overlays.Cut()
	var/overlays_num = num - iconn

	while(overlays_num > 0)
		for(var/d in reverselist(sortList(pu_denominations)))
			if(overlays_num >= d)
				if(prob(50) && d > 1)
					--d
				var/image/I = image('icons/obj/items.dmi', "pu[d]")
				var/matrix/M = matrix()
				M.Translate(rand(-6, 6), rand(-4, 8))
				M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
				I.transform = M
				overlays += I
				overlays_num -= d
				break
			
	name = "pile of [num] protein packages."

/obj/item/weapon/reagent_containers/food/snacks/protein_package/attackby(obj/item/pp, mob/user)
	if(istype(pp, /obj/item/protein_package))
		pp.attackby(src, user)
	else if(istype(pp, /obj/item/weapon/reagent_containers/food/snacks/protein_package))
		var/obj/item/weapon/reagent_containers/food/snacks/protein_package/pp_o = pp
		if(pp_o.reagents.total_volume != 10)
			return

		var/obj/item/protein_package/p2/pp2 = new(user.loc)
		qdel(src)
		qdel(pp)
		user.put_in_hands(pp2)


/obj/item/protein_package/attackby(pp, mob/user)
	if(istype(pp, /obj/item/weapon/reagent_containers/food/snacks/protein_package))
		++num
	else if(istype(pp, /obj/item/protein_package))
		var/obj/item/protein_package/pp2 = pp
		num += pp2.num
	else
		return
	update_icon()
	qdel(pp)

/obj/item/protein_package/Initialize()
	. = ..()
	update_icon()

/obj/item/protein_package/p2
	num = 2

/obj/item/protein_package/p3
	num = 3

/obj/item/protein_package/p4
	num = 4

/obj/item/protein_package/p5
	num = 5

/obj/item/protein_package/p10
	num = 10