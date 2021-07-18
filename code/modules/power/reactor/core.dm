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
	var/global/list/laser_receivers = list()
	var/global/RREACTOR
	var/list/rfuel_cells
	var/fuel_power = 0 //Amount of fuel
	pixel_y = 144
	pixel_x = 144
	bound_height = 144
	bound_width = 144
	bound_x = 144
	bound_y = 144
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

/obj/machinery/power/reactor/core/New()
	RREACTOR = src

/obj/machinery/power/reactor/core/proc/handle_sound()
	
	
/obj/machinery/power/reactor/core/proc/process() // Just a timer with some vital things
	temperatureprocess()
	//SSradiation.radiate(src, rtemperature * DEPLETION_MODIFIER / 10)

/obj/machinery/power/reactor/core/proc/temperatureprocess()
//REACTIVITY CALCULATION
	fuel_power = 0
	for(var/obj/item/rfuel_cell/FC in rfuel_cells)
		fuel_power = fuel_power + FC.fuel_power
		FC.deplete()
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
	src.visible_message("<span class='boldwarning'>The superstructure of the [src] collapses!</span>")
	new /obj/structure/plasmaball(loc)
	qdel(src)

/obj/structure/plasmaball
	name = "escaped plasma"
	desc = "An extremely large ball of plasma. You feel hopeless."
	icon = 'icons/obj/plasmaball.dmi'

/obj/structure/plasmaball/New()
	playsound(playsound(src.loc, 'sound/weapons/emitter2.ogg', 150, 1)) //Temporary sound
	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		M.flash_eyes()
		M.Stun(2)
		M.Weaken(10)
		to_chat(M, "<span class='warning'>You hear an extremely loud noise, after which comes silence...</span>")
	Cycle()

/obj/structure/plasmaball/proc/Cycle()
	icon_state = "13x13"
	spawn(750)
	icon_state = "3x3"
	spawn(400)
	icon_state = "explode"
	spawn(50)
	Explode()

/obj/structure/plasmaball/proc/Explode()

//Fuel
/obj/item/rfuel_cell
	name = "Fuel Cell"
	var/fuel_power = 150

/obj/item/rfuel_cell/proc/deplete(D)
	if(fuel_power <= D)
		fuel_power = 0
	else
		fuel_power - fuel_power - D

/obj/machinery/power/reactor/fuel_injector
	name = "fuel injector"
	desc = "Fuel cell holder."
	var/locked = FALSE
	var/melted = FALSE

/obj/machinery/power/reactor/fuel_injector/first
	var/global/FI1
/obj/machinery/power/reactor/fuel_injector/first/New()
	FI1 = src

/obj/machinery/power/reactor/fuel_injector/second
	var/global/FI2
/obj/machinery/power/reactor/fuel_injector/second/New()
	FI2 = src

/obj/machinery/power/reactor/fuel_injector/third
	var/global/FI3
/obj/machinery/power/reactor/fuel_injector/third/New()
	FI3 = src