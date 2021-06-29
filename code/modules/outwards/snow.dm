/obj/effect/decal/cleanable/outwards/snow_footsteps
	name = "footsteps"
	desc = ""
	gender = PLURAL
	density = 0
	anchored = 1
	icon = 'icons/effects/outwards.dmi'
	icon_state = "footsteps_boot1"
	mouse_opacity = 0
	dir = SOUTH

/obj/effect/decal/cleanable/outwards/snow_footsteps/New()
	..()
	spawn(5 MINUTES)
		qdel(src)
	icon_state = "footsteps_boot[rand(1,3)]"

/turf/simulated/floor/outwards/snow
	name = "snow"
	icon = 'icons/turf/outwards.dmi'
	icon_state = "snow_1"
	initial_flooring = null
	initial_gas = list("nitrogen" = MOLES_N2OUTWARDS)
	temperature = 4

/turf/simulated/floor/outwards/snow/get_footstep_sound()
	return safepick(footstep_sounds[FOOTSTEP_ASTEROID])

/turf/simulated/floor/outwards/snow/Entered(var/mob/living/carbon/human/H)
	..()

	if(!istype(H))
		return

	if(prob(H.m_intent == "run" ? 60 : 30))
		spawn(3)
			var/obj/effect/decal/cleanable/outwards/snow_footsteps/D = new(src)
			D.dir = H.dir

	var/atom/movable/A = H
	if(A && A.loc == src && ticker && ticker.mode)
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE + 1))
			A.touch_map_edge()

/turf/simulated/floor/outwards/snow/New()
	icon_state = "snow_[rand(1,12)]"
	..()

/turf/simulated/floor/outwards/snow/CanZPass(atom/A, direction)
	if(z == A.z)
		if(direction == DOWN)
			return 0
		else if(direction == UP)
			return 0
	return 1