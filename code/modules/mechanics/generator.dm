/obj/machinery/power/generator/mechanic_generator
	name = "generator"
	var/datum/internal_shaft/shaft
	icon = 'icons/obj/mechanics.dmi'
	icon_state = "generator"
	var/max_cap = 2 MWATT
	efficiency = 0.6
	var/voltage = 1000

/obj/machinery/power/generator/mechanic_generator/get_shaft()
	return shaft

/obj/machinery/power/generator/mechanic_generator/New()
	..()
	shaft = new

/obj/machinery/power/generator/mechanic_generator/Process()
	handle_shaft()


/obj/machinery/power/generator/mechanic_generator/get_voltage()
	return (shaft.rpm / 20000) * 200 + 1000

/obj/machinery/power/generator/mechanic_generator/available_power()
	return shaft.get_power() * 0.5 * efficiency

/obj/machinery/power/generator/mechanic_generator/on_power_drain(w)
	shaft.add_power(-w / efficiency)
	return w