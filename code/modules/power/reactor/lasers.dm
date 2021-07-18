

/obj/machinery/power/reactor/laser
	icon = 'icons/obj/lasers.dmi'
	var/integrity = 100
	var/id = null
	var/broke = 0
	var/break_state
	anchored = 1
	density = 1


/obj/machinery/power/reactor/laser/Initialize()
	. = ..()


/obj/machinery/power/reactor/laser/emp_act(var/severity)
	take_damage(severity)
	return 1

/obj/machinery/power/reactor/laser/proc/take_damage(var/amount)
	var/diff = integrity - amount
	if(!diff <= 0)
		integrity = integrity - amount
	else
		integrity = 0
		critfail()

/obj/machinery/power/reactor/laser/proc/critfail()
	broke = 1
	log_and_message_admins("[src] experienced critical failure")
	//icon_state = "broken"
	playsound(src.loc, get_sfx("explosion"), 25, 1)

/obj/machinery/power/reactor/laser/nosecone // Calculates everything
	name = "laser focus nosecone"
	desc = "A massive and heavy industrial laser, capable of releasing gigawatts of power."
	description_info = "This part of the laser focuses the laser and aligns it properly."
	icon_state = "nosecone"
	break_state = "nosecone_broken"


/obj/machinery/power/reactor/laser/nosecone/Initialize()
	. = ..()
	

/obj/machinery/power/reactor/laser/nosecone/Destroy()
	log_and_message_admins("deleted \the [src]")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","reactor")
	return ..()

/obj/machinery/power/reactor/laser/nosecone/attack_hand(mob/user as mob)
	src.add_fingerprint(user)

/obj/machinery/power/reactor/laser/nosecone/proc/activate(mob/user as mob)

/obj/machinery/power/reactor/laser/nosecone/proc/shoot()
	var/obj/item/projectile/beam/reactor/A = get_beam()
	A.damage = sup.power_stored
	A.launch( get_step(src.loc, src.dir) )
	sup.power_stored = 0

/obj/machinery/power/reactor/laser/nosecone/Process(var/cap, var/sup)
	if(gen.broke)
		return
	if(sup.broke)
		return
	if(broke)
		return

	if(!sup.shoot_point <= sup.power_stored)
		return

	if(max_power <= power_stored) //Overcharge
		playsound(src.loc, 'sound/effects/alert.ogg', 25, 1)
		src.visible_message("<span class='warning'>Alarm comes out of the capacitor array, it is about to discharge!.</span>")
		sup.power_stored = sup.power_stored *  2.5
		sleep(20.5)
		shoot()
		for(var/mob/living/carbon/M in hear(7, get_turf(src)))
			if(eye_safety < FLASH_PROTECTION_MODERATE)
				M.flash_eyes()
				M.Stun(2)
				M.Weaken(10)
				to_chat(M, "<span class='warning'>An extremely bright flash blinds you!.</span>")
		return
	else
		shoot()

/obj/machinery/power/reactor/laser/nosecone/proc/get_beam()
	return new /obj/item/projectile/beam/reactor(get_turf(src))

/obj/machinery/power/reactor/laser/generator
	name = "laser active zone"
	desc = "A massive and heavy industrial laser, capable of releasing gigawatts of power."
	icon_state = "generator"
	break_state = "generator_broken"

/obj/machinery/power/reactor/laser/supplysystem
	name = "laser power supply system"
	desc = "A massive and heavy industrial laser, capable of releasing gigawatts of power."
	icon_state = "supply"
	break_state = "supply_broken"
	var/power_stored = 0
	var/max_power = 600000 //Temporary
	var/shoot_point = 400000 //The amount of power on which the laser will automatically shoot. Defaults at 400000
/obj/machinery/power/reactor/laser/supplysystem/New()
	
/obj/machinery/power/reactor/laser/supplysystem/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/reactor/laser/supplysystem/Process()
	power_stored = avail()
	

