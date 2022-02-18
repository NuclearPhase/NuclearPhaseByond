#define NC_POWER (10 KWATT)
#define NC_CRITICAL_POWER (20 MWATT)
#define NC_POWER_PROPORTION 0.5
#define NC_POWER_MAX (NC_POWER * 0.8)

/obj/machinery/power/nuclear/core
	name = "Nuclear core"
	icon = 'icons/obj/machines/nuclear_core.dmi'
	icon_state = "core"

	anchored = TRUE

	pixel_x = -128
	pixel_y = -128

	var/list/rods = list()

	light_color = "#8a8a00"
	var/warning_color = "#b8b800"
	var/emergency_color = "#d9d900"

	var/power = 0
	var/exploded = FALSE

	layer = 2

/obj/machinery/power/nuclear/core/proc/explode()
	set waitfor = 0

	if(exploded)
		return

	log_and_message_admins("Nuclear core exploding at [x] [y] [z]")
	anchored = 1
	exploded = 1
	var/turf/TS = get_turf(src)		// The turf supermatter is on. SM being in a locker, mecha, or other container shouldn't block it's effects that way.
	if(!istype(TS))
		return

	// Effect 4: Medium scale explosion
	spawn(0)
		var/explosion_power = power / NC_CRITICAL_POWER * 9
		explosion(TS, explosion_power/2, explosion_power, explosion_power * 2, explosion_power * 4, 1)
		qdel(src)

/obj/machinery/power/nuclear/core/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return air.heat_capacity

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/nuclear/core/proc/shift_light(lum, clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, l_color = clr)

/obj/machinery/power/nuclear/core/Process()
	var/turf/T = get_turf(src)

	if(power > NC_CRITICAL_POWER)
		if(!exploded)
			explode()
	else if(power > (NC_CRITICAL_POWER*0.5)) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(power > (NC_CRITICAL_POWER*0.75))
			shift_light(7, emergency_color)
	else
		shift_light(4, initial(light_color))

	var/datum/gas_mixture/env = T.return_air()

	var/pwr = min(power * NC_POWER_PROPORTION, NC_POWER_MAX)
	if(env)
		power -= env.add_thermal_energy(pwr)

	var/poweradd = NC_POWER
	for(var/obj/machinery/power/nuclear/controlrod/rod in rods)
		poweradd -= (((100 - rod.state) / 100) * NC_POWER) / 9

	power += poweradd
