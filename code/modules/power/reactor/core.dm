#define MINIMUM_REACTION_TEMPERATURE 11000000
#define MAXIMUM_REACTION_TEMPERATURE 24000000

#define EFFICIENCY 0.9 //How much of laser power is converted into heat

#define CRIT_TEMPERATURE 12000 //Temperature at which the hull starts getting damaged
#define DEPLETION_MODIFIER 0.05 //How much fuel depletes in two seconds
#define CASING_HEAT_CONDUCTIVITY 0.00001 //How much of overall produced heat are radiated outside







/obj/machinery/power/reactor // A parent
	name = "Fusion"

/obj/machinery/power/reactor/core // Handles reactions
	name = "C.C.F.R"
	desc = "Closed Confinement Fusion Reactor"
	anchored = TRUE

	//Variables essential for operation
	var/rtemperature = T0C //Temperature of the plasma
	var/htemperature = T20C //Temperature of the reactor hull
	var/superstructure_integrity = 100 //Integrity of the reactor containment
	var/pressure = 0 //Pressure in the reaction chamber
	var/power = 0 //Reactivity
	var/power_modifier = 1
	var/list/fuel_cells = list()
	var/list/laser_receivers = list()
	var/fuel_power = 0 //Amount of fuel

	// Enviromental variables
	var/isOperating = FALSE
	var/hasFuel = FALSE
	var/isBreached = FALSE //Is cryostat breached
	var/isRunaway = FALSE //The reactor starts fusing the materials it's made of
	var/isOverloaded = FALSE //Too much power provided by the lasers, resulting in increase of temperature
	var/InjectingFuel = FALSE
	var/CritState = FALSE
	// Coolant variables
	var/CoolantMeltingPoint = 0 //Defines by the coolant insertion module
	var/CoolantAmount = 0 //Amount of coolant in the reactor
	var/CoolantTemperature = T0C
	var/isCoolantMolten = FALSE
	var/hasCoolant = FALSE


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
	if(!isBreached)
		var/release = rtemperature / CASING_HEAT_CONDUCTIVITY
		rtemperature = rtemperature - release
		htemperature = htemperature + release
		var/datum/gas_mixture/environment = loc.return_air()
		var/diff = environment.temperature - htemperature
		environment.add_thermal_energy(diff)
	else
		htemperature = rtemperature
		var/datum/gas_mixture/environment = loc.return_air()
		var/diff = environment.temperature - htemperature
		environment.add_thermal_energy(diff)

//PRESSURE CALCULATION



//COOLANT CALCULATION
	if(CoolantAmount < 5)
		hasCoolant = FALSE
	else
		hasCoolant = TRUE

	if(CoolantTemperature > CoolantMeltingPoint)
		isCoolantMolten = TRUE
	else
		isCoolantMolten = FALSE



//INTERNAL TEMPERATURE CALCULATION
	if(rtemperature < MINIMUM_REACTION_TEMPERATURE)
		return //No reaction
	if(fuel_power < 5)
		return //Same here



//Failures themed stuff
/obj/machinery/power/reactor/core/proc/collapse() //Final stage of the meltdown


//Fuel
/obj/item/rfuel_cell
	name = "Fuel Cell"
	var/fuel_power = 150

/obj/item/rfuel_cell/proc/deplete(D)
	fuel_power = fuel_power - D
	return