/datum/powernet
	var/list/cables = list()	// all cables & junctions
	var/list/nodes = list()		// all connected machines

	var/smes_demand = 0			// Amount of power demanded by all SMESs from this network. Needed for load balancing.
	var/list/inputting = list()	// List of SMESs that are demanding power from this network. Needed for load balancing.

	var/smes_avail = 0			// Amount of power (avail) from SMESes. Used by SMES load balancing
	var/smes_newavail = 0		// As above, just for newavail

	var/netexcess = 0			// excess power on the powernet (typically avail-load)

	var/problem = 0				// If this is not 0 there is some sort of issue in the powernet. Monitors will display warnings.
	var/voltage = 0
	var/newvoltage = 0

	var/ldemand = 0
	var/demand = 0 // W
	var/lavailable = 0
	var/available = 0 // W

/datum/powernet/proc/add_power(a, v)
	if((voltage - 0.1) >= v)
		return
	newvoltage = v
	available += a * v

/datum/powernet/proc/add_power_w(w, v)
	if((voltage - 0.1) >= v)
		return
	newvoltage = v
	available += w

/datum/powernet/New()
	START_PROCESSING_POWERNET(src)
	..()

/datum/powernet/Destroy()
	for(var/obj/structure/cable/C in cables)
		cables -= C
		C.powernet = null
	for(var/obj/machinery/power/M in nodes)
		nodes -= M
		M.powernet = null
	STOP_PROCESSING_POWERNET(src)
	return ..()

/datum/powernet/proc/load()
	return min(ldemand, lavailable)

//Returns the amount of excess power from last tick.
//This is for machines that might adjust their power consumption using this data.
// {W}
/datum/powernet/proc/last_surplus()
	return max(0, lavailable - ldemand)

/datum/powernet/proc/draw_power(w)
	demand += w
	return min(w, last_surplus())

/datum/powernet/proc/is_empty()
	return !cables.len && !nodes.len

//remove a cable from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/remove_cable(var/obj/structure/cable/C)
	cables -= C
	C.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it

//add a cable to the current powernet
//Warning : this proc DON'T check if the cable exists
/datum/powernet/proc/add_cable(var/obj/structure/cable/C)
	if(C.powernet)// if C already has a powernet...
		if(C.powernet == src)
			return
		else
			C.powernet.remove_cable(C) //..remove it
	C.powernet = src
	cables +=C

//remove a power machine from the current powernet
//if the powernet is then empty, delete it
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/remove_machine(var/obj/machinery/power/M)
	nodes -=M
	M.powernet = null
	if(is_empty())//the powernet is now empty...
		qdel(src)///... delete it - qdel


//add a power machine to the current powernet
//Warning : this proc DON'T check if the machine exists
/datum/powernet/proc/add_machine(var/obj/machinery/power/M)
	if(M.powernet)// if M already has a powernet...
		if(M.powernet == src)
			return
		else
			M.disconnect_from_network()//..remove it
	M.powernet = src
	nodes[M] = M

// Triggers warning for certain amount of ticks
/datum/powernet/proc/trigger_warning(var/duration_ticks = 20)
	problem = max(duration_ticks, problem)

/datum/powernet/proc/handle_generators()
	var/list/sorted = list() // unperfomance shit
	for(var/obj/machinery/power/generator/G in nodes)
		sorted[G] = G.available_power()

	if(sorted.len > 1)
		sorted = sortAssoc(sorted)
		var/tcoef = (sorted.len / (sorted.len-1))

		var/tosuck = ldemand
		for(var/A in sorted)
			var/obj/machinery/power/generator/G = A
			var/np = tosuck / sorted.len
			var/ap = sorted[A]
			var/v = G.get_voltage()

			if((voltage - 0.1) >= v || ap < 1)
				tosuck += np * tcoef
				continue

			newvoltage = v
			if(ap >= np)
				G.on_power_drain(np)
			else
				tosuck += (np - ap) * tcoef
				if(ap)
					G.on_power_drain(ap)
			available += ap
	else if(sorted.len)
		var/obj/machinery/power/generator/G = sorted[1]
		var/ap = sorted[G]
		var/v = G.get_voltage()

		if((voltage - 0.1) >= v || ap < 1)
			return
		newvoltage = v
		available += ap
		G.on_power_drain(min(ap, ldemand))
		

//handles the power changes in the powernet
//called every ticks by the powernet controller
/datum/powernet/proc/reset()

	//var/numapc = 0

	if(problem > 0)
		problem = max(problem - 1, 0)
	var/coef = min(1, 0.8 + cables.len * 0.045)

	if(voltage)
		for(var/obj/structure/cable/C in cables)
			var/turf/T = get_turf(C)
			var/datum/fluid_mixture/environment = T.return_air()
			var/used = draw_power(POWERNET_HEAT(src, C.resistance) / coef)
			environment.add_thermal_energy(POWER2HEAT(used))

	handle_generators()
/*
	// At this point, all other machines have finished using power. Anything left over may be used up to charge SMESs.
	if(inputting.len && smes_demand)
		var/smes_input_percentage = clamp((netexcess / smes_demand) * 100, 0, 100)
		for(var/obj/machinery/power/smes/S in inputting)
			S.input_power(smes_input_percentage)

	netexcess = avail - load

	if(netexcess)
		var/perc = get_percent_load(1)
		for(var/obj/machinery/power/smes/S in nodes)
			S.restore(perc)

	viewload = load
*/

	//reset the powernet
	smes_avail = smes_newavail
	inputting.Cut()
	smes_demand = 0
	smes_newavail = 0
	voltage = newvoltage
	newvoltage = 0
	ldemand = demand
	demand = 0
	lavailable = available
	available = 0

/datum/powernet/proc/get_percent_load(var/smes_only = 0)
	if(smes_only)
		var/smes_used = load() - (available - smes_avail) 			// SMESs are always last to provide power
		if(!smes_used || smes_used < 0 || !smes_avail)			// SMES power isn't available or being used at all, SMES load is therefore 0%
			return 0
		return clamp((smes_used / smes_avail) * 100, 0, 100)	// Otherwise return percentage load of SMESs.
	else
		if(!load())
			return 0
		return clamp((available / load()) * 100, 0, 100)

/datum/powernet/proc/get_electrocute_damage()
	switch(POWERNET_AMPERAGE(src))
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000)
			return min(rand(10,20),rand(10,20))
		else
			return 0

////////////////////////////////////////////////
// Misc.
///////////////////////////////////////////////


// return a knot cable (O-X) if one is present in the turf
// null if there's none
/turf/proc/get_cable_node()
	if(!istype(src, /turf/simulated))
		return null
	for(var/obj/structure/cable/C in src)
		if(C.d1 == 0)
			return C
	return null


/area/proc/get_apc()
	return apc
