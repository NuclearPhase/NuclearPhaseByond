/mob/living/death()
	if(hiding)
		hiding = FALSE
	stat = DEAD
	. = ..()