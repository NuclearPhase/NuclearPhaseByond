#define ADIABATIC_EXPONENT 0.667 //Actually adiabatic exponent - 1.

/obj/machinery/atmospherics/binary/turbine
	var/datum/internal_shaft/shaft
	var/efficiency = 0.6
	icon = 'icons/obj/mechanics.dmi'
	icon_state = "turbine"

	var/reversed = FALSE
	var/dP = 0 // debug
	var/gear = 1

/obj/machinery/atmospherics/binary/turbine/get_shaft()
	return shaft

/obj/machinery/atmospherics/binary/turbine/get_shaft_dir()
	return turn(dir, 90)

/obj/machinery/atmospherics/binary/turbine/New()
	..()
	shaft = new

/obj/machinery/atmospherics/binary/turbine/Process()
	handle_shaft()
	var/datum/fluid_mixture/air_in  = reversed ? air2 	  : air1
	var/datum/fluid_mixture/air_out = reversed ? air1 	  : air2
	var/datum/pipe_network/net_in 	= reversed ? network2 : network1
	var/datum/pipe_network/net_out 	= reversed ? network1 : network2

	var/input_starting_pressure 	= RETURN_PRESSURE(air_in)
	var/output_starting_pressure 	= RETURN_PRESSURE(air_out)

	dP 								= max(input_starting_pressure - output_starting_pressure - 5, 0)

	//only circulate air if there is a pressure difference (plus 5kPa kinetic, 10kPa static friction)
	if(air_in.temperature <= 0 || dP <= 5)
		return
	
	//Calculate energy generated from kinetic turbine
	var/power = min(dP * net_in.volume, input_starting_pressure * air_in.volume) / ADIABATIC_EXPONENT
	shaft.add_torque(power * efficiency * POWER_TO_PUMP, gear)

	//Calculate necessary moles to transfer using PV = nRT
	var/datum/fluid_mixture/removed = air_in.remove((dP * net_in.volume / (air_in.temperature * R_IDEAL_GAS_EQUATION)) / 3) //uses the volume of the whole network, not just itself
		
	//Actually transfer the gas
	if(!removed)
		return

	removed.add_thermal_energy(-power)
	air_out.merge(removed)
	net_out.update = 1