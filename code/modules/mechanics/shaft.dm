/datum/internal_shaft
	var/rpm = 0
	var/mass = 10

/datum/internal_shaft/proc/add_torque(torque, gear = 1)
	var/arpm = (torque * gear) / mass
	if(arpm < 0 || (torque / gear) > rpm)
		rpm += arpm


/datum/internal_shaft/proc/add_power(power, gear = 1)
	add_torque(power / mass, gear)

/datum/internal_shaft/proc/get_power()
	return rpm * mass

/datum/internal_shaft/proc/equalize(list/datum/internal_shaft/shafts)
	if(!shafts.len)
		return

	var/total_power = get_power()
	var/total_mass = mass
	for(var/datum/internal_shaft/shaft in shafts)
		total_power += shaft.get_power()
		total_mass += shaft.mass

	for(var/datum/internal_shaft/shaft in shafts + src)
		shaft.rpm = total_power / total_mass

/datum/internal_shaft/proc/handle_losses()
	rpm = max(0, rpm - (rpm ** 1.1) / (mass * 60))

/obj/proc/handle_shaft()
	var/datum/internal_shaft/shaft = get_shaft()
	shaft?.handle_losses()

/obj/proc/get_shaft()
	return null
/obj/proc/get_shaft_dir()
	return dir

/obj/shaft
	var/datum/internal_shaft/shaft
	var/list/datum/internal_shaft/connections = list()
	icon = 'icons/obj/mechanics.dmi'
	icon_state = "shaft"
	var/mass = 10

/obj/shaft/New()
	..()
	shaft = new
	shaft.mass = mass

/obj/shaft/Initialize()
	..()
	START_PROCESSING(SSmechanic, src)

/obj/shaft/Destroy()
	..()
	STOP_PROCESSING(SSmechanic, src)

/obj/shaft/get_shaft()
	return shaft

/obj/shaft/proc/update_connections()
	connections.Cut()
	var/revdir = GLOB.reverse_dir[dir]
	for(var/d in list(dir, revdir))
		for(var/obj/O in get_step(loc, d))
			var/datum/internal_shaft/shaft = O.get_shaft()
			if(shaft && (O.get_shaft_dir() == dir || O.get_shaft_dir() == revdir))
				connections += shaft

/obj/shaft/Process()
	if(!connections.len)
		update_connections()

	shaft.equalize(connections)
	handle_shaft()