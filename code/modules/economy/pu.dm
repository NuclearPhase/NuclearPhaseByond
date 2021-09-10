var/global/pu_denominations = list(10, 5, 4, 3, 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/protein_package
	name = "Protein package"
	desc = "Ew... what is this?"
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "pu1"
    filling_color = "#fffee0"
	center_of_mass = "x=17;y=10"
	w_class = ITEM_SIZE_TINY
    nutriment_amt = 3
	nutriment_desc = list("raw" = 3, "protein" = 3)
    bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/protein_package/New()
    ..()
    reagents.add_reagent(/datum/reagent/nutriment/protein, 10)