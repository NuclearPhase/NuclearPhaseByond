// If you add a more comprehensive system, just untick this file.
// Each bit re... haha just kidding this is a list of bools now
GLOBAL_LIST_EMPTY(z_levels)
// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New(turf/loc, _height)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return
	if(_height)
		height = _height
	//GLOB.z_levels[loc.z] = TRUE

/obj/effect/landmark/map_data/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

/*
/proc/HasAbove(var/z)
	return (z+1) in GLOB.z_levels

/proc/HasBelow(var/z)
	return (z-1) in GLOB.z_levels
*/

// FIXME: OH GOD PLEASE SORRY

/proc/HasAbove(var/z)
	return z >= 1 && z < 6

/proc/HasBelow(var/z)
	return z > 1 && z <= 6

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)