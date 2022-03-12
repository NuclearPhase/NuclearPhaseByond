/obj/machinery/power/mechanic_generator
	name = "generator"
	var/datum/internal_shaft/shaft
	icon = 'icons/obj/mechanics.dmi'
	icon_state = "generator"
	var/max_cap = 2 MWATT
	efficiency = 0.6
	var/voltage = 1000

/obj/machinery/power/mechanic_generator/get_shaft()
	return shaft

/obj/machinery/power/mechanic_generator/New()
	..()
	shaft = new

/obj/machinery/power/mechanic_generator/Process()
	var/power = shaft.get_power()
	if(power < 100)
		return
	power *= efficiency * 0.5

	power = min(power, max_cap)
	power = generate_power(power / voltage, voltage)
	shaft.add_power(-power)
	
	handle_shaft()
