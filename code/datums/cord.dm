// a datum to hold a coordinates.
/datum/cord
	var/x = 0
	var/y = 0
	var/z = 0

/datum/cord/proc/to_turf()
	var/turf/T = locate(x, y, z)
	return T

/datum/cord/proc/make_step(dir, datum/cord/dest = src)
	if(istype(dest))
		get_cord(get_step(to_turf(), dir), dest)
	else
		var/datum/cord/C = new
		get_cord(get_step(to_turf(), dir), C)
		return C

/proc/get_cord(D, datum/cord/created = null)
	var/turf/T = get_turf(D)
	var/datum/cord/C = created || new
	C.x = T.loc.x
	C.y = T.loc.y
	C.z = T.loc.z

	return C