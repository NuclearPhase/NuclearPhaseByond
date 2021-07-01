#define MINIMUM_REACTION_TEMPERATURE 11000000
#define MAXIMUM_REACTION_TEMPERATURE 24000000

#define CRIT_TEMPERATURE 12000 //Temperature at which the hull starts burning
#define DEPLETION_MODIFIER 0.05 //How much fuel depletes in two seconds
#define CASING_HEAT_CONDUCTIVITY 0.00001 //How much of overall produced heat are radiated outside







/obj/machinery/power/reactor // A parent
	name = "Fusion"

/obj/machinery/power/reactor/core // Handles reactions
	name = "C.C.F.R"
	desc = "Closed Confinement Fusion Reactor"
	anchored = TRUE
	
	// Variables essential for operation
	var/rtemperature = T0C //Temperature of the plasma
	var/htemperature = T20C //Temperature of the reactor hull
	var/superstructure_integrity = 100 //Integrity of the reactor containment
	var/pressure = 0 //Pressure in the reaction chamber
	var/power = 0 //Reactivity
	var/power_modifier = 1
	var/list/fuel_cells = list()
	var/fuel_power = 0
	// Enviromental variables
	var/isOperating = 0
	var/hasFuel = 0
	var/isBreached = 0 //Is cryostat breached
	var/isRunaway = 0 //The reactor starts fusing the materials it's made of
	var/hasCoolant = 0
	var/isOverloaded = 0 //Too much power provided by the lasers, resulting in increase of temperature
	var/isCoolantMolten = 0
	var/CoolantMeltingPoint = 0
	var/InjectingFuel = 0
	var/OperationalLasers = 0
	var/CritState = 0


/obj/machinery/power/reactor/core/examine(mob/user)
	. = ..()
	if(Adjacent(src, user))
		if(do_after(user, 1 SECONDS, target=src))
			var/msg = "<span class='warning'>The reactor looks operational.</span>"
			switch(superstructure_integrity)
				if(0 to 10)
					msg = "<span class='boldwarning'>[src] is melting down, spewing liquid metal all around the place! </span>"
				if(10 to 25)
					msg = "<span class='boldwarning'>The superstructure of the [src] is breached and has fire bursting out of the hole! </span>"
				if(25 to 60)
					msg = "<span class='warning'>Superstructure of the [src] is swelled and oxidized, it can't be good...</span>"
				if(60 to 80)
					msg = "<span class='warning'>[src] looks damaged, but the superstructure is still holding.</span>"
				if(80 to 90)
					msg = "<span class='notice'>[src] are in good shape.</span>"
				if(95 to 100)
					msg = "<span class='notice'>[src] looks factory new.</span>"
			. += msg

/obj/machinery/power/reactor/core/proc/process() // Just a timer with some vital things
	temperatureprocess()
	//SSradiation.radiate(src, rtemperature * DEPLETION_MODIFIER / 10)

/obj/machinery/power/reactor/core/proc/temperatureprocess()



//REACTIVITY CALCULATION
	/*fuel_power = 0
	for(var/obj/item/rfuel_rod/FC in fuel_cells)
			fuel_power += FC.fuel_power
			FC.deplete(DEPLETION_MODIFIER)*/

//HULL TEMPERATURE CALCULATION
	var/release = rtemperature / CASING_HEAT_CONDUCTIVITY
	rtemperature = rtemperature - release
	htemperature = htemperature + release
	var/datum/gas_mixture/environment = loc.return_air()
	var/diff = environment.temperature - htemperature
	environment.add_thermal_energy(diff)

//PRESSURE CALCULATION



//INTERNAL TEMPERATURE CALCULATION
	if(rtemperature < MINIMUM_REACTION_TEMPERATURE)
		return //No reaction
	

//COOLANT CALCULATION



/obj/item/rfuel_cell
	name = "Fuel Cell"
	var/fuel_power = 150

/obj/item/rfuel_cell/proc/deplete(var/D)
	fuel_power = fuel_power - D
	return