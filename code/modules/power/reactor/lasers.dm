

/obj/machinery/power/reactor/laser
	var/integrity = 100
	var/id = null
	var/broke = 0
	anchored = 1
	density = 1

/obj/machinery/power/reactor/laser/emp_act(var/severity/S)
	take_damage(S)
	return 1

/obj/machinery/power/reactor/laser/proc/take_damage(var/amount/A)
	var/diff = integrity - A 
	if(!diff =< 0)
		integrity = integrity - A
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
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	var/gen //Generator reference
	var/cap //Capacitor reference

/obj/machinery/power/reactor/laser/nosecone/Initialize()
	. = ..()

/obj/machinery/power/reactor/laser/nosecone/Destroy()
	log_and_message_admins("deleted \the [src]")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","reactor")
	return ..()

/obj/machinery/power/reactor/laser/nosecone/attack_hand(mob/user as mob)
	src.add_fingerprint(user)

/obj/machinery/power/reactor/laser/nosecone/proc/activate(mob/user as mob)


/obj/machinery/power/reactor/laser/nosecone/Process()
	if(broke)
		return


/obj/machinery/power/reactor/laser/generator
	name = "laser active zone"
	desc = "A massive and heavy industrial laser, capable of releasing gigawatts of power."

/obj/machinery/power/reactor/laser/capacitorarray
	name = "laser capacitor array"
	desc = "A massive and heavy industrial laser, capable of releasing gigawatts of power."
	var/power_stored = 0
	var/max_power = 500000 //Temporary
	var/shoot_point = 500000 //The amount of power on which the laser will automatically shoot. Defaults at 500000