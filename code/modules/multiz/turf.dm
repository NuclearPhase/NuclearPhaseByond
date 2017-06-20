/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/simulated/open/CanZPass(atom, direction)
	return 1

/turf/space/CanZPass(atom, direction)
	return 1

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	plane = SPACE_PLANE
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/turf/below

/turf/simulated/open/post_change()
	..()
	update()

/turf/simulated/open/initialize()
	..()
	update()

/turf/simulated/open/proc/update()
	below = GetBelow(src)
	turf_changed_event.register(below, src, /turf/simulated/open/update_icon)
	var/turf/simulated/T = get_step(src,NORTH)
	if(T)
		turf_changed_event.register(T, src, /turf/simulated/open/update_icon)
	levelupdate()
	for(var/atom/movable/A in src)
		A.fall()
	update_icon()

/turf/simulated/open/update_dirt()
	return 0


/turf/simulated/open/Entered(var/atom/movable/mover)
	. = ..()

	if(!mover.can_fall())
		return

	// only fall down in defined areas (read: areas with artificial gravitiy)
	if(!istype(below)) //make sure that there is actually something below
		below = GetBelow(src)
		if(!below)
			return

	// No gravit, No fall.
	if(!has_gravity(src))
		return

	if(locate(/obj/structure/catwalk) in src)
		return

	if(locate(/obj/structure/stairs) in src)
		return

	var/soft = FALSE
	for(var/atom/A in below)
		if(A.can_prevent_fall())
			return

		// Dont break here, since we still need to be sure that it isnt blocked
		if(istype(A, /obj/structure/stairs))
			soft = TRUE
	// We've made sure we can move, now.
	mover.forceMove(below)

	if(!soft)
		if(!isliving(mover))
			if(istype(below, /turf/simulated/open))
				mover.visible_message(
					"\The [mover] falls from the deck above through \the [below]!",
					"You hear a whoosh of displaced air."
				)
			else
				mover.visible_message(
					"\The [mover] falls from the deck above and slams into \the [below]!",
					"You hear something slam into the deck."
				)
		else
			var/mob/M = mover
			if(istype(below, /turf/simulated/open))
				below.visible_message(
					"\The [mover] falls from the deck above through \the [below]!",
					"You hear a soft whoosh.[M.stat ? "" : ".. and some screaming."]"
				)
			else
				M.visible_message(
					"\The [mover] falls from the deck above and slams into \the [below]!",
					"You land on \the [below].", "You hear a soft whoosh and a crunch"
				)

			// Handle people getting hurt, it's funny!
			if (istype(mover, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mover
				var/damage = 5
				for(var/organ in list(BP_CHEST, BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG))
					H.apply_damage(rand(0, damage), BRUTE, organ)

				H.Weaken(4)
				H.updatehealth()

		var/fall_damage = mover.get_fall_damage()
		for(var/mob/living/M in below)
			if(M == mover)
				continue
			M.Weaken(10)
			if(fall_damage >= FALL_GIB_DAMAGE)
				M.gib()
			else
				for(var/organ in list(BP_HEAD, BP_CHEST, BP_R_ARM, BP_L_ARM))
					M.apply_damage(rand(0, fall_damage), BRUTE, organ)


// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM, var/speed)
	. = ..()
	AM.fall()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/update_icon()
	if(below)
		underlays = list(image(icon = below.icon, icon_state = below.icon_state))

	var/list/noverlays = list()
	if(!istype(below,/turf/space))
		noverlays += image(icon =icon, icon_state = "empty", layer = ABOVE_WIRE_LAYER)

	var/turf/simulated/T = get_step(src,NORTH)
	if(istype(T) && !istype(T,/turf/simulated/open))
		noverlays += image(icon ='icons/turf/cliff.dmi', icon_state = "metal", layer = ABOVE_WIRE_LAYER)

	var/obj/structure/stairs/S = locate() in below
	if(S && S.loc == below)
		var/image/I = image(icon = S.icon, icon_state = "below", dir = S.dir, layer = ABOVE_WIRE_LAYER)
		I.pixel_x = S.pixel_x
		I.pixel_y = S.pixel_y
		noverlays += I

	overlays = noverlays

/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>You lay down the support lattice.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z))
		return

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return 1
