#define NC_POWER (1 MWATT) // stable power 
#define NC_CRITICAL_POWER (1200)
#define NC_POWER_PROPORTION 0.5
#define NC_POWER_TRANSFER_MAX 2

/obj/machinery/power/nuclear/core
	name = "Nuclear core"
	icon = 'icons/obj/machines/nuclear_core.dmi'
	icon_state = "core"

	anchored = TRUE

	pixel_x = -128
	pixel_y = -128

	var/list/rods = list()

	light_color = COLOR_DARK_ORANGE
	var/warning_color = COLOR_ORANGE
	var/emergency_color = COLOR_RED

	var/power = 0 // power = realpower / NC_POWER
	var/exploded = FALSE

	layer = 1
	plane = -19

/obj/machinery/power/nuclear/core/proc/explode()
	set waitfor = 0

	if(exploded)
		return

	log_and_message_admins("Nuclear core exploding at [x] [y] [z]")
	exploded = TRUE
	var/turf/TS = get_turf(src)
	if(!istype(TS))
		return

	spawn(0)
		var/explosion_power = min(4, (power / NC_CRITICAL_POWER) * 9)
		explosion(TS, explosion_power/2, explosion_power, explosion_power * 2, explosion_power * 4, 1)
		qdel(src)

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/nuclear/core/proc/shift_light(lum, clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, l_color = clr)

/obj/machinery/power/nuclear/core/Process()
	var/turf/T = get_turf(src)

	if(power > NC_CRITICAL_POWER && prob(1))
		if(!exploded)
			explode()
	else if(power > (NC_CRITICAL_POWER*0.5)) // while the core is still damaged and it's still worth noting its status
		if(power > (NC_CRITICAL_POWER*0.75))
			shift_light(7, emergency_color)
		else
			shift_light(5, warning_color)
	else
		shift_light(4, initial(light_color))

	var/datum/fluid_mixture/env = T.return_air()

	if(env)
		var/outsides = (env.temperature * env.heat_capacity) / NC_POWER
		if(outsides < power)
			var/pwr = min((power - outsides), NC_POWER_TRANSFER_MAX)
			power -= env.add_thermal_energy(pwr * NC_POWER)
		else
			var/dpower = min((outsides - power), NC_POWER_TRANSFER_MAX)
			power += abs(env.add_thermal_energy(-dpower * NC_POWER))

	var/poweradd = 1
	var/coef = 1
	for(var/obj/machinery/power/nuclear/controlrod/rod in rods)
		coef -= (100 - rod.state) / 400
	poweradd *= coef

	power = power + poweradd
