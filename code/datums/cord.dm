// a datum to hold a coordinates.
/datum/cord
	var/x = 0
	var/y = 0
	var/z = 0

/datum/cord/proc/to_turf()
	var/turf/T = locate(x, y, z)
	return T

/datum/cord/proc/apply_step(dir)
	switch(dir)
		if(UP)
			++z
		
		if(DOWN)
			--z

		if(WEST)
			--x

		if(EAST)
			++x

		if(NORTH)
			--y

		if(SOUTH)
			++y

/datum/cord/proc/make_step(dir, datum/cord/dest = src)
	if(dest && dest == src)
		apply_step(dir)
		return src
	else if(istype(dest))
		dest.apply_step(dir)
		return dest
	else
		var/datum/cord/C = new
		C.apply_step(dir)
		return C

/proc/get_cord(var/turf/T, datum/cord/created = null)
	var/datum/cord/C = created || new
	C.x = T.x
	C.y = T.y
	C.z = T.z 

	return C