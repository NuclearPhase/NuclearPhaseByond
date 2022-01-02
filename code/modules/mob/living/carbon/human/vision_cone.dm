client/
	var/list/hidden_atoms = list()
	var/list/hidden_mobs = list()

/mob/living/var/fov_view = 80
/mob/living/proc/in_fov(atom/observed_atom, ignore_self = FALSE)
	if(ignore_self && observed_atom == src)
		return TRUE
	if(is_blind())
		return FALSE
	. = FALSE
	var/turf/my_turf = get_turf(src) //Because being inside contents of something will cause our x,y to not be updated
	// If turf doesn't exist, then we wouldn't get a fov check called by `play_fov_effect` or presumably other new stuff that might check this.
	//  ^ If that case has changed and you need that check, add it.
	var/rel_x = observed_atom.x - my_turf.x
	var/rel_y = observed_atom.y - my_turf.y
	if(fov_view)
		if(rel_x >= -1 && rel_x <= 1 && rel_y >= -1 && rel_y <= 1) //Cheap way to check inside that 3x3 box around you
			return TRUE //Also checks if both are 0 to stop division by zero
	
		// Get the vector length so we can create a good directional vector
		var/vector_len = sqrt(abs(rel_x) ** 2 + abs(rel_y) ** 2)
	
		/// Getting a direction vector
		var/dir_x
		var/dir_y
		switch(dir)
			if(SOUTH)
				dir_x = 0
				dir_y = -vector_len
			if(NORTH)
				dir_x = 0
				dir_y = vector_len
			if(EAST)
				dir_x = vector_len
				dir_y = 0
			if(WEST)
				dir_x = -vector_len
				dir_y = 0
	
		///Calculate angle
		var/angle = arccos((dir_x * rel_x + dir_y * rel_y) / (sqrt(dir_x**2 + dir_y**2) * sqrt(rel_x**2 + rel_y**2)))
	
		/// Calculate vision angle and compare
		var/vision_angle = (360 - fov_view) / 2
		if(angle < vision_angle)
			. = TRUE
	else
		. = TRUE

	/*
	for(var/obj/item/grab/G in center)//TG doesn't have the grab item. But if you're porting it and you do then uncomment this.
		if(src == G.affecting)
			return 0
		else
			return .
			*/

mob/proc/update_vision_cone()
	return

/mob/living/carbon/human/update_vision_cone()
	var/delay = 10
	if(src.client)
		var/image/I = null
		for(I in src.client.hidden_atoms)
			I.override = 0
			spawn(delay)
				qdel(I)
			delay += 10
		check_fov()
		src.client.hidden_atoms = list()
		src.client.hidden_mobs = list()
		src.fov.dir = dir
		if(fov.alpha != 0)
			var/mob/living/M
			var/list/viewed = view(7, src)
			if(pulling)
				viewed -= pulling
			viewed -= contents // FIXME: lol
			for(var/mob/probablyIgnored in viewed)
				if(!in_fov(probablyIgnored))
					I = image("split", probablyIgnored)
					I.override = 1
					src.client.images += I
					src.client.hidden_atoms += I
					src.client.hidden_mobs += M

	//				else if(M.footstep >= 1)
					M.in_vision_cones[src.client] = 1

			for(var/obj/item/probablyIgnored in viewed)
				if(!in_fov(probablyIgnored))
					I = image("split", probablyIgnored)
					I.override = 1
					src.client.images += I
					src.client.hidden_atoms += I

	else
		return

mob/living/carbon/human/proc/SetFov(var/n)
	if(!n)
		hide_cone()
	else
		show_cone()

mob/living/carbon/human/proc/check_fov()

	if(resting || lying || client.eye != client.mob)
		src.fov.alpha = 0
		return

	else if(src.usefov)
		show_cone()

	else
		hide_cone()

//Making these generic procs so you can call them anywhere.
mob/living/carbon/human/proc/show_cone()
	if(src.fov)
		src.fov.alpha = 255
		src.usefov = 1

mob/living/carbon/human/proc/hide_cone()
	if(src.fov)
		src.fov.alpha = 0
		src.usefov = 0