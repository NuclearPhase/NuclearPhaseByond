/obj/structure/alv
	name = "\improper ALV"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "alv"
	anchored = 0
	density = 0
	var/mob/living/carbon/human/attached

/obj/structure/alv/MouseDrop(mob/living/carbon/human/over_object, src_location, over_location)
	if(!CanMouseDrop(over_object))
		return

	if(!usr.skillcheck(SKILL_ACLS, SKILL_TRAINED, message = "You have no idea how to use it."))
		return

	if(over_object?.wear_mask)
		to_chat(usr, SPAN_NOTICE("You need to remove mask before connect [over_object] to \the [src]."))
		return

	var/E = over_object.organs_by_name[BP_HEAD]
	over_object.custom_pain("[usr] is inserting tube into your throat!", 60, affecting = E)
	if(!do_after(usr, 100 - (10 * usr.get_skill(SKILL_ACLS)), over_object))
		return

	if(attached)
		visible_message("\The [attached] is taken off \the [src]")
		attached = null
		attached.clear_event("alv")
	else if(over_object)
		visible_message("\The [usr] connects \the [over_object] to \the [src].")
		attached = over_object
		START_PROCESSING(SSobj, src)

	update_icon()

/obj/structure/alv/Destroy()
	STOP_PROCESSING(SSobj, src)
	attached?.clear_event("alv")
	attached = null
	. = ..()

/obj/structure/alv/update_icon()
	icon_state = attached ? "alv-active" : "alv"

/obj/structure/alv/Process()
	if(prob(15))
		var/E = attached.organs_by_name[BP_HEAD]
		attached.custom_pain("Your throat is hurts so much!", 10, affecting = E)
	var/datum/happiness_event/HE = new
	HE.description = "There is a tube in my throat!"
	HE.happiness = -15
	attached.add_event("alv", HE)

	var/obj/item/organ/internal/lungs/L = attached.internal_organs_by_name[BP_LUNGS]

	if(!attached)
		update_icon()
		attached.clear_event("alv")
		return PROCESS_KILL
	if(!Adjacent(attached))
		var/E = attached.organs_by_name[BP_HEAD]
		if(prob(70) && L)
			attached.custom_pain(SPAN_DANGER("<big>Your throat have been ruptured!</big>"), 80, affecting = E)
			L.take_damage(rand(10, 15))
		else
			attached.custom_pain(SPAN_DANGER("Tube from your throat was ripped out!"), 60, affecting = E)
		attached = null
		update_icon()
		attached.clear_event("alv")
		return PROCESS_KILL

	if(!L)
		return
	var/datum/gas_mixture/breath = attached.get_breath_from_environment()
	var/fail = L.handle_breath(breath, 1)
	if(!fail && prob(20))
		to_chat(src, SPAN_NOTICE("You feel a breath of fresh air enter your lungs. It feels so good."))
