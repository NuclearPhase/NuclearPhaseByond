#define CRIT_TEMPERATURE 120000
#define DEPLETION_MODIFIER 1.2
#define CASING_HEAT_CONDUCTIVITY 0.001 //How much of overall produced heat are radiated outside







/obj/machinery/power/reactor // A parent
	name = "Fusion"

/obj/machinery/power/reactor/core // Handles reactions
	name = "C.C.F.R"
	desc = "Closed Confinement Fusion Reactor"
	anchored = TRUE
	// Variables essential for operation
	var/rtemperature = 400 //Temperature of the plasma
	var/htemperature = 131 //Temperature of the reactor hull
	var/superstructure_integrity = 100 //Integrity of the reactor containment
	var/pressure = 0 //Pressure in the reaction chamber
	var/power = 0 //The power that the reactor is consuming only by itself
	var/power_modifier = 1
	var/list/fuel_cells = list()
	var/fuel_power
	// Enviromental variables
	var/isOperating = 0
	var/hasFuel = 0
	var/isBreached = 0
	var/isRunaway = 0
	var/hasCoolant = 0
	var/isOverloaded = 0
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

/obj/machinery/power/reactor/core/proc/rstartup()
	if(!hasCoolant)
		src.visible_message("<span class='warning'>\The [src] shudders visibly, something is wrong!</span>")
	if(!OperationalLasers)
		src.visible_message("<span class='warning'>\The [src] beeps loudly, yet there is no lasers firing!</span>")
		return
	if(superstructure_integrity < 80)
		src.visible_message("<span class='warning'>\The [src] beeps loudly, you see smoke coming out of intakes!</span>")
		return
	isOperating = 1
	src.visible_message("<span class='warning'>\The intakes of the [src] open widely, making a nasty pumping noise!</span>")
	sleep(50)
	src.visible_message("<span class='warning'>\The [src] visibly comes alive!</span>")
	// Lights on animation here please
	sleep(50)
	src.visible_message("<span class='warning'>\The lasers begin to spin up, stand clear!</span>")
	// Spinup animation here please
	sleep(100)
	ignition()
	return

/obj/machinery/power/reactor/core/proc/ignition()
	if(!hasFuel)
		superstructure_integrity = superstructure_integrity - rand(1,10)
		return

/obj/machinery/power/reactor/core/proc/rshutdown()

/obj/machinery/power/reactor/core/proc/process() // Just a timer with some vital things
	if(rtemperature > CoolantMeltingPoint)
		isCoolantMolten = 1
	else
		isCoolantMolten = 0
	if(rtemperature > UNSTABLE_TEMPERATURE)
		eventprocess()
	fuel_power = 0 //Reset the fuel calculation
	if(hasFuel)
		for(var/obj/item/rfuel_rod/FC in fuel_cells)
			fuel_power += FC.fuel_power
			var/depletionmodifier = OperationalLasers * DEPLETION_MODIFIER
			//FR.deplete(depletionmodifier)
	temperatureprocess()
	//SSradiation.radiate(src, rtemperature * DEPLETION_MODIFIER / 10)

/obj/machinery/power/reactor/core/proc/temperatureprocess()

/obj/machinery/power/reactor/core/proc/eventprocess()
	var/severity = rand(1,100) //Chances of bad events.
	if(CritState)
		switch(severity)
			if(0 to 10)
				for(var/obj/machinery/light/L in SSmachines.machinery)
					if(prob(25))
						L.flicker()
			if(10 to 20)
				src.visible_message("<span class='boldwarning'>\The [src] shudders as it cools itself by releasing extremely hot air!</span>")
				var/diff = rand(1,1000)
				rtemperature = rtemperature - diff
				var/datum/gas_mixture/environment = loc.return_air()
				environment.add_thermal_energy(diff)
			if(20 to 30)
				for(var/obj/machinery/power/apc/A in SSmachines.machinery)
					if(prob(25))
						A.overload_lighting()
			if(30 to 95)
				var/loss = rand(1,5)
				if(superstructure_integrity > loss)
					superstructure_integrity = superstructure_integrity - loss
			if(95 to 100)
				for(var/obj/machinery/power/apc/A in SSmachines.machinery)
					if(prob(75))
						A.overload_lighting()
				//SSradiation.radiate(src, rtemperature * fuel_power)
	else
		if(prob(5) && !CritState)
			CritState = 1
	return
/obj/item/rfuel_cell
	name = "Fuel Cell"
	var/fuel_power = 150
/*/obj/item/rfuel_cell/proc/deplete(var/E)
	if(fuel_power < 5)
		var/obj/machinery/power/fusion/core/C = locate() in SSmachines.machinery
		if(!C.CritState) //No shutdown because of fuel running out in critical state
			C.rshutdown()
	var/deplamount = rand(0.1,0.3) * E
	fuel_power = fuel_power - deplamount
	return*/